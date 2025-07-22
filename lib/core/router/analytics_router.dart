import 'package:go_router/go_router.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:moneynest/core/utils/logger.dart';

class AnalyticsRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.analytics, // Đảm bảo đã thêm 'analytics' vào Routes
      builder: (context, state) {
        Log.d('📊 Routing to AnalyticsScreen');
        return const AnalyticsScreen();
      },
    ),
  ];
}