import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s25_module_b/pages/CommunityPage.dart';
import 'package:s25_module_b/pages/MyPage.dart';

import 'pages/HomePage.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<Widget> pages = [HomePage(), CommunityPage(), Tab3(), MyPage()];

  int tabIndex = 0;

  void _clickTab(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          onTap: _clickTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: '发现',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: '社区',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: '订购',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '我的',
            )
          ]),
    );
  }
}

class Tab3 extends StatelessWidget {
  const Tab3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('tab3'),
    );
  }
}
