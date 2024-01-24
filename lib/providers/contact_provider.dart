import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/contact_model.dart';
import '../services/contact_services.dart';

final contactService = ContactService();

final getAllContactProvider = FutureProvider<List<ContactModel>>((ref) async {
  try {
    List<ContactModel> users = await contactService.getAllUsers();

    return users;
  } catch (error) {
    print('Error fetching users: $error');
    return [];
  }
});
