import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynews/api/apis.dart';
import 'package:mynews/helper/my_date_util.dart';
import 'package:mynews/main.dart';
import 'package:mynews/model/chat_user.dart';
import 'package:mynews/model/message.dart';
import 'package:mynews/page/chat.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //Last message info (if null -> no message)
  Message? message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatPage(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
          stream: APIS.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              message = list[0];
            }
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: CachedNetworkImage(
                  width: mq.height * .055,
                  height: mq.height * .055,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                  message != null
                      ? message!.type == Type.image
                          ? 'image'
                          : message!.msg
                      : widget.user.about,
                  maxLines: 1),
              trailing: message == null
                  ? null
                  : message!.read.isEmpty && message!.fromId != APIS.user.uid
                      ?
                      //Show unread message
                      Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      //message sent time
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: message!.sent),
                          style: const TextStyle(color: Colors.black54),
                        ),
            );
          },
        ),
      ),
    );
  }
}
