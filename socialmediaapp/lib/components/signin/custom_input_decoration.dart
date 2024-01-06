import 'package:flutter/material.dart';

InputDecoration inputDecoration(
    {required String hintText,
      required BuildContext context,
      bool disabled = false}) {
  return InputDecoration(
    filled: true,
    fillColor: disabled
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onPrimary.withOpacity(0.33),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    ),
    hintText: hintText,
    hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: 16,
    ),
    errorStyle: const TextStyle(height: 0),
  );
}

InputDecoration inputDecorationWitIcon(
    {required String hintText,
      required Function() onTap,
      required IconData icon,
      required BuildContext context,
      bool disabled = false,
      Color? iconColor
      }) {
  return InputDecoration(
    suffixIcon: GestureDetector(
      onTap: onTap,
      child: Icon(icon),
    ),
    suffixIconColor: iconColor,
    filled: true,
    fillColor: disabled
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onPrimary.withOpacity(0.33),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    ),
    hintText: hintText,
    hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: 16,
    ),
    errorStyle: const TextStyle(height: 0),
  );
}