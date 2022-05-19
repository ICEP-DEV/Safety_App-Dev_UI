import 'package:admin/common/app_colors.dart';
import 'package:admin/pages/app_responsive.dart';
import 'package:admin/pages/widget/header_widget.dart';
import 'package:admin/pages/widget/layout_template.dart/layout_temp.dart';
import 'package:admin/pages/widget/notification_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColor.black, borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          //Header
          const HeaderWidget(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        children: [
                          const NotificationCardWidget(),
                          const SizedBox(
                            height: 5,
                          ),
                          if (AppResponsive.isMobile(context)) ...{
                            LayoutTemplate(),
                          }

                          //VecMembersDataWidget(),
                          // Navigator(
                          //   key: locator<NavigationService>().navigatorKey,
                          //   onGenerateRoute: generateRoute,
                          //   initialRoute: HomeRoute,
                          // ),
                        ],
                      ),
                    )),
                if (!AppResponsive.isMobile(context))
                  Expanded(child: Container()),
              ],
            ),
          ),
          if (!AppResponsive.isMobile(context)) ...{}
        ],
      ),
    );
  }
}
