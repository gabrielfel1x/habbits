import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habbits/core/colors.dart';

class CustomTextFieldLight extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;

  const CustomTextFieldLight({
    super.key,
    required this.hintText,
    this.validator,
    this.onSaved,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.contentPadding,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.white),
          contentPadding: contentPadding ?? const EdgeInsets.all(16.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: AppColors.white),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: AppColors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: AppColors.white, width: 2.0),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}
