import 'package:flutter/material.dart';

import 'logo.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sign Up",
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            color: const Color(0xFFfafafa),
            width: double.infinity,
            child: Column(
              children: [
                Logo(),
                Container(
      margin: const EdgeInsets.all(50), child: const Text("Flutter Notes")),
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
                _singupBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _singupBtn() {
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
      onPressed: () => {print('Sign in pressed.')},
      textColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: const Text("SIGN UP"),
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
