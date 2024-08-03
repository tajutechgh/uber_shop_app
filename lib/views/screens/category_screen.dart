import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_shop_app/views/screens/inner_screens/category_products.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> categoriesStream = FirebaseFirestore.instance.collection("categories").snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon((Icons.category)),
            SizedBox(width: 5,),
            Text("Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 5),)
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoriesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index){
                final categoryData = snapshot.data!.docs[index];

                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return CategoryProductScreen(categoryData: categoryData,);
                      }),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(categoryData["image"], width: 80, height: 80,),
                        SizedBox(height: 5,),
                        Text(categoryData["categoryName"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                );
              }
            ),
          );
        },
      ),
    );
  }
}
