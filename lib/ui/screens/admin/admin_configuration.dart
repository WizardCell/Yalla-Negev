import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/models/global_config.dart';
import 'package:yalla_negev/providers/global_config_provider.dart';
import 'package:yalla_negev/ui/theme/app_colors.dart';
import 'package:yalla_negev/generated/l10n.dart';

class AdminConfigurationScreen extends StatefulWidget {
  const AdminConfigurationScreen({super.key});

  @override
  _AdminConfigurationScreenState createState() =>
      _AdminConfigurationScreenState();
}

class _AdminConfigurationScreenState extends State<AdminConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _supportEmail;
  late String _whatsappLink;
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGlobalConfigData();
  }

  void _fetchGlobalConfigData() async {
    final globalConfigProvider =
        GlobalConfigProvider.of(context, listen: false);
    await globalConfigProvider.fetchGlobalConfig();
    final globalConfig = globalConfigProvider.globalConfig;

    setState(() {
      if (globalConfig != null) {
        _supportEmail = globalConfig.supportEmail;
        _whatsappLink = globalConfig.whatsappLink;
      } else {
        _supportEmail = '';
        _whatsappLink = '';
      }
      _isLoading = false;
    });
  }

  void _saveConfiguration() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      setState(() {
        _isSaving = true;
      });

      final newConfig = GlobalConfig(
        supportEmail: _supportEmail,
        whatsappLink: _whatsappLink,
      );

      try {
        await GlobalConfigProvider.of(context, listen: false)
            .updateGlobalConfigData(newConfig);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(S.of(context).configurationUpdatedSuccessfully)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${S.of(context).failedToUpdateConfiguration}: $e')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminConfiguration,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: SpinKitThreeBounce(
                color: AppColors.accentColor,
                size: 50.0,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _supportEmail,
                      decoration: InputDecoration(labelText: l10n.supportEmail),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterSupportEmail;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _supportEmail = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _whatsappLink,
                      decoration: InputDecoration(labelText: l10n.whatsappLink),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterWhatsappLink;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _whatsappLink = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveConfiguration,
                      child: Text(l10n.saveConfiguration),
                    ),
                  ],
                ),
              ),
            ),
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SpinKitThreeBounce(
                  color: AppColors.accentColor,
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
