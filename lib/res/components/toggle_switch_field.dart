import 'package:flutter/material.dart';

class ToggleSwitchField extends StatelessWidget {
  final String label;
  final ValueNotifier<bool> switchValue;

  const ToggleSwitchField({
    super.key,
    required this.label,
    required this.switchValue,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: switchValue,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Switch(
              value: value,
              onChanged: (newValue) {
                switchValue.value = newValue;
              },
            ),
          ],
        );
      },
    );
  }
}
