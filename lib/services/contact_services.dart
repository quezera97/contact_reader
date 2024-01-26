import 'dart:convert';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:contact_reader/services/database_helper.dart';
import 'package:http/http.dart' as http;

import '../model/contact_model.dart';

class ContactService {
  String allUserUrl = 'https://reqres.in/api/users';
  bool permissionGranted = false;

  Future getAllContactService(bool permission) async {
    permissionGranted = permission;

    try {
      List<ContactModel> allContacts = [];

      List<ContactModel> apiContacts = await getApiContacts();
      allContacts.addAll(apiContacts);
      List<ContactModel> localContacts = await getLocalContact();
      allContacts.addAll(localContacts);
      return allContacts;
    } catch (error) {
      print('Error fetching users: $error');
      return [];
    }
  }

  Future<List<ContactModel>> getApiContacts() async {
    List<ContactModel> apiContacts = [];
    var response = await http.get(Uri.parse(allUserUrl));

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body)['data'];

      apiContacts = result.map((contactJson) => ContactModel.fromJson(contactJson)).toList();

      for (var contact in apiContacts) {
        await DatabaseHelper.addContact(contact);
      }

      return apiContacts;
    } else {
      return [];
    }
  }

  Future<List<ContactModel>> getLocalContact() async {
    List<ContactModel> localContactsModel = [];

    if (permissionGranted == true) {
      List<Contact> localContacts = await FlutterContacts.getContacts();
      localContactsModel = localContacts.map((contact) => ContactModel.fromContact(contact)).toList();

      for (var contact in localContactsModel) {
        await DatabaseHelper.addContact(contact);
      }
    }

    return localContactsModel;
  }
}
