import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/image_constant.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/provider/nomination/nominations_provider.dart';
import 'package:provider/provider.dart';

class NominationHelpPage extends StatelessWidget {
  const NominationHelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // drawer: HomePageDrawer(),
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
                  text: "Nomination", margin: EdgeInsets.only(left: 12.h)),
              styleType: Style.standard),
          body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    const Color(0xFF2CC7E2).withOpacity(0.1),
                    Colors.white
                  ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 20, top: 0, left: 20, right: 20),
                    width: double.infinity,
                    height: 190.v,
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(color: Colors.grey[200]!, spreadRadius: 1.2)
                        ],
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                            image: AssetImage(
                                'assets/nsui/banner/nominationbanner.jpeg'),
                            fit: BoxFit.fitWidth)),
                  ),
                  // const HandIconIYC(),

                  // Container(
                  //   padding: const EdgeInsets.all(5),
                  //   child: Text(
                  //     "Welcome",
                  //     style: TextStyle(
                  //         fontSize: 22,
                  //         fontWeight: FontWeight.w800,
                  //         color: Constants.themeGradients[0]),
                  //   ),
                  // ),
                  // RichText(
                  //   text: new TextSpan(
                  //     children: [
                  //       new TextSpan(
                  //         text:
                  //             "•	Nomination will be conducted prior to the membership.\n"
                  //             "•	All aspirants will have to file nominations in order to be eligible.\n"
                  //             "•	List of nomination along with Candidate Serial Number will be displayed on IYC website.\n"
                  //             "•	Members will have to choose the “Candidate Serial Number” to select the candidate of their choice for each committee level when they fill up the membership form:",
                  //         style: new TextStyle(color: Colors.black),
                  //       ),
                  //       new TextSpan(
                  //         text: '',
                  //         style: new TextStyle(color: Colors.blue),
                  //         recognizer: new TapGestureRecognizer()..onTap = () {},
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        const MembershipWelcomePageTextItem(
                          labelText:
                              "Nomination will be conducted prior to the membership.",
                        ),
                        const MembershipWelcomePageTextItem(
                          labelText:
                              "All aspirants will have to file nominations in order to be eligible.",
                        ),
                        const MembershipWelcomePageTextItem(
                          labelText:
                              "Nomination along with candidate serial number will be displayed on NSUI website.",
                        ),
                        // MembershipWelcomePageTextItem(
                        //   labelText: "District GS Committee",
                        // ),
                        const MembershipWelcomePageTextItem(
                          labelText:
                              "Members will have to choose the \"Candidate Serial Number\" to select the candidate of their choice for each committee level when they fill up the membership form:",
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "1. Assembly Committee",
                                  style: theme.textTheme.bodyLarge!.copyWith(),
                                ),
                                Text(
                                  "2. District President Committee",
                                  style: theme.textTheme.bodyLarge!.copyWith(),
                                ),
                                Text(
                                  "3.  District GS Committee",
                                  style: theme.textTheme.bodyLarge!.copyWith(),
                                ),
                                Text(
                                  "4. State GS Committee",
                                  style: theme.textTheme.bodyLarge!.copyWith(),
                                ),
                                Text(
                                  "5. State President Committee",
                                  style: theme.textTheme.bodyLarge!.copyWith(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // const Spacer(),
                  // URoundButton(
                  //     title: "Apply",
                  //     onTap: () async {
                  //       context
                  //           .read<NominationsProvider>()
                  //           .agrCreateBatch(context);
                  //     })
                ],
              )),
          bottomNavigationBar: Container(
              padding: EdgeInsets.only(
                  left: 20.h, right: 20.h, bottom: 10.v, top: 10.v),
              decoration: AppDecoration.outlineBlue100011,
              child: CustomElevatedButton(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.6,
                          blurRadius: 0.6
                        )
                      ]),
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // This creates sharp, unrounded corners
                    ),
                  ),
                  text: "Apply",
                  onTap: () {
                    context.read<NominationsProvider>().agrCreateBatch(context);
                  }))),
    );
  }
}

class MembershipWelcomePageTextItem extends StatelessWidget {
  final String labelText;

  const MembershipWelcomePageTextItem({Key? key, required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: CustomImageView(
            svgPath: ImageConstant.imgBoldArrow,
            color: const Color(0xFF4193D0),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            labelText,
            style: theme.textTheme.bodyMedium!
                .copyWith(color: theme.textTheme.bodyLarge!.color),
          ),
        ),
      ]),
    );
  }
}
