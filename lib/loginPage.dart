import 'package:dpunavigation/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'authenticationService.dart';
import 'main.dart';


class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => loginPageState();
}

class loginPageState extends State<loginPage> {

   final TextEditingController userEmail = TextEditingController();
   final TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF282828),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            height: 200,
            child: Image.asset("assets/navigation.png"),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Center(
                  child: Text("DPÜ NAVİGASYON",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xff0E469B)
                  ),
                ),
              ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              child: TextFormField(
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
    controller: userEmail,
    decoration: const InputDecoration(
      contentPadding: EdgeInsets.only(left: 15),
      border: InputBorder.none,
      hintText: "Öğrenci E-maili",
      hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: TextFormField(
                obscureText: true,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                controller: userPassword,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15),
                    border: InputBorder.none,
                    hintText: "Şifre",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff0E469B))
            ),
              onPressed: () {
                context.read<AuthenticationService>().signIn(
                  email: userEmail.text,
                  password: userPassword.text,
                );
              },
              child: const Text("GİRİŞ YAP",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          Container(
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const signUpScreen()));
              },
              child: const Text("Hesabınız yok mu?",
                style: TextStyle(
              color: Color(0xff0E469B)
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}