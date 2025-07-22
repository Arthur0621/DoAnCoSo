import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:moneynest/core/router/authentication_router.dart';
import 'package:moneynest/core/router/budget_router.dart';
import 'package:moneynest/core/router/category_router.dart';
import 'package:moneynest/core/router/currency_router.dart';
import 'package:moneynest/core/router/onboarding_router.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/core/router/settings_router.dart';
import 'package:moneynest/core/router/transaction_router.dart';
import 'package:moneynest/core/router/wallet_router.dart';
import 'package:moneynest/features/splash/presentation/screens/splash_screen.dart';
import 'package:moneynest/core/router/analytics_router.dart';
final rootNavKey = GlobalKey<NavigatorState>();

// No duplicate GoalRouter class here!
// We just pull in all the feature routers.

final router = GoRouter(
  navigatorKey: rootNavKey,
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // feature‐specific sub‐routers:
    ...OnboardingRouter.routes,
    ...AuthenticationRouter.routes,
    ...TransactionRouter.routes,
    ...CategoryRouter.routes,
    ...AnalyticsRouter.routes, // ← your goal‐details route injected here
    ...BudgetRouter.routes,
    ...SettingsRouter.routes,
    ...CurrencyRouter.routes,
    ...WalletRouter.routes,
  ],
);
