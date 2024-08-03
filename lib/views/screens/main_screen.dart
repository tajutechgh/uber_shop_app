import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uber_shop_app/views/screens/account_screen.dart';
import 'package:uber_shop_app/views/screens/cart_screen.dart';
import 'package:uber_shop_app/views/screens/category_screen.dart';
import 'package:uber_shop_app/views/screens/favourite_screen.dart';
import 'package:uber_shop_app/views/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int pageIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    FavouriteScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value){
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/store-1.png", width: 20,),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/explore.svg"),
            label: "CATEGORIES",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/cart.svg"),
            label: "CART",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/favorite.svg"),
            label: "FAVOURITE",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/account.svg"),
            label: "ACCOUNT",
          ),
        ],
      ),
      body: _pages[pageIndex],
    );
  }
}
