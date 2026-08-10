/// Parsing for the `SCRUTINY_CODE` field returned by the scrutiny APIs.
///
/// The field carries one or more codes and the separator is not consistent —
/// the server sends `"26;"`, `"2,22"` and `"2;22"` for the same kind of value.
/// Splitting on `;` alone (which every view-model used to do) silently dropped
/// every code in a comma-separated list, so no correction was ever unlocked
/// for those members.
class ScrutinyCodes {
  ScrutinyCodes._();

  /// Known codes, for reference:
  ///   2  -> ID proof / Aadhaar re-upload
  ///   22 -> name mismatch
  ///   26 -> gender mismatch
  static const String idProof = '2';
  static const String nameMismatch = '22';
  static const String genderMismatch = '26';

  /// Splits on both `;` and `,`, trims each entry and drops the empties that
  /// a trailing separator leaves behind.
  static List<String> parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(RegExp(r'[;,]'))
        .map((code) => code.trim())
        .where((code) => code.isNotEmpty)
        .toList();
  }

  static bool has(String? raw, String code) => parse(raw).contains(code);
}
