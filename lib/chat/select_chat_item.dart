import 'package:flutter/material.dart';
import 'package:lingon/chat/screens/chat_screen.dart';

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
        // ChatMessages(chatId: chat.id)
        // Show a new page within the same tree so that provider is reachable
        String chatId = chat.id;
        Navigator.pushNamed(context, '/chat/$chatId',
            arguments: ScreenArguments(
              chatId,
            ));
      },
    );
  }
}
