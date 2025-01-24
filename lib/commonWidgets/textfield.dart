import 'package:flutter/material.dart';
import 'package:social/appColors/lightmode.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.callback,
    required this.controller,
    required this.hint,
    this.obsqureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true,
  });

  final VoidCallback callback; // Callback when text changes
  final TextEditingController controller; // Controller to manage text input
  final String hint; // Hint text for the field
  final bool obsqureText; // Whether to obscure the text (for passwords)
  final TextInputAction
      textInputAction; // Defines the action for the text input (like 'done', 'next')
  final TextInputType keyboardType; // Keyboard type (e.g., text, number)
  final int maxLines; // Number of lines for multi-line input
  final bool enabled; // Whether the text field is enabled

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obsqureText, // Handle obscuring text if needed
      keyboardType:
          widget.keyboardType, // Keyboard type (e.g., for numbers, text, etc.)
      textInputAction:
          widget.textInputAction, // Text field action (like 'done', 'next')
      maxLines: widget.maxLines, // Supports multi-line input
      enabled: widget.enabled, // Enable/Disable text field
      onChanged: (value) {
        widget.callback;
      },
      decoration: InputDecoration(
        labelText: widget.hint, // Use hint as label
        border: const OutlineInputBorder(), // Standard border
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.secondaryDarkColor, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      ),
    );
  }
}
