import 'package:chat/widgets/messages.dart';
import 'package:chat/widgets/sending_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: <Widget>[
          //Remove a linha em baixo do botão de 3 pontos
          DropdownButtonHideUnderline(
            //Botão de 3 pontos
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'singout',
                  child: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Sair'),
                    ],
                  ),
                ),
              ],
              onChanged: (item) {
                if (item == 'singout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: const <Widget>[
          Expanded(child: Messages()),
          SendingMessages(),
        ],
      ),
    );
  }
}
