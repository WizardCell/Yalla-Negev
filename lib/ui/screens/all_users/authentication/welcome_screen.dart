import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/navigation/routes.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/assets_helper.dart';
import '../../../theme/button_styles.dart';
import 'dart:ui' as ui;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetsHelper.welcomeBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                _buildTitle(context),
                const SizedBox(height: 100),
                _buildSubtitle(context),
                const SizedBox(height: 60),
                _buildSignInButton(context),
                const SizedBox(height: 10),
                _buildSignUpButton(context),
                const SizedBox(height: 20),
                _buildDivider(context),
                const SizedBox(height: 20),
                _buildGoogleSignInButton(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      width: 330,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).yallaNegev,
              style: TextStyle(
                fontFamily: 'NanumPenScript', // Use local font
                fontSize: 80,
                //fontStyle: FontStyle.italic,
                foreground: Paint()
                  ..shader = ui.Gradient.linear(
                    const Offset(0, 150),
                    const Offset(150, 200),
                    <Color>[
                      Colors.white!,
                      Colors.grey[50]!,
                    ],
                  ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Container(
      width: 230,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          S.of(context).voiceShapes,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto', // Use local font
            fontSize: 28,
            foreground: Paint()
              ..shader = ui.Gradient.linear(
                const Offset(0, 150),
                const Offset(150, 200),
                <Color>[
                  Colors.white!,
                  Colors.blueGrey[50]!,
                ],
              ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.signinRoute);
      },
      style: ButtonStyles.primaryButtonStyle,
      child: Container(
        width: ButtonStyles.buttonWidth,
        alignment: Alignment.center,
        child: Text(
          S.of(context).signIn,
          style: const TextStyle(
            fontFamily: 'Roboto', // Use local font
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.signupRoute);
      },
      style: ButtonStyles.secondaryButtonStyle.copyWith(
        side: WidgetStateProperty.all(const BorderSide(color: Colors.white)),
      ),
      child: Container(
        width: ButtonStyles.buttonWidth,
        alignment: Alignment.center,
        child: Text(
          S.of(context).signUp,
          style: const TextStyle(
            fontFamily: 'Roboto', // Use local font
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Divider(
              color: Colors.white,
              indent: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              S.of(context).or.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Roboto', // Use local font
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.white,
              indent: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    var l10n = S.of(context);
    return ElevatedButton(
      onPressed: () async {
        var res = await Provider.of<AuthRepository>(context, listen: false)
            .signInWithGoogle();

        if (res is AuthCredential) {
          // Delay the navigation
          Future.delayed(const Duration(seconds: 1), () {
            // Routes the user to the correct home screen based on their role
            Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeRoute,
                    (route) => false
            );
          });
        } else if (res is SignUpErrors) {
          String errorMessage;
          switch (res) {
            case SignUpErrors.mailAlreadyExistsWithDifferentCredential:
              errorMessage =
              'An error occurred: Email already in use with a different credential.';
              break;
            default:
              errorMessage =
              'An error occurred while trying to sign you in, please try again later.';
              break;
          }
          SnackBar snackBar = SnackBar(content: Text(errorMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if ((res is int && res != 0) || res is! int) {
          SnackBar snackBar = SnackBar(
              content: Text(l10n.signInGoogleError));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(color: Colors.white, width: 1.0),
        backgroundColor: Colors.transparent,
      ),
      child: Container(
        width: ButtonStyles.buttonWidth,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              AssetsHelper.googleLogo,
              height: 24,
            ),
            const SizedBox(width: 10),
            Text(
              S.of(context).signInGoogle,
              style: const TextStyle(
                fontFamily: 'Roboto', // Use local font
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
