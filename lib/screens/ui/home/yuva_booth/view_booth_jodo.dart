import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/yuva_booth/view_booth_jodo_vm.dart';
import 'package:provider/provider.dart';

class ViewBoothJodo extends StatefulWidget {
  const ViewBoothJodo({Key? key}) : super(key: key);

  @override
  State<ViewBoothJodo> createState() => _ViewBoothJodoState();
}

class _ViewBoothJodoState extends State<ViewBoothJodo> {
  @override
  void initState() {
    context.read<ViewBoothJodoVM>().getBoothJodos(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Constants.themeGradients[0],
          title: Text("Booth Jodo List"),
        ),
        body: Consumer<ViewBoothJodoVM>(
            builder: (_, model, __) => model.loadingPage
                ? NetworkLoading()
                : model.boothJodoList.isNotEmpty
                    ? ListView.builder(
                        // reverse: true,
                        itemCount: model.boothJodoList.length,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        itemBuilder: (context, index) => ExpansionTile(
                          title: Text(model.boothJodoList[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          subtitle: Text(
                            model.boothJodoList[index].stateCode,
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  model.boothJodoList[index].mobile,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                                Text(
                                  model.boothJodoList[index].verificationStatus,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : Center(
                        child: Text("No Yuva Users found "),
                      )));
  }
}
