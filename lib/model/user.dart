import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject{
  @HiveField(0)
  late String? company;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String address1;

  @HiveField(3)
  late String address2;

  @HiveField(4)
  late String? address3;

  @HiveField(5)
  late String? postalCode;

  @HiveField(6)
  late String hdphCC;

  @HiveField(7)
  late String? hdph;

  @HiveField(8)
  late String? officeCC;

  @HiveField(9)
  late String? office;

  @HiveField(10)
  late String? email;

}