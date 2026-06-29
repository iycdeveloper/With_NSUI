import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/theme/app_decoration.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/provider/batch/batch_list_provider.dart';
import 'package:iyc/utils/constants.dart';
import 'package:provider/provider.dart';


class MembershipWelcomePage extends StatelessWidget {
  const MembershipWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Membership',
          ),
          centerTitle: true,
          backgroundColor: Constants.themeGradients[0],
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              height: 190.v,
              decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/newlogo/membershipbanner.png"),
                      fit: BoxFit.fitWidth)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WELCOME!',
                      style: theme.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 16,
                  ),
                  // const Text(
                  //   'We have Introduced a new facility to add multiple AMs from one app. Please go through the information flyer to find out how this app will help you. Click here',
                  //   style: TextStyle(
                  //     color: Color(
                  //         0xFF365B85), // Hex color to Color object
                  //     fontFamily: 'Be Vietnam Pro',
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w400, // Normal font weight
                  //     height: 1.6, // Line height as a multiplier
                  //   ),
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                  _row(
                      'WE DO NOT DISCLOSE District-wise \nMembership Closure.'),
                  const SizedBox(
                    height: 16,
                  ),
                  _row('Fees payment is accepted \nONLY for Synced data.'),
                  const SizedBox(
                    height: 16,
                  ),
                  _row(
                      'Unpaid SYNC data will be deleted after \nMembership closure.'),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  width: mediaQueryData.size.width * 0.8,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlueAccent.shade100.withOpacity(0.2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info),
                      SizedBox(
                          width: mediaQueryData.size.width * 0.6,
                          child: const Text(
                              'You can now add multiple AMs from a single app. '))
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: Container(
            padding: EdgeInsets.only(
                left: 20.h, right: 20.h, bottom: 10.v, top: 10.v),
            decoration: AppDecoration.outlineBlue100011,
            child: CustomElevatedButton(
                text: "APPLY NOW".toUpperCase(),
                onTap: () =>
                    context.read<BatchListProvider>().getAggrId(context)))
        // SingleChildScrollView(
        //     child: Container(
        //         alignment: Alignment.center,
        //         margin: EdgeInsets.all(12),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             HandIconIYC(),
        //             Container(
        //               padding: EdgeInsets.all(5),
        //               child: Text(
        //                 "Welcome",
        //                 style: TextStyle(
        //                     fontSize: 22,
        //                     fontWeight: FontWeight.w800,
        //                     color: Constants.themeGradients[0]),
        //               ),
        //             ),
        //             RichText(
        //               text: new TextSpan(
        //                 children: [
        //                   new TextSpan(
        //                     text:
        //                         'WE have Introduced a new facility to add multiple AMs from one app. Please go through the information flyer to find out how this app will help you. ',
        //                     style: new TextStyle(color: Colors.black),
        //                   ),
        //                   new TextSpan(
        //                     text: 'Click here',
        //                     style: new TextStyle(color: Colors.blue),
        //                     recognizer: new TapGestureRecognizer()..onTap = () {},
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Container(
        //               alignment: Alignment.topLeft,
        //               padding: EdgeInsets.all(10),
        //               child: Text(
        //                 "Note",
        //                 style:
        //                     TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        //               ),
        //             ),
        //             MembershipWelcomePageTextItem(
        //               labelText:
        //                   "WE DO NOT DISCLOSE District- wise Membership Closure.",
        //             ),
        //             MembershipWelcomePageTextItem(
        //               labelText: "Fees payment is accepted ONLY for Synced data.",
        //             ),
        //             MembershipWelcomePageTextItem(
        //               labelText:
        //                   "WE DO NOT DISCLOSE District- wise Membership Closure",
        //             ),
        //             MembershipWelcomePageTextItem(
        //               labelText:
        //                   "Unpaid SYNCed data will be deleted after Membership closure.",
        //             ),
        //             URoundButton(
        //                 title: "Apply",
        //                 onTap: () async {
        //                   context.read<BatchListProvider>().getAggrId(context);
        //                   // toPage(
        //                   //     context,
        //                   //     MultiProvider(providers: [
        //                   //       ChangeNotifierProvider(
        //                   //         create: (context) =>
        //                   //             sl<MembershipListProvider>(),
        //                   //       ),
        //                   //       ChangeNotifierProvider(
        //                   //         create: (context) => sl<BatchListProvider>(),
        //                   //       ),
        //                   //     ], child: BatchMain(isBackButtonExist: true,)));
        //                   // Navigator.of(context).push(MaterialPageRoute(
        //                   //     builder: (context) => ChangeNotifierProvider(
        //                   //         create: (context) => LoginMembershipVM(),
        //                   //         child: LoginMembership())));
        //                 })
        //           ],
        //         ))),
        );
  }

  Widget _row(String title) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: CustomImageView(
              svgPath: ImageConstant.imgBoldArrow,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(title, style: theme.textTheme.bodyLarge!.copyWith())
        ],
      );
}

class MembershipWelcomePageTextItem extends StatelessWidget {
  final String labelText;

  const MembershipWelcomePageTextItem({Key? key, required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 8,
            color: Constants.themeTextGradients[0],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.only(left: 5),
          child: Text(
            labelText,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Constants.themeTextGradients[0]),
          ),
        ),
      ]),
    );
  }
}
