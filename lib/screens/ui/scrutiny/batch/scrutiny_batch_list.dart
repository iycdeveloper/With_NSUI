import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/provider/scrutiny/scrutiny_batch_vm.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/u_round_edge_container.dart';
import 'package:iyc/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../../di_container.dart';
import 'scrutiny_batch_list_card.dart';

class ScrutinyBatchList extends StatefulWidget {
  const ScrutinyBatchList({Key? key}) : super(key: key);

  @override
  _ScrutinyBatchListState createState() => _ScrutinyBatchListState();
}

class _ScrutinyBatchListState extends State<ScrutinyBatchList> {
  TextEditingController _searchController=TextEditingController();
  @override
  void initState() {
    print(sl.currentScopeName);

    context.read<ScrutinyBatchVM>().initScrutinyBatch(context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(sl.currentScopeName);
    return Scaffold(
      // endDrawer: BatchPageDrawer(),
      // endDrawer: ScrutinyBatchDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.themeGradients[0],
        title: Text(
          "Scrutiny Batch",
          style: Constants.appbarTitleTextStyle,
        ),
        bottom: PreferredSize(
          preferredSize: Size(0.0, 85.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Constants.themeGradients[1],
            padding: EdgeInsets.only(
              top: 3,
            ),
            child: Row(children: [
              URoundEdgeContainer(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextField(
                    onChanged: (str) {
                      context
                          .read<ScrutinyBatchVM>()
                          .onSearch(BuildContext, str);
                    },controller: _searchController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Constants.kitThemeGradients[0],
                        ),
                        hintText: "Search",
                        suffixIcon: IconButton(
                            onPressed: () {
                              _searchController.clear();
                              context
                                  .read<ScrutinyBatchVM>().clearSearch();

                            }, icon: Icon(Icons.clear))),
                  )),
              // IconButton(
              //   onPressed: () {},
              //   icon: Image.asset(
              //     "assets/icons/reload.svg",
              //     color: Constants.themeGradients[0],
              //   ),
              // )
            ]),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Center(
      //         child: Icon(
      //       CupertinoIcons.plus,
      //       size: 30,
      //       color: Constants.themeGradients[1],
      //     )),
      //     backgroundColor: Constants.themeGradients[0],
      //     foregroundColor: Colors.white,
      //     elevation: 1,
      //     onPressed: () {
      //       Provider.of<ScrutinyBatchVM>(context, listen: false)
      //           .downloadExistingScrutinyBatch(context: context);
      //
      //       ///add batch refresh list
      //     }),
      body: Consumer<ScrutinyBatchVM>(
          builder: (_, val, __) => val.loading
              ? NetworkLoading()
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'BATCH ID',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'AM count',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: Text('Sync Status',
                            //       style: TextStyle(
                            //           color: Colors.black45,
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w700)),
                            // ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'ON HOLD',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    val.scrutinyBatchList.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                                // shrinkWrap: true,

                                (context, index) => ScrutinyBatchListCard(
                                      batch: val.scrutinyBatchList[index],
                                    ),
                                childCount: val.scrutinyBatchList.length),
                          )
                        : SliverToBoxAdapter(
                            child: SizedBox(
                                height: 200,
                                child: Center(
                                    child: Text(
                                        "No batches available right now"))),
                          ),
                  ],
                )),
    );
  }
}
