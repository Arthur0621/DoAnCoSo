part of '../screens/settings_screen.dart';

class SettingsProfileGroup extends StatelessWidget {
  const SettingsProfileGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsGroupHolder(
      title: 'Thông tin',
      settingTiles: [
        MenuTileButton(
          label: 'Thông tin cá nhân',
          icon: HugeIcons.strokeRoundedUser,
        ),
      ],
    );
  }
}
