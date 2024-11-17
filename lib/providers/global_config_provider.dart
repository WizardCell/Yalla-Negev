import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/models/global_config.dart';
import '../utils/globals.dart';

class GlobalConfigProvider extends ChangeNotifier {
  GlobalConfig? _globalConfig;

  GlobalConfig? get globalConfig => _globalConfig;

  void updateGlobalConfig(GlobalConfig globalConfig) {
    _globalConfig = globalConfig;
    notifyListeners();
  }

  Future<void> fetchGlobalConfig() async {
    final doc = await globalConfigDoc.get();

    if (doc.exists) {
      print('GlobalConfigProvider: fetchGlobalConfig: ${doc.data()}');
      _globalConfig = GlobalConfig.fromMap(doc.data()!);
    } else {
      print('GlobalConfigProvider: fetchGlobalConfig: empty');
      _globalConfig = GlobalConfig.empty();
    }

    notifyListeners();
  }

  Future<void> updateGlobalConfigData(GlobalConfig globalConfig) async {
    await globalConfigDoc.set(globalConfig.toMap());
    _globalConfig = globalConfig;

    notifyListeners();
  }

  static GlobalConfigProvider of(BuildContext context, {bool listen = false}) {
    return Provider.of<GlobalConfigProvider>(context, listen: listen);
  }
}