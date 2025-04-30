import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/HomePage.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<Widget> pages = [HomePage(), Tab2(), Tab3(), Tab4()];

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
          showSelectedLabels: false,
          onTap: _clickTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: '发现',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: '联系人',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: '添加',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.margin),
              label: '我的',
            )
          ]),
    );
  }
}

class Tab2 extends StatelessWidget {
  const Tab2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('tab2'),
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

class Tab4 extends StatelessWidget {
  const Tab4({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('tab4'),
    );
  }
}
