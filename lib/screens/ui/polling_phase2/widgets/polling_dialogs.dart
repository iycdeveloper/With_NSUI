import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';

/// Gen-Z-themed error dialog for Polling Phase 2, matching
/// [ScrutinyTheme] instead of the app-wide plain [AlertDialog] that
/// `CustomSnackBar.showErrorDialog` renders.
void showPollingErrorDialog(BuildContext context, String message,
    {String title = 'Something went wrong'}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: ScrutinyTheme.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE0245E).withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFE0245E), size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: ScrutinyTheme.ink),
            ),
            const SizedBox(height: 8),
            Text(
              message.isEmpty ? 'Something went wrong.' : message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 18),
            ScrutinyGradientButton(
              label: 'OK',
              margin: EdgeInsets.zero,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Gen-Z-themed success dialog for a completed vote submission.
void showPollingSuccessDialog(BuildContext context,
    {VoidCallback? onDismiss}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: ScrutinyTheme.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ScrutinyTheme.accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: ScrutinyTheme.accent, size: 30),
            ),
            const SizedBox(height: 14),
            const Text(
              'Vote Recorded',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: ScrutinyTheme.ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Your vote for State & District President has been recorded.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 18),
            ScrutinyGradientButton(
              label: 'Done',
              margin: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).pop();
                onDismiss?.call();
              },
            ),
          ],
        ),
      ),
    ),
  );
}
