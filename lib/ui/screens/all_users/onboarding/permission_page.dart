import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../theme/app_colors.dart'; // Assuming you have this for your colors

class PermissionPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onRequestPermission;
  final bool isPermissionGranted;
  final List<Image> images;

  const PermissionPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onRequestPermission,
    required this.isPermissionGranted,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 50.0), // Add padding at the bottom
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 100,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.accentColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var image in images)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: image,
                    ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onRequestPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  l10n.grantPermission,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (isPermissionGranted)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    l10n.permissionGranted,
                    style: const TextStyle(
                        color: AppColors.successColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
