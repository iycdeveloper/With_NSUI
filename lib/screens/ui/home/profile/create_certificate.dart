
import 'package:flutter/material.dart';
import 'package:iyc/view_model/profile/inbox/create_certificate_vm.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class CreateCertificate extends StatefulWidget {
  const CreateCertificate({Key? key, this.certificateDate}) : super(key: key);

  final certificateDate;
  @override
  State<CreateCertificate> createState() => _CreateCertificateState();
}

class _CreateCertificateState extends State<CreateCertificate> {
  @override
  void initState() {
    super.initState();
    // context.read<CreateCertificateVM>().addTextToImage('assets/images/certificate.png', '${widget.certificateDate['name']}', '${widget.certificateDate['created_on']}');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<CreateCertificateVM>(
      builder: (_, logic, __) => Scaffold(
        appBar: AppBar(
          title: Text('Certificate'),
          actions: [
            IconButton(
                onPressed: () async {
                  await logic.screenshotController
                      .capture()
                      .then((value) async {
                    print('Screenshot completed');
                    await logic.saveImageAsPdf(value!, context).then((value) {
                    });
                  });
                },
                icon: Icon(Icons.share)),
          ],
        ),
        body: logic.isLoading
            ? Center(child: CircularProgressIndicator())
            : Screenshot(
                controller: logic.screenshotController,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/certificate.png'),
                              fit: BoxFit.fill)),
                    ),
                    Positioned(
                        top: screenSize.height / 2.7,
                        left: (screenSize.width -
                                widget.certificateDate['name']
                                        .toString()
                                        .length *
                                    15) /
                            2,
                        child: Center(
                            child: Text(
                          widget.certificateDate['name'].toString(),
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CustomFont'),
                        ))),
                    Positioned(
                        top: screenSize.height / 1.9,
                        left: (screenSize.width -
                                widget.certificateDate['created_on']
                                        .toString()
                                        .substring(0, 11)
                                        .length *
                                    10) /
                            2,
                        child: Center(
                            child: Text(
                          logic.correctDateFormat(
                              widget.certificateDate['created_on'].toString()),
                          style: TextStyle(fontSize: 25),
                        ))),
                    Positioned(
                        top: screenSize.height / 1.6,
                        left: screenSize.width / 8.8,
                        child: Center(
                            child: Text(
                          logic.correctDateFormat1(
                              widget.certificateDate['created_on'].toString()),
                          style: TextStyle(fontSize: 15),
                        )))
                  ],
                ),
              ),
      ),
    );
  }
}
