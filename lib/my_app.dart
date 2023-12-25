import 'package:basic_chat_app/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unique Names and IDs List',
      home: MyListView(),
    );
  }
}

class MyListView extends StatelessWidget {
  final List<Map<String, dynamic>> userList = [
    {'id': 1, 'name': 'John Doe'},
    {'id': 2, 'name': 'Jane Smith'},
    {'id': 3, 'name': 'Bob Johnson'},
    {'id': 4, 'name': 'Alice Williams'},
    {'id': 5, 'name': 'Charlie Brown'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                          username: userList[index]["name"].toString(),
                          userid: userList[index]["id"].toString())));
            },
            title: Text(user['name']),
            subtitle: Text('ID: ${user['id']}'),
          );
        },
      ),
    );
  }
}
