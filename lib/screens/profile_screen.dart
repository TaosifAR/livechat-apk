import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:livechat/api/api.dart';
import 'package:livechat/helper/dialogs.dart';
import 'package:livechat/models/chat_user.dart';
import 'package:livechat/screens/auth/login_screen.dart';
import 'package:livechat/screens/home_screens.dart';
import 'package:livechat/widgets/chat_user_widgets.dart';

import '../helper/navigator_helper.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {

  final _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery
        .of(context)
        .size;
    final radius = mq.width*.2;

    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                pagereplacement(context, HomeScreens());
              },

              child: Icon(CupertinoIcons.back,color: Colors.white,)),
          title: Text('Profile'),

        ),


        body:
        Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
            
              children: [
                SizedBox(
                  height: 70,
                  width: mq.width,
                ),
            
                Center(
                  child: Stack(
                    children: [
                       CircleAvatar(
          
                        radius:radius,
          
          
                        //child: Icon(CupertinoIcons.person),
                        child: widget.user.image.isEmpty ? Icon(CupertinoIcons.person) :
                        ClipOval(child: CachedNetworkImage(imageUrl: widget.user.image,
                          fit: BoxFit.cover,
                          width: mq.width *.4,
                          height: mq.width *.4,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
          
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: radius *1.2,
                        child: MaterialButton(onPressed: (){},
                        
                        child: Icon(Icons.edit,color: Color(0xFF12B560) ,),
                          color: Colors.white,
                          shape: CircleBorder(),
          
                        )
                      )
                    ],
                   
                  ),
            
            
                ),
                SizedBox(
                  height: 20,
                  width: mq.width,
                ),
                Center(child: Text(widget.user.email,style: TextStyle(fontSize: mq.width*.040,fontWeight: FontWeight.bold),)),
            
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val)=> APIs.me.about = val ?? '',
                    validator: (val)=> val!= null && val.isNotEmpty ? null: 'Required field.' ,
            
                    decoration: InputDecoration(
                      // Normal border (when not focused)
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
          
                      ),
          
                      // Focused border (when you tap the field)
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF12B560), width: 2.5),
                      ),
          
                      // Optional: If error occurs
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      prefixIcon: Icon(CupertinoIcons.person,color: Color(0xFF12B560),),
                      label: Text('Name',style: TextStyle(color: Color(0xFF12B560)),),
                      hintText: 'eg: Alex Xender',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 40),
                  child: TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val)=> APIs.me.name = val ?? '',
                    validator: (val)=> val!= null && val.isNotEmpty ? null: 'Required field.' ,
            
                    decoration: InputDecoration(
                      // Normal border (when not focused)
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
          
                      ),
          
                      // Focused border (when you tap the field)
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF12B560), width: 2.5),
                      ),
          
                      // Optional: If error occurs
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      prefixIcon: Icon(CupertinoIcons.pen,color: Color(0xFF12B560)),
                      label: Text('About',style: TextStyle(color: Color(0xFF12B560)),),
                      hintText: 'eg: Feeling Happy!',
                    ),
                  ),
          
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                  child: ElevatedButton.icon(onPressed:() {

                    if(_formkey.currentState!.validate())
                      {
                        _formkey.currentState!.save();
                        APIs.updateUserdata();

                      }
          
          
                  } ,
                      style: ElevatedButton.styleFrom(
                       minimumSize: Size(mq.width*.5,mq.width*.130),
                        backgroundColor: Color(0xFF12B560)
                      ),
                      icon:Icon(Icons.system_update_tv_rounded,color: Colors.white,), label: Text('Update',style:TextStyle(color: Colors.white),)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                  child: ElevatedButton.icon(onPressed:() async{
          
                    Dialogs.showprogressbar(context);
          
                    await FirebaseAuth.instance.signOut().then((value) async{
                    await GoogleSignIn().signOut().then((value) async {
                    // for hiding progressbar.
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 100)); // wait a bit
          

          
                    pagereplacement(context, Loginscreen());
          
                    });
                    });
                    Dialogs.showsnackbar(context,'Logged out succesfully.');
          
          
          
          
                  } ,
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(mq.width*.5,mq.width*.130),
                          backgroundColor: Color(0xFF5BC9E8)
                      ),
                      icon:Icon(Icons.logout,color: Colors.white,), label: Text('Logout',style:TextStyle(color: Colors.white),)),
                )
            
            
              ],
            ),
          ),
        )

    );
  }


}
