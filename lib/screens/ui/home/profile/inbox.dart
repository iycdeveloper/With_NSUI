import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/model/api_model/task/task.dart';
import 'package:iyc/screens/ui/home/profile/create_task.dart';
import 'package:iyc/screens/ui/home/profile/view_task_details.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/home/home_page_sashboard_vm.dart';
import 'package:iyc/view_model/profile/inbox/inbox_vm.dart';
import 'package:iyc/view_model/profile/inbox/task_create_vm.dart';
import 'package:iyc/view_model/profile/inbox/task_details_vm.dart';
import 'package:provider/provider.dart';

class InboxView extends StatefulWidget {
  const InboxView({Key? key}) : super(key: key);

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  Color customRedColor = Color.fromRGBO(229, 62, 62, 1.0);
  Color customGreyColor = Color.fromRGBO(113, 128, 150, 1);

  final List<String> options = ['New', 'Completed', 'Expired'];
  int currentIndex = 0;

  @override
  void initState() {
    context.read<InboxVM>().getAllTasks(context);
    context.read<InboxVM>().getUserProfile(context);
    context.read<InboxVM>().getDailyTaskStatus(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InboxVM>(
      builder: (_, model, __) => model.isLoading
          ? Scaffold(
              appBar: AppBar(
                title: Text("Tasks"),
                centerTitle: true,
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ))
          : RefreshIndicator(
              onRefresh: () async {
                model.getAllTasks(context, true);
              },
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () async {
                      await Provider.of<HomePageDashboardVM>(context,
                              listen: false)
                          .getLocalSavedPendingTaskCount();
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text("Tasks"),
                  centerTitle: true,
                  actions: [
                    // IconButton(
                    //     onPressed: () {
                    //       toPage(
                    //           context,
                    //           ChangeNotifierProvider(
                    //             create: (_) => TaskCalenderVM(),
                    //             child: TaskCalender(),
                    //           ));
                    //       //    model.CreateTask();
                    //     },
                    //     icon: Icon(
                    //       Icons.calendar_month,
                    //       color: Colors.white,
                    //     )),
                    if (model.userDetail != null)
                      if (['State Admin', 'Super Admin']
                          .contains(model.userDetail!.roleName))
                        IconButton(
                          onPressed: () {
                            toPage(
                                context,
                                ChangeNotifierProvider(
                                  create: (_) => TaskCreateVM(),
                                  child: CreateTask(),
                                ));
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                  ],
                ),
                body: Scaffold(
                  appBar: PreferredSize(
                    preferredSize:
                        Size(MediaQuery.of(context).size.width, kToolbarHeight),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  options.length,
                                  (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              currentIndex = index;
                                            });

                                            context
                                                .read<InboxVM>()
                                                .sortTasks(context, index);
                                          },
                                          child: Material(
                                            color: currentIndex == index
                                                ? customRedColor.withOpacity(.2)
                                                : customGreyColor
                                                    .withOpacity(.2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child: Text(
                                                options[index],
                                                // style: Theme.of(context)
                                                //     .textTheme
                                                //     .bodyText1!
                                                //     .copyWith(
                                                //         color: currentIndex ==
                                                //                 index
                                                //             ? customRedColor
                                                //             : customGreyColor),
                                              )),
                                            ),
                                          ),
                                        ),
                                      )),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: const LinearProgressIndicator(
                            minHeight: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                  body: model.isLoading
                      ? NetworkLoading()
                      : model.taskList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/iyc_icons/no-task.png"),
                                  Text("No Tasks"),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                if (model.dailyTaskCount != null &&
                                    currentIndex == 0)
                                  Column(
                                    children: [
                                      CircularProgressBarWithText(
                                        progress: int.parse(
                                                model.dailyTaskCompleted!) /
                                            int.parse(model.dailyTaskCount!),
                                        text:
                                            '${model.dailyTaskCompleted}/${model.dailyTaskCount}',
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Daily Progress Chart'),
                                    ],
                                  ),
                                Expanded(
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(24),
                                      itemBuilder: (context, index) =>
                                          InboxItemWidget(
                                            task: model.taskList[index],
                                            onTap: () async {
                                              await toPage(
                                                  context,
                                                  ChangeNotifierProvider(
                                                    create: (_) =>
                                                        TaskDetailsVM(),
                                                    child: ViewTaskDetails(
                                                        task: model
                                                            .taskList[index]),
                                                  ));
                                              context
                                                  .read<InboxVM>()
                                                  .getAllTasks(context, true);
                                            },
                                          ),
                                      separatorBuilder: (context, index) =>
                                          const Divider(),
                                      itemCount: model.taskList.length),
                                ),
                              ],
                            ),
                ),
              ),
            ),
    );
  }
}

class InboxItemWidget extends StatelessWidget {
  final Task task;

  final VoidCallback onTap;

  InboxItemWidget({
    Key? key,
    required this.task,
    required this.onTap,
  }) : super(key: key);

