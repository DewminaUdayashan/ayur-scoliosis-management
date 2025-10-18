import 'package:flutter/material.dart';

import '../core/extensions/theme.dart';
import '../core/theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.suffix,
  });
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[Text(labelText!), SizedBox(height: 6)],
        Container(
          color: Colors.white,
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            onChanged: onChanged,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            errorBuilder: (context, error) {
              return Text(
                error,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppTheme.error,
                ),
              );
            },
            decoration: InputDecoration(
              hint: Text(hintText),
              labelStyle: context.textTheme.bodyLarge,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: context.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: AppTheme.error),
              ),
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
