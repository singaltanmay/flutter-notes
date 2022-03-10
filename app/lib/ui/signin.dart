import 'package:app/model/resourceUri.dart';
import 'package:app/ui/allNotes.dart';
import 'package:app/ui/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'logo.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> onSignInPressed(Function callback) async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username cannot be blank'),
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password cannot be blank'),
        ),
      );
      return;
    }

    final response = await http.post(ResourceUri.getAppendedUri('signin'),
        body: {"username": username, "password": password});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      callback();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to Sign In. Response code = ${response.statusCode}\n');
    }
  }

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
                    false,
                    usernameController),
                _inputField(
                    const Icon(Icons.lock_outline,
                        size: 30, color: Color(0xffA6B0BD)),
                    "Password",
                    true,
                    passwordController),
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
        onPressed: () => {
          onSignInPressed(() => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AllNotes()),
                )
              })
        },
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: const Text("SIGN IN"),
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

Widget _inputField(Icon prefixIcon, String hintText, bool isPassword,
    TextEditingController controller) {
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
      controller: controller,
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
