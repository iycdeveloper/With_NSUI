/// Central Date-of-Birth (DOB) age rules for membership & nomination.
///
/// NSUI sets a per-state membership *cut-off date* (the membership start date).
/// A candidate's age is calculated **as on that cut-off date** and must fall
/// within [minAge]–[maxAge] (both inclusive). Anyone outside that band is
/// automatically rejected.
///
/// TODO(login): replace [cutoffDate] with the per-state value received on login
/// (e.g. Telangana starts 01-07-2026; other states may differ). For now it is a
/// hard-coded constant so the rule can be enforced end-to-end.
class DobRules {
  DobRules._();

  /// Membership start / cut-off date used as the reference for age calculation.
  static final DateTime cutoffDate = DateTime(2026, 7, 1);

  /// Inclusive minimum age (in years) as on [cutoffDate].
  static const int minAge = 16;

  /// Inclusive maximum age (in years) as on [cutoffDate].
  static const int maxAge = 27;

  /// Whole-years age of [dob] as on [ref].
  static int ageOn(DateTime dob, DateTime ref) {
    int age = ref.year - dob.year;
    if (ref.month < dob.month ||
        (ref.month == dob.month && ref.day < dob.day)) {
      age--;
    }
    return age;
  }

  /// Age as on the configured [cutoffDate].
  static int ageAtCutoff(DateTime dob) => ageOn(dob, cutoffDate);

  /// True when [dob] yields an age within [minAge]–[maxAge] (inclusive).
  static bool isValid(DateTime dob) {
    final age = ageAtCutoff(dob);
    return age >= minAge && age <= maxAge;
  }

  /// Latest DOB that still makes an applicant at least [minAge] on the cut-off.
  /// (Born on this day => turns [minAge] exactly on the cut-off.)
  static DateTime latestAllowedDob() =>
      DateTime(cutoffDate.year - minAge, cutoffDate.month, cutoffDate.day);

  /// Earliest DOB that keeps an applicant at most [maxAge] on the cut-off.
  /// (One day after turning [maxAge]+1 would be too old, so we add a day.)
  static DateTime earliestAllowedDob() =>
      DateTime(cutoffDate.year - maxAge - 1, cutoffDate.month, cutoffDate.day)
          .add(const Duration(days: 1));

  /// Validation message for a picked [dob]; null when acceptable.
  static String? errorText(DateTime? dob) {
    if (dob == null) return "Please select Date of Birth";
    if (!isValid(dob)) {
      return "Age must be between $minAge and $maxAge years as on ${_fmt(cutoffDate)}";
    }
    return null;
  }

  static String _fmt(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
}
