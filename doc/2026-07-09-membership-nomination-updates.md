# 2026-07-09 — Membership & Nomination updates

Change-request batch for the NSUI/IYC app (branch `feature/genz-ui-aadhaar-redesign`). All changes verified with `flutter analyze` (0 errors) and driven on device (Oppo CPH2337) where reachable.

## 1. DOB age eligibility (16–27 as of a cut-off date)
- New `lib/utils/dob_rules.dart` (`DobRules`): age computed **as on a per-state cut-off date**, not today. `cutoffDate = 01-07-2026` (TS) is a hard-coded constant with a `TODO(login)` to wire the per-state value from the login response. `minAge=16`, `maxAge=27` (inclusive).
- Applied to **Membership Step 1** and **Nomination** DOB pickers: the calendar is constrained to the valid window (≈02-07-1998 … 01-07-2010), an out-of-range pick is rejected with a snackbar + inline red error, and Submit/Next is blocked when DOB is missing/out of range.
- `DatePickerWidgetNSUI` gained an optional `errorText` for the inline message.

## 2. Labels & fields
- **Membership Step 1:** "Father's Name" → **"Father's Name/Mother's Name"** (label, hint, validation message).
- **Membership Step 1:** Mobile Number → `TextInputType.phone` (numeric keypad); Email → `TextInputType.emailAddress`.
- **Nomination:** removed the "Committee Levels" card from the help page.
- **Nomination:** added a free-text **"Course"** field after Education (`courseController`, required, submitted as `COURSE` — payload key to confirm with backend). (Nomination Phone/Email already used the correct keyboards.)

## 3. University/College merge
Collapsed "University" + "College" into a single **University/College** selector (the assembly; College/booth hidden, not deleted):
- **Nomination form:** University picker relabeled "University/College"; College (booth) hidden via `Visibility(visible:false)`; the College `validateForm` check commented out.
- **Membership Step 2:** added a **University/College** dropdown that loads by district (`onChangedDistrict → getAssemblyList() → getUniversityBallots(state, district)`); now required in `validateConsistencyForm`; submitted as `ASSEMBLY_CODE`.
- **Membership Step 4:** only **"University/College President Candidate"** remains (renamed); College President Candidate dropdown hidden; `validatePage` requires only that + declaration; `CSN_DP` defaults to `'0'`.

## 4. Category taxonomy (Membership + Nomination)
- Removed **NT/VJNT**; ensured **MBC**; renamed **"Physically Handicapped" → "Specially abled"** (code `PH`); added **"Transgender"**.
- Codes for new options pending backend confirmation: Transgender=`TG` (both); Membership MBC=`MBC`, Specially abled=`PH`.
- Hardened the nomination fee-waiver / category-document logic from fragile substring checks (`contains("T")`) to **exact-match** (`_docRequiredCategories = ["S","T","PH"]`, and `== 'O'` for OBC), so the new `TG` code can't falsely trigger a fee waiver.

## 5. Identity video (record + view)
- Rewrote `lib/screens/widgets/video_recoder_widget.dart` to be robust across devices: dynamic **front camera** (fallback to any camera), **camera + microphone** permission, **10s max** auto-stop with a live countdown and **tap-to-stop-early**, lifecycle/timer safety (`WidgetsBindingObserver`, `mounted` guards, timer cancel), and error/retry + permission-denied UI (no more dead "LOADING").
- **Fixed a file-corruption bug:** the recorded file was being self-copied (`File.copy(src→src)`) into the same app-docs path, truncating it to 0 bytes → "Unable to play" and a broken S3 upload. The recorder now returns the raw file, and both `saveVideo` methods guard `src == dest`.
- Rewrote `lib/screens/widgets/video_player_local.dart` ("view"): null-safe (old code deref'd the controller before init and crashed), loader-until-ready, tap play/pause, looping, close, and an "Unable to play" fallback.
- Moved the Upload Video field from Membership **Step 2** to **Step 3** (after Upload Photo).

## 6. Submission success popup
`membership/widgets/membership_success_bootom_sheet_nsui.dart` now shows a single line — *"Thanks for submission. This NSUI membership is a voluntary membership and free of any threat, promise or inducement"* — with a green check, app-gradient Okay button, and `MainAxisSize.min` so the longer copy never overflows.

## Open items (need backend confirmation)
- Category codes for the new options (Transgender `TG`; Membership MBC `MBC`, Specially abled `PH`).
- Nomination `COURSE` payload key.
- Wire `DobRules.cutoffDate` to the per-state value returned at login.
