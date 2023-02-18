import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    print("kullnıcı: $_firebaseAuth.currentUser");
  }


  Future<String?> signIn({required String email, required String password}) async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
    } on FirebaseAuthException catch  (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }

  Future<String?> signUp({required String email, required String password}) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print("kullnıcı: $_firebaseAuth.currentUser");
      return "Kayıt Oldunuz";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }




}