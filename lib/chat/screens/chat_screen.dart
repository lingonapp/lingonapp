import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/chat/bloc/bloc.dart';
import 'package:lingon/chat/models/chat.dart';
import 'package:lingon/loading/screens/loading_screen.dart';

import '../select_chat_item.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();

  ChatScreenState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (BuildContext context, ChatState chatState) {
        print(chatState);
        if (chatState == InitialChatState()) {
          BlocProvider.of<ChatBloc>(context).add(ListenForChats());
          return LoadingScreen(
            loadingText: 'Loading chats',
          );
        }
        print(chatState.chats);
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            Chat chat = chatState.chats.chats[index];
            return index >= chatState.chats.length
                ? LoadingScreen(loadingText: 'No chats')
                : SelectChatItem(chat: chat);
          },
          itemCount: chatState.chats.length,
          controller: _scrollController,
        );
      },
    );
  }

  void _onScroll() {
    print('scroll tjoho');
  }
}
