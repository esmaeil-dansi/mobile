import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/config/frappe_palette.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/views/awesome_bar/awesome_bar_view.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/views/desk/profile_page.dart';
import 'package:frappe_app/views/notification_view.dart';

import 'package:frappe_app/widgets/user_avatar.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      // controller: _controller,
      decoration: NavBarDecoration(boxShadow: [BoxShadow()]),
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style5,
    );
  }

  List<Widget> _buildScreens() {
    return [
      DesktopView(),
      Awesombar(),
      NotifcationView(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        title: 'خانه',
        inactiveIcon: FrappeIcon(
          FrappeIcons.home_outlined,
          size: 24,
          color: FrappePalette.grey[500],
        ),
        icon: FrappeIcon(
          FrappeIcons.home_filled,
          size: 24,
        ),
        activeColorPrimary: FrappePalette.grey[800]!,
        inactiveColorPrimary: FrappePalette.grey[500],
      ),
      PersistentBottomNavBarItem(
        title: 'Search',
        icon: FrappeIcon(
          FrappeIcons.search,
          color: FrappePalette.grey[800],
          size: 28,
        ),
        inactiveIcon: FrappeIcon(
          FrappeIcons.search,
          color: FrappePalette.grey[500],
          size: 28,
        ),
        activeColorPrimary: FrappePalette.grey[800]!,
        inactiveColorPrimary: FrappePalette.grey[500],
      ),
      PersistentBottomNavBarItem(
        title: 'Search',
        icon: FrappeIcon(
          FrappeIcons.notification,
          color: FrappePalette.grey[800],
          size: 22,
        ),
        inactiveIcon: FrappeIcon(
          FrappeIcons.notification,
          color: FrappePalette.grey[500],
          size: 22,
        ),
        activeColorPrimary: FrappePalette.grey[800]!,
        inactiveColorPrimary: FrappePalette.grey[500],
      ),
      PersistentBottomNavBarItem(
        title: 'Profile',
        icon: UserAvatar(
          uid: Config().userId!,
          size: 12,
        ),
        activeColorPrimary: FrappePalette.grey[800]!,
        inactiveColorPrimary: FrappePalette.grey[500],
      ),
    ];
  }
}
