import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/chatmessages/bloc/bloc.dart';
import 'package:lingon/chatmessages/chat_message.dart';
import 'package:lingon/currentuser/bloc/bloc.dart';
import 'package:lingon/loading/screens/loading_screen.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages({this.chatId, Key key}) : super(key: key);
  final String chatId;

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  // List<ChatMessages> _messages;
  final TextEditingController textEditingController = TextEditingController();
  ChatMessagesBloc chatMessagesBloc;
  FocusNode myFocusNode;

  @override
  void initState() {
    chatMessagesBloc = BlocProvider.of<ChatMessagesBloc>(context);
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
        builder: (BuildContext context, ChatMessagesState state) {
      return Scaffold(
        appBar: AppBar(
          title: Text("chatmessages"),
        ),
        body: SafeArea(
          bottom: true,
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: ChatMessagesListScreen(widget.chatId)),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    focusNode: myFocusNode,
                    onSubmitted: (_) {
                      sendMessage(context);
                      FocusScope.of(context).requestFocus(myFocusNode);
                    },
                    controller: textEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 16.0, color: Colors.pink.shade50),
                            borderRadius: BorderRadius.circular(4)),
                        hintText: 'Type a message...'),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  void sendMessage(context) {
    if (textEditingController.text.isEmpty) {
      return;
    }
    ;
    chatMessagesBloc
        .add(SendTextMessageEvent(textEditingController.text, widget.chatId));
    textEditingController.clear();
  }
}

class ChatMessagesListScreen extends StatefulWidget {
  ChatMessagesListScreen(this.chatId);

  final String chatId;

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
        BlocProvider.of<ChatMessagesBloc>(context).add(
            FetchPreviousMessagesEvent(
                chatId: widget.chatId, latestMessageId: messages.last.id));
        print('Fetch more chats?!?!?');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
        builder: (BuildContext context, ChatMessagesState state) {
      if (state is FetchingChatMessage) {
        return LoadingScreen(loadingText: "Loading more messages");
      }
      if (state is InitialChatMessagesState ||
          state.messages[widget.chatId] == null) {
        BlocProvider.of<ChatMessagesBloc>(context)
            .add(FetchMessagesEvent(widget.chatId));
        return LoadingScreen(loadingText: "Loading chat messages");
      }
      if (state is ChatMessagesFetched) {
        if (state.messages[widget.chatId]?.isNotEmpty ?? false) {
          messages = state.messages[widget.chatId];
        }
      }
      if (state is ChatMessagesEnd) {
        if (state.messages[widget.chatId]?.isNotEmpty ?? false) {
          messages = state.messages[widget.chatId];
        }
      }

      if (state is FetchingPreviousChatMessage) {
        // return Text("Loading more");
      }
      CurrentUserBloc _currentUserBloc =
          BlocProvider.of<CurrentUserBloc>(context);
      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          ChatMessage message = messages[index];
          if (message is ChatTextMessage) {
            bool isYourMessage =
                _currentUserBloc.state.userData.id == message.from.id;
            return Row(
              mainAxisAlignment: isYourMessage
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: isYourMessage
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withAlpha(20),
                  ),
                  child: Text(message.text),
                ),
              ],
            );
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
