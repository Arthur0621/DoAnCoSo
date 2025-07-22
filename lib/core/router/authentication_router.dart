import 'package:go_router/go_router.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/authentication/presentation/screens/login_screen.dart';
import 'package:moneynest/features/main/presentation/screens/main_screen.dart';

class AuthenticationRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.getStarted,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.main,
      builder: (context, state) => const MainScreen(),
    ),
  ];
}
