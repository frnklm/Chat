import 'package:chat/models/authentication_data.dart';
import 'package:chat/widgets/authentication_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthentictionScreen extends StatefulWidget {
  const AuthentictionScreen({Key? key}) : super(key: key);

  @override
  _AuthentictionScreenState createState() => _AuthentictionScreenState();
}

class _AuthentictionScreenState extends State<AuthentictionScreen> {
  //Instancia em _auth uma instancia de autenticação do firebase para comunicação com o firestore
  final _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool _isLoading = false;

  //Function criada para receber os dados da função onSubmit do componente AuthenticationForm
  //Future sync/await por ter que esperar o usuário fornecer os dados para depois gerar autenticação
  Future<void> _getSubmit(AuthenticationData authenticationData) async {
    //trocar o valor do método isLoading
    setState(() {
      _isLoading = true;
    });

    // recebe a credential do usuário logado ou cadastrado no sistema
    UserCredential userCredential;

    try {
      //Dados recebidos pelo authenticationData são passados ao firestore através da função signInWithEmailAndPassword para logar na aplicação
      // userCredential vai guardar a chave de autenticação do usuário logado ou cadastrado para persistir no na map userData e cadastrar no firestore
      if (authenticationData.isSingIn()) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: authenticationData.email.toString().trim(),
          password: authenticationData.password.toString(),
        );
        //Caso contrário será feito o cadastro
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: authenticationData.email.toString().trim(),
          password: authenticationData.password.toString(),
        );

        //Método cria uma referencia(bucket) dentro do storage do firebase em uma pasta user_images e nomeia o arquivo com o id do usuário concatenado com .jpg
        final refFirebaseStorage = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(userCredential.user!.uid + '.jpg');

        //Recebe os parametros de refFirebaseStorage e faz o upload para o bucket
        await refFirebaseStorage.putFile(authenticationData.image!);
        //recebe a url de download da imagem enviada ao bucket
        final url = await refFirebaseStorage.getDownloadURL();

        //Map para receber o nome e email do usuário cadastrado e persistir no firestore
        final userData = {
          'name': authenticationData.name,
          'email': authenticationData.email,
          'imageUrl': url,
        };

        // função que irá criar no firestore uma coleção e persistir o nome e email do usuário cadastrado
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);
      }
      //Exceção criada é recebida do firebase utulizando o PlatformException
    } catch (e) {
      final msg = e;

      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(msg.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      // trocar o valor do método isLoading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tela de Login'),
          centerTitle: true,
        ),
        // body: Center(
        //   child: SingleChildScrollView(
        //     child: AuthenticationForm(_getSubmit),
        //   ),
        // ),

        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    AuthenticationForm((_getSubmit)),
                    if (_isLoading)
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
