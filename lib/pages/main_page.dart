import 'package:flutter/material.dart';
import 'package:flutter_wan_android/constants/constants.dart';
import 'package:flutter_wan_android/pages/home_page.dart';
import 'package:flutter_wan_android/pages/mine_page.dart';
import 'package:flutter_wan_android/pages/project_page.dart';
import 'package:flutter_wan_android/pages/search_page.dart';
import 'package:flutter_wan_android/pages/square_page.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({super.key, required this.title});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItemIndex = 0;
  String _currentTitle = Constant.HOME;
  final List<String> _titles = [
    Constant.HOME,
    Constant.PROJECT,
    Constant.SQUARE,
    Constant.MINE
  ];
  final List<Widget> _navIcons = [
    const Icon(Icons.home),
    const Icon(Icons.ac_unit),
    const Icon(Icons.animation),
    const Icon(Icons.verified_user_rounded)
  ];

  final List<Widget> _pages = [
    // HomePage,
    const HomePage(),
    // ProjectPage,
    const ProjectPage(),
    // SquarePage,
    const SquarePage(),
    // MinePage
    const MinePage()
  ];

  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(_currentTitle, style: const TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              tooltip: '搜索',
              onPressed: () {
                Get.to(() => const SearchPage());
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _generateBottomNavList(),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        unselectedFontSize: 14,
        iconSize: 24,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedItemIndex,
        onTap: _onNavItemTapped,
      ),
      body: PageView.builder(
        itemBuilder: (context, index) => _pages[index],
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  List<BottomNavigationBarItem> _generateBottomNavList() {
    return List.generate(_titles.length, (index) {
      return BottomNavigationBarItem(
          icon: _navIcons[index], label: _titles[index]);
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  _onPageChanged(int index) {
    setState(() {
      _selectedItemIndex = index;
      _currentTitle = _titles[index];
    });
  }
}
