import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/profile/create_certificate.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/profile/inbox/create_certificate_vm.dart';
import 'package:iyc/view_model/profile/inbox/rewards_vm.dart';
import 'package:provider/provider.dart';

class MyRewards extends StatefulWidget {
  const MyRewards({Key? key}) : super(key: key);

  @override
  State<MyRewards> createState() => _MyRewardsState();
}

class _MyRewardsState extends State<MyRewards> {

  @override
  void initState() {
    context.read<RewardsVm>().initPage();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Consumer<RewardsVm>(
      builder: (_, model, __) => Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          title: Text('My Rewards'),
          elevation: 0,
        ),
        body:
        model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            :
        Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.count(
                  crossAxisCount: 2, // Number of columns in the grid
                  children: List.generate(model.rewards.length, (index) =>                     Card(
                    child: InkWell(
                      onTap: (){

                        toPage(
                            context,
                            ChangeNotifierProvider(
                              create: (_) => CreateCertificateVM(),
                              child: CreateCertificate(certificateDate: model.rewards[index],),
                            ));
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/rewards.png"))
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(model.correctDateFormat(model.rewards[index]['created_on'])),
                            Text('${model.rewards[index]['reward_type']}'),
                          ],
                        ),
                      ),
                    )
                    // ListTile(
                    //   title: Text(model.correctDateFormat(model.rewards[index]['created_on'])),
                    //   subtitle: Text('${model.rewards[index]['reward_type']}'),
                    //   leading: Icon(Icons.newspaper),
                    //   onTap: (){
                    //
                    //     toPage(
                    //         context,
                    //         ChangeNotifierProvider(
                    //           create: (_) => CreateCertificateVM(),
                    //           child: CreateCertificate(certificateDate: model.rewards[index],),
                    //         ));
                    //   },
                    // ),
                  ))
                ),
              ),
      ),
    );
  }
}

