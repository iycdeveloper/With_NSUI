import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';

/// Bottom sheet listing why a member was put on hold, with the action that
/// takes the scrutiniser into the correction form.
///
/// Returns true when the user chooses to fix the record.
Future<bool> showScrutinyReasonSheet(
  BuildContext context, {
  required BatchMember member,
}) async {
  final reasons = _parseReasons(member.reason);

  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0245E).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.report_problem_rounded,
                      color: Color(0xFFE0245E), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Correction needed',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: ScrutinyTheme.ink)),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if ((member.firstName ?? '').isNotEmpty)
                            member.firstName!,
                          if ((member.memberId ?? '').isNotEmpty)
                            member.memberId!,
                        ].join(' · '),
                        style: TextStyle(
                            fontSize: 12.5, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              reasons.length > 1
                  ? 'This record was held for ${reasons.length} reasons:'
                  : 'This record was held because of:',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            ...reasons.map(
              (reason) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFE0E8)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 16, color: Color(0xFFE0245E)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        reason,
                        style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: ScrutinyTheme.ink),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ScrutinyGradientButton(
              label: 'Review & Fix',
              margin: EdgeInsets.zero,
              onTap: () => Navigator.pop(context, true),
            ),
            const SizedBox(height: 4),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Not now',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  return result ?? false;
}

/// `REASON` arrives semicolon-separated ("GENDER MISMATCH;") and occasionally
/// comma-separated, mirroring SCRUTINY_CODE. Split on both, tidy the SHOUTING
/// into sentence case, and drop the empties a trailing separator leaves.
List<String> _parseReasons(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return const ['This record needs to be verified.'];
  }
  final parsed = raw
      .split(RegExp(r'[;,]'))
      .map((r) => r.trim())
      .where((r) => r.isNotEmpty)
      .map(_sentenceCase)
      .toList();
  return parsed.isEmpty ? const ['This record needs to be verified.'] : parsed;
}

String _sentenceCase(String value) {
  if (value.isEmpty) return value;
  final lower = value.toLowerCase();
  return lower[0].toUpperCase() + lower.substring(1);
}
