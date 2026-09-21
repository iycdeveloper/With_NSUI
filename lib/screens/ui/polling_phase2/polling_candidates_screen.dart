import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/phase2_candidate.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
import 'package:iyc/provider/polling_phase2/polling_provider_phase2.dart';
import 'package:iyc/screens/ui/polling_phase2/widgets/candidate_dropdown_nsui.dart';
import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:provider/provider.dart';

class PollingCandidatesScreen extends StatefulWidget {
  const PollingCandidatesScreen({Key? key}) : super(key: key);

  @override
  State<PollingCandidatesScreen> createState() =>
      _PollingCandidatesScreenState();
}

class _PollingCandidatesScreenState extends State<PollingCandidatesScreen> {
  @override
  void initState() {
    super.initState();

    /// Deferred to a microtask: loadCandidates's first line calls
    /// notifyListeners() synchronously, and calling that during initState
    /// re-enters the ChangeNotifierProvider ancestor while it is still
    /// completing its own first build/mount from the toPage() navigation
    /// that created this screen, which trips Flutter's '!_dirty' assertion.
    Future.microtask(
        () => context.read<PollingProviderPhase2>().loadCandidates(context));
  }

  Widget _candidateField({
    required String label,
    required List<Phase2Candidate> candidates,
    required bool isLoading,
    required String? selectedCsn,
    required ValueChanged<String?> onChanged,
  }) {
    if (!isLoading && candidates.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabelNSUI(label: label),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ScrutinyTheme.hairline),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 18, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('No candidates available for this ballot',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return CandidateDropdownNSUI(
      label: label,
      candidates: candidates,
      selectedCsn: selectedCsn,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: ScrutinyTheme.appBar(context, "Polling"),
      body: ScrutinyPageBackground(
        child: Consumer<PollingProviderPhase2>(
          builder: (_, val, __) => val.isLoading &&
                  val.stateCandidates.isEmpty &&
                  val.districtCandidates.isEmpty
              ? const NetworkLoading()
              : ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    const ScrutinyHero(
                      icon: Icons.how_to_vote_rounded,
                      title: 'Polling · Phase 2',
                      subtitle: 'Cast your vote for State & District President',
                    ),
                    const ScrutinySectionHeader(
                      icon: Icons.groups_rounded,
                      title: 'Select candidates',
                    ),
                    ScrutinyCard(
                      child: Column(
                        children: [
                          _candidateField(
                            label: 'State President',
                            candidates: val.stateCandidates,
                            isLoading: val.isLoading,
                            selectedCsn: val.selectedStateCsn,
                            onChanged: val.selectStateCandidate,
                          ),
                          const SizedBox(height: 8),
                          _candidateField(
                            label: 'District President',
                            candidates: val.districtCandidates,
                            isLoading: val.isLoading,
                            selectedCsn: val.selectedDistrictCsn,
                            onChanged: val.selectDistrictCandidate,
                          ),
                        ],
                      ),
                    ),
                    Opacity(
                      opacity: val.canSubmit ? 1 : 0.5,
                      child: ScrutinyGradientButton(
                        label: val.isLoading ? 'Submitting...' : 'Submit',
                        margin: const EdgeInsets.fromLTRB(16, 20, 16, 5),
                        onTap: val.canSubmit && !val.isLoading
                            ? () => val.submitPolling(context)
                            : () {},
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
