import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invoice_generator/page/database.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../model/invoice.dart';
import '../../model/quotation.dart';
import '../../model/user.dart';

class BillingSF extends StatefulWidget {

  Quotation? quotation;
  Invoice? invoice;

  static TextEditingController companyController = TextEditingController();
  static TextEditingController nameController = TextEditingController();
  static TextEditingController addressL1Controller = TextEditingController();
  static TextEditingController addressL2Controller = TextEditingController();
  static TextEditingController addressL3Controller = TextEditingController();
  static TextEditingController postalCodeController = TextEditingController();
  static TextEditingController hdphCCController = TextEditingController(text: "65");
  static TextEditingController hdphController = TextEditingController();
  static TextEditingController officeCCController = TextEditingController(text: "65");
  static TextEditingController officeController = TextEditingController();
  static TextEditingController emailController = TextEditingController();

  BillingSF({Key? key, this.quotation, this.invoice}) : super(key: key);


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
      quotation!.user.hdphCC = "65";
    }
    else{
      isQuotation = false;
      invoice!.user.hdphCC = "65";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Addressee Details",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.lightBlue, decoration: TextDecoration.underline))
        ),
        SizedBox(height: 15),
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
          controller: BillingSF.companyController,
          decoration: InputDecoration(
            labelText: 'Company Name',
            hintText: 'ABC Company',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.user.company = value) : (invoice!.user.company = value);
            });
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: BillingSF.nameController,
          decoration: InputDecoration(
            helperText: "Please include addressee's salutation",
            labelText: 'Addressee / Attn *',
            hintText: 'Ms Emma',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.user.name = value) : (invoice!.user.name = value);
            });
          },
          validator: (value) {
            if(value == null || value.isEmpty)
              return 'This field is required.';
            return null;
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: BillingSF.addressL1Controller,
          decoration: InputDecoration(
            labelText: 'Address Line 1',
            hintText: '39 Scotts Road',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.user.address1 = value) : (invoice!.user.address1 = value);
            });
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: BillingSF.addressL2Controller,
          decoration: InputDecoration(
            labelText: 'Address Line 2',
            hintText: '#12-9181',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.user.address2 = value) : (invoice!.user.address2 = value);
            });
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: BillingSF.addressL3Controller,
          decoration: InputDecoration(
            labelText: 'Address Line 3',
            hintText: 'The Inlands',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.user.address3 = value) : (invoice!.user.address3 = value);
            });
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: BillingSF.postalCodeController,
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
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.user.postalCode = value) : (invoice!.user.postalCode = value);
            });
          },
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextFormField(
                  controller: BillingSF.hdphCCController,
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
                  onChanged: (value){
                    setState(() {
                      isQuotation ? (quotation!.user.hdphCC = value) : (invoice!.user.hdphCC = value);
                    });
                  },
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
                controller: BillingSF.hdphController,
                decoration: InputDecoration(
                  labelText: 'Hdph *',
                  hintText: '1234 6678',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onChanged: (value){
                  setState(() {
                    isQuotation ? (quotation!.user.hdph = value) : (invoice!.user.hdph = value);
                  });
                },
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
                  controller: BillingSF.officeCCController,
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
                  onChanged: (value){
                    setState(() {
                      isQuotation ? (quotation!.user.officeCC = value) : (invoice!.user.officeCC = value);
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: TextFormField(
                controller: BillingSF.officeController,
                decoration: InputDecoration(
                  labelText: 'Office',
                  hintText: '1234 6678',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onChanged: (value){
                  setState(() {
                    isQuotation ? (quotation!.user.office = value) : (invoice!.user.office = value);
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: BillingSF.emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'emma@gmail.com',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.user.email = value) : (invoice!.user.email = value);
            });
          },
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

        //update controllers
        BillingSF.companyController.text = quotation!.user.company!;
        BillingSF.nameController.text = quotation!.user.name!;
        BillingSF.addressL1Controller.text = quotation!.user.address1!;
        BillingSF.addressL2Controller.text = quotation!.user.address2!;
        BillingSF.addressL3Controller.text = quotation!.user.address3!;
        BillingSF.postalCodeController.text = quotation!.user.postalCode!;
        BillingSF.hdphCCController.text = quotation!.user.hdphCC!;
        BillingSF.hdphController.text = quotation!.user.hdph!;
        BillingSF.officeCCController.text = quotation!.user.officeCC!;
        BillingSF.officeController.text = quotation!.user.office!;
        BillingSF.emailController.text = quotation!.user.email!;
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

        //update controllers
        BillingSF.companyController.text = invoice!.user.company!;
        BillingSF.nameController.text = invoice!.user.name!;
        BillingSF.addressL1Controller.text = invoice!.user.address1!;
        BillingSF.addressL2Controller.text = invoice!.user.address2!;
        BillingSF.addressL3Controller.text = invoice!.user.address3!;
        BillingSF.postalCodeController.text = invoice!.user.postalCode!;
        BillingSF.hdphCCController.text = invoice!.user.hdphCC!;
        BillingSF.hdphController.text = invoice!.user.hdph!;
        BillingSF.officeCCController.text = invoice!.user.officeCC!;
        BillingSF.officeController.text = invoice!.user.office!;
        BillingSF.emailController.text = invoice!.user.email!;
      }
    });
  }

}