  Color customRedColor = Color.fromRGBO(229, 62, 62, 1.0);
  Color customGreyColor = Color.fromRGBO(113, 128, 150, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: (task.taskPriority != null && task.taskPriority == "URGENT")
                ? Border.all(color: customRedColor)
                : null),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    Text(
                      DateFormat("dd-MM-yyyy").format(task.taskEndDate),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: task.taskStatus == 'Completed'
                              ? Colors.green
                              : customGreyColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                              side: BorderSide(
                                  color: task.taskStatus == 'COMPLETED'
                                      ? Colors.transparent
                                      : customGreyColor)),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: task.taskStatus == 'COMPLETED'
                                ? Colors.green
                                : Colors.transparent,
                            child: Icon(
                              Icons.check,
                              color: task.taskStatus == 'COMPLETED'
                                  ? Colors.white
                                  : customGreyColor,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          task.taskType,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Material(
                      color: customRedColor,
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                        child: Row(
                          children: [
                            Text(
                              '${task.taskPoint}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Icon(
                              Icons.catching_pokemon_sharp,
                              color: Colors.white,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)]
                          .withOpacity(.2),
                      radius: 30,
                      backgroundImage: (task.taskType == "TEXT"
                          ? const NetworkImage(
                              "https://www.shutterstock.com/image-photo/businessman-holds-paper-tasks-on-260nw-1892666329.jpg")
                          : task.taskType == "VIDEO"
                              ? NetworkImage(
                                  "https://i.ytimg.com/vi/${task.taskUrl.split("v=").last}/hqdefault.jpg")
                              : task.taskType == "AUDIO"
                                  ? NetworkImage(
                                      "https://www.headphonesty.com/wp-content/uploads/2020/04/Audio-file-format-MP3_OK-1100x653.jpg")
                                  : NetworkImage(task.taskUrl)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Text(
                            task.taskText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       '$timestamp - ',
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .bodyText2!
                        //           .copyWith(color: customGreyColor),
                        //     ),
                        //   ],
                        // )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

//class MessageDisplayWidget extends StatelessWidget {
//   MessageDisplayWidget({
//     Key? key,
//     required FirebaseAuth firebaseAuth,
//     required this.snapshot,
//     required this.inboxManager,
//   })  : _firebaseAuth = firebaseAuth,
//         super(key: key);
//
//
//   Color customRedColor = Color.fromRGBO(229, 62, 62, 1.0);
//   Color customGreyColor = Color.fromRGBO(113, 128, 150, 1);
//
//
//   final FirebaseAuth _firebaseAuth;
//   final Datum snapshot;
//   final InboxManager inboxManager;
//
//   final TextEditingController _commentController = TextEditingController();
//   final UiUtilities uiUtilities = UiUtilities();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 6,
//                     backgroundColor: Colors
//                         .primaries[Random().nextInt(Colors.primaries.length)],
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   Text(
//                     snapshot.team!,
//                     style: Theme.of(context).textTheme.bodyText1,
//                   ),
//                 ],
//               ),
//               Text(
//                 snapshot.status!,
//                 style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                     color: snapshot.status! == 'Completed'
//                         ? Colors.green
//                         : customGreyColor),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Material(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(45),
//                         side: BorderSide(
//                             color: snapshot.status! == 'Completed'
//                                 ? Colors.transparent
//                                 : customGreyColor)),
//                     child: CircleAvatar(
//                       radius: 12,
//                       backgroundColor: snapshot.status! == 'Completed'
//                           ? Colors.green
//                           : Colors.transparent,
//                       child: Icon(
//                         Icons.check,
//                         color: snapshot.status! == 'Completed'
//                             ? Colors.white
//                             : customGreyColor,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     snapshot.title!,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyText1!
//                         .copyWith(fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//               snapshot.like == null
//                   ? const SizedBox.shrink()
//                   : Material(
//                       color: customRedColor,
//                       borderRadius: BorderRadius.circular(35),
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
//                         child: Row(
//                           children: [
//                             Text(
//                               '${snapshot.like == null ? 0 : snapshot.like!.length}',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .subtitle2!
//                                   .copyWith(
//                                       fontWeight: FontWeight.normal,
//                                       color: Colors.white),
//                             ),
//                             const SizedBox(
//                               width: 2,
//                             ),
//                             const Icon(
//                               Ionicons.ios_chatbubbles,
//                               color: Colors.white,
//                               size: 15,
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors
//                     .primaries[Random().nextInt(Colors.primaries.length)]
//                     .withOpacity(.2),
//                 radius: 30,
//                 backgroundImage: (snapshot.user!.picture!.isEmpty
//                     ? const ExactAssetImage('assets/avatar.png')
//                     : NetworkImage(snapshot.user!.picture!)) as ImageProvider,
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width - 120,
//                     child: ReadMoreText(
//                       snapshot.message!,
//                       trimLines: 5,
//                       colorClickableText: customRedColor,
//                       lessStyle: Theme.of(context)
//                           .textTheme
//                           .bodyText1!
//                           .copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: customRedColor),
//                       trimMode: TrimMode.Line,
//                       trimCollapsedText: 'Show more',
//                       trimExpandedText: 'Show less',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyText1!
//                           .copyWith(fontWeight: FontWeight.normal),
//                       moreStyle: Theme.of(context)
//                           .textTheme
//                           .bodyText1!
//                           .copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: customRedColor),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${time_ago.format(snapshot.createdAt!)} - ',
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyText2!
//                             .copyWith(color: customGreyColor),
//                       ),
//                       Icon(
//                         (snapshot.like == null
//                                 ? false
//                                 : snapshot.like
//                                     .contains(_firebaseAuth.currentUser!.uid))
//                             ? Icons.thumb_up
//                             : Feather.thumbs_up,
//                         color: (snapshot.like == null
//                                 ? false
//                                 : snapshot.like
//                                     .contains(_firebaseAuth.currentUser!.uid))
//                             ? customRedColor
//                             : customGreyColor,
//                         size: 20,
//                       )
//                     ],
//                   )
//                 ],
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           Text(
//             '---------- Comments ----------',
//             textAlign: TextAlign.center,
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyText2!
//                 .copyWith(fontWeight: FontWeight.w600, color: customGreyColor),
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           StreamBuilder<comment.Comment?>(
//               stream: inboxManager
//                   .getInboxComments(inboxId: snapshot.id)
//                   .asStream(),
//               builder: (context, commentSnapshot) {
//                 return ListView.separated(
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       if (commentSnapshot.connectionState ==
//                               ConnectionState.waiting &&
//                           commentSnapshot.data == null) {
//                         return const Center(
//                             child: CircularProgressIndicator.adaptive());
//                       }
//
//                       if (commentSnapshot.connectionState ==
//                               ConnectionState.done &&
//                           commentSnapshot.data == null) {
//                         return const SizedBox.shrink();
//                       }
//                       return Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.primaries[
//                                     Random().nextInt(Colors.primaries.length)]
//                                 .withOpacity(.2),
//                             radius: 30,
//                             backgroundImage: (snapshot.user!.picture!.isEmpty
//                                     ? const ExactAssetImage('assets/avatar.png')
//                                     : NetworkImage(snapshot.user!.picture!))
//                                 as ImageProvider,
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width - 120,
//                                 child: ReadMoreText(
//                                   snapshot.message!,
//                                   trimLines: 5,
//                                   colorClickableText: customRedColor,
//                                   lessStyle: Theme.of(context)
//                                       .textTheme
//                                       .bodyText1!
//                                       .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: customRedColor),
//                                   trimMode: TrimMode.Line,
//                                   trimCollapsedText: 'Show more',
//                                   trimExpandedText: 'Show less',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyText1!
//                                       .copyWith(fontWeight: FontWeight.normal),
//                                   moreStyle: Theme.of(context)
//                                       .textTheme
//                                       .bodyText1!
//                                       .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: customRedColor),
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     '${time_ago.format(snapshot.createdAt!)} - ',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText2!
//                                         .copyWith(color: customGreyColor),
//                                   )
//                                 ],
//                               )
//                             ],
//                           )
//                         ],
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return const Divider();
//                     },
//                     itemCount: commentSnapshot.data == null
//                         ? 0
//                         : commentSnapshot.data!.data!.length);
//               })
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: TextFormField(
//             controller: _commentController,
//             style: Theme.of(context).textTheme.bodyText1,
//             textInputAction: TextInputAction.send,
//             keyboardType: TextInputType.multiline,
//             textCapitalization: TextCapitalization.words,
//             maxLines: 1,
//             cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
//             enableInteractiveSelection: true,
//             decoration: InputDecoration(
//                 suffixIcon: InkWell(
//                     onTap: () async {
//                       BotToast.showLoading(
//                           allowClick: false,
//                           clickClose: false,
//                           backButtonBehavior: BackButtonBehavior.ignore);
//
//                       bool isSent = await inboxManager.submitInboxComment(
//                           comment: _commentController.text,
//                           inboxId: snapshot.id);
//                       BotToast.closeAllLoading();
//                       if (isSent) {
//                         _commentController.clear();
//                         uiUtilities.actionAlertWidget(
//                             context: context, alertType: 'success');
//                         uiUtilities.alertNotification(
//                             context: context, message: inboxManager.message!);
//                       } else {
//                         uiUtilities.actionAlertWidget(
//                             context: context, alertType: 'error');
//                         uiUtilities.alertNotification(
//                             context: context, message: inboxManager.message!);
//                         debugPrint('$e');
//                       }
//                     },
//                     child: const Icon(
//                       Icons.send,
//                       color: customGreyColor,
//                     )),
//                 label: Text(
//                   'Comment',
//                   style: Theme.of(context).textTheme.bodyText1,
//                 ),
//                 filled: false,
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       BorderSide(color: customGreyColor.withOpacity(.3)),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       BorderSide(color: customGreyColor.withOpacity(.3)),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 hintStyle: Theme.of(context)
//                     .textTheme
//                     .bodyText1!
//                     .copyWith(color: Colors.grey)),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Field cannot be Empty';
//               }
//               return null;
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
