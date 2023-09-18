import 'package:flutter/material.dart';
import 'package:mynews/model/chat_user.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key, required this.chatUser});
  final ChatUser chatUser;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    print('CHATUSER: ${widget.chatUser}');
    print('CHATUSER-ID: ${widget.chatUser.id}');
    print('CHATUSER-NAME: ${widget.chatUser.name}');

    return ZegoUIKitPrebuiltCall(
        appID:
            2064421428, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            '493d3339790713269b955571ab6e4209d15fbdd7f53bb1b74e5e18b7ae4ffe58', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: widget.chatUser.id,
        userName: widget.chatUser.name,
        callID: 'CALLED',
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}
