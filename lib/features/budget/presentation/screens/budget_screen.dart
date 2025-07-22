import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/components/buttons/custom_icon_button.dart';
import 'package:moneynest/core/components/scaffolds/custom_scaffold.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/budget/presentation/components/budget_card_holder.dart';
import 'package:moneynest/features/budget/presentation/components/budget_summary_card.dart';
import 'package:moneynest/features/budget/presentation/components/budget_tab_bar.dart';
import 'package:moneynest/features/budget/presentation/components/budget_card_list.dart';

class BudgetScreen extends HookWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 5, initialIndex: 4);

    return CustomScaffold(
      context: context,
      title: 'Ngân sách của tôi',
      showBackButton: false,
      actions: [
        CustomIconButton(
          onPressed: () {
            context.push(Routes.budgetForm);
          },
          icon: HugeIcons.strokeRoundedPlusSign,
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing20),
        child: Column(
          children: [
            BudgetTabBar(tabController: tabController),
            const Gap(AppSpacing.spacing20),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  const Center(child: Text('Tab 1')),
                  const Center(child: Text('Tab 2')),
                  const Center(child: Text('Tab 3')),
                  const Center(child: Text('Tab 4')),
                  ListView(
                    children: const [
                      BudgetSummaryCard(),
                      BudgetCardList(),
                      Gap(100),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
