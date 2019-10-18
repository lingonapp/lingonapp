import 'package:flutter/material.dart';
import 'package:lingon/chatmessages/screens/chat_messages.dart';

import 'models/chat.dart';

class SelectChatItem extends StatefulWidget {
  SelectChatItem({Key key, this.chat}) : super(key: key);
  final Chat chat;
  @override
  _SelectChatItemState createState() => _SelectChatItemState();
}

class _SelectChatItemState extends State<SelectChatItem> {
  @override
  Widget build(BuildContext context) {
    Chat chat = widget.chat;
    return ListTile(
      leading: Icon(Icons.chat),
      title: Text(
        chat.userNames.join(", "),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isThreeLine: true,
      subtitle: Text(chat.latestMessage.text),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatMessages(chatId: chat.id)));
      },
    );
  }
}
