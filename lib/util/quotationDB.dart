import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invoice_generator/model/quotation.dart';

class QuotationDB{

  static Box<Quotation> getQuotations() => Hive.box<Quotation>("quotations");

  static Future createQuotation(Quotation quotation) async{
    final box = getQuotations();
    box.add(quotation);
  }

  static void updateQuotation(Quotation updatedQuotation){
    final box = getQuotations();
    var oldQuotation = box.getAt(updatedQuotation.key)!;
    oldQuotation = updatedQuotation;
    oldQuotation.save();
  }

  static void deleteQuotation(BuildContext context, Quotation quotation){
    quotation.delete();
  }

}