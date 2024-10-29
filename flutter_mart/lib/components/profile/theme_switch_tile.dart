import 'package:flutter/material.dart';

class ThemeSwitchTile extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;

  const ThemeSwitchTile({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.dark_mode, size: 24),
      title: const Text(
        "Dark Mode",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: onToggle,
      ),
    );
  }
}