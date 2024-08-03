import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/provider/favourite_provider.dart';
import 'package:uber_shop_app/views/screens/inner_screens/product_detail_screen.dart';

class ProductModel extends ConsumerStatefulWidget {
  const ProductModel({
    super.key,
    required this.productData,
  });

  final QueryDocumentSnapshot<Object?> productData;

  @override
  _ProductModelState createState() => _ProductModelState();
}

class _ProductModelState extends ConsumerState<ProductModel> {
  @override
  Widget build(BuildContext context) {
    final _favouriteProvider = ref.read(favouriteProvider.notifier);
    ref.watch(favouriteProvider);

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ProductDetailScreen(productData: widget.productData,);
        }));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0f0000000),
                  ),
                ],
                borderRadius: BorderRadius.circular(8,),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.productData["imageUrlList"][0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.productData["productName"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: Color(0xff000000,),
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "\$" + widget.productData["productPrice"].toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: Colors.pink,
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        widget.productData["rating"] == 0 ? SizedBox() :
                        Row(
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
                          ],
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 18,
            child: IconButton
              (onPressed: (){
                _favouriteProvider.addProductToFavourite(
                  widget.productData["productName"],
                  widget.productData["productId"],
                  widget.productData["imageUrlList"],
                  1,
                  widget.productData["productQuantity"],
                  widget.productData["productPrice"],
                  widget.productData["vendorId"],
                );
              },
              icon:_favouriteProvider.getFavoriteItems.containsKey(widget.productData["productId"])? Icon(
                Icons.favorite,
                color: Colors.red,
              ):Icon(Icons.favorite_border, color: Colors.red,),
            ),
          )
        ],
      ),
    );
  }
}