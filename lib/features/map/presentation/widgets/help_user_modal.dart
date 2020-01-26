import 'package:flutter/material.dart';
import 'package:lingon/chat/chat_repository.dart';
import 'package:lingon/users/HelpableUser.dart';

class HelpUserModal extends StatelessWidget {
  HelpUserModal(this.userToHelp, this.currentUserId);
  final HelpableUser userToHelp;
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    var userToHelp = this.userToHelp;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          userToHelp.name,
          textScaleFactor: 3,
          textAlign: TextAlign.left,
        ),
        Row(
          children: <Widget>[
            Text(userToHelp.distanceMeters.round().toString()),
            Text(' meters from you')
          ],
        ),
        Text('Needs help with:'),
        Row(
          children: <Widget>[Icon(Icons.all_inclusive), Text('Pads')],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.all_inclusive),
            Text('Tampons')
          ],
        ),
        MaterialButton(
          color: Colors.amber,
          child: Text('Help now!'),
          onPressed: () {
            print('Start chat with $userToHelp');
            ChatRepository().startChat([userToHelp.userId], currentUserId);
          },
        )
      ],
    );
  }
}
