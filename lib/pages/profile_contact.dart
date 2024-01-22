import 'package:flutter/material.dart';
import 'package:hoi_system_assessment/widgets/button.dart';

import '../constant.dart';
import 'edit_contact.dart';

class ProfileContact extends StatelessWidget {
  final buttonWidget = ButtonWidget();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  late final String firstName;
  final String lastName;
  final String email;
  late final String avatar;

  ProfileContact(this.firstName, this.lastName, this.email, this.avatar, {super.key}) {
    lastNameController.text = lastName;
    emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    final widthOfMedia = MediaQuery.of(context).size.width;

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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditContact(firstName, lastName, email, avatar)));
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
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        normalGap,
                        Text(firstName, style: normalTextStyle),
                      ],
                    )
                  : Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: Image.asset(
                              'asset/contact.png',
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
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 30,
                          ),
                        ),
                        normalGap,
                        Text(firstName, style: normalTextStyle),
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
                      color: Colors.white,
                      size: 36.0,
                    ),
                    Text(email, style: normalTextStyle),
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
