import 'package:flutter/material.dart';

class ButtonBarTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool pressed;

  const ButtonBarTextButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.pressed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        icon,
        color: pressed ? Theme.of(context).primaryColorDark : null,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: pressed ? Theme.of(context).primaryColorDark : null,
          fontWeight: pressed ? FontWeight.bold : null,
        ),
      ),
      onPressed: onPressed ?? () => {},
      style: ButtonStyle(
        backgroundColor: pressed
            ? MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColorLight)
            : null,
        elevation: pressed ? MaterialStateProperty.all(2) : null,
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
