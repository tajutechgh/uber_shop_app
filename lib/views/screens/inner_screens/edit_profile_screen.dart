import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  void populateController() async{
    String? userEmail = getUserEmail();
    String? userFullName = await getUserFullName();

    if(userEmail != null){
      emailController.text = userEmail;
    }

    if(userFullName != null){
      fullNameController.text = userFullName;
    }
  }

  // fetch full name
  Future<String?> getUserFullName() async{
    User? user = auth.currentUser;

    if(user != null){
      try{
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("buyers").doc(user.uid).get();

        return userDoc["fullName"];
      }catch (e){
        print("error fetching user full name: $e");
      }
    }else{
      return null;
    }
    return null;
  }

  String? getUserEmail(){
    User? user = auth.currentUser;

    if(user != null){
      return user.email;
    }else{
      return null;
    }
  }

  Future<void> updateProfile() async{
    try{
      User? user = auth.currentUser;

      if(user != null){

        // update email in authentication tab
        await user.verifyBeforeUpdateEmail(emailController.text);

        // then update email and fullName in cloud firestore
        await FirebaseFirestore.instance.collection("buyers").doc(user.uid).update({
          "email": emailController.text,
          "fullName": fullNameController.text,
        });

        // update controller text after successfully update
        emailController.text = emailController.text;
        fullNameController.text = fullNameController.text;

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Profile update initiated, please check your email to confirm.")
            )
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("failed to update: $e")
          )
      );
    }
  }

  @override
  void initState() {
    populateController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 6,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Edit Your Profile",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Enter Full Name',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: (){
                  updateProfile();
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                            color: Colors.white, fontSize: 18, letterSpacing: 6),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
