import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //StreamBuilder retorna streams amrazenadas no firebase
      //stream: recebe uma instancia FirebaseFirestone da collecion chat
      //snapshot recebe o contéudo da instância
      //builder recebe o ctx e o snapshot com os dados recebidos na stream retornando no ListView
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          //caso esteja aguardando mostra o CircularProgressIndicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final document = snapshot.data!.docs;

          return ListView.builder(
            //ListView.builder quando não se sabe quantos elementos terão na lista
            //Builder recebe um ctx e índice de elementos que serão mostrados em um Container
            itemCount: document.length,
            itemBuilder: (ctx, i) => Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                document[i]['text'],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
