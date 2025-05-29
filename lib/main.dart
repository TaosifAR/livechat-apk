import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:livechat/screens/home_screens.dart';
import 'package:livechat/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});



  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(



      debugShowCheckedModeBanner: false,
      title: 'Live Chat',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: mq.width * .040),
          backgroundColor:Color(0xFF12B560),
          iconTheme: IconThemeData(color: Colors.white),


        )
      ),
      home:Loginscreen(),
    );
  }
}
Future<void> _initialFirebase ()async{
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform

  );

}
