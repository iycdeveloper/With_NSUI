import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/repository/polling_repo.dart';
import 'package:iyc/model/data_model/phase2_candidate.dart';
import 'package:iyc/screens/ui/polling_phase2/widgets/polling_dialogs.dart';

import '../../di_container.dart';

class PollingProviderPhase2 extends ChangeNotifier {
  final PollingRepo _pollingRepo = PollingRepo(dioClient: sl());

  bool isLoading = false;
  String? memberId;

  /// Set whenever a call below returns false/empty. Callers decide how (or
  /// whether) to surface it — [checkAccess] in particular is awaited under a
  /// caller-owned modal loading dialog, so it must never pop up its own
  /// dialog: doing so stacks a second dialog that a single Navigator.pop()
  /// back at the call site would then immediately dismiss instead of the
  /// loading spinner, leaving the spinner stuck on screen forever.
  String? lastError;

  List<Phase2Candidate> stateCandidates = [];
  List<Phase2Candidate> districtCandidates = [];

  String? selectedStateCsn;
  String? selectedDistrictCsn;

  /// Decodes the common `[{"status": "...", "response": ...}]` envelope every
  /// Nomination/Polling Phase 2 endpoint returns. Never shows any UI itself —
  /// on failure it only records [lastError] and returns null.
  Map<String, dynamic>? _decode(dynamic apiResponse) {
    if (apiResponse.response == null ||
        apiResponse.response.statusCode != 200) {
      lastError = apiResponse.error.toString();
      return null;
    }
    return jsonDecode(utf8.decode(base64Decode(apiResponse.response.data)));
  }

  Future<bool> checkAccess(BuildContext context) async {
    var apiResponse = await _pollingRepo.checkPhase2PollingAccess();
    var decoded = _decode(apiResponse);
    if (decoded == null) return false;

    if (decoded['status'] == "SUCCESS") {
      var response = decoded['response'];
      if (response is List && response.isNotEmpty) {
        memberId = response.first['member_id']?.toString();
      }
      return true;
    }
    lastError = decoded['response'].toString();
    return false;
  }

  Future<void> loadCandidates(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    var results = await Future.wait([
      _pollingRepo.getPhase2Candidate(ballot: "STATE PRESIDENT"),
      _pollingRepo.getPhase2Candidate(ballot: "DISTRICT PRESIDENT"),
    ]);

    /// A ballot with no contest ("No data found") is an ordinary outcome, not
    /// a failure — the candidate list is simply left empty and the screen
    /// shows an inline "no candidates" state instead of a popup.
    var stateDecoded = _decode(results[0]);
    if (stateDecoded != null && stateDecoded['status'] == "SUCCESS") {
      stateCandidates = (stateDecoded['response'] as List)
          .map((e) => Phase2Candidate.fromJson(e))
          .toList();
    }

    var districtDecoded = _decode(results[1]);
    if (districtDecoded != null && districtDecoded['status'] == "SUCCESS") {
      districtCandidates = (districtDecoded['response'] as List)
          .map((e) => Phase2Candidate.fromJson(e))
          .toList();
    }

    isLoading = false;
    notifyListeners();
  }

  void selectStateCandidate(String? csn) {
    selectedStateCsn = csn;
    notifyListeners();
  }

  void selectDistrictCandidate(String? csn) {
    selectedDistrictCsn = csn;
    notifyListeners();
  }

  bool get canSubmit => selectedStateCsn != null && selectedDistrictCsn != null;

  Future<void> submitPolling(BuildContext context) async {
    if (!canSubmit) return;

    isLoading = true;
    notifyListeners();

    var apiResponse = await _pollingRepo.pollingPhase2(
        csnSp: selectedStateCsn!, csnDp: selectedDistrictCsn!);

    isLoading = false;
    notifyListeners();

    var decoded = _decode(apiResponse);
    if (decoded == null) {
      showPollingErrorDialog(context, lastError ?? '',
          title: 'Submission Failed');
      return;
    }

    if (decoded['status'] == "SUCCESS") {
      showPollingSuccessDialog(context,
          onDismiss: () => Navigator.of(context).pop());
    } else {
      showPollingErrorDialog(context, decoded['response'].toString(),
          title: 'Submission Failed');
    }
  }
}
