// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_ai_new/screens/home_screen.dart';
import 'package:gemini_ai_new/widgets/form_action.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Future<void> signIn(_mail, _pass) async {
    try {
      // ignore: unused_local_variable
      // Toast Message to notify user to wait for some time...
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please wait, we are signing you...'),
        duration: Duration(seconds: 2),
      ));
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _mail, password: _pass);
      final currentUser = credential.user;

      if (currentUser != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something Wrong, Please try again'),
          duration: Duration(seconds: 2),
        ));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something Wrong, Please try again'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print("Above all are correct while creating account but error is : $e");
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
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(204, 208, 207, 1),
                fontStyle: FontStyle.italic,
                letterSpacing: 5,
                fontWeight: FontWeight.w700,
                fontSize: 25),
          ),
        ),
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
                  signAction: ({required mail, required pass}) =>
                      signIn(mail, pass),
                  actionName: "Sign In",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
