import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:contact_reader/widgets/button.dart';

import '../constant.dart';
import '../model/contact_model.dart';
import '../providers/contact_notifier_provider.dart';
import '../widgets/text_style.dart';
import 'edit_contact.dart';

class ProfileContact extends ConsumerWidget {
  final buttonWidget = ButtonWidget();

  final ContactModel contact;

  ProfileContact(this.contact, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widthOfMedia = MediaQuery.of(context).size.width;

    final allContacts = ref.watch(contactProvider);
    ContactModel watchedContact = allContacts.firstWhere((ctx) => ctx.id == contact.id);

    String firstName = watchedContact.firstName ?? '';
    String lastName = watchedContact.lastName ?? '';
    String email = watchedContact.email ?? '';
    String avatar = watchedContact.avatar ?? '';
    int favorited = watchedContact.favorited ?? 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: mainScreenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: const Text('Edit', style: TextStyle(color: mainColor)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(contact)));
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: mainScreenPadding,
              child: avatar != ''
                  ? Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.network(
                                  avatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: mainColor,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                            ),
                            if (favorited == 1) ...[
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                              ),
                            ]
                          ],
                        ),
                        normalGap,
                        Text('$firstName $lastName', style: labelTextStyle(color: whiteColor, bold: false, size: 15, spacing: 1)),
                      ],
                    )
                  : Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.asset(
                                  'asset/user.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: mainColor,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                            ),
                            if (favorited == 1) ...[
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                              ),
                            ]
                          ],
                        ),
                        normalGap,
                        Text(firstName, style: labelTextStyle(color: whiteColor, bold: false, size: 15, spacing: 1)),
                      ],
                    ),
            ),
            Container(
              width: widthOfMedia,
              height: 100,
              color: const Color.fromARGB(255, 239, 235, 235), // Set the background color
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      color: whiteColor,
                      size: 36.0,
                    ),
                    Text(email, style: labelTextStyle(color: whiteColor, bold: false, size: 15, spacing: 1)),
                  ],
                ),
                onTap: () {
                  print('sent');
                },
              ),
            ),
            gapBetweenDifferentField,
            Padding(padding: mainScreenPadding, child: buttonWidget.roundedButtonWidget('Send Email', widthOfMedia, () {}))
          ],
        ),
      ),
    );
  }
}
