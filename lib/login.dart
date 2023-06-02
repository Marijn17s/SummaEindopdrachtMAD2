// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'main.dart';
import 'services/authentication.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.setSignedIn}) : super(key: key);
  final void Function(bool signedIn) setSignedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  void _handleLogin(BuildContext context) async {

    if (_emailTextController.text.isEmpty){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Warning',
        desc: 'The email can\'t be empty!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
      return;
    }
    if (!_emailTextController.text.characters.contains('@')){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Warning',
        desc: 'The email must be valid!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
      return;
    }
    if (_passwordTextController.text.isEmpty){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Warning',
        desc: 'The password can\'t be empty!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
      return;
    }
    if (_passwordTextController.text.length < 6 && _passwordTextController.text.isNotEmpty){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Warning',
        desc: 'The password must be at least 6 characters long!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
      return;
    }
    if (await AuthenticationServices.login(_emailTextController.text, _passwordTextController.text)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Login',
        desc: 'Successfully logged in!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(true);},
      ).show();
    }
    else{
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'The email/password don\'t match!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
    }
  }

  void _handleRegister(BuildContext context) async {
    if (_emailTextController.text.isEmpty){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Warning',
        desc: 'The email can\'t be empty!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
      return;
    }
    if (!_emailTextController.text.characters.contains('@')){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Warning',
        desc: 'The email must be valid!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
      return;
    }
    if (_passwordTextController.text.isEmpty){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Warning',
        desc: 'The password can\'t be empty!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
      return;
    }
    if (_passwordTextController.text.length < 6 && _passwordTextController.text.isNotEmpty){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Warning',
        desc: 'The password must be at least 6 characters long!',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {widget.setSignedIn(false);},
      ).show();
      return;
    }

    if (!await AuthenticationServices.login(_emailTextController.text, _passwordTextController.text)){
      if (await AuthenticationServices.register(_emailTextController.text, _passwordTextController.text)) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Registration',
          desc: 'Successfully registered!',
          buttonsTextStyle: const TextStyle(color: Colors.black),
          showCloseIcon: false,
          btnOkOnPress: () async {
            if (await AuthenticationServices.login(_emailTextController.text, _passwordTextController.text)){
              widget.setSignedIn(true);
            }
            else{
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                headerAnimationLoop: false,
                animType: AnimType.bottomSlide,
                title: 'Error',
                desc: 'Something went wrong! Try logging in again.',
                buttonsTextStyle: const TextStyle(color: Colors.black),
                showCloseIcon: false,
                btnOkOnPress: () {widget.setSignedIn(false);},
              ).show();
            }
          },
        ).show();
      }
    }
    else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'Registration failed! There may already be an account with this email.',
        buttonsTextStyle: const TextStyle(color: Colors.black),
        showCloseIcon: false,
        btnOkOnPress: () {
          widget.setSignedIn(false);
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {

    final inputEmail = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: _emailTextController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter an email!';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );

    final inputPassword = Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _passwordTextController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter a password!';
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );

    final buttonLogin = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: ElevatedButton(
            child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            onPressed: (){
              _handleLogin(context);
            }
        ),
      ),
    );

    final buttonRegister = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: ElevatedButton(
            child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 18)),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            onPressed: (){
              _handleRegister(context);
            }
        ),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              inputEmail,
              inputPassword,
              buttonLogin,
              buttonRegister,
            ],
          ),
        ),
      ),
    );
  }
}