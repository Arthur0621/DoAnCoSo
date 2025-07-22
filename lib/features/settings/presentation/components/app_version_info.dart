part of '../screens/settings_screen.dart';

class AppVersionInfo extends StatelessWidget {
  const AppVersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'App Version',
            style: AppTextStyles.body3,
          ),
          Text(
            '1.9.0.0 • Release: 10 Jun 2025',
            style: AppTextStyles.body4,
          ),
        ],
      ),
    );
  }
}
