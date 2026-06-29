import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/button/next_prev_button.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/payment/payment_select_batch_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class PaymentSelectBatch extends StatefulWidget {
  const PaymentSelectBatch({Key? key}) : super(key: key);

  @override
  _PaymentSelectBatchState createState() => _PaymentSelectBatchState();
}

class _PaymentSelectBatchState extends State<PaymentSelectBatch> {
  @override
  void initState() {
    context.read<PaymentSelectBatchVM>().getMembershipBatchList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Batches"),
        backgroundColor: Constants.themeGradients[0],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NextPrevButton(
            title: "Submit",
            onTap: () {
              final checkSelectedBatch = context
                  .read<PaymentSelectBatchVM>()
                  .membershipBatchList
                  .any((element) => element.selected);
              print(checkSelectedBatch);
              if (checkSelectedBatch) {
                context.read<PaymentSelectBatchVM>().initiatePayment(context);
              }
            }),
      ),
      body: Consumer<PaymentSelectBatchVM>(
          builder: (_, model, __) => model.isLoading
              ? const NetworkLoading()
              : model.membershipBatchList
                      .where((element) => element.syncStatus == "1")
                      .toList()
                      .isNotEmpty
                  ? Column(
                      children: [
                        ListTile(
                          leading: Checkbox(
                              value: model.isSelectedAll,
                              onChanged: (val) {
                                context
                                    .read<PaymentSelectBatchVM>()
                                    .toggleSelectAll();
                              }),
                          title: const Text("Select All Batches", style: TextStyle(color: Colors.black),),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: model.membershipBatchList
                                    .where(
                                        (element) => element.syncStatus == "1")
                                    .toList()
                                    .length,
                                itemBuilder: (context, index) => ListTile(
                                      leading: Checkbox(
                                          value: model.membershipBatchList
                                              .where((element) =>
                                                  element.syncStatus == "1")
                                              .toList()[index]
                                              .selected,
                                          onChanged: (val) {
                                            context
                                                .read<PaymentSelectBatchVM>()
                                                .changeCheckBox(index);
                                          }),
                                      title: Text(model.membershipBatchList
                                          .where((element) =>
                                              element.syncStatus == "1")
                                          .toList()[index]
                                          .batchId, style: const TextStyle(color: Colors.black),),
                                      trailing: Text(
                                          "₹ : ${model.paymentFee! * model.membershipBatchList.where((element) => element.syncStatus == "1").toList()[index].countAM}"),
                                    )))
                      ],
                    )
                  : const Center(
                      child: Text("Kindly create and Sync Batches before pay"),
                    )),
    );
  }
}
