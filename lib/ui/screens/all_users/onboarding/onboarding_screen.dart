import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/assets_helper.dart';
import '../../../../utils/preferences_utils.dart';
import '../../../../navigation/routes.dart';

import '../../../theme/app_colors.dart';
import 'first_screen.dart';
import 'second_screen.dart';
import 'permission_page.dart';
import 'final_page.dart';

class OnboardingScreen extends StatefulWidget {
  final bool mustPopOnDone;

  const OnboardingScreen({super.key, this.mustPopOnDone = false});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _doNotShowAgain = false;
  bool _isNotificationPermissionGranted = false;
  bool _isLocationPermissionGranted = false;

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              const FirstOnboardingPage(),
              const SecondOnboardingPage() ,
              PermissionPage(
                title: l10n.allowNotifications,
                description: l10n.notificationPermissionDescription,
                icon: Icons.notifications,
                onRequestPermission: () async {
                  _isNotificationPermissionGranted = await _requestNotificationPermission();
                  setState(() {});
                },
                isPermissionGranted: _isNotificationPermissionGranted,
                images: [
                  Image.asset('assets/images/onboarding/gif_7.gif', width: 100),
                  Image.asset('assets/images/onboarding/gif_5.gif', width: 100),
                ],
              ),
              PermissionPage(
                title: l10n.allowGeolocation,
                description: l10n.geolocationPermissionDescription,
                icon: Icons.location_on,
                onRequestPermission: () async {
                  _isLocationPermissionGranted = await _requestLocationPermission();
                  setState(() {});
                },
                isPermissionGranted: _isLocationPermissionGranted,
                images: [
                  Image.asset('assets/images/onboarding/gif_6.gif', width: 100),
                  Image.asset('assets/images/onboarding/gif_4.gif', width: 100),
                ],
              ),
              FinalPage(
                l10n: l10n,
                doNotShowAgain: _doNotShowAgain,
                onCheckboxChanged: (value) {
                  setState(() {
                    _doNotShowAgain = value!;
                  });
                },
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                _buildSegmentedProgressIndicator(),
                const SizedBox(height: 20),
                _buildNextButton(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.3,
        child: Image.asset(
          AssetsHelper.welcomeBackground,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSegmentedProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 10.0,
          width: _currentIndex == index ? 20.0 : 10.0,
          decoration: BoxDecoration(
            color: _currentIndex == index ?
            AppColors.accentColor : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton(S l10n) {
    bool isLastPage = _currentIndex == 4;
    bool canProceed = isLastPage ||
        _currentIndex < 2 ||
        (_currentIndex == 2 && _isNotificationPermissionGranted) ||
        (_currentIndex == 3 && _isLocationPermissionGranted);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canProceed
            ? isLastPage
            ? () async {
          if (_doNotShowAgain) {
            await PreferencesUtils.setOnboardingShown(false);
          }

          if(widget.mustPopOnDone) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacementNamed(AppRoutes.welcomeRoute);
          }
        }
            : () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
            : null,
        child: Text(isLastPage ? l10n.finish : l10n.next),
      ),
    );
  }

  Future<bool> _requestNotificationPermission() async {
    var status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> _requestLocationPermission() async {
    var status = await Permission.location.request();
    return status.isGranted;
  }
}
