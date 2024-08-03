import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // function select image from the gallery or camera
  pickProfileImage(ImageSource source) async{
     final ImagePicker _imagePicker = ImagePicker();

     XFile? _file = await _imagePicker.pickImage(source: source);

     if(_file != null){
       return await _file.readAsBytes();
     }else{
       print("No image selected or captured");
     }
  }

  // function to upload image to firebase storage
  _uploadImageToStorage(Uint8List? image) async{
     Reference reference = _storage.ref().child("profileImages").child(_auth.currentUser!.uid);
     
     UploadTask uploadTask = reference.putData(image!);

     TaskSnapshot snapshot = await uploadTask;

     String downloadUrl = await snapshot.ref.getDownloadURL();

     return downloadUrl;
  }

  // function to create new user
  Future<String> CreateNewUser(String email, String fullName, String password, Uint8List? image) async {

    String result = "Some error occurred";

    try{
       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

       String downloadUrl  = await _uploadImageToStorage(image);

       await _firestore.collection("buyers").doc(userCredential.user!.uid).set({
         "fullName": fullName,
         "profileImage": downloadUrl,
         "email": email,
         "buyerId": userCredential.user!.uid,
       });
       result = "Success";
    }catch (e){
      result = e.toString();
    }
    return result;
  }

  // function to login the registered user
  Future<String> loginUser(String email, String password) async{
    String results = "Some error occurred";

    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      results = "Success";
    }catch (e){
      results = e.toString();
    }

    return results;
  }
}