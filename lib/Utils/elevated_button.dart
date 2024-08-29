import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? textColor; // Color for the icon and text

  const ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor =
        textColor ?? Colors.white; // Default to white if no color is provided

    return Container(
      constraints: const BoxConstraints(
        maxWidth: double.infinity, // Ensures the button takes available width
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12), // Increased padding
          elevation: 4, // Slightly higher elevation for better visual effect
          shadowColor: Colors.black.withOpacity(0.25), // Add shadow color
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24, // Slightly larger icon for better visibility
              color: effectiveTextColor,
            ),
            const SizedBox(
                width: 12), // Increased spacing between icon and text
            Text(
              text,
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600, // Slightly bolder text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
