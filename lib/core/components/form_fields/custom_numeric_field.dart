import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneynest/core/components/form_fields/custom_text_field.dart';
import 'package:moneynest/features/authentication/presentation/riverpod/auth_provider.dart';

class CustomNumericField extends ConsumerWidget {
  final String label;
  final String? defaultCurreny;
  final TextEditingController? controller;
  final String? hint;
  final Color? hintColor;
  final Color? background;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isRequired;
  final bool autofocus;

  const CustomNumericField({
    super.key,
    required this.label,
    this.defaultCurreny,
    this.controller,
    this.hint,
    this.hintColor,
    this.background,
    this.icon,
    this.suffixIcon,
    this.isRequired = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    // Không dùng defaultCurrency cho prefix nữa
    String defaultCurrency = 'VND'; // Chỉ dùng cho logic ngoài input, không hiển thị trong input
    var lastFormattedValue = '';

    void _handleInputChanged(String value) {
  if (value == lastFormattedValue) return;

  String sanitizedValue = value
      .replaceAll(defaultCurrency, '')
      .replaceAll(' ', '')
      .replaceAll(',', '')
      .trim();

  List<String> parts = sanitizedValue.split('.');
  String integerPart = parts[0];
  String decimalPart = parts.length == 2 ? parts[1] : '';

  if (decimalPart.length > 2) {
    decimalPart = decimalPart.substring(0, 2);
  }

  // Chỉ format nếu integerPart không rỗng và là số hợp lệ
  String formattedInteger = '';
  if (integerPart.isNotEmpty) {
    final bigInt = BigInt.tryParse(integerPart);
    if (bigInt != null) {
      formattedInteger = NumberFormat("#,###", "vi_VN").format(bigInt);
    }
  }

  String formattedValue = (decimalPart.isNotEmpty || parts.length == 2)
      ? "$formattedInteger.$decimalPart"
      : formattedInteger;

  if (formattedInteger.isEmpty && decimalPart.isEmpty) {
    formattedValue = '';
  }

  if (formattedValue != lastFormattedValue) {
    lastFormattedValue = formattedValue;
    controller?.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}


    return CustomTextField(
      controller: controller,
      label: label,
      prefixIcon: icon,
      hint: hint ?? '0',
      textInputAction: TextInputAction.done,
      suffixIcon: suffixIcon,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
        SingleDotInputFormatter(),
        DecimalInputFormatter(),
      ],
      onChanged: _handleInputChanged,
      isRequired: isRequired,
      autofocus: autofocus,
    );
  }
}

class SingleDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Check if the new input contains more than one dot
    if (newValue.text.split('.').length > 2) {
      return oldValue; // Reject the new input
    }
    return newValue;
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Cho phép số lớn, không giới hạn số lượng số phía trước dấu chấm
    final regex = RegExp(r'^\d*\.?\d{0,2}$');
    if (!regex.hasMatch(text)) {
      return oldValue; // Reject invalid input
    }
    return newValue;
  }
}
