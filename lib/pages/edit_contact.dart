import 'package:flutter/material.dart';
import 'package:hoi_system_assessment/widgets/button.dart';

import '../constant.dart';

class EditContact extends StatelessWidget {
  final buttonWidget = ButtonWidget();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  final String firstName;
  final String lastName;
  final String email;
  late final String avatar;

  EditContact(this.firstName, this.lastName, this.email, this.avatar, {super.key}) {
    firstNameController.text = firstName;
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
      body: Padding(
        padding: mainScreenPadding,
        child: Column(
          children: [
            avatar != '' 
            ? Stack(
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: mainColor,                            
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.edit_sharp, 
                            color: Colors.white,
                            size: 20,
                          ),
                        ),                        
                      ]
                    ),
                  ),
                ],
              )
            : CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  'asset/contact.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            gapBetweenDifferentField,
            SizedBox(
              width: widthOfMedia,
              height: heightOfField,
              child: TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  label: Text('First Name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  hintText: 'First Name',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
            gapBetweenField,
            SizedBox(
              width: widthOfMedia,
              height: heightOfField,
              child: TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  label: Text('Last Name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  hintText: 'Last Name',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
            gapBetweenField,
            SizedBox(
              width: widthOfMedia,
              height: heightOfField,
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
            gapBetweenDifferentField,
            buttonWidget.roundedButtonWidget('Done', widthOfMedia, () { })
          ],
        ),
      ),
    );
  }
}