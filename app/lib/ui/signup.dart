import 'package:app/model/resourceUri.dart';
import 'package:app/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/logo.dart';
import 'allNotes.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController securityQuestionController = TextEditingController();
  TextEditingController securityQuestionAnswerController =
      TextEditingController();

  Future<void> onSignUpPressed(Function callback) async {
    String username = usernameController.text;
    String password = passwordController.text;
    String securityQuestion = securityQuestionController.text;
    String securityQuestionAnswer = securityQuestionAnswerController.text;

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

    if (securityQuestion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Security Question needs to be set'),
        ),
      );
      return;
    }

    if (securityQuestionAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Security Question needs to be answered'),
        ),
      );
      return;
    }

    final response = await http.post(ResourceUri.getAppendedUri('user'), body: {
      "username": username,
      "password": password,
      "securityQuestion": securityQuestion,
      "securityQuestionAnswer": securityQuestionAnswer
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      callback();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to Sign Up. Response code = ${response.statusCode}\n');
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
        onPressed: () => onSignUpPressed(() => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AllNotes()),
              )
            }),
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: const Text("SIGN UP"),
      ),
    );
  }

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
                    margin: const EdgeInsets.all(50),
                    child: const Text("Flutter Notes")),
                InputField(
                    prefixIcon: const Icon(Icons.person_outline,
                        size: 30, color: Color(0xffA6B0BD)),
                    hintText: "Username",
                    isPassword: false,
                    controller: usernameController),
                InputField(
                    prefixIcon: const Icon(Icons.lock_outline,
                        size: 30, color: Color(0xffA6B0BD)),
                    hintText: "Password",
                    isPassword: true,
                    controller: passwordController),
                InputField(
                    prefixIcon: const Icon(Icons.article_outlined,
                        size: 30, color: Color(0xffA6B0BD)),
                    hintText: "Security Question",
                    isPassword: false,
                    controller: securityQuestionController),
                InputField(
                    prefixIcon: const Icon(Icons.question_answer_outlined,
                        size: 30, color: Color(0xffA6B0BD)),
                    hintText: "Security Question Answer",
                    isPassword: false,
                    controller: securityQuestionAnswerController),
                _singupBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
