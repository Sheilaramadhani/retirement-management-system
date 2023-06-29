// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String content;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.content,
    required this.timestamp,
  });
}

class Conversation {
  final String id;
  final List<String> participantIds;
  final List<Message> messages;

  Conversation({required this.id, required this.participantIds, required this.messages});
}

class ConversationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Conversation>> getConversationsForUser(String userId) async {
    final querySnapshot = await _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessage.timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final conversationData = doc.data();
      final messagesData = conversationData['messages'] as List<dynamic>;

      final messages = messagesData.map((messageData) {
        return Message(
          senderId: messageData['senderId'],
          content: messageData['content'],
          timestamp: (messageData['timestamp'] as Timestamp).toDate(),
        );
      }).toList();

      return Conversation(
        id: doc.id,
        participantIds: List<String>.from(conversationData['participantIds']),
        messages: messages,
      );
    }).toList();
  }

  Future<String> createConversation(List<String> participantIds) async {
    final docRef = await _firestore.collection('conversations').add({
      'participantIds': participantIds,
      'messages': [],
    });

    return docRef.id;
  }

  Future<void> addMessageToConversation(String conversationId, Message message) async {
    // Add sender message
    await _firestore.collection('conversations').doc(conversationId).update({
      'messages': FieldValue.arrayUnion([
        {
          'senderId': message.senderId,
          'content': message.content,
          'timestamp': message.timestamp,
        }
      ]),
    });

    // Generate and add automatic response message
    final autoResponseMessage = Message(
      senderId: 'system',
      content: 'Thank you for your message. We will get back to you shortly.',
      timestamp: DateTime.now(),
    );

    await _firestore.collection('conversations').doc(conversationId).update({
      'messages': FieldValue.arrayUnion([
        {
          'senderId': autoResponseMessage.senderId,
          'content': autoResponseMessage.content,
          'timestamp': autoResponseMessage.timestamp,
        }
      ]),
    });
  }
}
