part of '../screens/settings_screen.dart';

class SettingsFinanceGroup extends StatelessWidget {
  const SettingsFinanceGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsGroupHolder(
      title: 'Tài chính',
      settingTiles: [
        MenuTileButton(
          label: 'Ví ',
          icon: HugeIcons.strokeRoundedWallet01,
          onTap: () => context.push(Routes.manageWallets),
        ),
        MenuTileButton(
          label: 'Danh mục',
          icon: HugeIcons.strokeRoundedStructure01,
          onTap: () => context.push(Routes.manageCategories),
        ),
        // MenuTileButton(
        //   label: 'Change Currency',
        //   icon: HugeIcons.strokeRoundedMoney01,
        // ),
      ],
    );
  }
}
