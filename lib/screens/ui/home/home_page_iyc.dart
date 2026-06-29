import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iyc/provider/global/home_page_iyc_provider.dart';
import 'package:iyc/screens/ui/home/home_page_dashboard.dart';
import 'package:iyc/screens/ui/home/membership_dashboard.dart';
import 'package:iyc/screens/ui/home/home_page_drawer.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/home/home_page_sashboard_vm.dart';
import 'package:provider/provider.dart';

import 'election_management_dashboard.dart';

class HomePageIyc extends StatefulWidget {
  HomePageIyc([this.initialIndex]);

  final int? initialIndex;

  @override
  _HomePageIycState createState() => _HomePageIycState();
}

class _HomePageIycState extends State<HomePageIyc> {
  int _selectedIndex = 0;
  bool isLogin = false;

  List<Widget> _sessionInWidgets = <Widget>[
    // ChangeNotifierProvider(
    //     create: (context) => FeedsHomeVM(), child: FeedsHome()),
    ChangeNotifierProvider(
      create: (context) => HomePageDashboardVM(),
      child: HomePageDashBoard(),
    ),

    MembershipDashboard(),
    ElectionManagementDashboard(),
    // MultiProvider(providers: [
    //   ChangeNotifierProvider(
    //     create: (context) => sl<MembershipListProvider>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (context) => BatchListProvider(apiConfig: sl()),
    //   ),
    // ], child: BatchMain()),
    // MultiProvider(providers: [
    //   ChangeNotifierProvider(
    //     create: (context) => NominationsProvider(apiConfig: sl<ApiConfig>()),
    //   ),
    //   ChangeNotifierProvider(create: (context) => ViewNominationVm())
    // ], child: NominationsMain()),
    // ChangeNotifierProvider(
    //   create: (context) => ReportsVM(),
    //   child: ReportsMain(),
    // ),
    // PkConnectHome(),
  ];

  @override
  void initState() {
    if(widget.initialIndex!=null)
      _selectedIndex=widget.initialIndex!;
    context.read<HomePageIycProvider>().getLocation(context);
    super.initState();
  }

  @override
  void dispose() {
    print("hoen page iyc screen sispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<HomePageIycProvider>(
        builder: (_, model, __) => model.isLoading
            ? Scaffold(
                body: NetworkLoading(),
              )
            : model.showLocationError
                ? Scaffold(
                    body: Center(
                        child: TextButton(
                            onPressed: () => context
                                .read<HomePageIycProvider>()
                                .getLocation(context, isRefresh: true),
                            child: Text("Location Fetch failed retry"))),
                  )
                : Scaffold(
                    drawer: HomePageDrawer(),
                    backgroundColor: Colors.white,
                    bottomNavigationBar: NavigationBar(
                      selectedIndex: _selectedIndex,

                      // selectedLabelStyle: TextStyle(color: Colors.green,fontSize: 12),
                      // unselectedLabelStyle:  TextStyle(color: Colors.green,fontSize: 12),
                      elevation: 2,

                      destinations: [
                        NavigationDestination(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: SvgPicture.asset(
                            "assets/icons/noun_membership_2397515.svg",
                            color: Constants.themeGradients[2],
                            height: 18,
                          ),
                          label: 'Membership',
                        ),
                        NavigationDestination(
                          icon: Icon(
                            Icons.poll,
                          ),
                          label: 'EM',
                        ),
                        NavigationDestination(
                          icon: SvgPicture.asset(
                            "assets/icons/noun-news.svg",
                            color: Constants.themeGradients[2],
                            height: 18,
                          ),
                          label: 'IYC Social',
                        ),
                      ],
                      onDestinationSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                        if (index == 1) {}
                        if (index == 2) {}
                      },
                    ),
                    body: _sessionInWidgets.elementAt(_selectedIndex),
                  ),
      ),
    );
  }
}
