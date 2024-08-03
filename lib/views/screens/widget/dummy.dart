import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/views/screens/category_screen.dart';

class CategoryTextWidget extends StatefulWidget {
  const CategoryTextWidget({super.key});

  @override
  State<CategoryTextWidget> createState() => _CategoryTextWidgetState();
}

class _CategoryTextWidgetState extends State<CategoryTextWidget> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> categoryStream = FirebaseFirestore.instance.collection('categories').snapshots();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: categoryStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading categories");
              }

              return Container(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index){
                            final categoryData = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ActionChip(
                                onPressed: (){

                                },
                                backgroundColor: Colors.pink.shade500,
                                label: Center(
                                  child: Text(
                                    categoryData["categoryName"].toUpperCase(),
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                                  ),
                                )
                              ),
                            );
                          }
                        )
                    ),
                    IconButton(onPressed: (){
                      Get.to(CategoryScreen());
                    }, icon: Icon(Icons.arrow_forward_ios,)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}