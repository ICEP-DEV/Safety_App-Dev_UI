import 'package:completereport/Admin Dashboard/common/app_colors.dart';
import 'package:completereport/Admin Dashboard/pages/User/view_user.dart';
import 'package:completereport/Admin Dashboard/pages/VEC/View_Vec.dart';
import 'package:completereport/Admin Dashboard/pages/VEC/register_vec.dart';
import 'package:completereport/Login/user_login.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: AppColor.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Safety App",
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DrawerListTile(
              title: 'Register VEC',
              icon: 'lib/Admin Dashboard/assets/menu_recruitment.png',
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AdminSite()));
              },
            ),
            DrawerListTile(
              title: 'View VEC',
              icon: 'lib/Admin Dashboard/assets/menu_recruitment.png',
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => View_VEC()));
              },
            ),
            DrawerListTile(
              title: 'View User',
              icon: 'lib/Admin Dashboard/assets/menu_recruitment.png',
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => View_User()));
              },
            ),
            SizedBox(height: 80),
            GestureDetector(
              child: Text(
                "               Signout",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            Spacer(),
            Image.asset("lib/Admin Dashboard/assets/gvb.jpg"),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile(
      {Key? key, required this.press, required this.title, required this.icon})
      : super(key: key);

  String title, icon;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        icon,
        color: AppColor.black,
        height: 27,
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColor.white),
      ),
    );
  }
}
