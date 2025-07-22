import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:moneynest/core/components/buttons/button_state.dart';
import 'package:moneynest/core/components/buttons/primary_button.dart';
import 'package:moneynest/core/components/form_fields/custom_select_field.dart';
import 'package:moneynest/core/components/form_fields/custom_text_field.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/core/database/database_provider.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/features/category/data/model/category_model.dart';
import 'package:moneynest/core/database/tables/category_table.dart'
    show CategoryTableExtensions;
import 'package:moneynest/features/category/presentation/riverpod/category_form_service.dart';
import 'package:moneynest/features/category/presentation/riverpod/category_providers.dart';

class CategoryFormScreen extends HookConsumerWidget {
  final int? categoryId; // Nullable ID for edit mode
  const CategoryFormScreen({super.key, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Thêm state cho loại danh mục
    final categoryTypeOptions = CategoryType.values;
    final categoryTypeLabels = ['Thu nhập', 'Chi tiêu', 'Chuyển khoản'];
    final selectedCategoryTypeState = useState<CategoryType>(CategoryType.expense);
    final selectedCategoryType = selectedCategoryTypeState.value;
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final isEditing = categoryId != null;

    // State for the selected parent category
    final selectedParentCategory = ref.watch(selectedParentCategoryProvider);

    // Fetch existing category data if in edit mode
    final categoryFuture = useFuture(
      useMemoized(() {
        if (categoryId != null) {
          final db = ref.read(databaseProvider);
          return db.categoryDao.getCategoryById(categoryId!);
        }
        return Future.value(null); // Not in edit mode
      }, [categoryId]),
    );

    // Initialize form fields when category data is loaded
    useEffect(() {
      if (categoryFuture.connectionState == ConnectionState.done &&
          categoryFuture.data != null) {
        final category = categoryFuture.data!;
        titleController.text = category.title;
        descriptionController.text = category.description ?? '';
        if (category.parentId != null) {
          // Fetch the parent Category object from DB then convert to CategoryModel
          ref
              .read(databaseProvider)
              .categoryDao
              .getCategoryById(category.parentId!)
              .then((parentDriftCategory) {
                if (parentDriftCategory != null) {
                  ref.read(selectedParentCategoryProvider.notifier).state =
                      parentDriftCategory.toModel();
                }
              });
        } else {
          ref.read(selectedParentCategoryProvider.notifier).state = null;
        }
      }
      return null;
    }, [categoryFuture.connectionState, categoryFuture.data]);

    return CustomBottomSheet(
      title: isEditing ? 'Sửa mục đích' : 'Thêm mục đích',
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.spacing16,
          children: [
            CustomTextField(
              controller: titleController, // Use the controller
              label: 'Title',
              hint: 'Mua sắm, du lịch',
              isRequired: true,
              prefixIcon: HugeIcons.strokeRoundedTextSmallcaps,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  /* SizedBox(
                    height: double.infinity,
                    child: SecondaryButton(
                      onPressed: () {},
                      icon: HugeIcons.strokeRoundedShoppingBag01,
                    ),
                  ),
                  const Gap(AppSpacing.spacing8), */
                  Expanded(
                    child: CustomSelectField(
                      label: 'Mục đích cha',
                      // Display the selected parent category's title, or a default hint
                      isRequired: true,
                      hint:
                          selectedParentCategory?.title ??
                          'Chọn mục đích cha',
                      prefixIcon: HugeIcons.strokeRoundedStructure01,
                      onTap: () async {
                        // Navigate to the picker screen and wait for a result
                        final result = await context.push(
                          Routes.categoryListPickingParent,
                        );
                        // If a category was selected and returned, update the provider
                        if (result != null && result is CategoryModel) {
                          ref
                                  .read(selectedParentCategoryProvider.notifier)
                                  .state =
                              result;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            CustomTextField(
              label: 'Description',
              hint: 'Write simple description...',
              controller: descriptionController, // Use the controller
              prefixIcon: HugeIcons.strokeRoundedNote,
              suffixIcon: HugeIcons.strokeRoundedAlignLeft,
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            // Dropdown chọn loại danh mục
            DropdownButtonFormField<CategoryType>(
              value: selectedCategoryType,
              items: List.generate(categoryTypeOptions.length, (i) => DropdownMenuItem(
                value: categoryTypeOptions[i],
                child: Text(categoryTypeLabels[i]),
              )),
              onChanged: (value) {
                if (value != null) selectedCategoryTypeState.value = value;
              },
              decoration: const InputDecoration(
                labelText: 'Loại danh mục',
                border: OutlineInputBorder(),
              ),
            ),
            PrimaryButton(
              label: 'Save',
              state: ButtonState.active,
              onPressed: () async {
                final newCategory = CategoryModel(
                  id: categoryId,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  categoryType: selectedCategoryType, // Thêm dòng này
                  parentId: selectedParentCategory?.id,
                );

                CategoryFormService().save(context, ref, newCategory);
              },
            ),
            if (isEditing)
              TextButton(
                child: Text(
                  'Delete',
                  style: AppTextStyles.body2.copyWith(color: AppColors.red),
                ),
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      title: Text('Delete Checklist'),
                      content: Text('Continue to delete this item?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            CategoryFormService().delete(
                              context,
                              ref,
                              categoryModel: categoryFuture.data!.toModel(),
                            );
                            context.pop();
                            context.pop();
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
