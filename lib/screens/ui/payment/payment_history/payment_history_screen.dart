import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
// import 'package:iyc/app/modules/forms/save_bengal_d2d_campaign/local_widget/language_drop_down.dart';
// import 'package:iyc/app/modules/forms/save_bengal_d2d_campaign/save_bengal_d2d_campaign_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/screens/ui/payment/payment_history/payment_history_controller.dart';
// import 'package:iyc/test2.dart';
import 'package:pinput/pinput.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color _indigo = const Color(0xFF1356BF);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromRGBO(126, 203, 224, 1),
        ),
      ),
    );
    return SafeArea(
      child: GetBuilder<PaymentHistoryController>(builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            leadingWidth: mediaQueryData.size.width * 0.12,
            // leadingWidth: 44.h,
            leading: IconButton(
                padding: const EdgeInsets.only(left: 10),
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.textTheme.bodyLarge!.color,
                )),
            centerTitle: true,
            title: Text(
              // lan: Get.find<HomeController>().language,
              'Payment History',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: (!logic.loadingData && logic.transactionList.isEmpty)
              ? const Center(
                child: SizedBox(
                    height: 150,
                    child: Center(
                      child: Text("Payment History Unavailable"),
                    ),
                  ),
              )
              : ListView.builder(
                  itemCount: logic.transactionList.length,
                  itemBuilder: (context, int i) {
                    return Container(
                      // height: MediaQuery.of(context).size.height * 0.065,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFF2CC7E2).withOpacity(0.3))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      logic.transactionList[i]
                                          ['order_id'], //.substring(0, 8),
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      logic.transactionList[i]['amount']
                                              .toString()
                                              .isNotEmpty
                                          ? '₹ ' +
                                              logic.transactionList[i]['amount']
                                          : '---',
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                flex: 31,
                              ),

                              // Expanded(
                              //   child:
                              //       Text(batch.paymentStatus == "PAID" ? "Paid" : "Pending"),
                              //   flex: 2,
                              // ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: logic.transactionList[i]
                                                ['order_status'] ==
                                            'Aborted'
                                        ? const Color(0xFFD5D5D5)
                                        : logic.transactionList[i]
                                                    ['order_status'] ==
                                                'Success'
                                            ? const Color(0xFFB5F5C9)
                                            : logic.transactionList[i]
                                                        ['order_status'] ==
                                                    'Pending'
                                                ? const Color(0xFFF5EEB5)
                                                : const Color(0xFFF5BFB5)),
                                child: Row(
                                  children: [
                                    Text(
                                        logic.transactionList[i]
                                            ['order_status'],
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: Colors.black)),
                                    Image.asset(
                                      ImageConstant.imagePathNew +
                                          '/images/synced.png',
                                      scale: 2,
                                    )
                                  ],
                                ),
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              // Container(
                              //     padding: const EdgeInsets.all(5),
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(8),
                              //         color: const Color(0xFFD4E5FF)),
                              //     child: const Icon(Icons.file_download_outlined)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: const Color(0xFF2CC7E2).withOpacity(0.3),
                            indent: 3.0,
                            endIndent: 3.0,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // CustomElevatedButton(
                              //     buttonStyle: ButtonStyle(
                              //       side: WidgetStateProperty.all(BorderSide(
                              //           color: theme.textTheme.bodyLarge!.color!,
                              //           width: 0.8)),
                              //       backgroundColor: WidgetStateProperty.all(
                              //           // batch.paymentStatus == 'PAID'
                              //           //     ? Colors.grey[400]
                              //               // :
                              //                Colors.white),
                              //     ),
                              //     width: mediaQueryData.size.width * 0.3,
                              //     height: mediaQueryData.size.height * 0.042,
                              //     text:
                              //          "Pay Now",
                              //     buttonTextStyle: theme.textTheme.bodyMedium!
                              //         .copyWith(color: theme.textTheme.bodyLarge!.color),
                              //     onTap:() async {

                              //           }),
                              CustomElevatedButton(
                                buttonStyle: ButtonStyle(
                                  backgroundColor:WidgetStateProperty.all(_indigo) 
                                ),
                                  width: mediaQueryData.size.width * 0.8,
                                  height: mediaQueryData.size.height * 0.042,
                                  text: "View Now >>",
                                  buttonTextStyle: theme.textTheme.bodyMedium!
                                      .copyWith(color: Colors.white),
                                  onTap: () async {
                                    RoutesManagement.goToPaymentHistoryDetails(
                                        logic.transactionList[i]);
                                  })
                            ],
                          )
                        ],
                      ),
                    );
                  }),
        );
      }),
    );
  }
}
