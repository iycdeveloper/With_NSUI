import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/ob/verify_event_details.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/ob/create_event/verify_event_vm.dart';
import 'package:provider/provider.dart';

class VerifyEvent extends StatefulWidget {
  const VerifyEvent();

  @override
  State<VerifyEvent> createState() => _VerifyEventState();
}

class _VerifyEventState extends State<VerifyEvent> {
  @override
  void initState() {
    context.read<VerifyEventVM>().getVerifyEventsList(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<VerifyEventVM>(
        builder: (context, model, __) => Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(title: Text('Verify Programs'), elevation: 0,),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: model.isLoading?Center(
            child: CircularProgressIndicator(),
          ):ListView(
            children: List.generate(model.eventList.length, (index) => Card(
              child: ListTile(
                title: Text(model.eventList[index].eventName!),
                subtitle: Text(model.eventList[index].eventDescription!),
                trailing: Text(model.eventList[index].eventDateTime!),
                onTap: (){
                  toPage(
                      context,
                    VerifyEventDetails(verifyEventData: model.eventList[index])
                  );
                },
              ),
            )),
            // children: List.generate(length, (index) => null),
          ),
        ),
      ),
    );
  }
}
