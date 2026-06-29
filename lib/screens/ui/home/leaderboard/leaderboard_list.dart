import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/leaderboard/statement_view.dart';
import 'package:iyc/screens/ui/home/profile/view_task_details.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/show_info_image.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/leaderboard/leaderboard_list_vm.dart';
import 'package:iyc/view_model/leaderboard/statement_vm.dart';
import 'package:provider/provider.dart';

class LeaderBoardList extends StatefulWidget {
  const LeaderBoardList({Key? key}) : super(key: key);

  @override
  State<LeaderBoardList> createState() => _LeaderBoardListState();
}

class _LeaderBoardListState extends State<LeaderBoardList> {
  @override
  void initState() {
    context.read<LeaderBoardListVM>().getLeaderboard(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("LeaderBoard"),
        actions: [
          // IconButton(onPressed: (){
          //   toPage(
          //       context,
          //       ChangeNotifierProvider(
          //         create: (_) => StatementVM(),
          //         child: StatementView(),
          //       ));
          // }, icon: Icon(Icons.file_present)),
          // IconButton(
          //     onPressed: () {
          //       toPage(context, ShowInfoImage());
          //     },
          //     icon: Icon(Icons.info)),
          IconButton(
              onPressed: () {
                context.read<LeaderBoardListVM>().toggleShowSearch(context);
              },
              icon: Icon(Icons.search)),
        ],
        centerTitle: true,
        bottom: PreferredSize(
            child: Consumer<LeaderBoardListVM>(
              builder: (_, model, __) => Column(
                children: [
                  model.loadingPage
                      ? NetworkLoading()
                      : model.pointsList.isEmpty
                          ? SizedBox()
                          : model.showSearchOption
                              ? Container(
                                  padding: EdgeInsets.only(right: 5, left: 5),
                                  width: MediaQuery.of(context).size.width - 10,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextField(
                                        controller: model.searchController,
                                        textInputAction: TextInputAction.search,
                                        focusNode: context
                                            .read<LeaderBoardListVM>()
                                            .searchFocus,
                                        // onChanged: (str) {
                                        //   // debouncer?.run(context
                                        //   //     .read<SearchVotersListVM>()
                                        //   //     .searchVoterByKeyword(
                                        //   //       str,
                                        //   //       context,
                                        //   //     ));
                                        // },
                                        onSubmitted: (str) {
                                          context
                                              .read<LeaderBoardListVM>()
                                              .searchUserByname(
                                                context,
                                                str,
                                              );
                                          context
                                              .read<LeaderBoardListVM>()
                                              .searchFocus
                                              .unfocus();
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            suffixIcon: model.filteredPointsList
                                                    .isNotEmpty
                                                ? IconButton(
                                                    icon: Icon(Icons.clear),
                                                    color: Constants
                                                        .kitThemeGradients[0],
                                                    onPressed: () {
                                                      model.searchController
                                                          .clear();
                                                      context
                                                          .read<
                                                              LeaderBoardListVM>()
                                                          .clearFilterList();
                                                    },
                                                  )
                                                : null,
                                            hintText: "Search eg: Raj"),
                                      )),
                                      ElevatedButton(
                                        child: Row(
                                          children: [
                                            Icon(Icons.search,
                                                color: Colors.white),
                                            Text("Search")
                                          ],
                                        ),
                                        onPressed: (model.showSearchOption)
                                            ? () {
                                                context
                                                    .read<LeaderBoardListVM>()
                                                    .searchUserByname(
                                                        context,
                                                        model.searchController
                                                            .text);
                                                context
                                                    .read<LeaderBoardListVM>()
                                                    .searchFocus
                                                    .unfocus();
                                              }
                                            : null,
                                      )
                                    ],
                                  ),
                                )
                              : Stack(
                                  children: [
                                    if (model.pointsList.isNotEmpty)
                                      Container(
                                        height: 150,
                                        width: screenWidth,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: PointsCard(
                                            imageAddress:
                                                "assets/gif_images/icons8-medal-first-place.gif",
                                            name:
                                                "${model.pointsList[0]["name"]}",
                                            points:
                                                "${model.pointsList[0]["points"]}",
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    if (model.pointsList.length > 1)
                                      Container(
                                          height: 150,
                                          width: screenWidth,
                                          alignment: Alignment.bottomLeft,
                                          child: PointsCard(
                                            imageAddress:
                                                "assets/gif_images/icons8-medal-second-place.gif",
                                            name:
                                                "${model.pointsList[1]["name"]}",
                                            points:
                                                "${model.pointsList[1]["points"]}",
                                          )),
                                    if (model.pointsList.length > 2)
                                      Container(
                                          height: 150,
                                          width: screenWidth,
                                          alignment: Alignment.bottomRight,
                                          child: PointsCard(
                                            imageAddress:
                                                "assets/gif_images/icons8-medal-third-place.gif",
                                            name:
                                                "${model.pointsList[2]["name"]}",
                                            points:
                                                "${model.pointsList[2]["points"]}",
                                          ))
                                  ],
                                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        model.options.keys.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<LeaderBoardListVM>()
                                      .changeLeaderBoardType(context, index);
                                },
                                child: Material(
                                  color: model.currentIndex == index
                                      ? Colors.amber.shade50
                                      : customGreyColor.withOpacity(.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      model.options.values.toList()[index],
                                      // style: Theme.of(context)
                                      //     .textTheme
                                      //     .bodyText1!
                                      //     .copyWith(
                                      //         color: model.currentIndex == index
                                      //             ? Colors.blue
                                      //             : Colors.black
                                      // ),
                                    )),
                                  ),
                                ),
                              ),
                            )),
                  ),
                ],
              ),
            ),
            preferredSize: Size(0.0, 200)),
      ),
      body: Consumer<LeaderBoardListVM>(
          builder: (_, model, __) => model.loadingPage
              ? NetworkLoading()
              : model.filteredPointsList.isNotEmpty
                  ? ListView.builder(
                      itemCount: model.filteredPointsList.length,
                      itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: ListTile(
                              title: Text(
                                  "${model.filteredPointsList[index]["name"]}"),
                              subtitle: Text(
                                  "${model.filteredPointsList[index]["mobile"]}"),
                              trailing: Container(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      "assets/iyc_icons/reward.png",
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(
                                      "${model.filteredPointsList[index]["points"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                  : Center(
                      child: Text(" Leader Board is Empty"),
                    )),
    );
  }
}

class PointsCard extends StatelessWidget {
  const PointsCard(
      {Key? key,
      required this.name,
      required this.imageAddress,
      required this.points,
      this.fontWeight})
      : super(key: key);

  final String imageAddress;
  final String points;
  final String name;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: MediaQuery.of(context).size.width / 3,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            margin: EdgeInsets.only(bottom: 4),
            child: Image.asset(imageAddress)),
        SizedBox(
          height: 30,
          width: MediaQuery.of(context).size.width / 3,
          child: Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeight ?? FontWeight.w600,
                fontSize: 14),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.amber,
          ),
          child: Text(
            points,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        )
      ]),
    );
  }
}
