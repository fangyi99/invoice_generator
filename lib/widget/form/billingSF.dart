import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/page/database.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../model/invoice.dart';
import '../../model/quotation.dart';
import '../../model/user.dart';

class BillingSF extends StatefulWidget {

  Quotation? quotation;
  Invoice? invoice;
  BillingSF({this.quotation, this.invoice});

  @override
  State<BillingSF> createState() => _BillingSFState();
}

class _BillingSFState extends State<BillingSF> {
  Quotation? quotation;
  Invoice? invoice;
  late bool isQuotation;

  var unitNumberMask = new MaskTextInputFormatter(
      mask: '#~~-~~~~',
      filter: { "~": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  var hdphMask = new MaskTextInputFormatter(
      mask: '+## ###############',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    super.initState();
    quotation = widget.quotation;
    invoice = widget.invoice;

    if(widget.quotation != null){
      isQuotation = true;
    }
    else{
      isQuotation = false;
    }

    initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
            child: ElevatedButton(
              onPressed: () async {
                final importedUser = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Database(exportType: "user")),
                );
                updateUser(importedUser);
              },
              child: Text('Import User'),
            ),
          ),
        ),
        TextFormField(
          controller: TextEditingController(text: isQuotation ? quotation!.user.company: invoice!.user.company),
          decoration: InputDecoration(
            labelText: 'Company Name',
            hintText: 'ABC Company',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: TextEditingController(text: isQuotation ? quotation!.user.name: invoice!.user.name),
          decoration: InputDecoration(
            labelText: 'Addressee / Attn *',
            hintText: 'Ms Emma',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if(value == null || value.isEmpty)
              return 'This field is required.';
            return null;
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: TextEditingController(text: isQuotation ? quotation!.user.address1: invoice!.user.address1),
          decoration: InputDecoration(
            labelText: 'Address Line 1 *',
            hintText: '39 Scotts Road',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: TextEditingController(text: isQuotation ? quotation!.user.address2: invoice!.user.address2),
          decoration: InputDecoration(
            labelText: 'Address Line 2 *',
            hintText: '#12-9181',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: TextEditingController(text: isQuotation ? quotation!.user.address3: invoice!.user.address3),
          decoration: InputDecoration(
            labelText: 'Address Line 3',
            hintText: 'The Inlands',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: TextEditingController(text: isQuotation ? quotation!.user.postalCode: invoice!.user.postalCode),
          decoration: InputDecoration(
            labelText: 'Postal Code',
            hintText: '123456',
            border: OutlineInputBorder(),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Text('\S'),
            ),
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextFormField(
                  controller: TextEditingController(text: isQuotation ? quotation!.user.hdphCC: invoice!.user.hdphCC),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('\+'),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    labelText: 'Ctry *',
                    hintText: '65',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if(value == null || value.isEmpty)
                      return 'This field is required.';
                    return null;
                  },
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: TextFormField(
                controller: TextEditingController(text: isQuotation ? quotation!.user.hdph: invoice!.user.hdph),
                decoration: InputDecoration(
                  labelText: 'Hdph *',
                  hintText: '1234 6678',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if(value == null || value.isEmpty)
                    return 'This field is required.';
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextFormField(
                  controller: TextEditingController(text: isQuotation ? quotation!.user.officeCC: invoice!.user.officeCC),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('\+'),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    labelText: 'Ctry',
                    hintText: '65',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: TextFormField(
                controller: TextEditingController(text: isQuotation ? quotation!.user.office: invoice!.user.office),
                decoration: InputDecoration(
                  labelText: 'Office',
                  hintText: '1234 6678',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        TextFormField(
          // controller: controllers['emailController'],
          controller: TextEditingController(text: isQuotation ? quotation!.user.email: invoice!.user.email),
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'emma@gmail.com',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  void updateUser(User importedUser){
    setState((){
      if(isQuotation == true){
        quotation!.user.company = importedUser.company;
        quotation!.user.name = importedUser.name;
        quotation!.user.address1 = importedUser.address1;
        quotation!.user.address2 = importedUser.address2;
        quotation!.user.address3 = importedUser.address3;
        quotation!.user.postalCode = importedUser.postalCode;
        quotation!.user.hdphCC = importedUser.hdphCC;
        quotation!.user.hdph = importedUser.hdph;
        quotation!.user.officeCC = importedUser.officeCC;
        quotation!.user.office = importedUser.office;
        quotation!.user.email = importedUser.email;
      }
      else{
        invoice!.user.company = importedUser.company;
        invoice!.user.name = importedUser.name;
        invoice!.user.address1 = importedUser.address1;
        invoice!.user.address2 = importedUser.address2;
        invoice!.user.address3 = importedUser.address3;
        invoice!.user.postalCode = importedUser.postalCode;
        invoice!.user.hdphCC = importedUser.hdphCC;
        invoice!.user.hdph = importedUser.hdph;
        invoice!.user.officeCC = importedUser.officeCC;
        invoice!.user.office = importedUser.office;
        invoice!.user.email = importedUser.email;
      }
    });
  }

  void initializeUser(){
    if(isQuotation == true){
      quotation!.user.company = "";
      quotation!.user.name = "";
      quotation!.user.address1 = "";
      quotation!.user.address2 = "";
      quotation!.user.address3 = "";
      quotation!.user.postalCode = "";
      quotation!.user.hdphCC = "";
      quotation!.user.hdph = "";
      quotation!.user.officeCC = "";
      quotation!.user.office = "";
      quotation!.user.email = "";
    }
    else{
      invoice!.user.company = "";
      invoice!.user.name = "";
      invoice!.user.address1 = "";
      invoice!.user.address2 = "";
      invoice!.user.address3 = "";
      invoice!.user.postalCode = "";
      invoice!.user.hdphCC = "";
      invoice!.user.hdph = "";
      invoice!.user.officeCC = "";
      invoice!.user.office = "";
      invoice!.user.email = "";
    }
  }
}