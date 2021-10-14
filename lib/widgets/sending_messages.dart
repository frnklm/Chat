import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendingMessages extends StatefulWidget {
  const SendingMessages({Key? key}) : super(key: key);

  @override
  _SendingMessagesState createState() => _SendingMessagesState();
}

class _SendingMessagesState extends State<SendingMessages> {
  String _typingMessage = '';
  final _controller = TextEditingController();

  //Método recebe a mensagem digitada, coloca no map com a tag 'text' setada no banco e envia a mensagem
  //createdAt adiciona valor data/hora nas mensagens criadas
  Future<void> _submittingMessage() async {
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    final userData =
        FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _typingMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData['name'],
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Enviar Messagem...'),
            onChanged: (value) {
              setState(() {
                _typingMessage = value;
              });
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _typingMessage.trim().isEmpty ? null : _submittingMessage,
        ),
      ],
    ));
  }
}
