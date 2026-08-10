import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_reason_sheet.dart';
import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/scrutiny/member/scrutiny_member_edit_vm.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_members_list_vm.dart';
import 'package:provider/provider.dart';

import 'members/scrutiny_members_edit_home.dart';

class ScrutinyMembersListCard extends StatelessWidget {
  const ScrutinyMembersListCard(
      {Key? key, required this.member, required this.provider})
      : super(key: key);
  final BatchMember member;
  final ScrutinyMembersListVM provider;

  bool get _isSynced => member.isSync == "1" && member.isEditedScrutiny == "1";
  bool get _isEdited => member.isEditedScrutiny == "1";

  Color _statusColor() => _isSynced
      ? const Color(0xFF11998E)
      : _isEdited
          ? const Color(0xFFF7971E)
          : ScrutinyTheme.brand;

  IconData _statusIcon() => _isSynced
      ? Icons.cloud_done_outlined
      : _isEdited
          ? Icons.edit_note_rounded
          : Icons.pending_outlined;

  String _statusLabel() => _isSynced
      ? "Synced"
      : _isEdited
          ? "Edited — not synced"
          : "Pending review";

  /// Shows why the record is on hold and, if the user opts to fix it, opens
  /// the correction wizard and refreshes the list afterwards.
  Future<void> _openReason(BuildContext context) async {
    final proceed = await showScrutinyReasonSheet(context, member: member);
    if (!proceed) return;

    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              /// The page reads ScrutinyMembershipEditVM in initState —
              /// pushing it bare throws a ProviderNotFoundException.
              create: (context) => ScrutinyMembershipEditVM(),
              child: ScrutinyMembershipEditHomePage(
                scrutinyMembersListVM: provider,
                member: member,
                isUpdate: true,
              ),
            )));
    Log.printILog(result);
    await provider.getScrutinyMembersList(context, member.batchId!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openReason(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            border: Border.all(color: ScrutinyTheme.hairline),
            boxShadow: ScrutinyTheme.cardShadow),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _statusColor().withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_statusIcon(), size: 18, color: _statusColor()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.firstName ?? '',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ScrutinyTheme.ink)),
                    const SizedBox(height: 4),
                    Text(
                      member.memberId ?? '',
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 6),
                    ScrutinyChip(
                        label: _statusLabel(),
                        color: _statusColor(),
                        icon: _statusIcon()),
                  ]),
              flex: 1,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: ScrutinyTheme.buttonGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Details",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                onTap: () => _openReason(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
