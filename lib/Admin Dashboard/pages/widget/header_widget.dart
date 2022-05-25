import 'package:completereport/Admin Dashboard/common/app_colors.dart';
import 'package:completereport/Admin Dashboard/controller/menu_controller.dart';
import 'package:completereport/Admin Dashboard/pages/app_responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          if (!AppResponsive.isDesktop(context))
            IconButton(
                onPressed: Provider.of<MenuController>(context, listen: false)
                    .controlMenu,
                icon: Icon(
                  Icons.menu_rounded,
                  color: AppColor.red,
                )),
          const Text(
            "Admin Dashboard",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Row(mainAxisSize: MainAxisSize.min, children: [
            navigationIcon(icon: Icons.search),
          ])
        ],
      ),
    );
  }
}

Widget navigationIcon({icon}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Icon(
      icon,
      color: AppColor.white,
    ),
  );
}
