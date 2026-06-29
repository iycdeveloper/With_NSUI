import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/view_model/campaign/leaderboard_campaign_vm.dart';
import 'package:provider/provider.dart';

class LeaderboardCampaign extends StatefulWidget {
  LeaderboardCampaign(this.selectedCampaign, {Key? key}) : super(key: key);

  String selectedCampaign;
  @override
  State<LeaderboardCampaign> createState() => _LeaderboardCampaignState();
}

class _LeaderboardCampaignState extends State<LeaderboardCampaign> {
  @override
  void initState() {
    context
        .read<LeaderboardCampaignVM>()
        .getUserPoints(context, widget.selectedCampaign);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
        centerTitle: true,
        actions: [
          // Container(
          //   margin: EdgeInsets.only(right: 10),
          //   child: GestureDetector(
          //     onTap: () async {
          //       if (context.read<>().userDetail != null) {
          //         final result = await toPage(
          //             context,
          //             ChangeNotifierProvider(
          //               create: (context) => RegisterProvider(),
          //               child: RegisterUser(
          //                   userDetail: context.read<>().userDetail),
          //             ));
          //         if (result != null && result) {
          //           context.read<>().getUserPoints(context);
          //           context.read<>().getUserProfile(context);
          //         }
          //       }
          //     },
          //     child: Row(
          //       children: [
          //         Icon(Icons.edit),
          //         Text(
          //           "Edit",
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
      body: Consumer<LeaderboardCampaignVM>(builder: (_, model, __) {
        if (model.isLoading) return NetworkLoading();
        if (model.campaignList.isEmpty)
          return Center(
            child: Text("Campaign List is empty"),
          );

        return ListView.builder(
          itemCount: model.campaignList.length,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(5),
            child: ExpansionTile(
              childrenPadding: EdgeInsets.symmetric(vertical: 5),
              title: Text(model.campaignList[index].name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black)),
              subtitle: Text(
                model.campaignList[index].mobile,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              trailing: Text(
                model.campaignList[index].count,
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Text(
                //       "EPIC ID:  ${model.campaignList[index].epicId}",
                //       style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 13,
                //           fontWeight: FontWeight.w500),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class LabelAndContent extends StatelessWidget {
  const LabelAndContent({Key? key, required this.label, required this.content})
      : super(key: key);
  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.lightBlueAccent))),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(content,
                  style: TextStyle(color: Colors.black87, fontSize: 18)),
            )
          ])),
    );
  }
}
