import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invoice_generator/model/user.dart';

class UserDB{

  static Box<User> getUsers() => Hive.box<User>("users");

  static Future createUser(User user) async{
    final box = getUsers();
    box.add(user);
  }

  static void updateUser(User updatedUser) {
    final box = getUsers();
    var oldUser = box.getAt(updatedUser.key)!;
    oldUser = updatedUser;
    oldUser.save();
  }

  static void deleteUser(BuildContext context, User user){
    user.delete();
  }

}