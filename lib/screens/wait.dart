// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Wait extends StatefulWidget {
  const Wait({super.key});

  @override
  State<Wait> createState() => _Wait();
}

class _Wait extends State<Wait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset('assets/loading.json',
              repeat: true,
              reverse: true,
              fit: BoxFit.cover,
              height: double.infinity),
          Card(
            clipBehavior: Clip.hardEdge,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(100), right: Radius.circular(100))),
            elevation: 10,
            child: Container(
              height: double.infinity,
              width: 125,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: Colors.accents)),
              child: const Center(
                child: Text(
                  " G\n E\n M\n  I\n N\n  I\n\n A\n  I\n",
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 0, 0), fontSize: 35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
