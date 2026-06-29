import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share/share.dart';

class CreateCertificateVM extends ChangeNotifier {

  bool isLoading = false;

  img.Image? modifiedImage;
  final ScreenshotController screenshotController = ScreenshotController();

  void updateLoading(){
    isLoading = !isLoading;
    notifyListeners();
  }

  String correctDateFormat(String date){
    DateTime dateTime = DateTime.parse(date);
    // Format DateTime into 'Month Day' format (e.g., 'August 21')
    String formattedDate = DateFormat('MMMM d').format(dateTime);
    return formattedDate;
  }

  String correctDateFormat1(String date){
    DateTime dateTime = DateTime.parse(date);
    // Format DateTime into 'Month Day' format (e.g., 'August 21')
    String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return formattedDate;
  }

  Future<void> saveImageAsPdf(Uint8List imageBytes, BuildContext context) async {
    print('Certificate share');

    final box = context.findRenderObject() as RenderBox?;

    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(image);
        },
      ),
    );

    final pdfBytes = await pdf.save();

    final appDocDir = await getApplicationDocumentsDirectory();
    final pdfFile = File('${appDocDir.path}/certificate-iyc.pdf');

    final files = <XFile>[];
    files.add(XFile(pdfFile.path, name: 'certificate-iyc.pdf'));
    await pdfFile.writeAsBytes(pdfBytes);
    var shareResult = await Share.shareXFiles([XFile(pdfFile.path)],
        text: 'certificate-iyc.pdf',
        subject: 'Certificate',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }


  // Future<pw.Document> generatePdf(BuildContext context, String name, String date) async {
  //   final pdf = pw.Document();
  //   Size screenSize = MediaQuery.of(context).size;
  //
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Stack(
  //           children: [
  //             pw.Container(decoration: pw.BoxDecoration(
  //                 image: pw.DecorationImage(image: pw., fit: BoxFit.fill)
  //             ),),
  //             pw.Positioned(
  //                 top: screenSize.height/2.7,
  //                 left: (screenSize.width - name.length * 15) / 2,
  //                 child: pw.Center(child: pw.Text(name, style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold, fontFamily: 'CustomFont'),))),
  //             pw.Positioned(
  //                 top: screenSize.height/1.9,
  //                 left: (screenSize.width - date.substring(0,11).length * 10) / 2,
  //                 child: pw.Center(child: pw.Text(correctDateFormat(date), style: pw.TextStyle(fontSize: 25),))),
  //             pw.Positioned(
  //                 top: screenSize.height/1.6,
  //                 left: screenSize.width/8.8,
  //                 child: pw.Center(child: pw.Text(correctDateFormat1(date), style: pw.TextStyle(fontSize: 15),)))
  //           ],
  //         )
  //       },
  //     ),
  //   );
  //
  //   return pdf;
  // }
}