import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, AsyncSnapshot futureSnapshot) => futureSnapshot
                    .connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection('chat')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final chatDocs = chatSnapshot.data.documents;
                  return ListView.builder(
                    reverse: true,
                    itemBuilder: (ctx, idx) => MessageBubble(
                        key: ValueKey(chatDocs[idx].documentID),
                        message: chatDocs[idx]['text'],
                        isMe:
                            chatDocs[idx]['userId'] == futureSnapshot.data.uid,
                        username: chatDocs[idx]['username'],
                        imageUrl: chatDocs[idx]['userImage']),
                    itemCount: chatDocs.length,
                  );
                }));
  }
}
