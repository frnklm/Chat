import 'package:chat/widgets/message_dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    //StreamBuilder retorna streams amrazenadas no firebase
    //stream: recebe uma instancia FirebaseFirestone da collecion chat
    //snapshot recebe o contéudo da instância
    //builder recebe o ctx e o snapshot com os dados recebidos na stream retornando no ListView
    //OrderBy vai pegar o createdAt feito na classe SendingMEssages para por um atriburo de data/hora nas mensagens e mostrar ordenada de forma descendente
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapShot) {
        if (chatSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final chatDocs = chatSnapShot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) => MessageDialogs(
            chatDocs[i]['text'],
            chatDocs[i]['userId'] == user!.uid,
            chatDocs[i]['userId'],
          ),
        );
      },
    );
  }
}
