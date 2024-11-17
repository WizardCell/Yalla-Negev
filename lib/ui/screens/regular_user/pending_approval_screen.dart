import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:yalla_negev/ui/theme/app_colors.dart';
import 'package:yalla_negev/utils/assets_helper.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                AssetsHelper.welcomeBackground,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Pending Approval Text with Animation
                  _buildAnimatedHeaderText(l10n.pendingApproval),
                  const SizedBox(height: 20),

                  // Static Image with Fade Animation
                  _buildAnimatedImage(),

                  const SizedBox(height: 30),
                  // Welcome Text
                  Flexible(
                    child: Text(
                      l10n.pendingApprovalS1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '🤝',
                    style: TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: 30),

                  // Carousel for Texts 3 and 4
                  _buildCarousel(context, l10n),
                ],
              ),
            ),
          ),
          // Footer Text
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                l10n.createdWithLove,
                style: TextStyle(
                  color: AppColors.accentColor.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Animated Header Text
  Widget _buildAnimatedHeaderText(String text) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.7, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  // Animated Image
  Widget _buildAnimatedImage() {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: Colors.grey[300], end: Colors.white),
      duration: const Duration(seconds: 2),
      builder: (context, color, child) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(color!, BlendMode.modulate),
          child: const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(
              'assets/images/pictures/app_icon.png',
            ),
          ),
        );
      },
    );
  }

  // Carousel for Texts 3 and 4
  Widget _buildCarousel(BuildContext context, S l10n) {
    return CarouselSlider(
      items: [
        _buildCarouselCard(
          icon: Icons.receipt_long,
          text: l10n.pendingApprovalS2,
          context: context,
        ),
        _buildCarouselCard(
          icon: Icons.notifications_active,
          text: l10n.pendingApprovalS3,
          context: context,
        ),
        _buildCarouselCard(
          icon: Icons.ballot_outlined,
          text: l10n.pendingApprovalS4,
          context: context,
        ),
      ],
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
      ),
    );
  }

  // Carousel Card Widget
  Widget _buildCarouselCard({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
