import 'package:calendar_view/calendar_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iyc/screens/ui/home/campaign/select_campaign.dart';
import 'package:iyc/screens/ui/home/home_page_drawer.dart';
import 'package:iyc/screens/ui/home/ob/events_page.dart';
import 'package:iyc/screens/ui/home/profile/inbox.dart';
import 'package:iyc/screens/ui/home/yuva_booth/add_booth_jodo.dart';
import 'package:iyc/screens/widgets/cards/icon_card.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/campaign/select_campaign_vm.dart';
import 'package:iyc/view_model/home/home_page_sashboard_vm.dart';
import 'package:iyc/view_model/leaderboard/leaderboard_list_vm.dart';
import 'package:iyc/view_model/ob/events_vm.dart';
import 'package:iyc/view_model/profile/inbox/inbox_vm.dart';
import 'package:iyc/view_model/yuva_booth/add_booth_jodo_vm.dart';
import 'package:iyc/view_model/yuva_booth/yuva_users_list_vm.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'leaderboard/leaderboard_list.dart';
import 'yuva_booth/yuva_user_list.dart';

class HomePageDashBoard extends StatefulWidget {
  const HomePageDashBoard({Key? key}) : super(key: key);

  @override
  State<HomePageDashBoard> createState() => _HomePageDashBoardState();
}

class _HomePageDashBoardState extends State<HomePageDashBoard> {
  @override
  void initState() {
    context.read<HomePageDashboardVM>().initDashboard(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: HomePageDrawer(),
      appBar: AppBar(
        title: Image.asset(
          "assets/images/iyc_logo.png",
          height: 50,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                var whatsappUrl =
                    "https://whatsapp.com/channel/0029Va5dVeU0G0XidNVHiY1Z";
                if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                  await launchUrl(Uri.parse(whatsappUrl));
                } else {
                  throw 'Could not launch $whatsappUrl';
                }
              },
              icon: Icon(Icons.message))
        ],
      ),
      body: Consumer<HomePageDashboardVM>(
        builder: (_, model, __) => model.loadingPage
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  Consumer<HomePageDashboardVM>(
                    builder: (_, model, __) => CarouselSlider(
                      options: CarouselOptions(
                          autoPlay: true, height: 150, viewportFraction: 0.99),
                      items: model.bannerUrlList.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Image.network(
                                  item,
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                ));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              IconCardHomePage(
                                  title: "My Activities",
                                  icon: "assets/images/myactivity.png",
                                  onTap: () {
                                    toPage(
                                        context,
                                        ChangeNotifierProvider(
                                          create: (_) => HomePageDashboardVM(),
                                          child: ChangeNotifierProvider(
                                            create: (_) => InboxVM(),
                                            child: InboxView(),
                                          ),
                                        ));
                                  }),
                              Consumer<HomePageDashboardVM>(
                                  builder: (_, model, __) => model
                                          .loadingTaskCount
                                      ? CircularProgressIndicator()
                                      : model.pendIngCount != 0
                                          ? Positioned(
                                              right: 15,
                                              top: 15,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: Text(
                                                    context
                                                        .read<
                                                            HomePageDashboardVM>()
                                                        .pendIngCount
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            )
                                          : SizedBox())
                            ],
                          ),
                          IconCardHomePage(
                              title: "LeaderBoard",
                              icon: "assets/images/leaderboard.png",
                              onTap: () async {
                                toPage(
                                    context,
                                    ChangeNotifierProvider(
                                        create: (context) =>
                                            LeaderBoardListVM(),
                                        child: LeaderBoardList()));
                              })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconCardHomePage(
                            title: "Booth Jodo",
                            icon: "assets/images/boothjodo.png",
                            onTap: () {
                              if (!context
                                  .read<HomePageDashboardVM>()
                                  .showError) {
                                toPage(
                                    context,
                                    ChangeNotifierProvider(
                                        create: (context) => AddBoothJodoVM(),
                                        child: AddBoothJodo(
                                            yuvaUser: context
                                                .read<HomePageDashboardVM>()
                                                .yuvaUser!,
                                            yuvaUserList: context
                                                .read<HomePageDashboardVM>()
                                                .yuvaUsersList!)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(context
                                            .read<HomePageDashboardVM>()
                                            .boothJodoError)));
                              }
                            },
                          ),
                          IconCardHomePage(
                            title: "Campaigns",
                            icon: "assets/images/campaigns.png",
                            onTap: () {
                              toPage(
                                  context,
                                  ChangeNotifierProvider(
                                    create: (context) => SelectCampaignVM(),
                                    child: SelectCampaign(),
                                  ));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconCardHomePage(
                              title: "My Team",
                              icon: "assets/images/myteams.png",
                              onTap: () {
                                toPage(
                                    context,
                                    ChangeNotifierProvider(
                                        create: (context) => YuvaUsersListVM(),
                                        child: YuvaUsersList(
                                            roleId: model.yuvaUser?.roleId)));
                              }),
                          if(model.yuvaUser != null)
                          ['PB', 'CG'].contains(model.yuvaUser!.stateCode)
                              ? IconCardHomePage(
                                  title: "Programmes",
                                  icon: "assets/images/programs.png",
                                  onTap: () async {
                                    toPage(
                                        context,
                                        CalendarControllerProvider(
                                            controller: EventController(),
                                            child: ChangeNotifierProvider(
                                                create: (context) => EventsVM(),
                                                child: EventsPage())));
                                  })
                              : Container(
                                  height: 150,
                                  width: 130,
                                  margin: EdgeInsets.all(20),
                                )
                        ],
                      ),
                    ],
                  )
                ]),
              ),
      ),
    );
  }
}
