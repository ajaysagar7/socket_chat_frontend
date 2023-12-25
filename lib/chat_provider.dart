import 'package:basic_chat_app/message_model.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  ScrollController _scrollController = ScrollController();
  List<MessageModel> _messageLists = [];

  ScrollController get scrollController => _scrollController;
  List<MessageModel> get messageLists => _messageLists;

  void addMessage(MessageModel message) {
    _messageLists.add(message);
    _scrollToBottom();
    notifyListeners();
  }

  void addAllMessages(List<MessageModel> messages) {
    _messageLists.addAll(messages);
    _scrollToBottom();
    notifyListeners();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
