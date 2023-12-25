import 'dart:io';

import 'package:basic_chat_app/chat_provider.dart';
import 'package:basic_chat_app/message_model.dart';
import 'package:basic_chat_app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MaterialApp(
        title: 'Chat App',
        home: HomePage(),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String username;
  final String userid;

  const ChatScreen({Key? key, required this.username, required this.userid})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();

  late IO.Socket socket;
  late ChatProvider chatProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    socket = IO.io('http://192.168.29.31:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('allMessages', (data) {
      if (data is List) {
        List<MessageModel> messages = [];
        for (var messageData in data) {
          if (messageData is Map<String, dynamic>) {
            messages.add(MessageModel(
              text: messageData["text"],
              senderid: messageData["senderId"],
            ));
          } else {
            print('Invalid data type for allMessages item: $messageData');
          }
        }
        chatProvider.addAllMessages(messages);
      } else {
        print('Invalid data type for allMessages: $data');
      }
    });

    socket.on('message', (data) {
      if (data is Map<String, dynamic>) {
        chatProvider.addMessage(MessageModel(
          text: data["text"],
          senderid: data["senderId"],
        ));
      } else {
        print('Unknown data type: $data');
      }
    });

    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  controller: provider.scrollController,
                  itemCount: provider.messageLists.length,
                  itemBuilder: (context, index) {
                    MessageModel model = provider.messageLists[index];
                    return Align(
                      alignment: model.senderid == "1"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          margin: EdgeInsets.all(12),
                          child: Text(model.text.toString()),
                        ),
                      ),
                    );
                  },
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
                    decoration:
                        InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () {
                    socket.emit('message',
                        {'text': _messageController.text, 'senderId': "2"});
                    _messageController.clear();
                  },
                  onTap: () {
                    socket.emit('message',
                        {'text': _messageController.text, 'senderId': "1"});
                    _messageController.clear();
                  },
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Disconnect from the server when the app is closed
    socket.disconnect();
    super.dispose();
  }
}
