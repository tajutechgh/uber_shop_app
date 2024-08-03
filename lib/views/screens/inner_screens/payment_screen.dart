import 'package:flutter/material.dart';
import 'package:uber_shop_app/views/screens/inner_screens/checkout_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool payOnDelivery = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Options",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pay on Delivery",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: payOnDelivery,
                  onChanged: (value){
                    setState(() {
                      payOnDelivery = value;
                    });
                    if(payOnDelivery){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CheckoutScreen();
                      }));
                    }
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
