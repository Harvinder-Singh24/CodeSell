import 'package:devgram/controllers/helper/constants.dart';
import 'package:devgram/view/screens/InAppScreens/main_screen.dart';
import 'package:devgram/view/screens/InAppScreens/profile_screen.dart';
import 'package:devgram/view/screens/InAppScreens/transaction_screen.dart';
import 'package:devgram/view/screens/InAppScreens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'InAppScreens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final name, email, designation;
  HomeScreen({Key? key, this.name, this.email, this.designation})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    _selectedPageIndex = 0;
    _pages = [
      const MainScreen(),
      const SearchScreen(),
      UploadScreen(
        name: widget.name,
        email: widget.email,
        designation: widget.designation,
      ),
      const TransactionScreen(),
      const ProfileScreen()
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  _selectedPageIndex = index;
                  _pageController.animateToPage(_selectedPageIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);

                  // Check if there is an active modal bottom sheet before popping
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                });
              },
              currentIndex: _selectedPageIndex,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Colors.indigo[600],
              selectedIconTheme: const IconThemeData(color: greenColor),
              unselectedIconTheme: IconThemeData(color: Colors.grey[700]),
              items: const [
                BottomNavigationBarItem(
                    label: "Home",
                    icon: Icon(
                      IconlyBold.home,
                    )),
                BottomNavigationBarItem(
                    label: "Search",
                    icon: Icon(
                      IconlyBold.search,
                    )),
                BottomNavigationBarItem(
                    label: "Upload",
                    icon: Icon(
                      IconlyBold.plus,
                    )),
                BottomNavigationBarItem(
                    label: "Transaction",
                    icon: Icon(
                      IconlyBold.notification,
                    )),
                BottomNavigationBarItem(
                    label: "Profile",
                    icon: Icon(
                      IconlyBold.profile,
                    )),
              ]),
        ),
        body: WillPopScope(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
          onWillPop: () {
            SystemNavigator.pop();
            throw "Cannot Back";
          },
        ));
  }
}
