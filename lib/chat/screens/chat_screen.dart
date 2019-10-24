import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/chat/bloc/bloc.dart';
import 'package:lingon/chat/models/chat.dart';
import 'package:lingon/chatmessages/bloc/bloc.dart';
import 'package:lingon/chatmessages/screens/chat_messages.dart';
import 'package:lingon/currentuser/bloc/bloc.dart';
import 'package:lingon/loading/screens/loading_screen.dart';

import '../select_chat_item.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<NavigatorState> _chatNavigatorKey =
      GlobalKey<NavigatorState>();
  final _scrollController = ScrollController();

  ChatScreenState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    CurrentUserBloc _currentUserBloc =
        BlocProvider.of<CurrentUserBloc>(context);
    ChatMessagesBloc _chatMessagesBloc =
        ChatMessagesBloc(_currentUserBloc.state.userData);
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
        return BlocProvider<ChatMessagesBloc>(
          builder: (BuildContext context) => _chatMessagesBloc,
          child: Navigator(
            key: _chatNavigatorKey,
            onGenerateRoute: (RouteSettings settings) {
              print(settings.name);
              ScreenArguments args = settings.arguments;
              String chatID = args?.chatId;
              if (chatID != null) {
                print(chatID);
                return MaterialPageRoute(builder: (context) {
                  return ChatMessages(
                    chatId: args.chatId,
                  );
                });
              }
              if (chatState.chats.isEmpty) {
                return MaterialPageRoute(
                    builder: (context) => Center(
                          child: Text("No chats"),
                        ));
              }
              return MaterialPageRoute(
                  builder: (context) => ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          Chat chat = chatState.chats.chats[index];
                          print(index);
                          return index >= chatState.chats.length
                              ? Center(
                                  child: Text("More chats?"),
                                )
                              : SelectChatItem(chat: chat);
                        },
                        itemCount: chatState.chats.length,
                        controller: _scrollController,
                      ));
            },
          ),
        );
      },
    );
  }

  void _onScroll() {
    print('scroll tjoho');
  }
}

class ScreenArguments {
  final String chatId;

  ScreenArguments(this.chatId);
}
