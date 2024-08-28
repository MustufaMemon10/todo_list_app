
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1, this.onTap,  this.readOnly = false, required this.keyBoardType, this.inputFormatter,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType keyBoardType;
  final List<TextInputFormatter>? inputFormatter;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyBoardType,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      inputFormatters: inputFormatter,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
              const BorderSide(width: 1.5, color: AppColors.secondary)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
              const BorderSide(width: 1.5, color: AppColors.secondary)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
              const BorderSide(width: 1.5, color: AppColors.secondary))),
    );
  }
}