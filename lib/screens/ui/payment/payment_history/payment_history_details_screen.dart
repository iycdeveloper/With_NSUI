import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:iyc/app/core/app_export.dart';
// import 'package:iyc/test2.dart';
import 'package:pinput/pinput.dart';

class PaymentHistoryDetailsScreen extends StatefulWidget {
  const PaymentHistoryDetailsScreen({super.key});

  @override
  State<PaymentHistoryDetailsScreen> createState() =>
      _PaymentHistoryDetailsScreenState();
}

class _PaymentHistoryDetailsScreenState
    extends State<PaymentHistoryDetailsScreen> {
  dynamic data = Get.arguments;
  String dateformate(String dateTime2) {
    DateTime dateTime = DateTime.parse(dateTime2);

    // Format to dd-MM-yyyy
    String formatted = DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);

    return formatted;
  }

      Color _indigo = const Color(0xFF1356BF);


  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
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
                icon:  Icon(
                  Icons.arrow_back,
                  color: theme.textTheme.bodyLarge!.color,
                )),
            centerTitle: true,
            title: Text(
              // lan: Get.find<HomeController>().language,
              'Transaction Checkout',
              style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold, ),
            ),
          ),
          body: Container(
              padding: const EdgeInsets.all(20),
              height: mediaQueryData.size.height,
              width: mediaQueryData.size.width,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Container(
                          width: mediaQueryData.size.width,
                          padding: const EdgeInsets.all(15),
                          height: mediaQueryData.size.height * 0.08,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: _indigo,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: Text(
                            'Payment Details',
                            style: theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(
                              mediaQueryData.size.height * 0.02),
                          child: Column(
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Id: ',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: mediaQueryData.size.width * 0.6,
                                    child: Text(
                                      data['order_id'],
                                      textAlign: TextAlign.start,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.grey[500]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bank Ref No: ',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: mediaQueryData.size.width * 0.5,
                                    child: Text(
                                      data['bank_ref_no'] == 'null' ||
                                              data['bank_ref_no']
                                                  .toString()
                                                  .isEmpty
                                          ? '---'
                                          : data['bank_ref_no'],
                                      textAlign: TextAlign.start,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.grey[500]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payemnt Status: ',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    // width: mediaQueryData.size.width * 0.4,
                                    child: Text(
                                      data['order_status'],
                                      textAlign: TextAlign.start,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: data['order_status'] ==
                                                      'Aborted'
                                                  ? const Color.fromARGB(255, 137, 132, 132)
                                                  : data['order_status'] ==
                                                          'Success'
                                                      ? const Color.fromARGB(
                                                          255, 15, 158, 61)
                                                      : data['order_status'] ==
                                                              'Pending'
                                                          ? const Color
                                                              .fromARGB(255,
                                                              251, 235, 110)
                                                          : const Color
                                                              .fromARGB(255,
                                                              241, 146, 129)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payemnt Mode: ',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    // width: mediaQueryData.size.width * 0.4,
                                    child: Text(
                                      data['payment_mode'].toString().isEmpty
                                          ? '---'
                                          : data['payment_mode'],
                                      textAlign: TextAlign.start,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Start: ',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    // width: mediaQueryData.size.width * 0.5,
                                    child: Text(
                                      data['payment_start']
                                              .toString()
                                              .isNotEmpty
                                          ? dateformate(data['payment_start'])
                                          : '---',
                                      textAlign: TextAlign.start,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.grey[500]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment End: ',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    // width: mediaQueryData.size.width * 0.5,
                                    child: Text(
                                      data['payment_complete']
                                              .toString()
                                              .isNotEmpty
                                          ? dateformate(data['payment_start'])
                                          : '',
                                      textAlign: TextAlign.start,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.grey[500]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount: ',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    // width: mediaQueryData.size.width * 0.5,
                                    child: Text(
                                      data['amount'].toString().isNotEmpty
                                          ? '₹ ' + data['amount']
                                          : '---',
                                      textAlign: TextAlign.start,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}
