import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/home_page_drawer.dart';
import 'package:iyc/screens/ui/home/profile/inbox.dart';
import 'package:iyc/screens/ui/home/profile/my_profile.dart';
import 'package:iyc/view_model/profile/inbox/inbox_vm.dart';
import 'package:iyc/view_model/profile/profile_vm.dart';
import 'package:provider/provider.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({Key? key}) : super(key: key);

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: HomePageDrawer(),
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(
                    text: "Inbox/Tasks",
                  ),
                  Tab(text: "Profile"),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (_) => InboxVM(),
              child: InboxView(),
            ),
            ChangeNotifierProvider(
              create: (context) => ProfileVm(),
              child: MyProfile(),
            ),
          ],
        ),
      ),
    );
  }
}
