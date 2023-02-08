import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;
  final void Function() onPressed;

  const SuccessDialog({
    Key? key,
    required this.title,
    required this.text,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(buttonText),
        )
      ],
    );
  }
}
