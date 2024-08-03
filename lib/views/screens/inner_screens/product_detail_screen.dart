import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:uber_shop_app/provider/cart_provider.dart';
import 'package:uber_shop_app/provider/selected_size_provider.dart';
import 'package:uber_shop_app/views/screens/inner_screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int imageIndex = 0;

  void callSeller(String phoneNumber) async {
    final String url = "tel:$phoneNumber";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw ("Could not launch phone call");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productReviewsStream = FirebaseFirestore.instance.collection('productReviews')
        .where("productId", isEqualTo: widget.productData["productId"])
        .snapshots();
    final _cartProvider = ref.read(cartProvider.notifier);
    final cartItem = ref.watch(cartProvider);
    final selectedSize = ref.watch(selectedSizeProvider);
    final isInCart = cartItem.containsKey(widget.productData["productId"]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productData["productName"],
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      widget.productData["imageUrlList"][imageIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData["imageUrlList"].length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                imageIndex = index;
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.pink.shade900,
                                ),
                              ),
                              child: Image.network(
                                widget.productData["imageUrlList"][index],
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productData["productName"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "\$"+widget.productData["productPrice"].toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.pink,
                      letterSpacing: 4,
                    ),
                  ),
                  widget.productData["rating"] == 0 ? SizedBox() :
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 15,
                        ),
                        Text(
                          widget.productData["rating"].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "(${widget.productData["totalReviews"]} Reviews)",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product Description", style: TextStyle(color: Colors.pink),),
                        Text("View More", style: TextStyle(color: Colors.pink),),
                      ],
                    ),
                    children: [
                      Text(
                        widget.productData["description"],
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  ExpansionTile(
                    title: Text(
                      "Product Sizes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.productData["sizeList"].length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: OutlinedButton(
                                  onPressed: (){
                                    final newSelected = widget.productData["sizeList"][index];
                                    
                                    ref.read(selectedSizeProvider.notifier).setSelectedSize(newSelected);
                                  },
                                  child: Text(widget.productData["sizeList"][index]),
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        widget.productData["storeImage"],
                      ),
                    ),
                    title: Text
                      (widget.productData["businessName"],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "SEE PROFILE",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            RatingSummary(
              counter: widget.productData["totalReviews"],
              average: widget.productData["rating"],
              showAverage: true,
              counterFiveStars: 5,
              counterFourStars: 4,
              counterThreeStars: 2,
              counterTwoStars: 1,
              counterOneStars: 1,
            ),
            SizedBox(height: 10,),
            StreamBuilder<QuerySnapshot>(
              stream: _productReviewsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading reviews");
                }

                return SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index){
                      final reviewData = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              reviewData["fullName"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              reviewData["review"],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                );
              },
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: isInCart? null : (){
                _cartProvider.addProductToCart(
                    widget.productData["productName"],
                    widget.productData["productId"],
                    widget.productData["imageUrlList"],
                    1,
                    widget.productData["productQuantity"],
                    widget.productData["productPrice"],
                    widget.productData["vendorId"],
                    selectedSize,
                );
                // print(_cartProvider.getCartItems.values.first.productName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isInCart? Colors.green : Colors.pink,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.shopping_cart,
                        color: Colors.white,
                      ),
                      Text(
                        isInCart ? "IN CART" : "ADD TO CART",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ChatScreen(
                    sellerId: widget.productData["vendorId"],
                    buyerId: FirebaseAuth.instance.currentUser!.uid,
                    productId: widget.productData["productId"],
                    productName: widget.productData["productName"],
                  );
                }));
              },
              icon: Icon(
                CupertinoIcons.chat_bubble,
                color: Colors.pink,
              ),
            ),
            IconButton(
              onPressed:(){
                callSeller(widget.productData["phoneNumber"]);
              },
              icon: Icon(
                CupertinoIcons.phone,
                color: Colors.pink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
