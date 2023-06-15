// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retirement_management_system/messages/message.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  const ConversationScreen({required this.conversationId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Conversation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('conversations')
                  .doc(widget.conversationId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].data() as Map<String, dynamic>;
                      final senderId = message['senderId'];
                      final content = message['content'];

                      return ListTile(
                        title: Text(content),
                        subtitle: Text('Sent by $senderId'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching messages'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final messageContent = _messageController.text.trim();
                    if (messageContent.isNotEmpty) {
                      final newMessage = Message(
                        senderId: 'currentUserId',
                        content: messageContent,
                        timestamp: DateTime.now(),
                      );

                      _firestore
                          .collection('conversations')
                          .doc(widget.conversationId)
                          .collection('messages')
                          .add({
                        'senderId': newMessage.senderId,
                        'content': newMessage.content,
                        'timestamp': newMessage.timestamp,
                      });

                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
