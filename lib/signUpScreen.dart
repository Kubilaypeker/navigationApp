import 'package:dpunavigation/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticationService.dart';
import 'main.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({Key? key}) : super(key: key);

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                validator: (value) {
                  if(value == null || value.isEmpty || !value.contains('@dpu.edu') || !value.contains('.')){
                    return 'Geçersiz E-mail';
                  }
                  return null;
                },
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                controller: email,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: InputBorder.none,
                    hintText: "\tÖğrenci E-maili",
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
                controller: password,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: InputBorder.none,
                    hintText: "\tŞifre",
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
                FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text).then((value) {print("Hesabınız Oluşturuldu!");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthenticationWrapper()));
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}"
                  );
                }
                );
              },
              child: const Text("KAYIT OL",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          Container(
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const loginPage()));
              },
              child: const Text("Hesabınız var ise giriş yapın.",
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
