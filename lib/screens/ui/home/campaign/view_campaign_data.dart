import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/view_model/campaign/view_campaign_data_vm.dart';
import 'package:provider/provider.dart';

class ViewCampaignData extends StatefulWidget {
  const ViewCampaignData({Key? key, required this.campaignId})
      : super(key: key);

  final String campaignId;
  @override
  State<ViewCampaignData> createState() => _ViewCampaignDataState();
}

class _ViewCampaignDataState extends State<ViewCampaignData> {
  @override
  void initState() {
    context
        .read<ViewCampaignDataVM>()
        .getCampaignDataList(context, widget.campaignId);
    super.initState();
  }

  Color customGreyColor = Color.fromRGBO(113, 128, 150, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Campaign Data View"),
        centerTitle: true,
      ),
      body: Consumer<ViewCampaignDataVM>(builder: (_, model, __) {
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
