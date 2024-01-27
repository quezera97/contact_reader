import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:contact_reader/model/contact_model.dart';
import 'package:contact_reader/widgets/button.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';
import '../providers/contact_notifier_provider.dart';
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
    // XFile? image = await picker.pickImage(source: ImageSource.camera);
    // final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return defaultImage;
    }

    final imageTemp = image.path;
    return imageTemp;
  } catch (e) {
    return defaultImage;
  }
}

class EditContact extends ConsumerWidget {
  final buttonWidget = ButtonWidget();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ContactModel contact;

  EditContact(this.contact, {super.key}) {
    firstNameController.text = contact.firstName ?? '';
    lastNameController.text = contact.lastName ?? '';
    emailController.text = contact.email ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widthOfMedia = MediaQuery.of(context).size.width;

    final allContacts = ref.watch(contactProvider);
    ContactModel watchedContact = allContacts.firstWhere((ctx) => ctx.id == contact.id);

    int favorited = watchedContact.favorited ?? 0;
    String uploadedImage = watchedContact.avatar ?? 'asset/user.png';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: favorited == 1 ? const Text('Remove From Fav', style: TextStyle(color: mainColor)) : const Text('Add To Fav', style: TextStyle(color: mainColor)),
                      onTap: () async {
                        ContactModel editedContact = ContactModel(
                          id: contact.id,
                          email: contact.email,
                          firstName: contact.firstName,
                          lastName: contact.lastName,
                          avatar: uploadedImage,
                          favorited: favorited == 1 ? 0 : 1,
                        );

                        await DatabaseHelper.updateContact(editedContact);

                        ref.read(contactProvider.notifier).updateContactProvider(editedContact);

                        favorited == 1 ? ToastHelper.showToast(message: 'Contact removed from favorite') : ToastHelper.showToast(message: 'Contact added to favorite');
                      },
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    uploadedImage = await _uploadImage();

                    ContactModel editedContact = ContactModel(
                      id: contact.id,
                      email: contact.email,
                      firstName: contact.firstName,
                      lastName: contact.lastName,
                      avatar: uploadedImage,
                      favorited: favorited,
                    );

                    await DatabaseHelper.updateContact(editedContact);

                    ref.read(contactProvider.notifier).updateContactProvider(editedContact);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: getImageWidget(uploadedImage),
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
                              Icons.edit_sharp,
                              color: whiteColor,
                              size: 20,
                            ),
                          ),
                        ]),
                      ),
                    ],
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
                buttonWidget.roundedButtonWidget('Done', widthOfMedia, () async {
                  FocusScope.of(context).unfocus();

                  if (_formKey.currentState!.validate()) {
                    ContactModel editedContact = ContactModel(
                      id: contact.id,
                      email: emailController.text,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      avatar: uploadedImage,
                      favorited: favorited,
                    );

                    await DatabaseHelper.updateContact(editedContact);

                    ref.read(contactProvider.notifier).updateContactProvider(editedContact);

                    ToastHelper.showToast(message: 'Contact successfully updated');
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
