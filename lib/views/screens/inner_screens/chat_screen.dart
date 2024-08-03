import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String sellerId;
  final String buyerId;
  final String productId;
  final String productName;

  const ChatScreen({
    super.key,
    required this.sellerId,
    required this.buyerId,
    required this.productId,
    required this.productName
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _chatsStream;

  @override
  void initState() {
    super.initState();
    _chatsStream = _firestore
        .collection('chats')
        .where('buyerId', isEqualTo: widget.buyerId)
        .where('sellerId', isEqualTo: widget.sellerId)
        .where('productId', isEqualTo: widget.productId)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  void _sendMessage() async {
    DocumentSnapshot userDoc = await _firestore.collection('vendors').doc(widget.sellerId).get();
    DocumentSnapshot buyerDoc = await _firestore.collection('buyers').doc(widget.buyerId).get();
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await _firestore.collection('chats').add({
        'productId': widget.productId,
        'buyerName':(buyerDoc.data() as Map<String, dynamic>)['fullName'],
        'buyerPhoto': (buyerDoc.data() as Map<String, dynamic>)['profileImage'],
        'sellerPhoto': (userDoc.data() as Map<String, dynamic>)['storeImage'],
        'buyerId': widget.buyerId,
        'sellerId': widget.sellerId,
        'message': message,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now(),
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chat Screen' + "(" + widget.productName + ")",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                    String message = data['message'].toString();
                    String senderId = data['senderId'].toString(); // Assuming 'senderId' field exists

                    // Determine if the sender is the buyer or the seller
                    bool isBuyer = senderId == widget.buyerId;
                    String senderType = isBuyer ? 'Buyer' : 'Seller';
                    bool isSellerMessage = senderId == FirebaseAuth.instance.currentUser!.uid;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: isSellerMessage
                            ? NetworkImage(data['sellerPhoto'])
                            : NetworkImage(data['buyerPhoto']),
                      ),
                      title: Text(data['message']),
                      subtitle: Text('Sent by $senderType'),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
