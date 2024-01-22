import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/contact_model.dart';

class ContactService {
  String userUrl = 'https://reqres.in/api/users';

  Future<List<ContactModel>> getUsers() async {
    var response = await http.get(Uri.parse(userUrl));

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body)['data'];

      List<ContactModel> contactList = result
          .map((contactJson) => ContactModel.fromJson(contactJson))
          .toList();

      return contactList;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}