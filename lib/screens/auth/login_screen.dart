import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:livechat/api/api.dart';
import 'package:livechat/helper/dialogs.dart';
import 'package:livechat/helper/navigator_helper.dart';
import 'package:livechat/screens/home_screens.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}


class _LoginscreenState extends State<Loginscreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  _checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = APIs.auth.currentUser;

    if (user != null) {
      pagereplacement(context, HomeScreens());

    } else {
      setState(() => _isAnimate = true);
    }
  }

  _handleGoogleBtnClck() async {
    Dialogs.showprogressbar(context);

    final user = await _signInWithGoogle();
    Navigator.pop(context); // Close progress dialog

    if (user != null) {
      log('\nUser: ${user.user}');
      log('\nUserAdditional Info: ${user.additionalUserInfo}');
     if(await (APIs.userExist())){
       pagereplacement(context, HomeScreens());
       Dialogs.showsnackbar(context, 'Logged in successfully.');

     }
     else{
      await APIs.createUser().then((value){
        pagereplacement(context, HomeScreens());
       });
     }
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // Check internet
      await InternetAddress.lookup('google.com');

      // Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,

      );


      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('_signInWithGoogle : $e');
      Dialogs.showsnackbar(
        context,
        'Something went wrong! Please check your internet connection.',
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Logo animation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            height: mq.width * .4,
            width: mq.width * .4,
            left: mq.width * .5 - mq.width * .4 * .5,
            bottom: _isAnimate
                ? mq.height * .5 + mq.width * .4 * .5
                : mq.height * .5 - mq.width * .4,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: _isAnimate ? 1 : 0,
              child: Image.asset(
                'lib/images/chat.png',
                gaplessPlayback: true,
                cacheWidth: 300,
                cacheHeight: 300,
              ),
            ),
          ),

          // Welcome Text
          Positioned(
            left: mq.width * .5 - mq.width * .80 * .5,
            bottom: mq.height * .5 - mq.width * .13 * .8,
            child: SizedBox(
              height: mq.width * .09,
              width: mq.width * .80,
              child: Text(
                'Welcome to Live chat!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: mq.width * .070,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Google Sign-In Button
          Positioned(
            height: mq.width * .13,
            width: mq.width * .85,
            left: mq.width * .5 - mq.width * .85 * .5,
            bottom: mq.height * .5 - mq.width * .69,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF12B560),
              ),
              onPressed: _handleGoogleBtnClck,
              icon: Image.asset(
                'lib/images/google-symbol.png',
                height: mq.width * .09 * .8,
                width: mq.width * .09 * .8,
              ),
              label: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'Sign in with ',
                      style: TextStyle(fontSize: mq.width * .09 * .5),
                    ),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: mq.width * .09 * .5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
