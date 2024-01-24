import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/contact_model.dart';

final contactProvider = StateNotifierProvider<ContactProvider, List<ContactModel>>(
  (ref) => ContactProvider(),
);

class ContactProvider extends StateNotifier<List<ContactModel>> {
  ContactProvider() : super([]);

  void setContactsProvider(List<ContactModel> contacts) {
    state = contacts;
  }

  void updateContactProvider(ContactModel updatedContact) {
    state = state.map((contact) =>
      contact.id == updatedContact.id ? updatedContact : contact
    ).toList();
  }

  void addContactsProvider(ContactModel contact) {
    state = [...state, contact];
  }

  void clearContactsProvider() {
    state = [];
  }

  void removeContactsProvider(int? contactId) {
    state = state.where((contact) => contact.id != contactId).toList();
  }
}
