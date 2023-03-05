import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevshopfirebase/app/constant/color.dart';
import 'package:elevshopfirebase/app/dynamic/addcontent.dart';
import 'package:elevshopfirebase/app/dynamic/contentView.dart';
import 'package:elevshopfirebase/app/modules/edit/views/edit_view.dart';
import 'package:elevshopfirebase/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late User? _user;
  late StreamSubscription<User?> _userSubscription;

  showAlertDialog(BuildContext context, String id) {
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () async {
        await FirebaseFirestore.instance.collection('content').doc(id).delete();
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Hapus content"),
      content: Text("Apakah anda yakin ingin menghapus content ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimary,
        title: const Text('HomeView'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.left,
        icon: Icons.menu,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddContent()));
              }),
          SpeedDialChild(child: Icon(Icons.list)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20),
        child: Container(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('content').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var listAllDocs = snapshot.data!.docs;

                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('content')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        var listAllDocs = snapshot.data!.docs;

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            mainAxisExtent: 200,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditView(
                                              id: snapshot.data!.docs[index].id,
                                              data: snapshot.data!.docs[index],
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: appPrimary,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        snapshot.data!.docs[index]['title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.docs[index]
                                            ['description'],
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                        child: Image.network(
                                          snapshot.data!.docs[index]
                                              ['imageUrl'],
                                          height: 80,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${snapshot.data!.docs[index]['price']}'),
                                          InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                  context,
                                                  snapshot
                                                      .data!.docs[index].id);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription.cancel();
  }
}
