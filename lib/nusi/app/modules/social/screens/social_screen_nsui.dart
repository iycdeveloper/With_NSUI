import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/nusi/app/modules/social/screens/social_controller_nsui.dart';
import 'package:iyc/nusi/widgets/dropdown_picker_nsui.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialscreenNSUI extends StatefulWidget {
  const SocialscreenNSUI({super.key});

  @override
  State<SocialscreenNSUI> createState() => _SocialscreenNSUIState();
}

class _SocialscreenNSUIState extends State<SocialscreenNSUI> {
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return socialMediaPage();
    //   );
    // });
  }

  Container socialMediaPage() {
    final controller = Get.put(SocialNSUIController());

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(
          left: mediaQueryData.size.width * 0.05,
          right: mediaQueryData.size.width * 0.05),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF2CC7E2), Color(0xFFF8FAFF)])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Social Media Post",
            style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          DropDownPickerNSUI(
            labelcolor: theme.textTheme.bodyLarge!.color,
            onChanged: (val) {
              controller.onchangeSocialMedia(val);
            },
            // viewOnly: model.disableFields,
            listValues: controller.listValues,
            labelText: "Social Media",
            hintText: "Select a social media",
            currentValue: controller.selectSocialMedia,
          ),
          Expanded(
              child: controller.webviewcontroller != null
                  ? WebViewWidget(controller: controller.webviewcontroller!)
                  : SizedBox()
              //  ListView.builder(
              //     itemCount: 2,
              //     itemBuilder: (context, int i) {
              //       return Container(
              //         margin: const EdgeInsets.only(top: 10),
              //         decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(
              //                 mediaQueryData.size.width * 0.03)),
              //         child: Column(
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.all(10),
              //               child: Row(
              //                 children: [
              //                   CircleAvatar(
              //                     radius:
              //                         mediaQueryData.size.height * 0.025,
              //                     child: Image.asset(
              //                         'assets/nsui/applogo/playstore.png'),
              //                   ),
              //                   const SizedBox(
              //                     width: 10,
              //                   ),
              //                   Column(
              //                     crossAxisAlignment:
              //                         CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         "nusi_india",
              //                         style: theme.textTheme.bodyLarge!
              //                             .copyWith(
              //                                 fontWeight:
              //                                     FontWeight.bold),
              //                       ),
              //                       Text(
              //                         "Delhi, India",
              //                         style: theme.textTheme.bodySmall!
              //                             .copyWith(),
              //                       ),
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.only(
              //                   left: 10, right: 10),
              //               child: Container(
              //                 height: mediaQueryData.size.height * 0.25,
              //                 width: mediaQueryData.size.width,
              //                 decoration:
              //                     const BoxDecoration(color: Colors.blue),
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.only(
              //                   left: 10, right: 10, top: 10),
              //               child: SizedBox(
              //                 width: mediaQueryData.size.width,
              //                 child: Text(
              //                   "nsui_india The NSUI National President Shri Varun Choudhary will be in Odisha tomorrow (16th July, 2025). Do join us in greeting him!",
              //                   style:
              //                       theme.textTheme.bodySmall!.copyWith(),
              //                 ),
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(10),
              //               child: Row(
              //                 children: [
              //                   Text(
              //                     "10:45 PM Sep 1, 2022",
              //                     style: theme.textTheme.bodySmall!
              //                         .copyWith(),
              //                   ),
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //       );
              //     })

              )
        ],
      ),
      // ),
      // bottomNavigationBar: MotionTabBar(
      //   controller: Get.find<HomeNSUIController>()
      //       .motionTabBarController, // ADD THIS if you need to change your tab programmatically
      //   initialSelectedTab: "Social",
      //   useSafeArea: true, // default: true, apply safe area wrapper
      //   labelAlwaysVisible:
      //       true, // default: false, set to "true" if you need to always show labels
      //   labels: const ["Home", "Social", "Profile"],
      //   // use custom widget as display Icon
      //   iconWidgets: [
      //     SvgPicture.asset(
      //       'assets/nsui/svg/bottomhome.svg',
      //       fit: BoxFit.fill,
      //       height: mediaQueryData.size.height * 0.04,
      //       width: mediaQueryData.size.width * 0.04,
      //     ),
      //     SvgPicture.asset(
      //       'assets/nsui/svg/bottomsocial.svg',
      //       fit: BoxFit.fill,
      //       height: mediaQueryData.size.height * 0.04,
      //       width: mediaQueryData.size.width * 0.04,
      //     ),
      //     SvgPicture.asset(
      //       'assets/nsui/svg/bottomprofile.svg',
      //       fit: BoxFit.fill,
      //       height: mediaQueryData.size.height * 0.04,
      //       width: mediaQueryData.size.width * 0.04,
      //     ),
      //   ],

      //   tabSize: 30,
      //   // tabBarHeight: mediaQueryData.size.height*0.08,
      //   textStyle: const TextStyle(
      //     fontSize: 12,
      //     color: Colors.black,
      //     fontWeight: FontWeight.w500,
      //   ),
      //   // tabIconColor: Colors.blue[600],
      //   tabIconSize: 28.0,
      //   tabIconSelectedSize: 32.0,
      //   tabSelectedColor: Colors.white,
      //   tabIconSelectedColor: Colors.black,
      //   tabBarColor: Colors.white,
      //   onTabItemSelected: (int value) {
      //     Get.find<HomeNSUIController>().onchangeMenu(value);
      //   },
      // ),
    );
  }
}
