import 'package:invoice_generator/model/transport.dart';
import 'package:invoice_generator/model/user.dart';

import 'TnC.dart';
import 'itemSection.dart';

class Quotation{
  String fileName, documentID, term, subjectTitle, itemSupply;
  DateTime date;
  User user;
  List<ItemSection> itemSections;
  Transport transport;
  TnC tnC;

  Quotation(this.fileName, this.documentID, this.term, this.subjectTitle, this.itemSupply, this.date, this.user, this.itemSections, this.transport, this.tnC);
}