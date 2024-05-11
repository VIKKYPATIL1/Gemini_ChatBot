// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_ai_new/screens/home_screen.dart';
import 'package:gemini_ai_new/widgets/form_action.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  void signUp({required String mail, required String pass}) async {
    try {
      // Toast Message to notify user to wait for some time...
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please wait, we are signing you...'),
        duration: Duration(seconds: 2),
      ));
      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pass);
      final currentUser = credential.user;

      if (currentUser != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enter Password is too Weak'),
          duration: Duration(seconds: 1),
        ));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('The Account Exist for this user'),
          duration: const Duration(seconds: 1),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred : $e'),
        duration: const Duration(seconds: 1),
      ));
      print("Error occurred : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboard_height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromRGBO(204, 208, 207, 1),
              fontStyle: FontStyle.italic,
              letterSpacing: 5,
              fontWeight: FontWeight.w700,
              fontSize: 25),
        )),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: keyboard_height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset('assets/signin.json')),
              Expanded(
                child: FormAction(
                  signAction: signUp,
                  actionName: "SignUp",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
