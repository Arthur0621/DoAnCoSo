part of '../screens/login_screen.dart';

class Form extends HookConsumerWidget {
  final TextEditingController nameField;
  const Form({
    super.key,
    required this.nameField,
  });

  @override
  Widget build(BuildContext context, ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bắt đầu',
                style: AppTextStyles.heading5,
              ),
              Gap(AppSpacing.spacing4),
              GetStartedDescription(),
            ],
          ),
          const Gap(AppSpacing.spacing20),
          Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: nameField,
                        label: 'Tên',
                        hint: 'Nguyễn Văn A',
                        prefixIcon: HugeIcons.strokeRoundedTextSmallcaps,
                      ),
                    ),
                    const Gap(AppSpacing.spacing16),
                    const LoginImagePicker(),
                  ],
                ),
              ),
              const Gap(AppSpacing.spacing16),
              const CurrencyPickerField(),
            ],
          ),
          const Gap(AppSpacing.spacing20),
          const LoginInfo(),
          const Gap(AppSpacing.spacing56),
        ],
      ),
    );
  }
}
