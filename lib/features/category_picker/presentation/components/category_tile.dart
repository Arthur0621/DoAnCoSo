import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:moneynest/core/components/buttons/custom_icon_button.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/features/category/data/model/category_model.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final double? height;
  final double? iconSize;
  final IconData? suffixIcon;
  final GestureTapCallback? onSuffixIconPressed;
  final Function(CategoryModel)? onSelectCategory;
  const CategoryTile({
    super.key,
    required this.category,
    this.onSuffixIconPressed,
    this.onSelectCategory,
    this.suffixIcon,
    this.height,
    this.iconSize = AppSpacing.spacing32,
  });

  IconData _getIconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'thu nhập':
        return Icons.attach_money;
      case 'thú cưng':
        return Icons.pets;
      case 'tiết kiệm':
        return Icons.savings;
      case 'tiện ích':
        return Icons.lightbulb;
      case 'travel':
        return Icons.flight;
      case 'trẻ em':
        return Icons.child_care;
      case 'ăn uống':
        return Icons.restaurant;
      case 'đầu tư':
        return Icons.trending_up;
      case 'giáo dục':
        return Icons.school;
      case 'giải trí':
        return Icons.sports_esports;
      case 'nhà ở':
        return Icons.home;
      case 'mua sắm':
        return Icons.shopping_bag;
      case 'sức khỏe & làm đẹp':
        return Icons.spa;
      case 'quà tặng & quyên góp':
        return Icons.card_giftcard;
      case 'chi phí công việc':
        return Icons.work;
      case 'chăm sóc cá nhân':
        return Icons.face;
      case 'di chuyển':
        return Icons.directions_car;
      case 'khác':
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectCategory?.call(category),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        decoration: BoxDecoration(
          color: AppColors.secondary50,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          border: Border.all(color: AppColors.secondaryAlpha10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacing12),
              decoration: BoxDecoration(
                color: AppColors.secondaryAlpha10,
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                border: Border.all(color: AppColors.secondaryAlpha10),
              ),
              child: Icon(_getIconForCategory(category.title), size: iconSize),
            ),
            const Gap(AppSpacing.spacing8),
            Expanded(child: Text(category.title, style: AppTextStyles.body3)),
            if (suffixIcon != null)
              CustomIconButton(
                onPressed: onSuffixIconPressed ?? () {},
                icon: suffixIcon!,
                iconSize: IconSize.small,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}
