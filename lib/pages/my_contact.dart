// import 'dart:html';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../model/contact_model.dart';
import '../providers/contact_notifier_provider.dart';

import '../services/contact_services.dart';
import '../services/database_helper.dart';
import '../services/mail_services.dart';
import '../widgets/button.dart';
import '../widgets/confirmation_pop_up.dart';
import '../widgets/fab_widget.dart';
import '../widgets/list_tile_contact.dart';
import '../widgets/text_style.dart';
import 'edit_contact.dart';
import 'add_contact.dart';
import 'profile_contact.dart';

class MyContact extends ConsumerStatefulWidget {
  const MyContact({Key? key}) : super(key: key);

  @override
  ConsumerState<MyContact> createState() => _MyContactState();
}

class _MyContactState extends ConsumerState<MyContact> {
  final buttonWidget = ButtonWidget();
  String searchedValue = '';
  late List<ContactModel> allContactDB = [];
  final contactService = ContactService();
  bool permissionGranted = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initialRequest();
  }

  _initialRequest() async {
    prefs = await SharedPreferences.getInstance();
    await _requestContactsPermission();
  }

  Future<void> _requestContactsPermission() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      await prefs.setBool('permission_denied', true);
    } else {
      await prefs.setBool('permission_denied', false);
    }

    await _getPermission();
  }

  _getPermission() async {
    final bool? isPermissionDenied = prefs.getBool('permission_denied');

    if (isPermissionDenied == true) {
      permissionGranted = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationPopUp(
            titleAlert: 'You have denied permission',
            contentAlert: 'Please manually allow CONTACT permission',
            onConfirm: () async {
              openAppSettings();
            },
          );
        },
      );
    } else {
      permissionGranted = true;
    }

    _initData();
  }

  Future<void> _initData() async {
    try {
      List<ContactModel> allContact = await DatabaseHelper.getAllContact() ?? [];

      allContact = await contactService.getAllContactService(permissionGranted);

      ref.read(contactProvider.notifier).setContactsProvider(allContact);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    allContactDB = ref.watch(contactProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Contacts'),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationPopUp(
                    titleAlert: 'This will reset all contacts',
                    contentAlert: 'Continue?',
                    onConfirm: () async {
                      try {
                        await DatabaseHelper.clearAllContacts();
                        final allContact = await contactService.getAllContactService(permissionGranted);
                        ref.read(contactProvider.notifier).setContactsProvider(allContact);
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationPopUp(
                    titleAlert: 'This will sync to contacts',
                    contentAlert: 'Continue?',
                    onConfirm: () async {
                      _requestContactsPermission();
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.contact_page_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: mainScreenPadding,
        child: SafeArea(
            child: DefaultTabController(
                length: 2,
                child: Column(children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      hintText: 'Search Contact',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchedValue = value;
                      });
                    },
                  ),
                  gapBetweenDifferentField,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ButtonsTabBar(
                        backgroundColor: mainColor,
                        unselectedBackgroundColor: Colors.grey[400],
                        unselectedLabelStyle: const TextStyle(color: Colors.black),
                        labelStyle: labelTextStyle(color: whiteColor, bold: true, size: 15, spacing: 1),
                        tabs: const [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('All', style: TextStyle(color: whiteColor)),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Favorite', style: TextStyle(color: whiteColor)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                      child: TabBarView(children: <Widget>[
                    if (allContactDB.isNotEmpty) ...[
                      ListView.builder(
                        itemCount: allContactDB.length,
                        itemBuilder: (context, index) {
                          ContactModel contact = allContactDB[index];
                          String avatar = contact.avatar ?? '';
                          String firstName = contact.firstName ?? '';
                          String lastName = contact.lastName ?? '';
                          String email = contact.email ?? '';
                          String fullName = '$firstName $lastName';
                          int favorited = contact.favorited ?? 0;
                          if (searchedValue.isNotEmpty && !fullName.toLowerCase().contains(searchedValue.toLowerCase())) {
                            return Container();
                          }

                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    ContactModel editedContact = ContactModel(
                                      id: contact.id,
                                      email: contact.email,
                                      firstName: contact.firstName,
                                      lastName: contact.lastName,
                                      avatar: contact.avatar,
                                      favorited: favorited == 1 ? 0 : 1,
                                    );

                                    await DatabaseHelper.updateContact(editedContact);

                                    ref.read(contactProvider.notifier).updateContactProvider(editedContact);
                                  },
                                  foregroundColor: Colors.amber,
                                  icon: favorited == 1 ? Icons.star : Icons.star_border_outlined,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(contact)));
                                  },
                                  foregroundColor: Colors.blue,
                                  icon: Icons.edit,
                                ),
                                SlidableAction(
                                  onPressed: (context) async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConfirmationPopUp(
                                          contentAlert: 'Are you sure you want to delete this contact?',
                                          onConfirm: () async {
                                            await DatabaseHelper.deleteContact(contact);
                                            ref.read(contactProvider.notifier).removeContactsProvider(contact.id);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  foregroundColor: Colors.red,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: ListTileContactWidget(
                              title: fullName,
                              subtitle: email,
                              extraIntParam: favorited,
                              imageUrl: avatar,
                              onTapCallback: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(contact)));
                              },
                              onPressedCallback: () {
                                sendEmail(email);
                              },
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ],
                    if (allContactDB.isNotEmpty) ...[
                      ListView.builder(
                        itemCount: allContactDB.length,
                        itemBuilder: (context, index) {
                          ContactModel contact = allContactDB[index];
                          int favorited = contact.favorited ?? 0;

                          if (favorited == 1) {
                            String avatar = contact.avatar ?? '';
                            String firstName = contact.firstName ?? '';
                            String lastName = contact.lastName ?? '';
                            String email = contact.email ?? '';
                            String fullName = '$firstName $lastName';

                            if (searchedValue.isNotEmpty && !fullName.toLowerCase().contains(searchedValue.toLowerCase())) {
                              return Container();
                            }

                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      ContactModel editedContact = ContactModel(
                                        id: contact.id,
                                        email: contact.email,
                                        firstName: contact.firstName,
                                        lastName: contact.lastName,
                                        avatar: contact.avatar,
                                        favorited: favorited == 1 ? 0 : 1,
                                      );

                                      await DatabaseHelper.updateContact(editedContact);

                                      ref.read(contactProvider.notifier).updateContactProvider(editedContact);
                                    },
                                    foregroundColor: Colors.amber,
                                    icon: favorited == 1 ? Icons.star : Icons.star_border_outlined,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(contact)));
                                    },
                                    foregroundColor: Colors.blue,
                                    icon: Icons.edit,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ConfirmationPopUp(
                                            contentAlert: 'Are you sure you want to delete this contact?',
                                            onConfirm: () async {
                                              await DatabaseHelper.deleteContact(contact);
                                              ref.read(contactProvider.notifier).removeContactsProvider(contact.id);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete,
                                  ),
                                ],
                              ),
                              child: ListTileContactWidget(
                                title: fullName,
                                subtitle: email,
                                extraIntParam: favorited,
                                imageUrl: avatar,
                                onTapCallback: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(contact)));
                                },
                                onPressedCallback: () {
                                  sendEmail(email);
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ] else ...[
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ]
                  ]))
                ]))),
      ),
      floatingActionButton: fabWidget(context, AddContact()),
    );
  }
}
