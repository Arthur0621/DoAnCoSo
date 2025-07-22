part of '../screens/dashboard_screen.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 0,
      children: [
        CustomIconButton(
          onPressed: () {},
          icon: Icons.notifications_none_outlined,
          showBadge: true,
        ),
        CustomIconButton(
          onPressed: () {
            context.push(Routes.settings);
          },
          icon: Icons.settings_outlined,
        ),
      ],
    );
  }
}
