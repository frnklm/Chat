import 'package:chat/models/authentication_data.dart';
import 'package:flutter/material.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({Key? key}) : super(key: key);

  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final AuthenticationData _authMode = AuthenticationData();
  //Necessário para atribuir uma key aos formulários
  final GlobalKey<FormState> _formKey = GlobalKey();

  //Submete as informções recebidas no formulário de login
  void _submitForm() {
    //Verifica se o formulário referente a key é válido
    bool isValid = _formKey.currentState!.validate();
    //fecha o teclado após a conclusão da tela
    FocusScope.of(context).unfocus();

    if (isValid) {
      print(_authMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                if (_authMode.isSingUp())
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                    key: const ValueKey('name'),
                    initialValue: _authMode.name,
                    //Sempre que o usuário insere um valor ele é recebido pelo value e guardado no _authMode.name
                    onChanged: (value) => _authMode.name = value,
                    //validator recebe um valor inserido, checa se é igual a null e o valor possui ao menos 3 letras sem contar espaços
                    //caso satisfaça o valor eh validado se não retorna mensagem de erro
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return 'Nome Inválido';
                      } else {
                        return null;
                      }
                    },
                  ),
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    key: const ValueKey('email'),
                    //Sempre que o usuário insere um valor ele é recebido pelo value e guardado no _authMode.email
                    onChanged: (value) => _authMode.email = value,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Inserira um Email válido';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    //deixa o texto da senha censurado
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                    ),
                    key: const ValueKey('password'),
                    //Sempre que o usuário insere um valor ele é recebido pelo value e guardado no _authMode.password
                    onChanged: (value) => _authMode.password = value,
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return 'Informe uma senha com mais de 6 caracteres';
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  //alterna o modo de login baseado no getter isSingIn
                  child: Text(_authMode.isSingIn() ? 'ENTRAR' : 'CADASTRAR'),
                  //chama a função _submitForm
                  onPressed: _submitForm,
                ),
                TextButton(
                  onPressed: () {
                    //Após o usuário clicar em cadastrar o método toggleMode troca o tipo de formulário da tela de login
                    setState(() {
                      _authMode.toggleMode();
                    });
                  },
                  child: Text(
                      _authMode.isSingIn() ? 'Criar nova conta' : 'Retornar'),
                ),
              ],
            )),
      ),
    );
  }
}
