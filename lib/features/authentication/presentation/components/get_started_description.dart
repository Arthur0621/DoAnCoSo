part of '../screens/login_screen.dart';

class GetStartedDescription extends StatelessWidget {
  const GetStartedDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      style: AppTextStyles.body3,
      TextSpan(
        text: 'Hãy nhập ',
        children: [
          TextSpan(
            text: 'tên hoặc nhóm của bạn',
            style: TextStyle(fontVariations: [FontVariation.weight(700)]),
          ),
          TextSpan(
            text: ', chọn một ',
          ),
          TextSpan(
            text: 'tấm ảnh',
            style: TextStyle(fontVariations: [FontVariation.weight(700)]),
          ),
          // TextSpan(
          //   text: ' and choose your ',
          // ),
          // TextSpan(
          //   text: 'currency',
          //   style: TextStyle(fontVariations: [FontVariation.weight(700)]),
          // ),
          // TextSpan(
          //   text: ' to personalize your account.',
          // ),
        ],
      ),
    );
  }
}
