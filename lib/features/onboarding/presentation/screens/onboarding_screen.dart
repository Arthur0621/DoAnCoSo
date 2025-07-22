import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:moneynest/core/components/buttons/primary_button.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/core/router/routes.dart';

part '../components/get_started_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            // color: Colors.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon/icon-transparent-full.png',
                  width: 160,
                ),
                const Gap(16),
                const Text(
                  'Chào mừng đến',
                  style: AppTextStyles.heading2,
                ),
                const Text(
                  'MoneyNest!',
                  style: AppTextStyles.heading2,
                ),
                const Gap(16),
                Text(
                  'Người đồng hành tài chính đơn giản và trực quan. Theo dõi chi tiêu, ngân sách'
                  'quản lý tài chính dễ dàng với chiếc điện thoại',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.neutral800,
                    fontVariations: [const FontVariation.weight(500)],
                  ),
                ),
                const Gap(150),
              ],
            ),
          ),
          const GetStartedButton(),
        ],
      ),
    );
  }
}
