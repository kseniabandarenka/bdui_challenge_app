// client/lib/navigation/navigation_service.dart
import 'package:client/presentation/screen/challenge_detail_screen/challenge_detail_screen.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> navigateToChallengeDetail(String challengeId) async {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ChallengeDetailScreen(challengeId: challengeId),
      ),
    );
  }

  static void goBack() {
    navigatorKey.currentState?.pop();
  }
}