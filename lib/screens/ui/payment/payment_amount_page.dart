import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/payment/payment_amount_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class PaymentAmountPage extends StatefulWidget {
  const PaymentAmountPage(
      {Key? key,
      required this.amount,
      required this.transactionId,
      required this.batchList})
      : super(key: key);
  final int amount;
  final String transactionId;
  final List<BatchDataModel> batchList;

  @override
  _PaymentAmountPageState createState() => _PaymentAmountPageState();
}

class _PaymentAmountPageState extends State<PaymentAmountPage> {
  @override
  void initState() {
    print(widget.amount);
    super.initState();
  }
  static const Color _indigo = Color(0xFF1356BF);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Payment Batches",
            style: theme.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: theme.textTheme.bodyLarge!.color,
              )),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _indigo,
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  )),
              GestureDetector(
                  onTap: () async {
                    context.read<PaymentAmountVM>().checkPaymentAmountMatching({
                      "transaction_id": widget.transactionId,
                      "amount": widget.amount.toString()
                    }, context, widget.batchList);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ))
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "TOTAL AMOUNT",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: _indigo
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Center(child: Text(widget.amount.toString(),
              style:  theme.textTheme.bodyMedium!.copyWith(
                color: _indigo,
              ),
              )),
              decoration: BoxDecoration(
                  border: Border.all(color: _indigo.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(5)),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "TRANSACTION ID",
              style:  theme.textTheme.bodyLarge!.copyWith(
                color: _indigo
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(child: Text(widget.transactionId,
               style:  theme.textTheme.bodyMedium!.copyWith(
                color: _indigo
              ),
              )),
              decoration: BoxDecoration(
                  border: Border.all(color: _indigo.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(5)),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: Text(
                "Note: Transaction through UPI is only 50% success rate",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
