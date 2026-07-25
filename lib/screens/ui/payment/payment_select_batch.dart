import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
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

  static const Color _indigo = Color(0xFF1356BF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Membership",
          style:
              theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          // _indigo.withOpacity(0.10)
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: theme.textTheme.bodyLarge!.color,
            )),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NextPrevButton(
            color: _indigo,
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
                              activeColor: _indigo,
                              value: model.isSelectedAll,
                              checkColor: Colors.white,
                              onChanged: (val) {
                                context
                                    .read<PaymentSelectBatchVM>()
                                    .toggleSelectAll();
                              }),
                          title: const Text(
                            "Select All Membership",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: model.membershipBatchList
                                    .where((element) =>
                                        element.syncStatus == "1" &&
                                        element.paymentStatus == 'Pending')
                                    .toList()
                                    .length,
                                itemBuilder: (context, index) {
                                  final batch = model.membershipBatchList
                                      .where((e) =>
                                          e.syncStatus == "1" &&
                                          e.paymentStatus == "Pending")
                                      .toList()[index];

                                  final members = model.memberList!
                                      .where((m) => m.batchId == batch.batchId)
                                      .toList();

                                  if (members.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return ListTile(
                                    leading: Checkbox(
                                        activeColor: _indigo,
                                        checkColor: Colors.white,
                                        value: batch.selected,
                                        onChanged: (val) {
                                          context
                                              .read<PaymentSelectBatchVM>()
                                              .changeCheckBox(batch);
                                        }),
                                    title: Text(
                                      members.first.memberId ?? "",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    trailing: Text(
                                        "₹ : ${model.paymentFee! * members.length}"),
                                  );
                                }))
                      ],
                    )
                  : const Center(
                      child: Text("Kindly create and Sync Batches before pay"),
                    )),
    );
  }
}
