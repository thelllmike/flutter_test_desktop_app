import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metatube/utils/app_style.dart';
import 'package:metatube/utils/snackBar.dart';

class CustomTextField extends StatefulWidget {
  final int maxLength;
  final int? maxLines;
  final String hintTest;
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.maxLength,
    this.maxLines,
    required this.hintTest,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final _focusNode = FocusNode();
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void copyToClipBoard(context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarUtils.showSnackBar(context, Icons.content_copy, 'Copied Text');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      keyboardType: TextInputType.multiline,
      cursorColor: AppTheme.accent,
      style: AppTheme.inputStyle,
      decoration: InputDecoration(
        hintStyle: AppTheme.hintStyle,
        hintText: widget.hintTest,
        suffixIcon: _copyButton(context),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.accent,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.medium,
          ),
        ),
        counterStyle: AppTheme.counterStyle,
      ),
    );
  }

  IconButton _copyButton(BuildContext context) {
    return IconButton(
        onPressed: widget.controller.text.isNotEmpty
            ? () => copyToClipBoard(context, widget.controller.text)
            : null,
        color: AppTheme.accent,
        disabledColor: AppTheme.medium,
        splashColor: AppTheme.accent,
        splashRadius: 20,
        icon: const Icon(
          Icons.content_copy_rounded,
        ));
  }
}
