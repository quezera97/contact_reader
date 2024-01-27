import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:contact_reader/widgets/button.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';
import '../model/contact_model.dart';
import '../providers/contact_notifier_provider.dart';
import '../providers/upload_image_provider.dart';
import '../services/database_helper.dart';
import '../widgets/image_widget.dart';
import '../widgets/toast.dart';

Future<String> _uploadImage() async {
  final ImagePicker picker = ImagePicker();
  String defaultImage = 'asset/user.png';
  try {
    XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 480,
      maxHeight: 640,
      imageQuality: 50,
    );

    if (image == null) {
      return defaultImage;
    }

    final imageTemp = image.path;
    return imageTemp;
  } catch (e) {
    return defaultImage;
  }
}

class AddContact extends ConsumerWidget {
  AddContact({super.key});

  final buttonWidget = ButtonWidget();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widthOfMedia = MediaQuery.of(context).size.width;
    var uploadedImage = ref.watch(uploadImageProvider);

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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: mainScreenPadding,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    String newUploadedImage = await _uploadImage();
                    ref.read(uploadImageProvider.notifier).setUploadImageProvider(newUploadedImage);
                  },
                  child: Stack(children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: getImageWidget(uploadedImage),
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
                            color: whiteColor,
                            size: 20,
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
                gapBetweenDifferentField,
                SizedBox(
                  width: widthOfMedia,
                  height: heightOfField,
                  child: TextFormField(
                    onTap: () {
                      _formKey.currentState?.reset();
                    },
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      label: Text('First Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      hintText: 'First Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorStyle: TextStyle(height: 0.3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ),
                gapBetweenField,
                SizedBox(
                  width: widthOfMedia,
                  height: heightOfField,
                  child: TextFormField(
                    onTap: () {
                      _formKey.currentState?.reset();
                    },
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      label: Text('Last Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      hintText: 'Last Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorStyle: TextStyle(height: 0.3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ),
                gapBetweenField,
                SizedBox(
                  width: widthOfMedia,
                  height: heightOfField,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorStyle: TextStyle(height: 0.3),
                    ),
                    validator: (value) {
                      bool isEmailValid = isValidEmail(emailController.text);

                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      } else if (isEmailValid == false) {
                        return 'Please enter valid email format';
                      }
                      return null;
                    },
                  ),
                ),
                gapBetweenDifferentField,
                buttonWidget.roundedButtonWidget('Save', widthOfMedia, () async {
                  FocusScope.of(context).unfocus();

                  if (_formKey.currentState!.validate()) {
                    ContactModel editedContact = ContactModel(
                      email: emailController.text,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      avatar: uploadedImage,
                    );

                    await DatabaseHelper.addContact(editedContact);

                    ref.read(contactProvider.notifier).addContactsProvider(editedContact);

                    ToastHelper.showToast(message: 'Contact successfully added');
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
