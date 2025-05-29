import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:livechat/api/api.dart';
import 'package:livechat/helper/navigator_helper.dart';
import 'package:livechat/models/chat_user.dart';
import 'package:livechat/screens/profile_screen.dart';
import 'package:livechat/widgets/chat_user_widgets.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}


class _HomeScreensState extends State<HomeScreens> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getUserinfo();

  }

  @override
  Widget build(BuildContext context) {
    List<ChatUser> list = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Chat'),
        leading: Icon(CupertinoIcons.home),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {
           pagereplacement(context,ProfileScreen(user: APIs.me));
          }, icon: Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add_comment_rounded, color: Colors.white),
          backgroundColor: Color(0xFF12B560),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: APIs.getAllusers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const CircularProgressIndicator();

              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
            }
            if (list.isNotEmpty) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),

                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    child: ChatUserWidgets(user: list[index]),
                  );
                },
              );
            } else {
              return Center(child: Text('Network error!'));
            }
          },
        ),
      ),
    );
  }
}
