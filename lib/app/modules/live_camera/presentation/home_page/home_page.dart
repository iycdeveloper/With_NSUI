// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:gmlkit_liveness/presentation/live_data_page/live_data_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   XFile? result2;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Google MLKit Liveness"),
//       ),
//       body: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 XFile? result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const LiveDataPage(),
//                   ),
//                 );
//                 if (result == null) {
//                   // CustomSnackBar.showErrorSnackBar('No live person detected.');
//                 } else {
//                   setState(() {
//                     result2 = result;
//                     // Future.delayed(Duration(seconds: 2))
//                   });
//                   // pickedAMFilePath = result.path;
//                   // pickedAMFile = File(pickedAMFilePath!);
//                   // showAMImage = true;
//                   // notifyListeners();
//                 }
//               },
//               child: const Card.filled(
//                 child: Padding(
//                   padding: EdgeInsets.all(24),
//                   child: Column(
//                     children: [
//                       Text("Live data"),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//                 color: Colors.grey,
//                 height: 200,
//                 width: 300,
//                 child: result2 != null
//                     ? Image.file(File(result2!.path))
//                     : const SizedBox())
//           ],
//         ),
//       ),
//     );
//   }
// }
