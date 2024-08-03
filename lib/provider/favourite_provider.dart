import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/favourite_model.dart';

final favouriteProvider = StateNotifierProvider<FavouriteNotifier, Map<String, FavouriteModel>>((ref) => FavouriteNotifier());

class FavouriteNotifier extends StateNotifier<Map<String, FavouriteModel>>{

  FavouriteNotifier() : super({});

  void addProductToFavourite(String productName, String productId, List imageUrl, int quantity, int productQuantity,
    double price, String vendorId){
    state[productId] = FavouriteModel(
      productName: productName,
      productId: productId,
      imageUrl: imageUrl,
      quantity: quantity + 1,
      productQuantity: productQuantity,
      price: price,
      vendorId: vendorId,
    );
    // notify listeners that the state has changed
    state = {...state};
  }

  void removeAllItems(){
    state.clear();

    state = {...state};
  }

  void removeItem(String productId){
    state.remove(productId);

    state = {...state};
  }

  Map<String, FavouriteModel> get getFavoriteItems => state;
}