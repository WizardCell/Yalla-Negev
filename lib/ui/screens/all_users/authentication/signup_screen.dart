import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/navigation/routes.dart';
import 'package:yalla_negev/utils/validators.dart';

import '../../../../generated/l10n.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormFieldState>();
  final _displayNameFormKey = GlobalKey<FormFieldState>();
  final _emailFormKey = GlobalKey<FormFieldState>();
  final _passwordFormKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFormKey = GlobalKey<FormFieldState>();
  final _nameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;
  String? _displayNameError;
  bool _isLoading = false; // State to manage loading indicator

  final _nameFocus = FocusNode();
  final _displayNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus) {
        _nameFormKey.currentState!.reset();
      } else {
        setState(() {
          _nameFormKey.currentState!.validate();
        });
      }
    });
    _displayNameFocus.addListener(() async {
      if (_displayNameFocus.hasFocus) {
        _displayNameFormKey.currentState!.reset();
      } else {
        bool displayNameExists =
        await checkIfDisplayNameExists(_displayNameController.text);
        if (displayNameExists) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            var l10n = S.of(context);
            setState(() {
              _displayNameError = l10n.displayNameExists!;
            });
          });
        } else {
          setState(() {
            _displayNameError = null;
          });
        }
        setState(() {
          _displayNameFormKey.currentState!.validate();
        });
      }
    });
    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        _emailFormKey.currentState!.reset();
      } else {
        setState(() {
          _emailFormKey.currentState!.validate();
        });
      }
    });
    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        _passwordFormKey.currentState!.reset();
      } else {
        setState(() {
          _passwordFormKey.currentState!.validate();
        });
      }
    });
    _confirmPasswordFocus.addListener(() {
      if (_confirmPasswordFocus.hasFocus) {
        _confirmPasswordFormKey.currentState!.reset();
      } else {
        setState(() {
          _confirmPasswordFormKey.currentState!.validate();
        });
      }
    });
  }

  String? confirmPasswordValidator(String? value, BuildContext context) {
    var l10n = S.of(context);
    if (value != _passwordController.text) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _displayNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  Widget _buildNameField(BuildContext context) {
    var l10n = S.of(context);
    return TextFormField(
      key: _nameFormKey,
      controller: _nameController,
      focusNode: _nameFocus,
      maxLength: 30,
      decoration: InputDecoration(
        labelText: l10n.name,
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: _nameFocus.hasFocus || nameValidator(_nameController.text, context) != null
            ? null
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
      validator: (value) => nameValidator(value, context),
    );
  }

  Widget _buildDisplayNameField(BuildContext context) {
    var l10n = S.of(context);
    return TextFormField(
      key: _displayNameFormKey,
      controller: _displayNameController,
      focusNode: _displayNameFocus,
      maxLength: 20,
      decoration: InputDecoration(
        labelText: l10n.displayName,
        errorText: _displayNameError,
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: _displayNameFocus.hasFocus
            ? Tooltip(
          message: l10n.uniqueNameInfo,
          child: const Icon(Icons.info_outline),
        )
            : displayNameValidator(_displayNameController.text, context) != null ||
            _displayNameError != null
            ? null
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
      validator: (value) => displayNameValidator(value, context),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    var l10n = S.of(context);
    return TextFormField(
      key: _emailFormKey,
      controller: _emailController,
      focusNode: _emailFocus,
      maxLength: 50,
      decoration: InputDecoration(
        labelText: l10n.email,
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: _emailFocus.hasFocus ||
            emailValidator(_emailController.text, context) != null
            ? null
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
      validator: (value) => emailValidator(value, context),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    var l10n = S.of(context);
    return TextFormField(
      key: _passwordFormKey,
      controller: _passwordController,
      focusNode: _passwordFocus,
      maxLength: 30,
      decoration: InputDecoration(
        labelText: l10n.password,
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePasswordText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _obscurePasswordText = !_obscurePasswordText;
            });
          },
        ),
      ),
      obscureText: _obscurePasswordText,
      validator: (value) => passwordValidator(value, context),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    var l10n = S.of(context);
    return TextFormField(
      key: _confirmPasswordFormKey,
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocus,
      maxLength: 30,
      decoration: InputDecoration(
        labelText: l10n.confirmPassword,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPasswordText
                ? Icons.visibility_off
                : Icons.visibility,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPasswordText = !_obscureConfirmPasswordText;
            });
          },
        ),
      ),
      obscureText: _obscureConfirmPasswordText,
      validator: (value) => confirmPasswordValidator(value, context),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    var l10n = S.of(context);
    var user = Provider.of<AuthRepository>(context, listen: false);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      onPressed: _isLoading
          ? null
          : () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });

          var res = await user.signUp(
            _emailController.text,
            _passwordController.text,
            _nameController.text.trim(),
            _displayNameController.text.trim(),
          );

          setState(() {
            _isLoading = false;
          });

          if (res is UserCredential) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homeRoute,
                  (route) => false,
            );
          } else if (res is SignUpErrors) {
            String errorMessage;
            switch (res) {
              case SignUpErrors.mailAlreadyExists:
                errorMessage = l10n.emailInUse;
                break;
              case SignUpErrors.weakPassword:
                errorMessage = l10n.weakPassword;
                break;
              case SignUpErrors.invalidEmail:
                errorMessage = l10n.invalidEmail;
                break;
              case SignUpErrors.displayNameAlreadyExists:
                errorMessage = l10n.displayNameExists;
                break;
              default:
                errorMessage = l10n.signInError;
                break;
            }
            SnackBar snackBar = SnackBar(content: Text(errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            final snackBar = SnackBar(content: Text(l10n.signInError));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          l10n.signUp,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSignInRow(BuildContext context) {
    var l10n = S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(l10n.alreadyHaveAccount),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.signinRoute);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: Text(l10n.signIn),
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
          title: Text(l10n.signUp),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      _buildNameField(context),
                      const SizedBox(height: 20),
                      _buildDisplayNameField(context),
                      const SizedBox(height: 20),
                      _buildEmailField(context),
                      const SizedBox(height: 20),
                      _buildPasswordField(context),
                      const SizedBox(height: 20),
                      _buildConfirmPasswordField(context),
                      const SizedBox(height: 20),
                      _buildSignupButton(context),
                      const SizedBox(height: 20),
                      _buildSignInRow(context),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
