import 'package:flutter_contacts/flutter_contacts.dart';

class ContactModel {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;
  int? favorited;

  ContactModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    this.favorited,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'] ?? '',
      favorited: json['favorited'] ?? 0,
    );
  }

  factory ContactModel.fromContact(Contact contact) {
    int idFromContact = int.parse(contact.id);
    int toBeUniqueId = 9000000000;

    return ContactModel(
      id: (idFromContact + toBeUniqueId),
      email: '',
      firstName: contact.displayName,
      lastName: '',
      avatar: '',
      favorited: contact.isStarred == true ? 1 : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email ?? '',
      'first_name': firstName ?? '',
      'last_name': lastName ?? '',
      'avatar': avatar ?? '',
      'favorited': favorited ?? 0,
    };
  }

  @override
  String toString() {
    return '''
      ContactModel{
        id: $id, 
        email: $email, 
        firstName: $firstName, 
        lastName: $lastName, 
        avatar: $avatar, 
        favorited: $favorited,
      }
    ''';
  }
}
