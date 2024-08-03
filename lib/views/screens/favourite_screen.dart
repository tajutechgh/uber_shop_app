import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/provider/favourite_provider.dart';

class FavouriteScreen extends ConsumerStatefulWidget {
  const FavouriteScreen({super.key});

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final _favouriteProvider = ref.read(favouriteProvider.notifier);
    final _wishItem = ref.watch(favouriteProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wishlist",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              _favouriteProvider.removeAllItems();
            },
            icon: Icon(
              CupertinoIcons.delete,
            ),
          )
        ],
      ),
      body:_wishItem.isNotEmpty? ListView.builder(
        shrinkWrap: true,
        itemCount: _wishItem.length,
        itemBuilder: (context, index){
          final wishData = _wishItem.values.toList()[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(wishData.imageUrl[0]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wishData.productName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "\$" + wishData.price.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              _favouriteProvider.removeItem(wishData.productId);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ):Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Wish List is Empty",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
            Text(
              "Your haven't added any items to your wish list\n you can add from the home screen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
