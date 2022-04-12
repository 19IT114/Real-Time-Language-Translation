import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realtime/widget/chats/messageLook.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('chat')
        .orderBy('createTime', descending: true)
        .snapshots();
    return StreamBuilder(
      stream: _usersStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final msg = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: msg.length,
          itemBuilder: (context, index) {
            return MessageLook(
              msg[index]['finalText'],
              msg[index]['userId'] == userid,
            );
          },
        );
      },
    );
  }
}

// FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance.collection('chat').get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         final msg = snapshot.data!.docs;
//         if (snapshot.hasData) {
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               return Text(
//                 msg[index]['text'],
//               );
//             },
//           );
//         } else if (snapshot.hasError) {
//           Center(
//             child: Text(
//               snapshot.hasError.toString(),
//             ),
//           );
//         }
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );