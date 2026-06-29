# NSUI App — Gen-Z Redesign & Aadhaar Changes

**Date:** 2026-06-29
**Author:** maheshbr28 (with Claude Code)
**Flutter:** 3.44.1 · Dart 3.12.1 · Device: Oppo CPH2337 (Android 14)

---

## 1. Project setup & build fixes

Fresh clone wouldn't build on Flutter 3.44.1. Two dependencies were too old for the SDK:

| Package | Old | New | Why |
|---|---|---|---|
| `font_awesome_flutter` | ^10.1.0 | ^11.0.0 | `IconData` became a `final class`; v10 subclassed it (compile error). |
| `google_fonts` | ^6.2.1 | ^8.1.0 | `FontWeight` lost "primitive equality" → const-map error in v6. |

**Migration required by font_awesome 11:** icons are now wrapped in `FaIconData`, not `IconData`. So `Icon(FontAwesomeIcons.x)` no longer compiles — must use `FaIcon(FontAwesomeIcons.x)`.
- Migrated 20 `Icon(FontAwesomeIcons.*)` call sites → `FaIcon(...)`.
- Reverted one generic `Icon(icon)` (param typed `IconData`) back to `Icon` in `event_details.dart`.

Workflow used throughout: `flutter clean` → `flutter pub get` → `flutter run -d <device>` → `adb exec-out screencap` to verify on the physical device.

## 2. API endpoint switch

Base URL and all hardcoded URLs changed:

```
https://nsui.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/
→ https://api.iyc.in/ycea/ycea-api/service/nsui/api/v1.0/
```

Files: `lib/app/data/resources/urls.dart` (central `_baseUrl`), `payment_repo.dart`,
`payment_screen.dart`, `social_feeds_repo.dart`, `membership_repo.dart`.

## 3. Gen-Z visual redesign

Audience = students; the old UI looked dated (harsh cyan gradients, hard grey
borders/shadows, drop-shadowed text). New design language:

- **Background:** soft `[#F1F4FF → #F8FAFF]` vertical gradient.
- **Hero / accent gradient:** `[#1356BF, #5B2EC4, #2CC7E2]` (indigo → violet → cyan), diagonal.
- **Cards:** white, radius 18–24, soft shadow `black.withOpacity(0.06), blur 14–16, offset (0,6)`.
- **Buttons:** indigo→cyan gradient, radius 16, color-tinted glow shadow.
- **Brand anchor:** NSUI indigo `#1356BF`. Ink text `#1F2A44`.

### Screens redesigned
- **Home** (`home_screen_nsui.dart`) — gradient hero with avatar + points pill, "✦ Featured" banner, **bento grid** of vibrant gradient action tiles (`_buildHero`, `_buildBanner`, `_bentoTile`, `_wideTile`).
- **Login / OTP / Sign Up** (`login_screen_nsui.dart`, `otp_screen_nsui.dart`, `register_screen_nsui.dart`) — gradient bg, circular logo badge, rounded shadowed card, gradient primary button. Consistent across the whole auth flow.
- **Membership Batch** (`membership_batch_screen.dart`) — gradient hero with **stat chips** (Total/Unpaid/Paid AM), white action cards (Pay Now / Download), gradient Create Batch, **card-based batch list** (replaced dark data-table).
- **Member List** (`membership_member_list_screen.dart`) — gradient bg, gradient Add Member, **card-based member rows**, friendly empty-state. Fixed a "RIGHT OVERFLOWED" bug (centered `Row` with long text → proper wrapped empty-state).
- **Nomination help page** (`nomination_help_page.dart`) — rules card with check icons, gradient "Committee Levels" card, gradient Apply. Fixed a 4px overflow (fixed-width text container → `Expanded`).
- **Nomination form** (`nominations_main.dart`) — header, gradient bg, gradient Apply button, **iconified field labels**.

### Reusable widget: `FieldLabelNSUI`
`lib/nusi/widgets/field_label_nsui.dart` — renders an **icon + smaller (12.5px) bold label** when an `icon` is provided, and falls back to the **exact original style** (14px, no icon) when not. Added an optional `icon` param to 9 shared NSUI field widgets (text field, dropdown, education/state/district/assembly pickers, date picker, image & video upload) so passing an icon is opt-in per screen — **other screens stay pixel-identical**.

## 4. Aadhaar-only policy (push users to Aadhaar)

- **Nomination "Select ID Proof"** now offers **only "Aadhaar Card"** (code `"AC"`, matching the membership backend value), pre-selected. (`nominations_provider.dart`)
- Renamed labels in `nominations_main.dart`: "Government ID Card" → **"Aadhaar ID Card"**; "Upload Id Card (Front)/(Back)" → **"Upload Aadhaar Card (Front)/(Back)"**.
- **Membership Add Member · Step 3** (`membership_member_create_screen.dart`): "Upload Government ID" → **"Upload Aadhaar Card Photo"** (label + button text). Label-only, no functionality change (`DocumentType.idBack` unchanged).

## 5. Membership · Step 4 candidate labels (temporary, label-only)

In `membership_member_create_screen.dart`, the candidate dropdowns were relabeled to match a requested mockup (display only; `onChanged`/list/value bindings unchanged):
- 2nd dropdown → **District President Candidate** (was State General Secretary)
- 3rd dropdown → **College President Candidate** (was District President)

`StateNominationPickerWidget` reuses `labelText` for the header **and** the post-selection text (`"{label} CSN: {csn}"`), and `defaultValue` for the hint — so one prop change covers header + hint + post-selected.

## Known follow-ups
- `lib/app/modules/membership 2/` is a duplicate module (unused by routes); not updated.
- Member **view** screen still says "Upload Government ID" (only the create/upload flow was changed).
- Pre-existing `withOpacity` deprecation hints (info-level) left as-is to match surrounding code.
