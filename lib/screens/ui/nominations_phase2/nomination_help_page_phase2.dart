import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/image_constant.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/provider/nomination_phase2/nominations_provider_phase2.dart';
import 'package:provider/provider.dart';

class NominationHelpPagePhase2 extends StatelessWidget {
  const NominationHelpPagePhase2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            leadingWidth: 44.h,
            leading: AppbarImage(
                onTap: () {
                  Get.back();
                },
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
            title: AppbarSubtitle1(
                text: "Nomination Phase 2", margin: EdgeInsets.only(left: 12.h)),
            styleType: Style.standard),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF1F4FF), Color(0xFFF8FAFF)],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/nsui/banner/nominationbanner.jpeg',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Before you begin 🗳️',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2A44)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quick rules for filing your nomination',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                // Rules card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      MembershipWelcomePageTextItemPhase2(
                        labelText:
                            "Nomination will be conducted prior to the membership.",
                      ),
                      MembershipWelcomePageTextItemPhase2(
                        labelText:
                            "All aspirants will have to file nominations in order to be eligible.",
                      ),
                      MembershipWelcomePageTextItemPhase2(
                        labelText:
                            "Nomination along with candidate serial number will be displayed on NSUI website.",
                      ),
                      MembershipWelcomePageTextItemPhase2(
                        labelText:
                            "Members will have to choose the \"Candidate Serial Number\" to select the candidate of their choice for each committee level when they fill up the membership form.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              context.read<NominationsProviderPhase2>().agrCreateBatch(context);
            },
            child: Container(
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1356BF), Color(0xFF2CC7E2)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1356BF).withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MembershipWelcomePageTextItemPhase2 extends StatelessWidget {
  final String labelText;

  const MembershipWelcomePageTextItemPhase2({Key? key, required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF1356BF).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded,
                size: 16, color: Color(0xFF1356BF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              labelText,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF3A4357),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
