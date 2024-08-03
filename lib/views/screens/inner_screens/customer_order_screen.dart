import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CustomerOrderScreen extends StatefulWidget {
  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  double rating = 0;
  final TextEditingController _reviewTextController = TextEditingController();

  String formatedDate(date){
    final outPutDateFormat = DateFormat("dd/MM/yyyy");
    final outPutDate = outPutDateFormat.format(date);

    return outPutDate;
  }

  Future<bool> hasUserReviewedProduct(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: productId)
        .where('buyerId', isEqualTo: user!.uid)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> updateProductRating(String productId) async{
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: productId)
        .get();

    double totalRating = 0;

    int totalReviews = querySnapshot.docs.length;

    for(final doc in querySnapshot.docs){
      totalRating += doc["rating"];
    }

    final double averageRating = totalReviews > 0? totalRating / totalReviews : 0;
    
    await FirebaseFirestore.instance.collection("products").doc(productId).update({
      "rating": averageRating,
      "totalReviews": totalReviews,
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance.collection('orders').where("buyerId", isEqualTo: auth.currentUser!.uid).snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Orders",
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  ListTile(
                     leading: CircleAvatar(
                       backgroundColor: Colors.white,
                       radius: 14,
                       child: data["accepted"] == true ? Icon(Icons.delivery_dining) : Icon(Icons.access_time),
                     ),
                     title: data["accepted"] == true
                     ? Text(
                       "Accepted",
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         color: Colors.green,
                       ),
                     )
                     : Text(
                       "Not Accepted",
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         color: Colors.red,
                       ),
                     ),
                     trailing: Text(
                       "\$" + data["price"].toStringAsFixed(2),
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         color: Colors.black,
                       ),
                     ),
                  ),
                  ExpansionTile(
                    title: Text(
                      "Order Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    subtitle: Text(
                      "View Order Details",
                    ),
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Image.network(
                            data["productImages"][0],
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["productName"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quantity",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data["quantity"].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: ListTile(
                          title: Text(
                            "Buyer Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["fullName"],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                data["email"],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Order date " + formatedDate(data["orderDate"].toDate()),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                  ),
                                ),
                              ),
                              data["accepted"] == true? ElevatedButton(onPressed: () async{
                                final productId = data["productId"];
                                final hasReviewed = await hasUserReviewedProduct(productId);
                                if(hasReviewed){
                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      title: Text(
                                        "Update Review",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 4,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: _reviewTextController,
                                            decoration: InputDecoration(
                                              labelText: "Update Your Review",
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RatingBar.builder(
                                                initialRating: rating,
                                                itemCount: 5,
                                                minRating: 1,
                                                maxRating: 5,
                                                allowHalfRating: true,
                                                itemSize: 15,
                                                unratedColor: Colors.grey,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                                itemBuilder: (context, _){
                                                  return Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  );
                                                },
                                                onRatingUpdate: (value){
                                                  rating = value;
                                                }
                                            ),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            final review = _reviewTextController.text;
                                            await FirebaseFirestore.instance.collection('productReviews').doc(data["orderId"]).update({
                                              'productId': data['productId'],
                                              'fullName': data['fullName'],
                                              'buyerId': data['buyerId'],
                                              'buyerPhoto': data['profileImage'],
                                              'rating': rating,
                                              'review': review,
                                              'email': data['email'],
                                              'timestamp': Timestamp.now(),
                                            }).whenComplete((){
                                              updateProductRating(productId);
                                              Navigator.pop(context);
                                              _reviewTextController.clear();
                                              rating = 0;
                                            });
                                          },
                                          child: Text('Submit'),
                                        ),
                                      ],
                                    );
                                  });
                                }else{
                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      title: Text(
                                        "Leave a review",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 4,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: _reviewTextController,
                                            decoration: InputDecoration(
                                              labelText: "Your Review",
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RatingBar.builder(
                                                initialRating: rating,
                                                itemCount: 5,
                                                minRating: 1,
                                                maxRating: 5,
                                                allowHalfRating: true,
                                                itemSize: 15,
                                                unratedColor: Colors.grey,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                                itemBuilder: (context, _){
                                                  return Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  );
                                                },
                                                onRatingUpdate: (value){
                                                  rating = value;
                                                }
                                            ),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            final review = _reviewTextController.text;
                                            await FirebaseFirestore.instance.collection('productReviews').doc(data["orderId"]).set({
                                              'productId': data['productId'],
                                              'fullName': data['fullName'],
                                              'buyerId': data['buyerId'],
                                              'rating': rating,
                                              'review': review,
                                              'email': data['email'],
                                              'timestamp': Timestamp.now(),
                                            }).whenComplete((){
                                              updateProductRating(productId);
                                              Navigator.pop(context);
                                              _reviewTextController.clear();
                                              rating = 0;
                                            });
                                          },
                                          child: Text('Submit'),
                                        ),
                                      ],
                                    );
                                  });
                                }
                              }, child: Text("Review")): Text("")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
