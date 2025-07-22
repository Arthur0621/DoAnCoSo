import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/core/utils/logger.dart';
import 'package:moneynest/features/wallet/data/repositories/wallet_repo.dart'; // Assuming defaultWallets is here

class WalletPopulationService {
  final AppDatabase _db;

  WalletPopulationService(this._db);

  Future<void> populateDefaultWallets() async {
    Log.i('Populating default wallets...');
    for (final walletModel in defaultWallets) {
      try {
        await _db.walletDao.addWallet(walletModel);
        Log.d('Successfully added default wallet: ${walletModel.name}');
      } catch (e) {
        Log.e(
          'Failed to add default wallet ${walletModel.name}: $e',
          label: 'wallet population',
        );
      }
    }

    Log.i('Default wallets populated successfully. (${defaultWallets.length})');
  }
}
