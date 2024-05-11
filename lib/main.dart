import 'package:firebase_core/firebase_core.dart';
// import 'package:gemini_ai_new/screens/sign_up_screen.dart';
import 'package:gemini_ai_new/screens/tab_bar.dart';
import 'package:gemini_ai_new/theme.dart';
// import 'package:gemini_ai_new/widgets/form_action.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemini_ai_new/provider/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ChatProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini AI',
      themeMode: ThemeMode.system,
      theme: designtheme,
      darkTheme: designtheme,
      // home: formAction(signAction: () {}),
      home: const SignUpInTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}
