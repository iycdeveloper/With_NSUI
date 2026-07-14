// import 'dart:async';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:iyc/app/core/app_export.dart';
// import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
// import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
// import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
// import 'package:share_plus/share_plus.dart';

// class PDFScreen extends StatefulWidget {
//   final String? path;

//   const PDFScreen({Key? key, this.path}) : super(key: key);

//   @override
//   _PDFScreenState createState() => _PDFScreenState();
// }

// class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller =
//   Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: CustomAppBar(
//           leadingWidth: 44.h,
//           leading: AppbarImage(
//               onTap: Get.back,
//               svgPath: ImageConstant.imgBiarrowleftIndigo800,
//               margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
//           title:
//           AppbarSubtitle1(text: 'Document', margin: EdgeInsets.only(left: 12.h)),
//           actions: [
//             IconButton(
//                 onPressed: () async {
//                   final file = XFile(widget.path!);
//                   // Share.shareXFiles([file], text: 'Here is your generated PDF!');
//                 },
//                 icon: Icon(
//                   Icons.share,
//                   size: 30,
//                   color: Colors.lightBlueAccent,
//                 ))
//           ],
//           styleType: Style.standard),
//         body: Stack(
//           children: <Widget>[
//             PDFView(
//               filePath: widget.path,
//               enableSwipe: true,
//               swipeHorizontal: true,
//               autoSpacing: false,
//               pageFling: true,
//               pageSnap: true,
//               defaultPage: currentPage!,
//               fitPolicy: FitPolicy.BOTH,
//               preventLinkNavigation:
//               false, // if set to true the link is handled in flutter
//               backgroundColor: Colors.black,
//               onRender: (_pages) {
//                 setState(() {
//                   pages = _pages;
//                   isReady = true;
//                 });
//               },
//               onError: (error) {
//                 setState(() {
//                   errorMessage = error.toString();
//                 });
//                 print(error.toString());
//               },
//               onPageError: (page, error) {
//                 setState(() {
//                   errorMessage = '$page: ${error.toString()}';
//                 });
//                 print('$page: ${error.toString()}');
//               },
//               onViewCreated: (PDFViewController pdfViewController) {
//                 _controller.complete(pdfViewController);
//               },
//               onLinkHandler: (String? uri) {
//                 print('goto uri: $uri');
//               },
//               onPageChanged: (int? page, int? total) {
//                 print('page change: $page/$total');
//                 setState(() {
//                   currentPage = page;
//                 });
//               },
//             ),
//             errorMessage.isEmpty
//                 ? !isReady
//                 ? Center(
//               child: CircularProgressIndicator(),
//             )
//                 : Container()
//                 : Center(
//               child: Text(errorMessage),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }