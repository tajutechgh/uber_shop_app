import 'package:flutter/material.dart';
import 'package:uber_shop_app/views/screens/widget/banner_widget.dart';
import 'package:uber_shop_app/views/screens/widget/category_text_widget.dart';
import 'package:uber_shop_app/views/screens/widget/home_products.dart';
import 'package:uber_shop_app/views/screens/widget/location_widget.dart';
import 'package:uber_shop_app/views/screens/widget/men_product_widget.dart';
import 'package:uber_shop_app/views/screens/widget/reuse_text.dart';
import 'package:uber_shop_app/views/screens/widget/women_product_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationWidget(),
          SizedBox(height: 10,),
          BannerWidget(),
          SizedBox(height: 10,),
          CategoryItemWidget(),
          HomeProductsWidget(),
          SizedBox(height: 10,),
          ReuseTextWidget(title: "Men's Products"),
          SizedBox(height: 10,),
          MenProductsWidget(),
          SizedBox(height: 10,),
          ReuseTextWidget(title: "Women's Products"),
          WomenProductsWidget(),
        ],
      ),
    );
  }
}
