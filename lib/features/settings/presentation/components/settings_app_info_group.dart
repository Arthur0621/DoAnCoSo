part of '../screens/settings_screen.dart';

final logoutKey = GlobalKey<NavigatorState>();

class SettingsAppInfoGroup extends ConsumerWidget {
  const SettingsAppInfoGroup({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SettingsGroupHolder(
      title: 'Thông tin ứng dụng',
      settingTiles: [
        const MenuTileButton(
          label: 'Chính sách bảo mật',
          icon: HugeIcons.strokeRoundedLegalHammer,
          suffixIcon: HugeIcons.strokeRoundedSquareArrowUpRight,
        ),
        const MenuTileButton(
          label: 'Điều khoản',
          icon: HugeIcons.strokeRoundedFileExport,
          suffixIcon: HugeIcons.strokeRoundedSquareArrowUpRight,
        ),
        const MenuTileButton(
          label: 'Xóa dữ liệu',
          icon: HugeIcons.strokeRoundedDelete01,
        ),
        MenuTileButton(
          label: 'Đăng xuất',
          icon: HugeIcons.strokeRoundedLogout01,
          onTap: () {
            showAdaptiveDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const Text('Đăng xuất'),
                content: const Text('Bạn có muốn tiếp tục đăng xuất không?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Không'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop(); // close dialog
                      ref.read(authStateProvider.notifier).logout();
                      context.replace(Routes.onboarding);
                    },
                    child: const Text('Có'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
