import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/membership/controllers/membership_batch_controller.dart';
import 'package:iyc/app/modules/membership/screens/membership_landing_screen.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
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
  @override
  void initState() {
    super.initState();
    // Check for phone call support.
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MembershipBatchController>(builder: (logic) {
      return logic.isFirstTimeMembership
          ? MembershipLandingPage()
          : SafeArea(
              child: Scaffold(
              backgroundColor: const Color(0xFFF8FAFF),
              appBar: CustomAppBar(
                  leadingWidth: 44.h,
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
              body: ListView(
                children: [
                  SizedBox(
                    height: 270,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          height: 212,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                const Color(0xFF2CC7E2).withOpacity(0.1),
                                Colors.white
                              ])),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Membership Batch',
                                  style: theme.textTheme.titleLarge),
                              Text(
                                  'You can choose to pay batch members or download the batch details',
                                  style: theme.textTheme.bodyLarge),
                              SizedBox(
                                height: 14.v,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await toPage(
                                          context,
                                          ChangeNotifierProvider(
                                            create: (context) =>
                                                PaymentSelectBatchVM(),
                                            child: const PaymentSelectBatch(),
                                          ));
                                      // logic.getMembershipBatchList(context,
                                      //     reload: true);
                                    },
                                    child: Container(
                                      width: 160,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: const Color(
                                              0xFFC0D5F3), // Use Color(0xFFC0D5F3) for the hex color
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Equivalent to justify-content: center
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // Equivalent to align-items: center
                                        mainAxisSize: MainAxisSize
                                            .min, // Similar effect to flex-shrink: 0
                                        children: [
                                          CustomImageView(
                                            svgPath:
                                                ImageConstant.imgCreditCard,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'PAY NOW',
                                            style: TextStyle(
                                              color: Color(
                                                  0xFFFFFFFF), // White color
                                              fontFamily: 'Be Vietnam Pro',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              height:
                                                  1.0, // Line height as a multiplier (100%)
                                              letterSpacing: 0.32,
                                              textBaseline: TextBaseline
                                                  .alphabetic, // Helps with vertical alignment
                                            ),
                                          ) // Spacing between widgets
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      logic
                                        ..downloadExistingBatch(
                                            context: context);
                                    },
                                    child: Container(
                                      width: 160,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: const Color(
                                              0xFFC0D5F3), // Use Color(0xFFC0D5F3) for the hex color
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Equivalent to justify-content: center
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // Equivalent to align-items: center
                                        mainAxisSize: MainAxisSize
                                            .min, // Similar effect to flex-shrink: 0
                                        children: [
                                          CustomImageView(
                                            svgPath: ImageConstant.imgFolder,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'DOWNLOAD',
                                            style: TextStyle(
                                              color: Color(
                                                  0xFFFFFFFF), // White color
                                              fontFamily: 'Be Vietnam Pro',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              height:
                                                  1.0, // Line height as a multiplier (100%)
                                              letterSpacing: 0.32,
                                              textBaseline: TextBaseline
                                                  .alphabetic, // Helps with vertical alignment
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 80.v,
                            width: 335.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: const Color(
                                    0xFFC0D5F3), // Use Color(0xFFC0D5F3) for the hex color
                                width: 1.0,
                              ),
                              color: Colors.white, // Background color
                            ),
                            // Add your child widget here
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Total AM',
                                          style: TextStyle(
                                            color: Color(0xFF6B8199),
                                            fontFamily: 'Be Vietnam Pro',
                                            fontSize: 12,
                                            fontWeight: FontWeight
                                                .w400, // Normal font weight
                                            height:
                                                1.0, // Line height as a multiplier (100%)
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${logic.totalCount}',
                                          style: const TextStyle(
                                            color: Color(0xFF365B85),
                                            fontFamily: 'Be Vietnam Pro',
                                            fontSize: 16,
                                            fontWeight: FontWeight
                                                .w400, // Normal font weight
                                            height:
                                                1.0, // Line height as a multiplier (100%)
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    color: Color(0xFFC0D5F3),
                                    thickness: 1,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Unpaid AM',
                                          style: TextStyle(
                                            color: Color(0xFF6B8199),
                                            fontFamily: 'Be Vietnam Pro',
                                            fontSize: 12,
                                            fontWeight: FontWeight
                                                .w400, // Normal font weight
                                            height:
                                                1.0, // Line height as a multiplier (100%)
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${logic.totalUnpaidAmCount}',
                                          style: const TextStyle(
                                            color: Color(0xFF365B85),
                                            fontFamily: 'Be Vietnam Pro',
                                            fontSize: 16,
                                            fontWeight: FontWeight
                                                .w400, // Normal font weight
                                            height:
                                                1.0, // Line height as a multiplier (100%)
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    color: Color(0xFFC0D5F3),
                                    thickness: 1,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Paid AM',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontFamily: 'Be Vietnam Pro',
                                            fontSize: 12,
                                            fontWeight: FontWeight
                                                .w400, // Normal font weight
                                            height:
                                                1.0, // Line height as a multiplier (100%)
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${logic.totalPaidAmCount}',
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontFamily: 'Be Vietnam Pro',
                                            fontSize: 16,
                                            fontWeight: FontWeight
                                                .w400, // Normal font weight
                                            height:
                                                1.0, // Line height as a multiplier (100%)
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Batch Data',
                          style: TextStyle(
                            color: Color(
                                0xFF244974), // This is the hex code for #244974
                            fontFamily: 'Be Vietnam Pro',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height:
                                1.4, // This is equivalent to 140% line height
                          ),
                        ),
                        InkWell(
                          onTap: () => logic.addBatch(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    const Color(0xFF2CC7E2), // Cyan-Blue color
                                width: 1.0,
                              ),
                              color: Colors.blueAccent, // White background
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'CREATE BATCH  ',
                                  style: TextStyle(
                                    color: Colors.white, // Cyan-Blue color
                                    fontFamily: 'Be Vietnam Pro',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4, // 140% line height
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  if (logic.membershipBatchList.isNotEmpty) ...[
                    Container(
                      height: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        color: Color(0xFF244974),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Batch Id',
                              style: titleStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'AM',
                              style: titleStyle,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Sync',
                              style: titleStyle,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Payment',
                              style: titleStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFC0D5F3), // Stroke color
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: List.generate(
                            logic.membershipBatchList.length, (index) {
                          // final reversedIndex =
                          //     logic.membershipBatchList.length - 1 - index;

                          if (index == 0) {
                            final item = logic.membershipBatchList.last;
                            return batchlistCard(item, logic);
                          } else {
                            final item = logic.membershipBatchList[index - 1];
                            return batchlistCard(item, logic);
                          }
                        }),
                      ),
                    ),
                  ]
                ],
              ),
            ));
    });
  }

  InkWell batchlistCard(BatchDataModel item, MembershipBatchController logic) {
    return InkWell(
      onTap: () {
        RoutesManagement.goToMembershipMemberListScreen(item.batchId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFC0D5F3), // Stroke color
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                item.batchId,
                style: const TextStyle(
                  color: Color(0xFF365B85), // Body color
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // Normal font weight
                  height: 1.6, // 160% line height
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${item.countAM}',
                style: const TextStyle(
                  color: Color(0xFF365B85), // Body color
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // Normal font weight
                  height: 1.6, // 160% line height
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                item.syncStatus! == "1" ? "Completed" : "Pending",
                style: const TextStyle(
                  color: Color(0xFF365B85), // Body color
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // Normal font weight
                  height: 1.6, // 160% line height
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                item.paymentStatus == "PAID" ? "Paid" : "Pending",
                style: TextStyle(
                  color: logic.paymentStatusColor(
                      item.paymentStatus!), // Orange---Progress color
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.6, // 160% line height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle titleStyle = const TextStyle(
  color: Colors.white, // White color
  fontFamily: 'Be Vietnam Pro',
  fontSize: 16,
  fontWeight: FontWeight.w400, // Normal font weight
  height: 1.6, // 160% line height
);
