import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';

import '../constant.dart';
import '../model/contact_model.dart';
import '../providers/contact_notifier_provider.dart';
import '../providers/contact_provider.dart';

import '../services/database_helper.dart';
// import '../services/mail_services.dart';
import '../services/mail_services.dart';
import '../widgets/button.dart';
import '../widgets/confirmation_pop_up.dart';
import '../widgets/fab_widget.dart';
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

  @override
  void initState() {
    super.initState();

    initData();
  }

  Future<void> initData() async {
    try {
      List<ContactModel> allContact = await DatabaseHelper.getAllContact() ?? [];

      if(allContact.isEmpty){
        allContact = await ref.read(getAllContactProvider.future);
      }

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
              await DatabaseHelper.clearAllContacts();
              await initData();
            },
            icon: const Icon(Icons.refresh),
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
                        labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        tabs: const [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('All', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Favorite', style: TextStyle(color: Colors.white)),
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
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(child: Text(fullName, overflow: TextOverflow.clip)),
                                      normalGap,
                                      favorited == 1 ? const Icon(Icons.star, color: Colors.amber) : const SizedBox(width: 0),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Expanded(child: Text(email, overflow: TextOverflow.clip)),
                                    ],
                                  ),
                                  leading: avatar != ''
                                      ? InkWell(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.transparent,
                                            child: ClipOval(
                                              child: Image.network(
                                                avatar,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(contact)));
                                          },
                                        )
                                      : InkWell(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.transparent,
                                            child: ClipOval(
                                              child: Image.asset(
                                                'asset/user.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(contact)));
                                          },
                                        ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      sendEmail(email);
                                    },
                                    icon: const Icon(Icons.send),
                                    color: mainColor,
                                  ),
                                ));
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
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(child: Text(fullName, overflow: TextOverflow.clip)),
                                        normalGap,
                                        favorited == 1 ? const Icon(Icons.star, color: Colors.amber) : const SizedBox(width: 0),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Expanded(child: Text(email, overflow: TextOverflow.clip)),
                                      ],
                                    ),
                                    leading: avatar != ''
                                        ? InkWell(
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.transparent,
                                              child: ClipOval(
                                                child: Image.network(
                                                  avatar,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(contact)));
                                            },
                                          )
                                        : InkWell(
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.transparent,
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'asset/user.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(contact)));
                                            },
                                          ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        sendEmail(email);
                                      },
                                      icon: const Icon(Icons.send),
                                      color: mainColor,
                                    ),
                                  ));
                            }
                            else{
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


// Container(
                    //   child: allContact.when(
                    //     data: (users) {
                    //       return ListView.builder(
                    //         itemCount: users.length,
                    //         itemBuilder: (context, index) {
                    //           ContactModel contact = users[index];
                    //           String avatar = contact.avatar ?? '';
                    //           String firstName = contact.firstName ?? '';
                    //           String lastName = contact.lastName ?? '';
                    //           String email = contact.email ?? '';
                    //           String fullName = '$firstName $lastName';

                    //           if (searchedValue.isNotEmpty && !fullName.toLowerCase().contains(searchedValue.toLowerCase())) {
                    //             return Container();
                    //           }

                    //           return Slidable(
                    //               endActionPane: ActionPane(
                    //                 motion: const BehindMotion(),
                    //                 children: [
                    //                   SlidableAction(
                    //                     onPressed: (context) {
                    //                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(firstName, lastName, email, avatar)));
                    //                     },
                    //                     foregroundColor: Colors.blue,
                    //                     icon: Icons.edit,
                    //                   ),
                    //                   SlidableAction(
                    //                     onPressed: (context) {
                    //                       showDialog(
                    //                         context: context,
                    //                         builder: (BuildContext context) {
                    //                           return ConfirmationPopUp(
                    //                             contentAlert: 'Are you sure you want to delete this contact?',
                    //                             onConfirm: () {
                    //                               print('asd');
                    //                             },
                    //                           );
                    //                         },
                    //                       );
                    //                     },
                    //                     foregroundColor: Colors.red,
                    //                     icon: Icons.delete,
                    //                   ),
                    //                 ],
                    //               ),
                    //               child: ListTile(
                    //                 title: Text(fullName),
                    //                 subtitle: Text(email),
                    //                 leading: avatar != ''
                    //                     ? InkWell(
                    //                         child: CircleAvatar(
                    //                           radius: 25,
                    //                           backgroundColor: Colors.transparent,
                    //                           child: ClipOval(
                    //                             child: Image.network(
                    //                               avatar,
                    //                               fit: BoxFit.cover,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         onTap: () {
                    //                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(firstName, lastName, email, avatar)));
                    //                         },
                    //                       )
                    //                     : InkWell(
                    //                         child: CircleAvatar(
                    //                           radius: 25,
                    //                           backgroundColor: Colors.transparent,
                    //                           child: ClipOval(
                    //                             child: Image.asset(
                    //                               'asset/contact.png',
                    //                               fit: BoxFit.cover,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         onTap: () {
                    //                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(firstName, lastName, email, avatar)));
                    //                         },
                    //                       ),
                    //                 trailing: IconButton(
                    //                   onPressed: () {
                    //                     sendEmail(email);
                    //                   },
                    //                   icon: const Icon(Icons.send),
                    //                   color: mainColor,
                    //                 ),
                    //               ));
                    //         },
                    //       );
                    //     },
                    //     loading: () {
                    //       return const Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     },
                    //     error: (error, stack) {
                    //       return Center(
                    //         child: Text('Error: $error'),
                    //       );
                    //     },
                    //   ),
                    // ),
