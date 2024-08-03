import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_shop_app/views/screens/widget/product_model.dart';

class HomeProductsWidget extends StatefulWidget {
  const HomeProductsWidget({super.key});

  @override
  State<HomeProductsWidget> createState() => _HomeProductsWidgetState();
}

class _HomeProductsWidgetState extends State<HomeProductsWidget> {

  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance.collection('products').snapshots();

    return StreamBuilder<QuerySnapshot>(

      stream: productsStream,

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: 100,
          child: PageView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){

              final productData = snapshot.data!.docs[index];

              return ProductModel(productData: productData);
            }
          ),
        );
      },
    );
  }
}
