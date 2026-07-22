import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';

newSuccessBotttomSheet(
  String title,
  String msg,
  String msgDesc,
  String buttontext, {
  Function()? onTap,
  Function()? closeonTap,
  bool failed = false,
  bool buttonicon = true,
  bool closeIcon = true,

  
}) async {
  return Get.bottomSheet(
    // barrierDismissible: false,
    // Color _indigo = const Color(0xFF1356BF);

    Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      // height: mediaQueryData.size.height * 0.5,
      width: mediaQueryData.size.width,
      // padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Color(0xFF1356BF),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                if(closeIcon)
                InkWell(
                  onTap: closeonTap ??
                      () {
                        Get.back();
                      },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: failed
                ? null
                : const BoxDecoration(
                    color: Color(0xFF2CC7E2),
                    shape: BoxShape.circle,
                  ),
            child: failed
                ? Icon(
                    Icons.warning_amber,
                    color: Color(0xFF1356BF),
                    size: mediaQueryData.size.height * 0.06,
                  )
                : Icon(
                    Icons.check,
                    color: Color(0xFF1356BF),
                    size: mediaQueryData.size.height * 0.06,
                  ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Image.asset('assets/images/Check.png'),
          //   ],
          // ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: mediaQueryData.size.width * 0.9,
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge!.copyWith(
                  color: appTheme.indigo800, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          msgDesc.isNotEmpty
              ? SizedBox(
                  width: mediaQueryData.size.width * 0.9,
                  child: Text(msgDesc,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge!.copyWith()),
                )
              : const SizedBox(),
          SizedBox(
            height: mediaQueryData.size.height * 0.05,
          ),
          // const Spacer(),
          CustomElevatedButton(
            buttonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(0xFF1356BF))
            ),
              margin: const EdgeInsets.only(left: 20, right: 20),
              leftIcon: buttonicon
                  ? const Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.white,
                    )
                  : null,
              text: buttontext,
              onTap: onTap ??
                  () {
                    Get.back();
                    // logic.submit(context);
                  }
              // logic.youthJodoFormMetadata['eventType']
              //         .toString()
              //         .contains('attend')
              //     ? logic.submitAttend
              //     :
              ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}
