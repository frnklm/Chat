import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar(this.onImagePick, {Key? key}) : super(key: key);

  //Comunicação indireta, passa a função como parametro pro componente, quando a imagem for selecionada a função chama de volta
  final Function(File pickedImage) onImagePick;

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  File? _pickedImageFile;

  //Método para acessar a câmera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    //Escolhe o caminho de onde será pega a imagem(galeria, camera...)
    XFile? pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    //Testa se é vlálido
    if (pickedImage == null) {
      return;
    }
    //Altera o estado
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    //Recebe a iamgem selecionada como parametro para a função
    widget.onImagePick(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          //Se a imagem for válida insere dentro do CircleAvatar
          backgroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tirar foto'),
        ),
      ],
    );
  }
}
