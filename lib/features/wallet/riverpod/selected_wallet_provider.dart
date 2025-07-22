import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';

/// Provider lưu ví được chọn hiện tại (nếu bạn muốn dùng riêng thay vì activeWalletProvider)
final selectedWalletProvider = StateProvider<WalletModel?>((ref) => null);
