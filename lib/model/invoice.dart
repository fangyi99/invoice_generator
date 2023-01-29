import 'package:invoice_generator/model/transport.dart';
import 'package:invoice_generator/model/user.dart';
import 'addOn.dart';
import 'deduction.dart';
import 'deposit.dart';
import 'item.dart';

class Invoice{
  String fileName, documentID, term, subjectTitle, itemSupply;
  DateTime date;
  User user;
  List<Item> itemList;
  Transport transport;
  List<AddOn> addOns;
  List<Deduction> deductions;
  List<Deposit> deposits;


  Invoice(this.fileName, this.documentID, this.term, this.subjectTitle, this.itemSupply,
      this.date, this.user, this.itemList, this.transport, this.addOns, this.deductions, this.deposits);

  Map<String, dynamic> toJSON() {
    return {
      "fileName": fileName,
      "documentID": documentID, "term": term, "subjectTitle": subjectTitle,
      "itemSupply": itemSupply, "date": date, "user": user.toJSON(), "itemSections": itemList.map((e) => e.toJSON()), "transport": transport.toJSON(),
      "addOns": addOns.map((e) => e.toJSON()), "deductions": deductions.map((e) => e.toJSON()), "deposits": deposits.map((e) => e.toJSON())
    };
  }
}