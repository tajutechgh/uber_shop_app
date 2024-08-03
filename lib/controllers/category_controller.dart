import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/models/category_model.dart';

class CategoryController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit(){
    super.onInit();
    fetchCategories();
  }
  
  void fetchCategories(){
    firestore.collection("categories").limit(4).snapshots().listen((QuerySnapshot){
      categories.assignAll(QuerySnapshot.docs.map((doc){
        final data = doc.data() as Map<String, dynamic>;
        return CategoryModel(categoryImage: data["image"], categoryName: data["categoryName"]);
      }).toList());
    });
  }
}