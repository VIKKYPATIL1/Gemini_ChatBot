import 'package:flutter/material.dart';

class FormAction extends StatefulWidget {
  const FormAction(
      {super.key, required this.signAction, required this.actionName});
  final void Function({required String mail, required String pass}) signAction;
  final String actionName;

  @override
  State<FormAction> createState() => _FormActionState();
}

class _FormActionState extends State<FormAction> {
  final _emailCtr = TextEditingController();
  final _passctr = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailCtr.dispose();
    _passctr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 400,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: Color.fromRGBO(204, 208, 207, 1)),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailCtr,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: Color.fromRGBO(204, 208, 207, 1)),
                    label: const Text("User Email"),
                    labelStyle: const TextStyle(
                        color: Color.fromRGBO(204, 208, 207, 1)),
                    hintText: "abc@gmail.com",
                    hintStyle: const TextStyle(
                        color: Color.fromRGBO(204, 208, 207, 1)),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        gapPadding: BorderSide.strokeAlignOutside),
                    filled: false,
                    alignLabelWithHint: false,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: Color.fromRGBO(204, 208, 207, 1)),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: _passctr,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password,
                        color: Color.fromRGBO(204, 208, 207, 1)),
                    label: const Text("Password"),
                    labelStyle: const TextStyle(
                        color: Color.fromRGBO(204, 208, 207, 1)),
                    hintText: "abcABC123@",
                    hintStyle: const TextStyle(
                        color: Color.fromRGBO(204, 208, 207, 1)),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        gapPadding: BorderSide.strokeAlignOutside),
                    filled: false,
                    alignLabelWithHint: false,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  widget.signAction(mail: _emailCtr.text, pass: _passctr.text);
                },
                child: Text(
                  "${widget.actionName}",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
