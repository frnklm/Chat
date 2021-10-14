import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageDialogs extends StatelessWidget {
  MessageDialogs(this.message, this.belongsToMe, this.userId, {Key? key})
      : super(key: key);

  String message;
  final bool? belongsToMe;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      //Se a mensagem pertercer a mim vai pra direita se não esquerda
      mainAxisAlignment:
          belongsToMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          //Se a mensagem pertencer a mim cor do tema se não cor diferente
          decoration: BoxDecoration(
            color: belongsToMe!
                ? Theme.of(context).colorScheme.primary
                : Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: belongsToMe!
                  ? const Radius.circular(12)
                  : const Radius.circular(0),
              bottomRight: belongsToMe!
                  ? const Radius.circular(0)
                  : const Radius.circular(12),
            ),
          ),
          width: 140,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: belongsToMe!
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              //Depois do update tem que por os generics pra dizer que ta acessando um doc snapshot
              FutureBuilder<DocumentSnapshot>(
                //Recebe uma collection de users do firestore, pega o id do usuário com o get()
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Carregando...');
                  }
                  //Snapshot recebe no data a collection de users e pega o nome dento da chave 'name' e retorna num texto acima da mensagem
                  return Text(
                    snapshot.data!['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  );
                },
              ),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                ),
                textAlign: belongsToMe! ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
