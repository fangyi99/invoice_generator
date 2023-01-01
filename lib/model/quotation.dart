import 'package:invoice_generator/model/transport.dart';
import 'package:invoice_generator/model/user.dart';

import 'tnC.dart';
import 'itemSection.dart';

import 'package:hive/hive.dart';
part 'quotation.g.dart';

@HiveType(typeId: 0)
class Quotation extends HiveObject{
  Quotation({
    required this.fileName,
    required this.documentID,
    required this.term,
    required this.subjectTitle,
    required this.itemSupply,
    required this.date,
    required this.user,
    required this.itemSections,
    required this.transport,
    required this.tnC
  });

  @HiveField(0)
  String fileName;

  @HiveField(1)
  String documentID;

  @HiveField(2)
  String term;

  @HiveField(3)
  String subjectTitle;

  @HiveField(4)
  String itemSupply;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  User user;

  @HiveField(7)
  List<ItemSection> itemSections;

  @HiveField(8)
  Transport transport;

  @HiveField(9)
  TnC tnC;

  Map<String, dynamic> toJSON() {
    return {
      "fileName": fileName,
      "documentID": documentID, "term": term, "subjectTitle": subjectTitle,
      "itemSupply": itemSupply, "date": date, "user": user, "itemSections": itemSections,
      "transport": transport, "tnC": tnC
    };
  }

}