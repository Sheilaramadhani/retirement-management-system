import 'package:retirement_management_system/messages/message.dart';

class Conversation {
  final String id;
  final List<String> participantIds;
  final List<Message> messages;

  Conversation({required this.id, required this.participantIds, required this.messages});
}
