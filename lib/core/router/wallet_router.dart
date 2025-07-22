import 'package:go_router/go_router.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/wallet/screens/wallets_screen.dart';

class WalletRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.manageWallets,
      builder: (context, state) {
        return WalletsScreen();
      },
    ),
  ];
}
