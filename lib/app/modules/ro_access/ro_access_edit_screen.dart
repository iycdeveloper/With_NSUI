import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/ro_access/ro_access_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import 'package:iyc/screens/ui/membership_ui/bottom_page_switcher.dart';
import 'package:iyc/screens/widgets/custom_button.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/dropdown/assembly_picker_dropdown.dart';
import 'package:iyc/screens/widgets/dropdown/category_picker.dart';
import 'package:iyc/screens/widgets/dropdown/district_picker_dropdown.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';
import 'package:iyc/utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:widget_zoom/widget_zoom.dart';

class NominationEditScreen extends StatefulWidget {
  const NominationEditScreen();

  @override
  State<NominationEditScreen> createState() => _NominationEditScreenState();
}

class _NominationEditScreenState extends State<NominationEditScreen> {
  dynamic nominationDetail = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<ROAccessController>().editInitcall(nominationDetail);
  }

  @override
  Widget build(BuildContext context) {
    // dynamic nominationDetail = Get.arguments;

    return GetBuilder<ROAccessController>(builder: (logic) {
      return SafeArea(
        child: logic.showVideo
            ? VideoPlayerExample(videoUrl: nominationDetail['video'])
            : Scaffold(
                appBar: CustomAppBar(
                    leadingWidth: 44.h,
                    leading: AppbarImage(
                        onTap: Get.back,
                        svgPath: ImageConstant.imgBiarrowleftIndigo800,
                        margin: EdgeInsets.only(
                            left: 20.h, top: 15.v, bottom: 15.v)),
                    title: AppbarSubtitle1(
                        text: '${nominationDetail['member_id']}',
                        margin: EdgeInsets.only(left: 12.h)),
                    styleType: Style.standard),
                bottomNavigationBar: Container(
                    padding: EdgeInsets.only(
                        left: 20.h, right: 20.h, bottom: 16.v, top: 16.v),
                    // decoration: AppDecoration.outlineBlue100011,
                    child: CustomElevatedButton(
                      text: 'Submit'.toUpperCase(),
                      onTap: () {
                        logic.onEditSubmit(context);
                      },
                    )),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: logic.firstFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFieldWithLabel(
                            label: "First Name",
                            hintText: "First Name",
                            // focusNode: model.usernameFocus,
                            // nextFocus: model.lastNameFocus,
                            // readOnly: logic.disableFields,
                            keyBoardType: TextInputType.name,
                            controller: logic.usernameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter A Valid Name';
                              }
                              return null;
                            },
                          ),
                          TextFieldWithLabel(
                            label: "Last Name",
                            hintText: "Last Name",
                            // focusNode: model.lastNameFocus,
                            // nextFocus: model.professionFocus,
                            // readOnly: model.disableFields,
                            keyBoardType: TextInputType.name,
                            controller: logic.lastNameController,
                            validation: (value) {
                              if (value.isEmpty) {
                                return 'Enter A Valid Name';
                              }
                              return null;
                            },
                          ),
                          DropDownPicker(
                            onChanged: (val) {
                              logic.changeGender(val);
                            },
                            // viewOnly: logic.disableFields,
                            listValues: logic.genders,
                            labelText: "Gender",
                            hintText: "Select a gender",
                            currentValue: logic.selectedGender,
                          ),
                          DatePickerWidget(
                            selectedDate: logic.selectedDate ?? "Select a date",
                            onTap: () async {
                              if (!logic.enableDOBEdit && logic.disableFields) {
                              } else {
                                final datePick = await showDatePicker(
                                  context: context,
                                  initialDate: new DateTime.utc(
                                    int.parse(await LocalStorageServices()
                                        .getDobEndRange()),
                                  ),
                                  firstDate: DateTime(int.parse(
                                    await LocalStorageServices()
                                        .getDobStartRange(),
                                  )),
                                  lastDate: new DateTime(
                                      int.parse(
                                        await LocalStorageServices()
                                            .getDobEndRange(),
                                      ),
                                      12,
                                      31),
                                  builder:
                                      (BuildContext? context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary: Constants.themeGradients[1],
                                          onPrimary: Colors.black87,
                                          surface: Constants.themeGradients[0],
                                          onSurface:
                                              Constants.themeGradients[1],
                                        ),
                                        dialogBackgroundColor:
                                            Constants.themeGradients[0],
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                //await datePicker(context);
                                print(datePick);
                                if (datePick != null &&
                                    datePick != logic.eventDate) {
                                  logic.changeDate(datePick);
                                }
                              }
                            },
                          ),
                          CategoryPickerWidget(
                            onChanged: (val) {
                              logic.changeCategory(val);
                            },
                            viewOnly: logic.disableFields,
                            listValues: logic.categoryList!,
                            labelText: "Category",
                            hintText: "Select a category",
                            currentValue: logic.selectedCategory,
                          ),
                          DropDownPicker(
                            onChanged: (val) {
                              logic.changeEditCandidature(val);
                            },
                            // viewOnly: logic.disableFields,
                            listValues: logic.candidateLevelList,
                            labelText: "Ballot",
                            hintText: "Select Ballot",
                            currentValue: logic.selectedEditCandidature,
                          ),

                          DistrictPickerDropDown(
                              currentDistrict: logic.selectedEditDistrict,
                              districtList: logic.districtListEditScreen,
                              selectedConstituency:
                                  "Select District Constituency",
                              // viewOnly: !val.enableDistrictEdit&&val.disableFields,
                              onChanged: (value) {
                                FocusScope.of(context).unfocus();
                                logic.changeSelectedDistrict(logic
                                    .districtListEditScreen!
                                    .singleWhere((element) =>
                                        element.districtCode == value));
                              }),
                          AssemblyPickerDropDown(
                              currentAssembly: logic.selectedEditAssembly,
                              assemblyList: logic.assemblyListeditScreen,
                              // viewOnly: !model.enableDistrictEdit&&model.disableFields,
                              selectedAssembly:
                                  "Select Assembly Constituency/Zonal/Block",
                              onChanged: (value) {
                                FocusScope.of(context).unfocus();
                                logic.changeSelectedAssemblyEditScreen(logic
                                    .assemblyListeditScreen!
                                    .singleWhere((element) =>
                                        element.assemblyCode == value));
                              }),
                          DropDownPicker(
                            currentValue: logic.selectedEditMandalam,
                            listValues: logic.mandalamListEditDropDown,
                            onChanged: (value) {
                              logic.changeMandalameditscreen(value);
                            },
                            labelText: "Mandalam/Block",
                            hintText: "Select a Mandalam/Block",
                          )
                          //district
                          //assembly

                          // CustomFloatingDropDown(
                          //     title: 'Select Ballot',
                          //     defaultMargin: false,
                          //     value: logic.selectedEditCandidature,
                          //     listValues: logic.candidateLevelList,
                          //     onChanged: (value) {
                          //       logic.changeEditCandidature(value);
                          //     }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      );
    });
  }

  void showAlertDialog(String title, String memberId) async {
    return showCupertinoDialog(
      context: Get.context!,
      builder: (context) => GetBuilder<ROAccessController>(builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              children: [
                Text('Are you sure?'),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Remark',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 2.0, // Border width when focused
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    Log.printDLog(value);
                    logic.updateRemark(value);
                  },
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: Get.back,
              ),
              CupertinoDialogAction(
                child: Text(title),
                onPressed: () {
                  Get.back();
                  logic.updateNominationStatus(
                      logic.roId,
                      memberId,
                      {
                        'Accept': 'ACCEPT',
                        'On Hold': 'ONHOLD',
                        'Reject': 'REJECT'
                      }[title]!);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ZoomableNetworkImage extends StatelessWidget {
  final String imageUrl;

  const ZoomableNetworkImage({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Image.network(
        imageUrl,
        // You can add other image properties here, like fit, width, height, etc.
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Center(child: Icon(Icons.error));
        },
      ),
    );
  }
}

class VideoPlayerExample extends StatefulWidget {
  const VideoPlayerExample({Key? key, required this.videoUrl})
      : super(key: key);
  final String videoUrl;
  @override
  State<VideoPlayerExample> createState() => _VideoPlayerExampleState();
}

class _VideoPlayerExampleState extends State<VideoPlayerExample> {
  late VideoPlayerController controller;
  // String videoUrl =
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoUrl);

    controller.addListener(() {
      setState(() {});
    });
    controller.setLooping(true);
    controller.initialize().then((_) => setState(() {}));
    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SizedBox(
        height: 60,
        child: CustomButton(
            labelText: 'Back',
            onTap: () {
              Get.find<ROAccessController>().updateShowVideo(false);
            }),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}
