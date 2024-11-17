import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../theme/app_colors.dart';

class FirstOnboardingPage extends StatelessWidget {
  const FirstOnboardingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    var theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '👋',
            style: TextStyle(fontSize: 60),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.welcome,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              l10n.welcomeDescription,
              style: const TextStyle(fontSize: 16, color: AppColors.accentColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/onboarding/gif_1.gif',
                width: 100,
              ),
              const SizedBox(width: 20),
              Image.asset(
                'assets/images/onboarding/gif_3.gif',
                width: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
