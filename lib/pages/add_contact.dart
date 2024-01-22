import 'package:flutter/material.dart';
import 'package:hoi_system_assessment/widgets/button.dart';

import '../constant.dart';

class AddContact extends StatelessWidget {
  AddContact({super.key});

  final buttonWidget = ButtonWidget();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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
        child: Padding(
          padding: mainScreenPadding,
          child: Column(
            children: [
              InkWell(
                child: Stack(children: [
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Stack(children: [
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
                          Icons.upload,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ]),
                  ),
                ]),
                onTap: () {
                  print('upload');
                },
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
              buttonWidget.roundedButtonWidget('Save', widthOfMedia, () {})
            ],
          ),
        ),
      ),
    );
  }
}
