import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invoice_generator/model/quotation.dart';

import '../widget/popup.dart';

class QuotationDB{

  static Box<Quotation> getQuotations() => Hive.box<Quotation>("quotations");

  static Future createQuotation(Quotation quotation) async{
    final box = getQuotations();
    box.add(quotation);
  }

  static void deleteQuotation(BuildContext context, String source, Quotation quotation){
    if(source == "db"){
      quotation.delete()
          .then((value) => Popup.createToastMsg(context, "Quotation deleted", Colors.lightGreen[600]))
          .catchError((e) => Popup.createToastMsg(context, "Error: ${e}. Please try again.", Colors.red[400]));
    }else{
      quotation.delete();
    }

  }

}