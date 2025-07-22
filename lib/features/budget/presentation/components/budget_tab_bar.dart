import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/core/components/tabs/custom_tab.dart';
import 'package:moneynest/core/components/tabs/custom_tab_bar.dart';

class BudgetTabBar extends HookConsumerWidget {
  final TabController tabController;
  const BudgetTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context, ref) {
    return CustomTabBar(
      tabController: tabController,
      tabs: [
        CustomTab(label: DateFormat('MMM yyyy', 'vi').format(DateTime(2025, 2))),
        CustomTab(label: DateFormat('MMM yyyy', 'vi').format(DateTime(2025, 3))),
        CustomTab(label: DateFormat('MMM yyyy', 'vi').format(DateTime(2025, 4))),
        CustomTab(label: 'Tháng trước'),
        CustomTab(label: 'Tháng này'),
      ],
    );
  }
}
