// import 'dart:html';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../model/contact_model.dart';
import '../providers/contact_notifier_provider.dart';

import '../providers/searched_value_provider.dart';
import '../services/contact_services.dart';
import '../services/database_helper.dart';
import '../services/mail_services.dart';
import '../widgets/button.dart';
import '../widgets/confirmation_pop_up.dart';
import '../widgets/fab_widget.dart';
import '../widgets/list_tile_contact.dart';
import '../widgets/loading_state.dart';
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
  final loadingDataState = LoadingDataState();
  late List<ContactModel> allContactDB = [];
  late String searchedValue = '';
  final contactService = ContactService();
  late SharedPreferences prefs;
  bool statusIsGranted = false;
  Orientation? previousOrientation;
  TextEditingController tempSearchedValue = TextEditingController();
  bool showAllContactList = true;

  @override
  void initState() {
    super.initState();
    _initialRequest();

    ref.read(searchedValueProvider.notifier).setSearchedValueProvider('');
  }

  @override
  void dispose() {
    tempSearchedValue.dispose();
    super.dispose();
  }

  _initialRequest() async {
    prefs = await SharedPreferences.getInstance();
    bool isFirstRunAfterInstall = await _checkFirstRunApp();
    await _requestContactsPermission(requestSync: false, isFromReset: false, isFirstRunAfterInstall: isFirstRunAfterInstall);
  }

  Future<bool> _checkFirstRunApp() async {
    bool firstRun = await IsFirstRun.isFirstRun();
    return firstRun;
  }

  Future<void> _requestContactsPermission({
    required bool requestSync,
    required bool isFromReset,
    required bool isFirstRunAfterInstall,
  }) async {
    var status = await Permission.contacts.status;

    if (status.isPermanentlyDenied && requestSync == true && isFromReset == false) {
      _manualPermission();
      return;
    }

    status = await Permission.contacts.request();

    statusIsGranted = status.isGranted;

    if (requestSync == false && isFromReset == false) {
      //regular sync contact
      _regularSync(statusIsGranted);
      return;
    }

    if (statusIsGranted) {
      if (isFromReset == true || isFirstRunAfterInstall == true) {
        //reset contact  with allow permission
        //first time install with allow permission
        _resetContact(statusIsGranted);
        return;
      }

      if (requestSync == true) {
        //request sync loacal contact
        _syncLocalContact();
      }
    } else if (status.isPermanentlyDenied || status.isDenied) {
      statusIsGranted = false;

      if (isFromReset == true) {
        //reset contact  with not allow permission
        _resetContact(statusIsGranted);
      }
    }
  }

  _regularSync(bool statusIsGranted) async {
    List<ContactModel> allContact = await DatabaseHelper.getAllContact() ?? [];

    if (allContact.isEmpty) {
      allContact = await contactService.getAllContactService(statusIsGranted);
    }

    ref.read(contactProvider.notifier).setContactsProvider(allContact);
  }

  _resetContact(bool statusIsGranted) async {
    List<ContactModel> allContact = await contactService.getAllContactService(statusIsGranted);
    ref.read(contactProvider.notifier).setContactsProvider(allContact);
  }

  _syncLocalContact() async {
    List<ContactModel> allContact = await contactService.getAllContactService(true);
    allContact = await DatabaseHelper.getAllContact() ?? [];
    ref.read(contactProvider.notifier).setContactsProvider(allContact);
  }

  _manualPermission() async {
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
  }

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    allContactDB = ref.watch(contactProvider);
    searchedValue = ref.watch(searchedValueProvider);

    Widget buildListViewBuilder() {
      return ListView.builder(
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
            return emptySizeBox;
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
            child: Column(
              children: [
                if (showAllContactList == true) ...[
                  ListTileContactWidget(
                    title: fullName,
                    subtitle: email,
                    extraIntParam: favorited,
                    imageUrl: avatar,
                    onTapCallback: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(contact)));
                    },
                    onPressedCallback: () {
                      if (email == '') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationPopUp(
                              titleAlert: 'This contact does not have email',
                              contentAlert: 'Please update to send email',
                              onConfirm: () async {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(contact)));
                              },
                            );
                          },
                        );
                      } else {
                        sendEmail(email);
                      }
                    },
                  ),
                ] else ...[
                  if (favorited == 1) ...[
                    ListTileContactWidget(
                      title: fullName,
                      subtitle: email,
                      extraIntParam: favorited,
                      imageUrl: avatar,
                      onTapCallback: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(contact)));
                      },
                      onPressedCallback: () {
                        if (email == '') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationPopUp(
                                titleAlert: 'This contact does not have email',
                                contentAlert: 'Please update to send email',
                                onConfirm: () async {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(contact)));
                                },
                              );
                            },
                          );
                        } else {
                          sendEmail(email);
                        }
                      },
                    ),
                  ] else ...[
                    emptySizeBox,
                  ]
                ]
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: currentOrientation == Orientation.portrait
          ? AppBar(
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
                              _requestContactsPermission(requestSync: true, isFromReset: true, isFirstRunAfterInstall: false);
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
                if (statusIsGranted == false) ...[
                  IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationPopUp(
                            titleAlert: 'This will sync to contacts',
                            contentAlert: 'Continue?',
                            onConfirm: () async {
                              _requestContactsPermission(requestSync: true, isFromReset: false, isFirstRunAfterInstall: false);
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.contact_page_outlined),
                  ),
                ],
              ],
            )
          : AppBar(
              backgroundColor: mainColor,
              title: TextFormField(
                controller: tempSearchedValue,
                decoration: const InputDecoration(
                  hintText: 'Search Contact',
                  hintStyle: TextStyle(color: whiteColor),
                  suffixIcon: Icon(
                    Icons.search,
                    color: whiteColor,
                  ),
                ),
                onChanged: (value) {
                  ref.read(searchedValueProvider.notifier).setSearchedValueProvider(value);
                },
              ),
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
                              _requestContactsPermission(requestSync: true, isFromReset: true, isFirstRunAfterInstall: false);
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
                if (statusIsGranted == false) ...[
                  IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationPopUp(
                            titleAlert: 'This will sync to contacts',
                            contentAlert: 'Continue?',
                            onConfirm: () async {
                              _requestContactsPermission(requestSync: true, isFromReset: false, isFirstRunAfterInstall: false);
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.contact_page_outlined),
                  ),
                ],
              ],
            ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (previousOrientation != orientation) {
          if (previousOrientation != orientation) {
            Future.delayed(const Duration(milliseconds: 100), () {
              ref.read(searchedValueProvider.notifier).setSearchedValueProvider(tempSearchedValue.text);
              previousOrientation = orientation;
            });
          }
          // Future.microtask(() {
          //   ref.read(searchedValueProvider.notifier).setSearchedValueProvider(tempSearchedValue.text);
          //   previousOrientation = orientation;
          // });
        }
        return Padding(
          padding: mainScreenPadding,
          child: SafeArea(
              child: DefaultTabController(
                  length: 2,
                  child: Column(children: <Widget>[
                    if (currentOrientation == Orientation.portrait) ...[
                      TextFormField(
                        controller: tempSearchedValue,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          hintText: 'Search Contact',
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          tempSearchedValue.text = value;
                          ref.read(searchedValueProvider.notifier).setSearchedValueProvider(value);
                        },
                      ),
                      gapBetweenDifferentField,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ButtonsTabBar(
                            onTap: (value) {
                              if (value == 0) {
                                showAllContactList = true;
                              } else if (value == 1) {
                                showAllContactList = false;
                              }
                            },
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
                    ],
                    Expanded(
                        child: TabBarView(children: <Widget>[
                      if (allContactDB == []) ...[
                        loadingDataState.dataIsLoadingState('Loading...'),
                      ] else if (allContactDB.isEmpty) ...[
                        loadingDataState.dataIsEmptyState('No list of contact here', 'add contact now'),
                      ] else ...[
                        buildListViewBuilder(),
                      ],
                      if (allContactDB == []) ...[
                        loadingDataState.dataIsLoadingState('Loading...'),
                      ] else if (allContactDB.isEmpty) ...[
                        loadingDataState.dataIsEmptyState('No list of contact here', 'add contact now'),
                      ] else ...[
                        buildListViewBuilder(),
                      ]
                    ]))
                  ]))),
        );
      }),
      floatingActionButton: fabWidget(context, AddContact(), ref),
    );
  }
}
