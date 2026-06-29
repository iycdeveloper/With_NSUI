import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iyc/app/modules/profile/profile_controller.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:http/http.dart' as http;
import 'package:iyc/nusi/app/modules/profile/screens/profile_controller_nsui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class IdCardGenerator extends StatefulWidget {
  IdCardGenerator({Key? key,}) : super(key: key);

  final UserDetail userDetails = Get.find<ProfileNSUIController>().userDetail!;

  @override
  State<IdCardGenerator> createState() => _IdCardGeneratorState();
}

class _IdCardGeneratorState extends State<IdCardGenerator> {
  fetchAuthenticatedImage() async {
    final String imageUrl =
        'https://memberdoc.ycea.in/PROFILE/9916557335_P.jpg'; // Replace with your image URL
    final String token =
        'your_auth_token_here'; // Replace with your authentication token

    final response = await http.get(Uri.parse(imageUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    return response;
  }

  Future<void> saveImageAsPdf(
      Uint8List imageBytes, BuildContext context) async {
    print('ID Card Share');

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
    final pdfFile = File('${appDocDir.path}/id-card.pdf');

    final files = <XFile>[];
    files.add(XFile(pdfFile.path, name: '-d-card.pdf'));
    await pdfFile.writeAsBytes(pdfBytes);
    var shareResult = await Share.shareXFiles([XFile(pdfFile.path)],
        text: 'id-card.pdf',
        subject: 'ID Card',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Card'),
        actions: [
          IconButton(
            onPressed: () async {
              await screenshotController.capture().then((value) async {
                print('Screenshot completed');
                await saveImageAsPdf(value!, context).then((value) {});
              });
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/id_card2.jpeg'),
                      fit: BoxFit.fill)),
            ),
            widget.userDetails.profilePic!.isEmpty
                ? Positioned(
                top: screenSize.height / 4,
                left: screenSize.width / 3.5,
                child: Container(
                  width: 170,
                  height: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.black),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/default_id_image.jpeg'),
                        fit: BoxFit.cover,
                      )),
                ))
                : Positioned(
                top: screenSize.height / 4,
                left: screenSize.width / 3.5,
                child: Container(
                  width: 170,
                  height: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.black),
                      image: DecorationImage(
                        image: NetworkImage(widget.userDetails.profilePic!),
                        fit: BoxFit.cover,
                      )),
                )),
            Positioned(
                top: screenSize.height / 1.8,
                left: (screenSize.width -
                    'Name  : ${widget.userDetails.name}'.length * 14) /
                    2,
                child: Center(
                    child: Text(
                      'Name            : ${widget.userDetails.name}'.toUpperCase(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ))),
            Positioned(
                top: screenSize.height / 1.8 + 30,
                left: (screenSize.width -
                    'Name  : ${widget.userDetails.name}'.length * 14) /
                    2,
                child: Center(
                    child: Text(
                      'Designation  : ${widget.userDetails.roleName}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ))),
            Positioned(
                top: screenSize.height / 1.8 + 60,
                left: (screenSize.width -
                    'Name  : ${widget.userDetails.name}'.length * 14) /
                    2,
                child: Center(
                    child: Text(
                      'Issued on      : ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ))),
            Positioned(
                top: screenSize.height / 1.8 + 90,
                left: (screenSize.width -
                    'Name  : ${widget.userDetails.name}'.length * 14) /
                    2,
                child: Center(
                    child: Text(
                      'Valid Upto     : 30-5-2025',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ))),
          ],
        ),
      ),
    );
  }
}
