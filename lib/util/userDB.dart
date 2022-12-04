import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invoice_generator/model/user.dart';

class UserDB{

  static Box<User> getUsers() => Hive.box<User>("users");

  static Future createUser(BuildContext context, Map newUser) async{
      final user = User()
        ..company = newUser["company"]
        ..name = newUser["name"]
        ..address1 = newUser["address1"]
        ..address2 = newUser["address2"]
        ..address3 = newUser["address3"]
        ..postalCode = newUser["postalCode"]
        ..hdphCC = newUser["hdphCC"]
        ..hdph = newUser["hdph"]
        ..officeCC = newUser["officeCC"]
        ..office = newUser["office"]
        ..email = newUser["email"];

    final box = getUsers();

    box.add(user);
  }

  static void updateUser(BuildContext context, User user, Map updatedUser) {
    user.company = updatedUser["company"];
    user.name = updatedUser["name"];
    user.address1 = updatedUser["address1"];
    user.address2 = updatedUser["address2"];
    user.address3 = updatedUser["address3"];
    user.postalCode = updatedUser["postalCode"];
    user.hdphCC = updatedUser["hdphCC"];
    user.hdph = updatedUser["hdph"];
    user.officeCC = updatedUser["officeCC"];
    user.office = updatedUser["office"];
    user.email = updatedUser["email"];

    user.save();

  }

  static void deleteUser(BuildContext context, User user){
    user.delete();
  }

}