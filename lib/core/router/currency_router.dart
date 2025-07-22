import 'package:go_router/go_router.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/currency_picker/presentation/screens/currency_list_tiles.dart';

class CurrencyRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.currencyListTile,
      builder: (context, state) => const CurrencyListTiles(),
    ),
  ];
}
