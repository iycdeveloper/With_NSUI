import 'package:flutter/material.dart';

/// Shared field label for NSUI form widgets.
///
/// When [icon] is null it renders the original plain label (so existing
/// screens are unchanged). When an [icon] is provided it renders a smaller,
/// bolder label preceded by a tinted icon — used to make forms feel livelier.
class FieldLabelNSUI extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color? color;

  const FieldLabelNSUI({
    Key? key,
    this.icon,
    required this.label,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(
        label,
        style: TextStyle(color: color ?? Colors.blueAccent, fontSize: 14),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF1356BF)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color ?? Colors.blueAccent,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
