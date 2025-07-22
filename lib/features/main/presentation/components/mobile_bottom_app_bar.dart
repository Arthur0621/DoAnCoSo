import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/components/buttons/circle_button.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/main/presentation/riverpod/main_page_view_riverpod.dart';

class MobileBottomAppBar extends ConsumerWidget {
  final PageController pageController;
  const MobileBottomAppBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.spacing12,
        horizontal: AppSpacing.spacing16,
      ),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            radius: 25,
            icon: Icons.home_outlined,
            backgroundColor: Colors.transparent,
            foregroundColor:
                ref.read(pageControllerProvider.notifier).getIconColor(0),
            onTap: () {
              pageController.jumpToPage(0);
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: Icons.attach_money_outlined,
            backgroundColor: Colors.transparent,
            foregroundColor:
                ref.read(pageControllerProvider.notifier).getIconColor(1),
            onTap: () {
              pageController.jumpToPage(1);
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: Icons.add,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            onTap: () {
              context.push(Routes.transactionForm);
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: Icons.bar_chart_outlined,
            backgroundColor: Colors.transparent,
            foregroundColor:
                ref.read(pageControllerProvider.notifier).getIconColor(2),
            onTap: () {
              pageController.jumpToPage(2);
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: Icons.account_balance_wallet_outlined,
            backgroundColor: Colors.transparent,
            foregroundColor:
                ref.read(pageControllerProvider.notifier).getIconColor(3),
            onTap: () {
              pageController.jumpToPage(3);
            },
          ),
        ],
      ),
    );
  }
}
