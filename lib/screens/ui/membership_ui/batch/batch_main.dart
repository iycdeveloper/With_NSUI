import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iyc/provider/batch/batch_list_provider.dart';
import 'package:iyc/screens/ui/payment/payment_select_batch.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/payment/payment_select_batch_vm.dart';
import 'package:provider/provider.dart';

import '../membership_welcome_page.dart';
import 'batch_list_card.dart';

class BatchMain extends StatefulWidget {
  final bool isBackButtonExist;
  const BatchMain({Key? key, this.isBackButtonExist = false}) : super(key: key);

  @override
  _BatchMainState createState() => _BatchMainState();
}

class _BatchMainState extends State<BatchMain> {
  @override
  void initState() {
    context.read<BatchListProvider>().initialize(context);
    super.initState();
  }

  @override
  void dispose() {
    // sl.popScopesTill("membership_scope");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async =>
            context.read<BatchListProvider>().onBackButton(context),
        child: Consumer<BatchListProvider>(
            builder: (_, mod, __) => mod.loading
                ? const Scaffold(body: NetworkLoading())
                : mod.isFirstTimeMembership
                    ? const MembershipWelcomePage()
                    : Scaffold(
                        appBar: AppBar(
                          elevation: 0,
                          centerTitle: true,
                          toolbarHeight: 110,
                          backgroundColor: Constants.themeGradients[0],
                          title: Text(
                            "Membership Batch",
                            style: Constants.appbarTitleTextStyle,
                          ),
                          leading: widget.isBackButtonExist
                              ? IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  color: Constants.themeGradients[1],
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                )
                              : null,
                          bottom: PreferredSize(
                            preferredSize: const Size(0.0, 85.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Constants.themeGradients[1],
                              padding: const EdgeInsets.only(
                                top: 3,
                              ),
                              child: Column(
                                children: [
                                  Row(children: [
                                    PayButton(
                                      title: "Pay",
                                      onTap: () async {
                                        await toPage(
                                            context,
                                            ChangeNotifierProvider(
                                              create: (context) =>
                                                  PaymentSelectBatchVM(),
                                              child: const PaymentSelectBatch(),
                                            ));
                                        context
                                            .read<BatchListProvider>()
                                            .getMembershipBatchList(context,
                                                reload: true);
                                      },
                                      color: Constants.themeGradients[1],
                                      labelColor: Constants.themeGradients[0],
                                      svgIcon: "assets/icons/noun_pay.svg",
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                    ),
                                    const Spacer(),
                                    PayButton(
                                      title: "Download/Refresh",
                                      onTap: () {
                                        context
                                            .read<BatchListProvider>()
                                            .downloadExistingBatch(
                                                context: context);
                                      },
                                      svgIcon: "assets/icons/noun_Download.svg",
                                      color: Constants.themeGradients[1],
                                      labelColor: Constants.themeGradients[0],
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                    ),
                                    // URoundEdgeContainer(
                                    //     width: MediaQuery.of(context).size.width / 1.3,
                                    //     child: TextField(
                                    //       decoration: InputDecoration(
                                    //           border: InputBorder.none,
                                    //           prefixIcon: Icon(
                                    //             Icons.search,
                                    //             color: Constants.kitThemeGradients[0],
                                    //           ),
                                    //           hintText: "Search"),
                                    //     )),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: Image.asset(
                                    //     "assets/icons/reload.svg",
                                    //     color: Constants.themeGradients[0],
                                    //   ),
                                    // )
                                  ]),
                                  Consumer<BatchListProvider>(
                                      builder: (_, model, __) => Container(
                                            margin: const EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Text(
                                                    "Total AM: ${model.totalCount}"),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                        "Unpaid AM:${model.totalUnpaidAmCount}"),
                                                    Text(
                                                        "Paid AM: ${model.totalPaidAmCount}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        floatingActionButton: URoundButton(
                          title: "Create Batch",
                          onTap: () {
                            Provider.of<BatchListProvider>(context,
                                    listen: false)
                                .addBatch(context);
                          },
                          color: Constants.themeGradients[0],
                          labelColor: Constants.themeGradients[1],
                          svgIcon: "assets/icons/plus_icon.svg",
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        body: Consumer<BatchListProvider>(
                            builder: (_, val, __) => val.loading
                                ? const NetworkLoading()
                                : Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                'Batch ID',
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text('AM',
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text('Payment',
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text('Sync',
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount:
                                                val.membershipBatchList.length,
                                            itemBuilder: (context, index) =>
                                                BatchListCard(
                                                  batch: val.membershipBatchList
                                                      .reversed
                                                      .toList()[index],
                                                )),
                                      ),
                                    ],
                                  )),
                      )));
  }
}

class PayButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final Color? color;
  final Color labelColor;
  final double? width;
  final double? height;
  final String? svgIcon;

  const PayButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.color,
      this.width,
      this.height,
      this.labelColor = Colors.white,
      this.svgIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      height: MediaQuery.of(context).size.height / 12,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: color ?? Constants.themeGradientsMain[0],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: labelColor)),
      child: TextButton(
          onPressed: onTap,
          child: Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgIcon != null
                      ? Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: SvgPicture.asset(
                                svgIcon!,
                                color: labelColor,
                                height: 18,
                              )),
                        )
                      : Container(),
                  Expanded(
                    flex: 3,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: labelColor, fontWeight: FontWeight.w500),
                    ),
                  )
                ]),
          )),
    );
  }
}
