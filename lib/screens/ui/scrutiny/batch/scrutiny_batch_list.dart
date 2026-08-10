import 'package:flutter/material.dart';
import 'package:iyc/provider/scrutiny/scrutiny_batch_vm.dart';
import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:provider/provider.dart';

import '../../../../di_container.dart';
import 'scrutiny_batch_list_card.dart';

class ScrutinyBatchList extends StatefulWidget {
  const ScrutinyBatchList({Key? key}) : super(key: key);

  @override
  _ScrutinyBatchListState createState() => _ScrutinyBatchListState();
}

class _ScrutinyBatchListState extends State<ScrutinyBatchList> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<ScrutinyBatchVM>().initScrutinyBatch(context);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _searchField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ScrutinyTheme.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (str) =>
            context.read<ScrutinyBatchVM>().onSearch(BuildContext, str),
        style: const TextStyle(color: ScrutinyTheme.ink, fontSize: 15),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon:
              const Icon(Icons.search_rounded, color: ScrutinyTheme.brand),
          hintText: "Search batch",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          suffixIcon: IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.grey[500], size: 20),
            onPressed: () {
              _searchController.clear();
              context.read<ScrutinyBatchVM>().clearSearch();
            },
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: ScrutinyTheme.brand.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.fact_check_outlined,
                size: 34, color: ScrutinyTheme.brand),
          ),
          const SizedBox(height: 16),
          const Text(
            "No batches to verify right now",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ScrutinyTheme.ink),
          ),
          const SizedBox(height: 6),
          Text(
            "Batches on hold will appear here once they are assigned to you.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(sl.currentScopeName);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: ScrutinyTheme.appBar(context, "Scrutiny"),
      body: ScrutinyPageBackground(
        child: Consumer<ScrutinyBatchVM>(
          builder: (_, val, __) => val.loading
              ? NetworkLoading()
              : CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: ScrutinyHero(
                        icon: Icons.fact_check_rounded,
                        title: 'Verify Members',
                        subtitle: 'Pick a batch to review records on hold 🔍',
                      ),
                    ),
                    SliverToBoxAdapter(child: _searchField()),
                    val.scrutinyBatchList.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (context, index) => ScrutinyBatchListCard(
                                      batch: val.scrutinyBatchList[index],
                                    ),
                                childCount: val.scrutinyBatchList.length),
                          )
                        : SliverToBoxAdapter(child: _emptyState()),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
        ),
      ),
    );
  }
}
