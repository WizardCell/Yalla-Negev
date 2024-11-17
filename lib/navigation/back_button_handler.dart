import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import 'navigation_service.dart';

class BackButtonHandler {
  bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    final canPop = NavigatorService.navigatorKey.currentState?.canPop();

    if (canPop ?? false) {
      Navigator.pop(NavigatorService.navigatorKey.currentContext!);
    } else {
      return true; // Prevents closing the app
    }
    return true; // Prevents the default back button behavior
  }
}
