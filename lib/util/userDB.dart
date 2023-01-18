import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invoice_generator/model/user.dart';
import 'package:invoice_generator/widget/popup.dart';

class UserDB{

  static Box<User> getUsers() => Hive.box<User>("users");

  static Future createUser(BuildContext context, User user) async{
    final box = getUsers();
    box.add(user)
        .then((value) => Popup.popAndReturnMsg(context, "User created", Colors.lightGreen[600]))
        .catchError((e) => Popup.popAndReturnMsg(context, "Error: ${e}. Please try again.", Colors.red[400]));
  }

  static void updateUser(BuildContext context, User oldUser, User updatedUser) {
    final box = getUsers();
    User user = box.get(oldUser.key)!;

    user.company = updatedUser.company;
    user.name = updatedUser.name;
    user.address1 = updatedUser.address1;
    user.address2 = updatedUser.address2;
    user.address3 = updatedUser.address3;
    user.postalCode = updatedUser.postalCode;
    user.hdphCC = updatedUser.hdphCC;
    user.hdph = updatedUser.hdph;
    user.officeCC = updatedUser.officeCC;
    user.office = updatedUser.office;
    user.email = updatedUser.email;

    user.save()
        .then((value) => Popup.popAndReturnMsg(context, "User updated", Colors.lightGreen[600]))
        .catchError((e) => Popup.popAndReturnMsg(context, "Error: ${e}. Please try again.", Colors.red[400]));
  }

  static void deleteUser(BuildContext context, User user){
    user.delete()
        .then((value) => Popup.createToastMsg(context, "User deleted", Colors.lightGreen[600]))
        .catchError((e) => Popup.createToastMsg(context, "Error: ${e}. Please try again.", Colors.red[400]));
  }

}