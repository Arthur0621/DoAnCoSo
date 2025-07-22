import 'package:go_router/go_router.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/onboarding/presentation/screens/onboarding_screen.dart';

class OnboardingRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ];
}
