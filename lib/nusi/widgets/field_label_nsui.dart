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

  /// Opt-in emphasis for a label that carries the whole form (e.g. the single
  /// field on the Nomination Phase 2 screen). Off by default so every other
  /// screen renders exactly as before.
  final bool bold;

  const FieldLabelNSUI({
    Key? key,
    this.icon,
    required this.label,
    this.color,
    this.bold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(
        label,
        style: TextStyle(
            color: color ?? Colors.blueAccent,
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : null),
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
                fontSize: bold ? 15 : 12.5,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
