import 'package:app/ui/allNotes.dart';
import 'package:app/ui/signup.dart';
import 'package:flutter/material.dart';

import 'logo.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sign In",
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            color: const Color(0xFFfafafa),
            width: double.infinity,
            child: Column(
              children: [
                Logo(),
                _logoText(),
                _inputField(
                    const Icon(Icons.person_outline,
                        size: 30, color: Color(0xffA6B0BD)),
                    "Username",
                    false),
                _inputField(
                    const Icon(Icons.lock_outline,
                        size: 30, color: Color(0xffA6B0BD)),
                    "Password",
                    true),
                _signinBtn(context),
                const Text("Don't have an account?"),
                _signUp(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _signUp(BuildContext context) {
  return TextButton(
    onPressed: () => {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUp()),
      )
    },
    child: const Text("SIGN UP NOW"),
  );
}

Widget _signinBtn(BuildContext context) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 20, bottom: 50),
    decoration: const BoxDecoration(
        color: Color(0xff008FFF),
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Color(0x60008FFF),
            blurRadius: 10,
            offset: Offset(0, 5),
            spreadRadius: 0,
          ),
        ]),
    child: FlatButton(
      onPressed: () => {Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllNotes()),
      )},
      textColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: const Text("SIGN IN"),
    ),
  );
}

Widget _inputField(Icon prefixIcon, String hintText, bool isPassword) {
  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 25,
          offset: Offset(0, 5),
          spreadRadius: -25,
        ),
      ],
    ),
    margin: const EdgeInsets.only(bottom: 20),
    child: TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 25),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xffA6B0BD),
        ),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 75,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
  );
}

Widget _logoText() {
  return Container(
      margin: const EdgeInsets.all(50), child: const Text("Flutter Notes"));
}
