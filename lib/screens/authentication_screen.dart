import 'package:chat/widgets/authentication_form.dart';
import 'package:flutter/material.dart';

class AuthentictionScreen extends StatefulWidget {
  const AuthentictionScreen({Key? key}) : super(key: key);

  @override
  _AuthentictionScreenState createState() => _AuthentictionScreenState();
}

class _AuthentictionScreenState extends State<AuthentictionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela de Login'),
        centerTitle: true,
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: AuthenticationForm(),
        ),
      ),
    );
  }
}
