import 'package:flutter/material.dart';

import 'package:chat/models/authentication_data.dart';

class AuthenticationForm extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AuthenticationForm(
    this.onSubmit,
  );

  //Function criada para passar os dados recebidos pelo form para o AuthenticationScreen
  final void Function(AuthenticationData authenticationData) onSubmit;

  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final AuthenticationData _authenticationData = AuthenticationData();

  //Necessário para atribuir uma key aos formulários
  final GlobalKey<FormState> _formKey = GlobalKey();

  //Submete as informções recebidas no formulário de login
  void _submitForm() {
    //Verifica se o formulário referente a key é válido
    bool isValid = _formKey.currentState!.validate();
    //fecha o teclado após a conclusão da tela
    FocusScope.of(context).unfocus();

    if (isValid) {
      widget.onSubmit(_authenticationData);
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
                if (_authenticationData.isSingUp())
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                    key: const ValueKey('name'),
                    initialValue: _authenticationData.name,
                    //Sempre que o usuário insere um valor ele é recebido pelo value e guardado no _authenticationData.name
                    onChanged: (value) => _authenticationData.name = value,
                    //validator recebe um valor inserido, checa se é igual a null e o valor possui ao menos 3 letras sem contar espaços
                    //caso satisfaça o valor eh validado se não retorna mensagem de erro
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
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
                    //Sempre que o usuário insere um valor ele é recebido pelo value e guardado no _authenticationData.email
                    onChanged: (value) => _authenticationData.email = value,
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
                    //Sempre que o usuário insere um valor ele é recebido pelo value e guardado no _authenticationData.password
                    onChanged: (value) => _authenticationData.password = value,
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
                  child: Text(
                      _authenticationData.isSingIn() ? 'ENTRAR' : 'CADASTRAR'),
                  //chama a função _submitForm
                  onPressed: _submitForm,
                ),
                TextButton(
                  onPressed: () {
                    //Após o usuário clicar em cadastrar o método toggleMode troca o tipo de formulário da tela de login
                    setState(() {
                      _authenticationData.toggleMode();
                    });
                  },
                  child: Text(_authenticationData.isSingIn()
                      ? 'Criar nova conta'
                      : 'Retornar'),
                ),
              ],
            )),
      ),
    );
  }
}
