import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/models/users/user_data.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/navigation/routes.dart';
import 'package:yalla_negev/utils/validators.dart';

import '../../../../generated/l10n.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePasswordText = true;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _validateForm() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  Widget _buildEmailField() {
    var l10n = S.of(context);
    return TextFormField(
      textDirection: TextDirection.ltr,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: l10n.email,
        errorMaxLines: 3,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) => emailValidator(value, context),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    var l10n = S.of(context);
    return TextFormField(
      textDirection: TextDirection.ltr,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: l10n.password,
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _obscurePasswordText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _obscurePasswordText = !_obscurePasswordText;
            });
          },
        ),
      ),
      obscureText: _obscurePasswordText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.enterPassword;
        } else if (value.length < 6) {
          return l10n.passwordLength;
        }
        return null;
      },
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    var l10n = S.of(context);
    return Consumer<AuthRepository>(
      builder: (context, userState, _) {
        if (userState.status == Status.authenticating) {
          return const CircularProgressIndicator();
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor, // background
              foregroundColor: Colors.white, // foreground
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (!await Provider.of<AuthRepository>(context, listen: false)
                    .signIn(_emailController.text, _passwordController.text)) {
                  /// Show a Snackbar if login is unsuccessful
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l10n.errorLoggingIn),
                  ));
                } else {
                  // Route the user to the their corresponding home screen
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.homeRoute,
                      (route) => false
                  );
                }
              }
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                l10n.signIn,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSignUpRow() {
    var l10n = S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(l10n.dontHaveAccount),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.signupRoute);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: Text(l10n.signUp),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordRow() {
    var l10n = S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.resetPasswordRoute);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: Text(l10n.forgotPassword),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              l10n.signIn,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20), // Adjust space as needed
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(context),
                  const SizedBox(height: 20),
                  _buildSignInButton(context),
                  const SizedBox(height: 20),
                  _buildSignUpRow(),
                  _buildForgotPasswordRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
