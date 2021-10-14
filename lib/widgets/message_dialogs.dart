import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageDialogs extends StatelessWidget {
  MessageDialogs(this.message, this.belongsToMe, this.userName, this.userImage,
      {required this.key})
      : super(key: key);

  @override
  // ignore: overridden_fields
  final Key key;

  String message;
  final bool? belongsToMe;
  final String userName;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
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
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: belongsToMe!
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  //Mostra a mensagem digitada dentro do dialog usando o nome e o texto da mensagem
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
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
        ),
        Positioned(
          top: 0,
          left: belongsToMe! ? null : 128,
          right: belongsToMe! ? 128 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
