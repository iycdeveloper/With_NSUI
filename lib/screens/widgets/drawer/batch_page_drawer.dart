// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:iyc/provider/batch/batch_db_provider.dart';
// import 'package:iyc/provider/batch/download_exsting_batch_provider.dart';
// import 'package:iyc/app/data/resources/services/local_storage_services.dart';// import 'package:iyc/screens/ui/login/login_with_phone.dart';
// import 'package:provider/provider.dart';
//
// import '../../../di_container.dart';
// import 'drawer_Item.dart';
//
// class BatchPageDrawer extends StatelessWidget {
//   const BatchPageDrawer({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.6,
//       child: Drawer(
//           child: ListView(
//         children: [
//           DrawerItem(
//             onTap: () async {
//               DownloadExistingBatchProvider(batchRepo: sl())
//                   .downloadExistingBatch(context: context);
//             },
//             iconData: FontAwesomeIcons.download,
//             labelName: "Download",
//           ),
//           DrawerItem(
//             onTap: () async {
//               await LocalStorageServices().setAgrID("");
//               await LocalStorageServices().setSTCode("");
//               await LocalStorageServices().setDisCode("");
//               await LocalStorageServices().setScrutinyAgrID("");
//               ///delete batch table
//              await Provider.of<BatchDBProvider>(context, listen: false)
//              .deleteTable();
//
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => LoginWithMobile()));
//             },
//             iconData: FontAwesomeIcons.arrowCircleLeft,
//             labelName: "Logout",
//           ),
//         ],
//       )),
//     );
//   }
// }
