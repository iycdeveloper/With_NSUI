import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/membership/controllers/membership_batch_controller.dart';
import 'package:iyc/app/modules/membership/screens/membership_landing_screen.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/payment/payment_select_batch.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/payment/payment_select_batch_vm.dart';
import 'package:provider/provider.dart';

class MembershipBatchScreen extends StatefulWidget {
  const MembershipBatchScreen();

  @override
  State<MembershipBatchScreen> createState() => _MembershipBatchScreenState();
}

class _MembershipBatchScreenState extends State<MembershipBatchScreen> {
  static const Color _ink = Color(0xFF1F2A44);
  static const Color _indigo = Color(0xFF1356BF);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MembershipBatchController>(builder: (logic) {
      return logic.isFirstTimeMembership
          ? const MembershipLandingPage()
          : SafeArea(
              child: Scaffold(
              backgroundColor: const Color(0xFFF1F4FF),
              appBar: CustomAppBar(
                  leadingWidth: 44.h,
                  actions: [
                    _appBarTextAction(
                      icon: Icons.payments_rounded,
                      label: 'Pay Now',
                      onTap: () async {
                        await toPage(
                            context,
                            ChangeNotifierProvider(
                              create: (context) => PaymentSelectBatchVM(),
                              child: const PaymentSelectBatch(),
                            ));
                      },
                    ),
                    const SizedBox(width: 16),
                    _appBarTextAction(
                      icon: Icons.history_rounded,
                      label: 'History',
                      onTap: () {
                        RoutesManagement.goToPaymentHistory();
                      },
                    ),
                    const SizedBox(width: 14),
                  ],
                  leading: AppbarImage(
                      onTap: () {
                        Get.back();
                      },
                      svgPath: ImageConstant.imgBiarrowleftIndigo800,
                      margin:
                          EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
                  title: AppbarSubtitle1(
                      text: "Membership", margin: EdgeInsets.only(left: 12.h)),
                  styleType: Style.standard),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: _createBatchButton(context, logic),
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
                children: [
                  _buildHero(logic),
                  const SizedBox(height: 14),
                  // if (logic.membershipBatchList.isEmpty)
                  if (logic.filtermemberList != null) ...[
                    if (logic.filtermemberList!.isEmpty)
                      _emptyState()
                    else
                      for (final member in logic.filtermemberList!)
                        Builder(
                          builder: (context) {
                            final batch = logic.filtermembershipBatchList
                                .cast<dynamic>()
                                .firstWhere(
                                  (b) => b.batchId == member.batchId,
                                  orElse: () => null,
                                );

                            if (batch == null) {
                              return const SizedBox.shrink();
                            }
// print(logic.filtermemberList!.length);
                            return _batchCard(context, member, batch);
                          },
                        ),
                  ]
                ],
              ),
            ));
    });
  }

  Widget _appBarTextAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _indigo, size: 16),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: _indigo, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildHero(MembershipBatchController logic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1356BF), Color(0xFF5B2EC4), Color(0xFF2CC7E2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _indigo.withOpacity(0.30),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Membership Batch',
          //   style: TextStyle(
          //       color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 4),
          // const Text(
          //   'Pay batch members or download batch details',
          //   style: TextStyle(color: Colors.white70, fontSize: 13),
          // ),
          // const SizedBox(height: 18),
          Row(
            children: [
              _statChip('Total AM', '${logic.totalCount}'),
              const SizedBox(width: 10),
              _statChip('Unpaid', '${logic.totalUnpaidAmCount}'),
              const SizedBox(width: 10),
              _statChip('Paid', '${logic.totalPaidAmCount}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _createBatchButton(
      BuildContext context, MembershipBatchController logic) {
    return GestureDetector(
      onTap: () => logic.addBatch(context),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text('New Member',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _batchCard(
      BuildContext context, BatchMember member, BatchDataModel batch) {
    final bool synced = member.isSync == "1";
    final bool paid = batch.paymentStatus == "PAID";
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () => RoutesManagement.goToMembershipMemberViewScreen(
          member,
          isUpdate: (member.isSync == "1"),
          isUpdateToDB: true,
        ),
        //     RoutesManagement.goToMembershipMemberListScreen(batch.batchId),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${member.memberId}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: _ink, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              _miniChip(
                  synced ? 'Synced' : 'Pending',
                  synced
                      ? const Color(0xFF11998E)
                      : const Color(0xFF6B8199)),
              const SizedBox(width: 6),
              _miniChip(paid ? 'Paid' : 'Unpaid',
                  paid ? const Color(0xFF11998E) : Colors.orange),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFF9AA7BD), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 44),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.inbox_rounded, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text('No Membership yet',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Tap "Create Membership" to get started',
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}
