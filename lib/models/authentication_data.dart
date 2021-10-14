//crair modos de login
import 'dart:io';

enum AuthMode {
  signIn,
  signUp,
}

class AuthenticationData {
  String? name;
  String? email;
  String? password;
  File? image;
  //o modo de login eh criado dentro da classe recebendo um modo padrão signIn
  AuthMode _mode = AuthMode.signIn;

  //Verificador de modo de login na tela de autenticação
  void toggleMode() {
    _mode = _mode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn;
  }

  //Getter para retornar o tipo de modo setado
  bool isSingIn() {
    return _mode == AuthMode.signIn;
  }

  //Getter para retornar o tipo de modo setado
  bool isSingUp() {
    return _mode == AuthMode.signUp;
  }
}
