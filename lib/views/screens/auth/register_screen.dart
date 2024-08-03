import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber_shop_app/views/screens/auth/login_screen.dart';
import '../../../controllers/auth_controller.dart';

class CustomerRegisterScreen  extends StatefulWidget {
  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {

  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String fullName;
  late String password;
  bool _isLoading = false;

  Uint8List? _image;

  selectProfileImage() async{
    Uint8List img = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  captureProfileImage() async{
    Uint8List img = await _authController.pickProfileImage(ImageSource.camera);

    setState(() {
      _image = img;
    });
  }

  registerUser() async{
    if(_image != null){
      if(_formKey.currentState!.validate()){

        setState(() {
          _isLoading = true;
        });

        String result = await  _authController.CreateNewUser(email, fullName, password, _image);

        setState(() {
          _isLoading = false;
        });

        if(result == "Success") {
          setState(() {
            _isLoading = false;
          });
          Get.to(CustomerLoginScreen());
          Get.snackbar(
            "Success",
            "Your account has been successfully created!",
            backgroundColor: Colors.pink,
            colorText: Colors.white,
            margin: EdgeInsets.all(15),
            icon: Icon(Icons.message, color: Colors.white,),
          );
        }else{
          Get.snackbar(
            "Error",
            "An error occurred during the process, please kindly try again!",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(15),
            icon: Icon(Icons.message, color: Colors.white,),
          );
        }
      }else{
        Get.snackbar(
          "Validation",
          "Please fill in all the required fields!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(15),
          icon: Icon(Icons.message, color: Colors.white,),
        );
      }
    }else{
      Get.snackbar(
        "Profile Image Upload",
        "Please select a photo for your profile!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(15),
        icon: Icon(Icons.message, color: Colors.white,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register Account",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(height: 25,),
                  Stack(
                    children: [
                      _image == null? CircleAvatar(
                        radius: 65,
                        child: Icon(
                          Icons.person,
                          size: 70,
                        ),
                      ):CircleAvatar(
                        radius: 65,
                        backgroundImage: MemoryImage(_image!),
                      ),
                      Positioned(
                        right: 0,
                        top: 15,
                        child: IconButton(onPressed: () {
                          selectProfileImage();
                        }, icon: Icon(CupertinoIcons.photo),)
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  TextFormField(
                    onChanged: (value){
                      email = value;
                    },
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please email address must not be empty!";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      hintText: "Enter your email address",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  TextFormField(
                    onChanged: (value){
                      fullName = value;
                    },
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please full name must not be empty!";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      hintText: "Enter your full name",
                      prefixIcon: Icon(
                        Icons.person_2_rounded,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  TextFormField(
                    onChanged: (value){
                      password = value;
                    },
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please password must not be empty!";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  InkWell(
                    onTap: (){
                      registerUser();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width-30,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: _isLoading? CircularProgressIndicator(color: Colors.white,) : Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CustomerLoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text("Already Having An Account ?"),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
