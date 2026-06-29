import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/membership/controllers/membership_batch_controller.dart';
import 'package:iyc/app/modules/membership/screens/membership_landing_screen.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
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
                    leading: AppbarImage(
                        onTap: () {
                          Get.back();
                        },
                        svgPath: ImageConstant.imgBiarrowleftIndigo800,
                        margin: EdgeInsets.only(
                            left: 20.h, top: 15.v, bottom: 15.v)),
                    title: AppbarSubtitle1(
                        text: "Membership",
                        margin: EdgeInsets.only(left: 12.h)),
                    styleType: Style.standard),
                body: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
                  children: [
                    _buildHero(logic),
                    const SizedBox(height: 18),
                    _buildActions(context, logic),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Batch Data',
                          style: TextStyle(
                              color: _ink,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        _createBatchButton(context, logic),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (logic.membershipBatchList.isEmpty)
                      _emptyState()
                    else
                      for (final batch in logic.membershipBatchList)
                        _batchCard(context, batch),
                  ],
                ),
              ));
    });
  }

  Widget _buildHero(MembershipBatchController logic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1356BF), Color(0xFF5B2EC4), Color(0xFF2CC7E2)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _indigo.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Membership Batch',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pay batch members or download batch details',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 18),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildActions(BuildContext context, MembershipBatchController logic) {
    return Row(
      children: [
        _actionCard(
          icon: Icons.payments_rounded,
          label: 'Pay Now',
          color: _indigo,
          onTap: () async {
            await toPage(
                context,
                ChangeNotifierProvider(
                  create: (context) => PaymentSelectBatchVM(),
                  child: const PaymentSelectBatch(),
                ));
          },
        ),
        const SizedBox(width: 14),
        _actionCard(
          icon: Icons.download_rounded,
          label: 'Download',
          color: const Color(0xFF7B2FF7),
          onTap: () {
            logic.downloadExistingBatch(context: context);
          },
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                    color: _ink, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
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
          children: [
            Text('Create Batch',
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

  Widget _batchCard(BuildContext context, dynamic batch) {
    final bool synced = batch.syncStatus == "1";
    final bool paid = batch.paymentStatus == "PAID";
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => RoutesManagement.goToMembershipMemberListScreen(
            batch.batchId),
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
                child: const Icon(Icons.folder_copy_rounded, color: _indigo),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${batch.batchId}',
                      style: const TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _miniChip('${batch.countAM} AM', _indigo),
                        _miniChip(synced ? 'Synced' : 'Pending',
                            synced ? const Color(0xFF11998E) : const Color(0xFF6B8199)),
                        _miniChip(paid ? 'Paid' : 'Unpaid',
                            paid ? const Color(0xFF11998E) : Colors.orange),
                      ],
                    ),
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
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
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
          Text('No batches yet',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Tap "Create Batch" to get started',
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}
