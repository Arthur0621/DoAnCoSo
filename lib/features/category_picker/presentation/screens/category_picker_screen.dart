import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/core/components/buttons/button_chip.dart'
    show ButtonChip;
import 'package:moneynest/core/components/buttons/button_state.dart';
import 'package:moneynest/core/components/buttons/primary_button.dart';
import 'package:moneynest/core/components/scaffolds/custom_scaffold.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/features/category/presentation/riverpod/category_providers.dart';
import 'package:moneynest/features/category/presentation/screens/category_form_screen.dart';
import 'package:moneynest/features/category_picker/presentation/components/category_dropdown.dart';

import 'package:moneynest/features/category/data/model/category_model.dart';

class CategoryPickerScreen extends ConsumerWidget {
  final bool isManageCategories;
  final bool isPickingParent;
  final CategoryType? categoryTypeFilter;
  const CategoryPickerScreen({
    super.key,
    this.isManageCategories = false,
    this.isPickingParent = false,
    this.categoryTypeFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      context: context,
      title: isManageCategories ? 'Quản lý danh mục' : 'Thêm danh mục',
      showBalance: false,
      body: Stack(
        children: [
          if (!isManageCategories)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: ButtonChip(label: 'Chi tiêu', active: true)),
                  Gap(AppSpacing.spacing12),
                  Expanded(child: ButtonChip(label: 'Thu nhập')),
                ],
              ),
            ),
          ref
              .watch(hierarchicalCategoriesProvider)
              .when(
                data: (categories) {
                  // Nếu có filter loại danh mục thì chỉ lấy đúng loại
                  final filtered = categoryTypeFilter == null
                      ? categories
                      : categories.where((c) => c.categoryType == categoryTypeFilter).toList();
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.spacing20),
                        child: Text('Không tìm thấy danh mục!'),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.spacing20,
                      0,
                      AppSpacing.spacing20,
                      150,
                    ),
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => CategoryDropdown(
                      category: filtered[index],
                      isManageCategory: isManageCategories,
                    ),
                    separatorBuilder: (context, index) =>
                        const Gap(AppSpacing.spacing12),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error loading categories: $error')),
              ),
          if (!isPickingParent)
            PrimaryButton(
              label: 'Thêm danh mục mới',
              state: ButtonState.outlinedActive,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  builder: (context) => CategoryFormScreen(),
                );
              },
            ).floatingBottom,
        ],
      ),
    );
  }
}
