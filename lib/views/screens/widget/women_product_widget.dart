import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_shop_app/views/screens/widget/product_model.dart';

class WomenProductsWidget extends StatefulWidget {
  const WomenProductsWidget({super.key});

  @override
  State<WomenProductsWidget> createState() => _WomenProductsWidgetState();
}

class _WomenProductsWidgetState extends State<WomenProductsWidget> {

  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance.collection("products").where("category", isEqualTo: "Women").snapshots();

    return StreamBuilder<QuerySnapshot>(

      stream: productsStream,

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.data!.docs.isEmpty){
          return Center(
            child: Text(
              "No Women Products",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                letterSpacing: 4,
              ),
            ),
          );
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