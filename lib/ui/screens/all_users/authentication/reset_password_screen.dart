import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/ui/theme/theme_helper.dart';
import 'package:yalla_negev/navigation/routes.dart';
import 'package:yalla_negev/utils/validators.dart';

import '../../../../generated/l10n.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreen();
}

class _ResetPasswordScreen extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  dynamic _user;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _startReset(BuildContext context) async {
    var l10n = S.of(context);
    FocusManager.instance.primaryFocus?.unfocus();
    var email = _emailController.text;
    _emailController.clear();
    if (email != "") {
      try {
        bool sent = await _user.resetPassword(email);
        AlertDialog alert = AlertDialog(
          title: Text(l10n.emailSent),
          content: Text(l10n.checkYourInbox),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(l10n.ok))
          ],
        );

        if (sent) {
          showDialog(
              context: context,
              builder: (builder) {
                return alert;
              });
        } else {
          throw Exception;
        }
      } catch (_) {
        final snackBar =
        SnackBar(content: Text(l10n.problemSendingEmail));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget _buildEmailField(BuildContext context) {
    var l10n = S.of(context);
    return TextFormField(
      textDirection: TextDirection.ltr,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: l10n.email,
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) => emailValidator(value, context),
    );
  }

  Widget _buildRestorePasswordButton() {
    var l10n = S.of(context);
    return ElevatedButton(
      onPressed: () {
        _startReset(context);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: ThemeHelper.lightTheme.primaryColor,
      ),
      child: Container(
        width: 250,
        alignment: Alignment.center,
        child: Text(
          l10n.restorePassword,
          style: const TextStyle(color: Colors.white),
        ),
      ),
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
          child: Text(
            l10n.signUp,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    _user = Provider.of<AuthRepository>(context);
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
            l10n.resetPassword,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ),
        body: Container(
          color: ThemeHelper.lightTheme.scaffoldBackgroundColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildEmailField(context),
                  const SizedBox(height: 35),
                  _buildRestorePasswordButton(),
                  const SizedBox(height: 20),
                  _buildSignUpRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
