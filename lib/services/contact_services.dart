import 'dart:convert';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hoi_system_assessment/services/database_helper.dart';
import 'package:http/http.dart' as http;

import '../model/contact_model.dart';

class ContactService {
  String allUserUrl = 'https://reqres.in/api/users';

  Future<List<ContactModel>> getAllUsers() async {
    var response = await http.get(Uri.parse(allUserUrl));

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body)['data'];

      List<ContactModel> allContact = [];
      List<ContactModel> contactList = result.map((contactJson) => ContactModel.fromJson(contactJson)).toList();
      if(contactList.isNotEmpty || contactList != []){
        allContact.addAll(contactList);
      }

      List<Contact> localContacts = await FlutterContacts.getContacts();
      List<ContactModel> contactModels = localContacts.map((contact) => ContactModel.fromContact(contact)).toList();
      if(localContacts.isNotEmpty || localContacts != []){
        allContact.addAll(contactModels);
      }

      for (var contact in allContact) {
        await DatabaseHelper.addContact(contact);
      }

      return allContact;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
