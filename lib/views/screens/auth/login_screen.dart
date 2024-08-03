import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/controllers/auth_controller.dart';
import 'package:uber_shop_app/views/screens/auth/register_screen.dart';
import 'package:uber_shop_app/views/screens/map_screen.dart';

class CustomerLoginScreen  extends StatefulWidget {
  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  late String email;
  late String password;

  loginUser() async{
    if(_formKey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });

      String results = await _authController.loginUser(email, password);

      setState(() {
        _isLoading = false;
      });

      if(results == "Success"){
        setState(() {
          _isLoading = false;
        });
        Get.to(MapScreen());
        Get.snackbar(
          "Login Success",
          "You have successfully login to your account!",
          backgroundColor: Colors.pink,
          colorText: Colors.white,
          margin: EdgeInsets.all(15),
          icon: Icon(Icons.message, color: Colors.white,),
        );
      }else{
        Get.snackbar(
          "Error Occurred",
          results.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(15),
          icon: Icon(Icons.message, color: Colors.white,),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "Login Account",
                   style: TextStyle(
                     fontSize: 22,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 4,
                   ),
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
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(
                    Icons.email,
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
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.pink,
                  ),
                ),
              ),
              SizedBox(height: 25,),
              InkWell(
                onTap: (){
                  loginUser();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width-30,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: _isLoading? CircularProgressIndicator(color: Colors.white,) : Text(
                      "Login",
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
                              return CustomerRegisterScreen();
                            },
                        ),
                    );
                  },
                  child: Text("Need An Account ?"),
              )
            ],
          ),
        ),
      )
    );
  }
}
