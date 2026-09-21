# 2026-09-21 — Polling Phase 2, live bug fixes, release engineering

Change batch for the NSUI app (branch `feature/nomination-v2`). All changes verified with `flutter analyze` (0 errors) and driven live: Android on a physical device (Oppo CPH2337), iOS on the iPhone 16 Pro simulator.

## 1. Polling Phase 2 (new feature)
New Home card **"Polling Phase2"** (replaced the dead "Result" card, realigned into the Scrutiny row) that:
- Checks access via `checkPhase2PollingAccess.php` before navigating — the one card on Home that gates navigation on an API call.
- Shows a candidate-selection screen with **State President** / **District President** dropdowns, populated from `getPhase2Candidates.php` (one call per ballot).
- Submits the selection via `pollingPhase2.php` (`CSN_SP`/`CSN_DP`), State-dropdown selection → `CSN_SP`, District-dropdown selection → `CSN_DP`.

New files: `lib/provider/polling_phase2/polling_provider_phase2.dart`, `lib/screens/ui/polling_phase2/**`, `lib/app/data/resources/repository/polling_repo.dart`, `lib/model/data_model/phase2_candidate.dart`.

Design notes:
- Candidate dropdown labels show `NAME (CSN: value)`, not just the name — names can collide, CSN is meant to be the unique key.
- An empty ballot ("No data found") renders an inline "no candidates available" state instead of a popup — it's a normal outcome, not a failure.
- Error/success feedback uses new themed dialogs (`widgets/polling_dialogs.dart`) matching the Gen-Z chrome, instead of the app-wide plain `AlertDialog`.
- The initial candidate load is deferred to a microtask in `initState` — calling it synchronously notified listeners while the `ChangeNotifierProvider` ancestor was still mid-mount from the same navigation, tripping Flutter's `'!_dirty'` framework assertion.

**Known backend dependency (open as of this writing):** `getPhase2Candidates.php` was returning an empty `"CSN"` for every candidate in the test environment. Confirmed with the team this is a backend data bug, not a client workaround — the client-side CSN_SP/CSN_DP mapping is correct and verified live; a real vote submission is meaningless server-side until CSN is populated and unique.

## 2. Bug fixes found while testing live
- **Profile screen blank State/District:** `profile_controller_nsui.dart`'s `getUserProfile()` checked `APP_COD` emptiness against `OB_DETAILS` (copy-paste). A non-empty `OB_DETAILS` with an empty `APP_COD` indexed `APP_COD[0]` on an empty list, threw a `RangeError`, and silently aborted the rest of the same try block — including the state/district/assembly name-matching further down. That's why State/District showed blank despite a valid `state_code`/`district_code` from the server.
- **Notification bell:** was showing a hardcoded leftover "Member Submission" bottom sheet instead of the real, already-registered `NotificationScreen` (the real navigation call was commented out on both sides). Restored it. Its back button then surfaced a second, previously-unreachable bug: it called `Get.find<HomeController>()`, a legacy controller not registered under the Gen-Z home redesign (`HomeNSUIController` is used instead) — crashed on tap. Simplified to a plain `Get.back()`.

## 3. Release engineering
- **Android:** `android/app/build.gradle`'s `defaultConfig` had `versionCode = 11` / `versionName = '1.0.8'` hardcoded, ignoring the `flutterVersionCode`/`flutterVersionName` already read from `local.properties`. Every `pubspec.yaml` bump was silently discarded — this is why Play Console kept rejecting uploads with "version code 11 has already been used" no matter how many times the version was bumped. Fixed to reference those variables properly.
- **iOS:** the identical pattern in `ios/Runner.xcodeproj/project.pbxproj` — `MARKETING_VERSION = 1.0.8;` / `CURRENT_PROJECT_VERSION = 3;` hardcoded across all three build configs instead of `$(FLUTTER_BUILD_NAME)`/`$(FLUTTER_BUILD_NUMBER)`. The substitution had to be **quoted** (`"$(FLUTTER_BUILD_NAME)"`, matching every other variable reference in that file) — an unquoted reference parses fine by eye but made this project unreadable to `xcodebuild` outright ("The project 'Runner' is damaged and cannot be opened due to a parse error"), confirmed by reverting and reapplying the edit in isolation.
- `nominationVersion` bumped `1.2` → `1.4`; app version bumped `1.0.8+11` → `1.0.9+13` (an intermediate `+12` was skipped over once the Android hardcoding bug was found and fixed).
- Both platforms' built artifacts were verified at the binary level, not just via `pubspec.yaml`: Android AAB's `versionCode`/`versionName` via the Gradle-generated `bundle_manifest`, iOS IPA's `CFBundleShortVersionString`/`CFBundleVersion` via `plutil` on the unzipped `Info.plist`. Both confirmed `1.0.9`/`13`.
- Two unrelated local tooling issues hit and fixed along the way: `flutterfire_cli`'s cached snapshot was stale relative to the active Dart SDK, breaking the Crashlytics symbol-upload Xcode script phase (fixed via `dart pub global activate flutterfire_cli`); and `flutter run`/`flutter build ipa` can hang indefinitely on `pod install` after `flutter clean` (a pipe-buffer deadlock between CocoaPods' verbose output and Flutter's tooling) — running `pod install` directly in `ios/` instead unblocks it.

## Open items
- Backend: `getPhase2Candidates.php` needs to return a real, unique `CSN` per candidate before Polling Phase 2 submissions are meaningful.
- Android AAB uploaded to Play Console; iOS IPA built and loaded into Transporter.app, awaiting manual review + delivery to App Store Connect.
