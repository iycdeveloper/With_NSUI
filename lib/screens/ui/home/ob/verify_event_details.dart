import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/events/verify_event_data.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class VerifyEventDetails extends StatelessWidget {
  const VerifyEventDetails({required this.verifyEventData});

  final VerifyEventData verifyEventData;

  Future verifyEvent(BuildContext context, String id, String rating) async {
    ApiResponse apiResponse = await UnitManagementRepo().verifyEvent(id, rating);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        print(responseDecoded["response"]);
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text(verifyEventData.eventName!),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: URoundButton(
            title: "Verify Event",
            onTap: () async {
              await Alert(
              context: context,
              type: AlertType.info,
              title: "Select rating",
              desc: "Select Rating",
              content: Column(
                children: [
                  ListTile(
                    title: Text('A+'),
                    onTap: ()async {
                      await verifyEvent(context, verifyEventData.eventId!, 'A+');
                    },
                  ),
                  ListTile(
                    title: Text('A'),
                    onTap: ()async {
                      await verifyEvent(context, verifyEventData.eventId!, 'A');
                    },
                  ),
                  ListTile(
                    title: Text('B+'),
                    onTap: ()async {
                      await verifyEvent(context, verifyEventData.eventId!, 'B+');
                    },
                  ),
                  ListTile(
                    title: Text('B'),
                    onTap: ()async {
                      await verifyEvent(context, verifyEventData.eventId!, 'B');
                    },
                  ),
                  ListTile(
                    title: Text('C'),
                    onTap: ()async {
                      await verifyEvent(context, verifyEventData.eventId!, 'C');
                    },
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  width: 120,
                )
              ],
              ).show();
              // context.read<CreateEventVM>().createEvent(context);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text('Program Name'),
                subtitle: Text('${verifyEventData.eventName!}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Program DateTime'),
                subtitle: Text('${verifyEventData.eventDateTime!}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Program Description'),
                subtitle: Text('${verifyEventData.eventDescription!}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Program Level'),
                subtitle: Text('${verifyEventData.eventLevel!}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Program Type'),
                subtitle: Text('${verifyEventData.eventType!}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Program Location'),
                subtitle: Text('${verifyEventData.eventLocation!}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Program Organiser Name'),
                subtitle: Text('${verifyEventData.organiserName!}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Program Organiser Mobile Number'),
                subtitle: Text('${verifyEventData.organiserMobile}'),
              ),
            ),
            // Container(
            //     height: 200,
            //     width: MediaQuery.of(context).size.width,
            //     margin: EdgeInsets.symmetric(horizontal: 5.0),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         border: Border.all(color: Colors.black12),
            //     ),
            //     child: Image.network(
            //       '${verifyEventData.eventPic1}',
            //       alignment: Alignment.center,
            //       fit: BoxFit.cover,
            //     )),
            Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
                image: DecorationImage(image: NetworkImage('${verifyEventData.eventPic1}'))
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12),
                  image: DecorationImage(image: NetworkImage('${verifyEventData.eventPic2}'))
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12),
                  image: DecorationImage(image: NetworkImage('${verifyEventData.eventPic3}'))
              ),
            ),
            // Card(
            //   child: ListTile(
            //     title: Text('Event Name'),
            //     subtitle: Text('${verifyEventData.eventName!}'),
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}
