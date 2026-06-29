import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_list_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/model/data_model/batch_member.dart';

class MembershipMemberListScreen extends StatelessWidget {
  const MembershipMemberListScreen();

  static const Color _ink = Color(0xFF1F2A44);
  static const Color _indigo = Color(0xFF1356BF);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MembershipMemberListController>(builder: (logic) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF1F4FF),
          appBar: CustomAppBar(
            leadingWidth: 44.h,
            leading: AppbarImage(
                onTap: () {
                  Get.back();
                },
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
            title: AppbarSubtitle1(
                text: "${logic.batchId}", margin: EdgeInsets.only(left: 12.h)),
            styleType: Style.standard,
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF1F4FF), Color(0xFFF8FAFF)])),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Member Data',
                      style: TextStyle(
                          color: _ink,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    if (logic.membershipRequestList.isEmpty)
                      _addMemberButton(logic),
                  ],
                ),
                const SizedBox(height: 18),
                if (logic.membershipRequestList.isEmpty)
                  _emptyState()
                else
                  for (final member in logic.membershipRequestList)
                    _memberCard(member),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _addMemberButton(MembershipMemberListController logic) {
    return GestureDetector(
      onTap: () async {
        final aggrId = await LocalStorageServices().getAgrIDMembership();
        final stateCode = await LocalStorageServices().getSTCode();
        if (logic.membershipRequestList.length >= 10) {
          CustomSnackBar.showErrorSnackBar('Only 10 members are allowed');
          return;
        }
        RoutesManagement.goToMembershipMemberCreateScreen(
            BatchMember(
                memberId: (logic.membershipRequestList.length + 1)
                            .toString()
                            .length <
                        2
                    ? logic.batchId +
                        "0" +
                        (logic.membershipRequestList.length + 1)
                            .toString()
                            .padLeft(1, "0")
                    : logic.batchId +
                        "0" +
                        (logic.membershipRequestList.length + 1).toString(),
                batchId: logic.batchId,
                isSync: "0",
                aggrId: aggrId,
                stateCode: stateCode),
            isUpdate: false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1356BF), Color(0xFF2CC7E2)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _indigo.withOpacity(0.30),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          children: [
            Text('Add Member',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            SizedBox(width: 6),
            Icon(Icons.add_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Icon(Icons.group_off_rounded, size: 56, color: Colors.grey[400]),
          const SizedBox(height: 14),
          Text('No members yet',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            'No records found for this batch.\nTap "Add Member" to get started.',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _memberCard(BatchMember member) {
    final bool synced = member.isSync == "1";
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          RoutesManagement.goToMembershipMemberViewScreen(
            member,
            isUpdate: (member.isSync == "1"),
            isUpdateToDB: true,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _indigo.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person_rounded, color: _indigo),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${member.memberId}',
                      style: const TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    _miniChip(synced ? 'Completed' : 'Pending',
                        synced ? const Color(0xFF11998E) : Colors.orange),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF9AA7BD)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
