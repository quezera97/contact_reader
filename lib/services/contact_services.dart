import 'dart:convert';
import 'package:hoi_system_assessment/services/database_helper.dart';
import 'package:http/http.dart' as http;

import '../model/contact_model.dart';

class ContactService {
  String allUserUrl = 'https://reqres.in/api/users';

  Future<List<ContactModel>> getAllUsers() async {
    var response = await http.get(Uri.parse(allUserUrl));

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body)['data'];

      List<ContactModel> contactList = result.map((contactJson) => ContactModel.fromJson(contactJson)).toList();
      
      for (var contact in contactList) {
        await DatabaseHelper.addContact(contact);
      }

      return contactList;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
