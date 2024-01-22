import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../constant.dart';
import '../model/contact_model.dart';
import '../providers/contact_provider.dart';

import '../widgets/button.dart';
import '../widgets/confirmation_pop_up.dart';
import 'edit_contact.dart';
import 'add_contact.dart';
import 'profile_contact.dart';

class MyContact extends ConsumerWidget {
  MyContact({Key? key}) : super(key: key);

  final buttonWidget = ButtonWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {    
    final userContact = ref.watch(getContactProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Contacts'),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(getContactProvider);
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
              child: Column(
                children: <Widget>[
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
                      print(value);
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
                    child: TabBarView(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: userContact.when(
                              data: (users) {
                                return ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    ContactModel contact = users[index];
                                    String avatar = contact.avatar ?? '';
                                    String firstName = contact.firstName ?? '';
                                    String lastName = contact.lastName ?? '';
                                    String email = contact.email ?? '';

                                    return Slidable(
                                      endActionPane: ActionPane(
                                        motion: const BehindMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(
                                                firstName,
                                                lastName,
                                                email,
                                                avatar
                                              )));
                                            },
                                            foregroundColor: Colors.blue,
                                            icon: Icons.edit,
                                          ),
                                          SlidableAction(
                                            onPressed: (context) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ConfirmationPopUp(
                                                    contentAlert: 'Are you sure you want to delete this contact?',
                                                    onConfirm: () {
                                                      print('asd');
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
                                        title: Text(firstName),
                                        subtitle: Text(email),
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
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(
                                              firstName,
                                              lastName,
                                              email,
                                              avatar
                                            )));
                                          },
                                        ) 
                                        : InkWell(
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.transparent,
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'asset/contact.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(
                                                firstName,
                                                lastName,
                                                email,
                                                avatar
                                            )));
                                        },
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            print('send email');
                                          },
                                          icon: const Icon(Icons.send),
                                          color: mainColor,
                                        ),                        
                                      )
                                    );
                                  },
                                );
                              },
                              loading: () {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              error: (error, stack) {
                                return Center(
                                  child: Text('Error: $error'),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: userContact.when(
                              data: (users) {
                                return ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    ContactModel contact = users[index];
                                    String avatar = contact.avatar ?? '';
                                    String firstName = contact.firstName ?? '';
                                    String lastName = contact.lastName ?? '';
                                    String email = contact.email ?? '';

                                    return Slidable(
                                      endActionPane: ActionPane(
                                        motion: const BehindMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(
                                                firstName,
                                                lastName,
                                                email,
                                                avatar
                                              )));
                                            },
                                            foregroundColor: Colors.blue,
                                            icon: Icons.edit,
                                          ),
                                          SlidableAction(
                                            onPressed: (context) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ConfirmationPopUp(
                                                    contentAlert: 'Are you sure you want to delete this contact?',
                                                    onConfirm: () {
                                                      print('asd');
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
                                        title: Text(firstName),
                                        subtitle: Text(email),
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
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(
                                              firstName,
                                              lastName,
                                              email,
                                              avatar
                                            )));
                                          },
                                        ) 
                                        : InkWell(
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.transparent,
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'asset/contact.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileContact(
                                                firstName,
                                                lastName,
                                                email,
                                                avatar
                                            )));
                                        },
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            print('send email');
                                          },
                                          icon: const Icon(Icons.send),
                                          color: mainColor,
                                        ),                        
                                      )
                                    );
                                  },
                                );
                              },
                              loading: () {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              error: (error, stack) {
                                return Center(
                                  child: Text('Error: $error'),
                                );
                              },
                            ),
                          ),
                        ),
                      ]))
                ]))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddContact()));
        },
        backgroundColor: mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
