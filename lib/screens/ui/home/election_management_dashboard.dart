import 'package:flutter/material.dart';
import 'package:iyc/screens/ui/home/yuva_booth/yuva_booth_home.dart';
import 'package:iyc/view_model/yuva_booth/yuva_booth_home_vm.dart';
import 'package:provider/provider.dart';

class ElectionManagementDashboard extends StatefulWidget {
  const ElectionManagementDashboard({Key? key}) : super(key: key);

  @override
  State<ElectionManagementDashboard> createState() =>
      _ElectionManagementDashboardState();
}

class _ElectionManagementDashboardState
    extends State<ElectionManagementDashboard> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => YuvaBoothHomeVM(),
      )
    ], child: YuvaBoothHome());
  }
}
