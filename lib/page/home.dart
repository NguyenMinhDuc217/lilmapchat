// import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynews/api/apis.dart';
import 'package:mynews/helper/dialog.dart';
import 'package:mynews/main.dart';
import 'package:mynews/model/chat_user.dart';
import 'package:mynews/page/profire.dart';
import 'package:mynews/widgets/chat_user_card.dart';
// import 'package:mynews/widgets/chat_user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //For all users
  List<ChatUser> list = [];
  //For searched items
  final List<ChatUser> _searchList = [];
  //For search status
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIS.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIS.auth.currentUser != null) {
        if (message.toString().contains('resumed')) {
          APIS.updateActiveStatus(true);
        }
        if (message.toString().contains('paused')) {
          APIS.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Ẩn bàn phím tìm phát hiện 1 cú chạm
      onTap: () => FocusScope.of(context).unfocus(),
      //Nếu đang search thì từ searchList cử chỉ vuốt (back) sẽ quay trở lại List
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name, email, ...'),
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, letterSpacing: 0.5),
                    //When search text changes then updated search list
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                      }
                      setState(() {
                        _searchList;
                      });
                    },
                  )
                : const Text('We Chat'),
            actions: [
              //Search user
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),

              //Profire
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfirePage(
                                  user: APIS.me,
                                )));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),

          //Add user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () async {
                _addChatUserDialog();
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),

          body: StreamBuilder(
              stream: APIS.getMyUsersId(),
              builder: (context, snapshot) {
                if (snapshot.data?.docs.isEmpty ?? false) {
                  return const Center(
                    child: Text(
                      // 'No chat (You need to add the user of the person who wants to chat by email!)',
                      'No chat!!!',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
                switch (snapshot.connectionState) {
                  // If data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  // return const Center(child: CircularProgressIndicator());

                  // If some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    print('OOOO: ${snapshot.data?.docs}');
                    print('OOO1: ${APIS.getMyUsersId()}');
                    print(
                        'OOO2: ${snapshot.data?.docs.map((e) => e.id).toList() ?? []}');
                    print(
                        'OOO3: ${APIS.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? [])}');
                    return StreamBuilder(
                      stream: APIS.getAllUsers(
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          // If data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          // If some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            list = data
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ??
                                [];
                            if (list.isNotEmpty) {
                              return ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : list[index]);
                                },
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'No connection founds',
                                  style: TextStyle(fontSize: 5),
                                ),
                              );
                            }
                        }
                      },
                    );
                }
              }),
        ),
      ),
    );
  }

  //For adding new user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.person_add, color: Colors.blue, size: 28),
            Text('     Add User')
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
              hintText: 'Email Id',
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.blue,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'cancel',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.pop(context);
              if (email.isNotEmpty) {
                await APIS.addChatUser(email).then((value) {
                  if (!value) {
                    Dialogs.showSnackbar(context, "User does not Exists!");
                  } else {
                    Dialogs.showSnackbar(context, "Add successfully!");
                  }
                });
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
