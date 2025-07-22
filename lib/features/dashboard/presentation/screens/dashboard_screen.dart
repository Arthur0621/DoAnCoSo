import 'dart:io';
import 'package:intl/intl.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/components/buttons/circle_button.dart';
import 'package:moneynest/core/components/buttons/custom_icon_button.dart';
import 'package:moneynest/core/components/progress_indicators/custom_progress_indicator.dart';
import 'package:moneynest/core/components/progress_indicators/custom_progress_indicator_legend.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_font_weights.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/core/extensions/double_extension.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';
import 'package:moneynest/features/transaction/presentation/components/transaction_tile.dart';
import 'package:moneynest/features/transaction/presentation/riverpod/transaction_providers.dart';
import 'package:moneynest/features/wallet/riverpod/wallet_providers.dart';
import 'package:moneynest/features/wallet_switcher/presentation/screens/wallet_switcher_dropdown.dart';
import 'package:moneynest/features/budget/riverpod/transactions_provider.dart';

part '../components/action_button.dart';
part '../components/balance_card.dart';
part '../components/cash_flow_cards.dart';
part '../components/greeting_card.dart';
part '../components/header.dart';
// part '../components/my_goals/goals_carousel.dart';
part '../components/recent_transaction_list.dart';
part '../components/spending_progress_chart.dart';
part '../components/transaction_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(85),
        child: Header(),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 100),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.spacing20,
              0,
              AppSpacing.spacing20,
              AppSpacing.spacing20,
            ),
            child: const Column(
              children: [
                BalanceCard(),
                Gap(AppSpacing.spacing12),
                CashFlowCards(),
                Gap(AppSpacing.spacing12),
                SpendingProgressChart(),
              ],
            ),
          ),
          // const MyGoalsCarousel(),
          const RecentTransactionList(),
        ],
      ),
    );
  }
}
