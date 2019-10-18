import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/chatmessages/bloc/bloc.dart';
import 'package:lingon/chatmessages/chat_message.dart';
import 'package:lingon/loading/screens/loading_screen.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages({this.chatId, Key key}) : super(key: key);
  final String chatId;

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  // List<ChatMessages> _messages;

  @override
  Widget build(BuildContext context) {
    ChatMessagesBloc _chatMessagesBloc = ChatMessagesBloc(widget.chatId);
    return BlocProvider<ChatMessagesBloc>(
      builder: (BuildContext context) => _chatMessagesBloc,
      child: BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
          builder: (BuildContext context, ChatMessagesState state) {
        if (state is InitialChatMessagesState) {
          _chatMessagesBloc.dispatch(FetchMessagesEvent());
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("chatmessages"),
          ),
          body: ChatMessagesListScreen(),
        );
      }),
    );
  }
}

class ChatMessagesListScreen extends StatefulWidget {
  @override
  _ChatMessagesListScreenState createState() => _ChatMessagesListScreenState();
}

class _ChatMessagesListScreenState extends State<ChatMessagesListScreen> {
  final ScrollController listScrollController = ScrollController();
  List<ChatMessage> messages = List();

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('Fetch more chats?!?!?');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
        builder: (BuildContext context, ChatMessagesState state) {
      if (state is InitialChatMessagesState) {
        return LoadingScreen(loadingText: "Loading chat messages");
      }
      if (state is ChatMessagesFetched) {
        print('Got initial messages');
        messages = state.messages;
      }
      print(messages.length);
      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          ChatMessage message = messages[index];
          if (message is ChatTextMessage) {
            return Text(message.text + " from: " + message.from.name);
          }
          return Text("hej");
        },
        itemCount: messages.length,
        reverse: true,
        controller: listScrollController,
      );
    });
  }
}
