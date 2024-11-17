import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yalla_negev/providers/all_main_providers.dart';
import 'package:yalla_negev/utils/assets_helper.dart';
import '../../../../generated/l10n.dart';
import '../../../theme/app_colors.dart';
import '../onboarding/onboarding_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "YallaNegev v${packageInfo.version}";
  }

  void _launchWhatsApp(BuildContext context) async {
    var whatsappLink = Provider.of<GlobalConfigProvider>(context, listen: false)
        .globalConfig!
        .whatsappLink;

    final Uri url = Uri.parse(whatsappLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showAlternativeContactDialog(
        context,
        S.of(context).cannotLaunchWhatsAppTitle,
        S.of(context).useWhatsAppLink,
        whatsappLink,
      );
    }
  }

  void _contactTeam(BuildContext context) async {
    var email = Provider.of<GlobalConfigProvider>(context, listen: false)
        .globalConfig!
        .supportEmail;

    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl, mode: LaunchMode.externalApplication);
    } else {
      _showAlternativeContactDialog(
        context,
        S.of(context).cannotLaunchEmailTitle,
        S.of(context).useEmailAddress,
        email,
      );
    }
  }

  void _showAlternativeContactDialog(
      BuildContext context, String title, String message, String contactInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('$message $contactInfo'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
  }

  void _showOnboarding(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(mustPopOnDone: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Consumer<GlobalConfigProvider>(
      builder: (context, globalConfigProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.about,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    showAboutDialog(context: context);
                  }),
            ],
          ),
          body: Stack(
            children: [
              // Main Content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon Image
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(AssetsHelper.appIcon),
                      ),
                      const SizedBox(height: 20),

                      // WhatsApp Button
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(MdiIcons.whatsapp, color: Colors.green),
                          title: Text(l10n.joinWhatsAppGroup),
                          onTap: () => _launchWhatsApp(context),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Contact Team Button
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading:
                              Icon(MdiIcons.emailOutline, color: Colors.blue),
                          title: Text(l10n.contactTheTeam),
                          onTap: () => _contactTeam(context),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Informational Texts
                      Text(
                        l10n.negevCommunitySupport,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.dataProcessedLegally,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),

                      // Show Onboarding Button
                      ElevatedButton(
                        onPressed: () => _showOnboarding(context),
                        child: Text(l10n.showWelcomeOnboarding),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      FutureBuilder<String>(
                        future: _getAppVersion(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return Text(
                              snapshot.data ?? 'YallaNegev',
                              style: TextStyle(
                                color: AppColors.accentColor.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.createdWithLove,
                        style: TextStyle(
                          color: AppColors.accentColor.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
