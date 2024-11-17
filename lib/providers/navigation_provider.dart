import 'package:flutter/material.dart';
import '../ui/widgets/app_bottom_navigation_bar.dart';

class NavigationProvider with ChangeNotifier {
  BottomBarEnum _currentTab = BottomBarEnum.surveys;

  BottomBarEnum get currentTab => _currentTab;

  void selectTab(BottomBarEnum tab) {
    _currentTab = tab;
    notifyListeners();
  }

  void resetTab() {
    _currentTab = BottomBarEnum.surveys;
    notifyListeners();
  }
}
