import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var _entermessages = '';
  String finalMsg = '';
  final TextEditingController _textController = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    try {
      print(_entermessages);
      final url = Uri.parse(
          "https://translator-deployment-project.herokuapp.com/api/?ip_text=$_entermessages");
      final respone = await http.get(url);
      Map msg = jsonDecode(respone.body) as Map;
      setState(() {
        finalMsg = msg['data']['gujarati'];
      });
      print(finalMsg);
    } catch (e) {
      print("Inside Functions");
      print(e);
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('chat').add({
      'finalText': finalMsg,
      'text': _entermessages,
      'createTime': Timestamp.now(),
      'userId': userId,
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Send Message'),
              onChanged: (value) {
                setState(() {
                  _entermessages = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _entermessages.trim().isEmpty ? null : sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
