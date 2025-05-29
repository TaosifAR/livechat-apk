
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livechat/models/chat_user.dart';
class ChatUserWidgets extends StatefulWidget {
  final ChatUser user;
  const ChatUserWidgets({super.key,required this.user});

  @override
  State<ChatUserWidgets> createState() => _ChatUserWidgetsState();
}

class _ChatUserWidgetsState extends State<ChatUserWidgets> {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
     
      child: InkWell(
        onTap: (){},
        child: ListTile(
          leading: CircleAvatar(

            //child: Icon(CupertinoIcons.person),
            child: widget.user.image.isEmpty ? Icon(CupertinoIcons.person) :
            ClipOval(child: CachedNetworkImage(imageUrl: widget.user.image,fit: BoxFit.cover,width: 50,height: 50,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),

            ),
          ),
          title: Text(widget.user.name,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(widget.user.about,maxLines: 1,),
          trailing: Text(widget.user.lastActive,style: TextStyle(color: Colors.black54),),
          



        ),
      ),
      color: Color(0xFFFFFFFF),

    );
  }
}
