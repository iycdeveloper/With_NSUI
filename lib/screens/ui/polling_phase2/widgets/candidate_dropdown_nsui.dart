import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/data_model/phase2_candidate.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';

/// Candidate picker for Polling Phase 2, styled like
/// [StatePickerDropDownNSUI] but over a list of candidates rather than
/// locations.
class CandidateDropdownNSUI extends StatelessWidget {
  const CandidateDropdownNSUI({
    Key? key,
    required this.label,
    required this.candidates,
    required this.selectedCsn,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final List<Phase2Candidate> candidates;
  final String? selectedCsn;
  final void Function(String? csn) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabelNSUI(label: label),
          Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE7EDF9)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ]),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.065,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: Colors.white,
                    hint: Text(
                      "Select candidate",
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                    icon: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1356BF).withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.angleDown,
                        size: 14,
                        color: Color(0xFF1356BF),
                      ),
                    ),
                    value: selectedCsn,
                    isDense: true,
                    isExpanded: true,
                    onChanged: onChanged,
                    items: candidates.map((candidate) {
                      return DropdownMenuItem(
                        value: candidate.csn,
                        child: Text(
                          candidate.displayLabel,
                          style: selectedCsn == candidate.csn
                              ? theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.textTheme.bodyLarge!.color,
                                  fontWeight: FontWeight.w500)
                              : theme.textTheme.bodyMedium!
                                  .copyWith(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
