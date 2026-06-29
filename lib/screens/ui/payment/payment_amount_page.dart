import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: ()async=>false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Payment Batches"),leading: Container(),centerTitle: true,
          backgroundColor: Constants.themeGradients[0],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.lightBlueAccent.shade200,
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
                        color: Colors.black87,
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
                        color: Colors.black87,
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
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Center(child: Text(widget.amount.toString())),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade300),
                  borderRadius: BorderRadius.circular(5)),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "TRANSACTION ID",
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Center(child: Text(widget.transactionId)),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade300),
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
