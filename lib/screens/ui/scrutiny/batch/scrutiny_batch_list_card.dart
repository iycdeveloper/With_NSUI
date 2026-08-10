import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_members_list_vm.dart';
import 'package:iyc/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../../../di_container.dart';
import '../scrutiny_members_list.dart';

class ScrutinyBatchListCard extends StatelessWidget {
  const ScrutinyBatchListCard({Key? key, required this.batch})
      : super(key: key);
  final BatchDataModel batch;

  @override
  Widget build(BuildContext context) {
    final int onHold = int.tryParse(batch.onhold ?? "0") ?? 0;

    return ScrutinyCard(
      onTap: () async {
        await toPage(
          context,
          ChangeNotifierProvider(
            create: (context) => ScrutinyMembersListVM(
              scrutinyRepo: sl(),
            ),
            child: ScrutinyMembersList(
              batchId: batch.batchId,
              syncStatus: batch.syncStatus! == "1" ? true : false,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ScrutinyTheme.brand.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.inventory_2_outlined,
                size: 18, color: ScrutinyTheme.brand),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batch.batchId,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ScrutinyTheme.ink),
                ),
                const SizedBox(height: 6),

                /// Wrap, not Row — on narrow screens the two chips overflowed
                /// the card by a couple of pixels.
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    ScrutinyChip(
                      label:
                          "${batch.countAM} ${batch.countAM == 1 ? 'member' : 'members'}",
                      color: ScrutinyTheme.brand,
                      icon: Icons.people_alt_outlined,
                    ),
                    ScrutinyChip(
                      label: onHold > 0 ? "$onHold on hold" : "None on hold",
                      color: onHold > 0
                          ? const Color(0xFFE0245E)
                          : const Color(0xFF11998E),
                      icon: onHold > 0
                          ? Icons.pause_circle_outline
                          : Icons.check_circle_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
