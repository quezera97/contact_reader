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

final getFavContactProvider = FutureProvider<List<ContactModel>>((ref) async {
  try {
    List<ContactModel> users = await contactService.getFavUsers();
    return users;
  } catch (error) {
    print('Error fetching users: $error');
    return [];
  }
});

final allContactProvider = StateNotifierProvider<AllContactProvider, List<ContactModel>>(
  (ref) => AllContactProvider(),
);

class AllContactProvider extends StateNotifier<List<ContactModel>> {
  AllContactProvider() : super([]);

  void setContactsProvider(List<ContactModel> contacts) {
    state = contacts;
  }

  void addContactsProvider(ContactModel contact) {
    state = [...state, contact];
  }

  void removeContactsProvider(int? contactId) {
    state = state.where((contact) => contact.id != contactId).toList();
  }
}
