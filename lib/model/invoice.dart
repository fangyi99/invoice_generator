import 'package:invoice_generator/model/transport.dart';
import 'package:invoice_generator/model/user.dart';
import 'addOn.dart';
import 'deduction.dart';
import 'deposit.dart';
import 'itemSection.dart';

class Invoice{
  String fileName, documentID, term, subjectTitle, itemSupply;
  DateTime date;
  User user;
  List<ItemSection> itemSections;
  Transport transport;
  List<AddOn> addOns;
  List<Deduction> deductions;
  List<Deposit> deposits;


  Invoice(this.fileName, this.documentID, this.term, this.subjectTitle, this.itemSupply, this.date, this.user, this.itemSections, this.transport, this.addOns, this.deductions, this.deposits);
}