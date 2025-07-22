part of '../screens/settings_screen.dart';

class SettingsPreferencesGroup extends StatelessWidget {
  const SettingsPreferencesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsGroupHolder(
      title: 'Giao diện',
      settingTiles: [
        MenuTileButton(
          label: 'Thông báo',
          icon: HugeIcons.strokeRoundedNotification01,
        ),
      ],
    );
  }
}
