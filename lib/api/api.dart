import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livechat/models/chat_user.dart';

class APIs {

  static late ChatUser me;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  //checking user exist or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //storing selfdata
 static Future<void> getUserinfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async{
      if(user.exists)
        {
          me = ChatUser.fromJson(user.data()!);

        }
      else
        {
         await createUser().then((user){
           getUserinfo();
         });
        }


    }




    );

 }


  //creating user if user not exist
  static Future<void> createUser () async {
    final time = DateTime(DateTime.now().millisecondsSinceEpoch);
    
    final chatUser = ChatUser(
      image: user.photoURL!,
      name: user.displayName.toString(),
      about: 'Hey I am using Livechat!',
      createdAt: '',
      isOnline: false,
      id: user.uid,
      lastActive: time.toString(),
      pushToken: '',
      email: user.email!.toString(),
    );
    return (await firestore
            .collection('users')
            .doc(user.uid)
            .set(chatUser.toJson()));

  }
// for getting users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusers(){
   return firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }

  //Update user data.
  static Future<void> updateUserdata() async {
    await firestore.collection('users').doc(user.uid).update({
      'name' : me.name,
      'about' : me.about,
    });
  }

}
