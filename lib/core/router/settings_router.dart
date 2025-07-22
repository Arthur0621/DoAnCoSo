import 'package:go_router/go_router.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/settings/presentation/screens/settings_screen.dart';

class SettingsRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ];
}
