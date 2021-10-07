import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('chats/R1eFeGpZcOTUAQdCSmN9/messages')
              .snapshots(),
          builder: (ctx, AsyncSnapshot streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshot.data.documents;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, i) => Container(
                padding: const EdgeInsets.all(8),
                child: Text(documents[i]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/R1eFeGpZcOTUAQdCSmN9/messages')
              .add({'text': 'This was added'});
        },
      ),
    );
  }
}
