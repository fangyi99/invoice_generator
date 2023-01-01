import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject{

  User({
    this.company = '',
    this.name = '',
    this.address1 = '',
    this.address2 = '',
    this.address3 = '',
    this.postalCode = '',
    this.hdphCC = '',
    this.hdph = '',
    this.officeCC = '',
    this.office = '',
    this.email = ''
  });

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

  Map<String, dynamic> toJSON() {
    return {
      "company": company,
      "name": name,
      "address1": address1,
      "address2": address2,
      "address3": address3,
      "postalCode": postalCode,
      "hdphCC": hdphCC,
      "hdph": hdph,
      "officeCC": officeCC,
      "office": office,
      "email": email
    };
  }

}