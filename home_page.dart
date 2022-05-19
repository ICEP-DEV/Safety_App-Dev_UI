import 'package:admin/pages/app_responsive.dart';
import 'package:admin/pages/dashboard/dashboard.dart';
import 'package:admin/pages/widget/side_bar_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/app_colors.dart';
import '../controller/menu_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      key: Provider.of<MenuController>(context, listen: false).ScaffoldKey,
      backgroundColor: AppColor.red,
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Side Nvigation Menu
          if (AppResponsive.isDesktop(context))
            const Expanded(
              child: SideBar(),
            ),

          //Main Body Part

          const Expanded(flex: 4, child: Dashboard()),
        ],
      )),
    );
  }
}
