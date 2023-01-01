import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../model/invoice.dart';
import '../../model/quotation.dart';
import '../../page/database.dart';

class DocumentSF extends StatefulWidget {

  String mode;
  Quotation? quotation;
  Invoice? invoice;

  DocumentSF({required this.mode, this.quotation, this.invoice});

  @override
  State<DocumentSF> createState() => _DocumentSFState();
}

class _DocumentSFState extends State<DocumentSF> {
  Quotation? quotation;
  Invoice? invoice;
  late bool isQuotation;

  @override
  void initState(){
    quotation = widget.quotation;
    invoice = widget.invoice;

    if(widget.quotation != null){
      isQuotation = true;
    }
    else{
      isQuotation = false;
    }
  }

  var quoNumberMask = new MaskTextInputFormatter(
    mask: 'RD/####Q/##',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.eager,
  );

  var invNumberMask = new MaskTextInputFormatter(
    mask: 'RD/####/##',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.eager,
  );

  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // SizedBox(height: 5),
        Visibility(
          visible: !isQuotation,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
              child: ElevatedButton(
                onPressed: () async {
                  final importedQuotation = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Database(exportType: "quotation")),
                  );
                  updateQuotation(importedQuotation);
                },
                child: Text('Import Quotation'),
              ),
            ),
          ),
        ),
        // SizedBox(height: 5),
        TextFormField(
          maxLines: null,
          enabled: widget.mode!="update",
          decoration: InputDecoration(
            labelText: 'PDF File Name *',
            border: OutlineInputBorder(),
            errorMaxLines: 3,
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value){
            if(isQuotation){
              quotation!.fileName = value;
            }
            else{
              invoice!.fileName = value;
            }
          },
          validator: (value) {
            if(value == null || value.isEmpty) {
              return 'This field is required.';
            }
            if(value.contains(RegExp('[\\/:*?<>|]'))) {
              return "A file name can't contain any of the following characters: \ / : * ? < > |";
            }
            return null;
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          inputFormatters: isQuotation ? [quoNumberMask] : [invNumberMask],
          decoration: InputDecoration(
            labelText: isQuotation ?  'Quotation No. *' : 'Invoice No. *',
            hintText: isQuotation ? 'RD/####Q/YY' : 'RD/####/YY',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (value){
            if(isQuotation) {
              quotation!.documentID = value;
            }
            else{
              invoice!.documentID = value;
            }
          },
          validator: (value) {
            if(value == null || value.isEmpty)
              return 'This field is required.';
            return null;
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Terms *',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.term = value) : (invoice!.term = value);
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
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_month),
            labelText: 'Date *',
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? newDate;
            if((isQuotation) ? (quotation!.date!=null && quotation!.date!='') : (invoice!.date!=null && invoice!.date!='')){
              newDate = await showDatePicker(
                  context: context,
                  initialDate: isQuotation ? DateTime.parse(quotation!.date.toString()) : DateTime.parse(invoice!.date.toString()),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2200)
              );
            }else{
              newDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2200));
            }
            //if 'CANCEL'
            if(newDate == null) return;
            //if 'OK'
            setState(() {
              if(isQuotation){
                quotation!.date = newDate!;
              }
              else{
                invoice!.date = newDate!;
              }
            });
            //update display
            dateController.text = DateFormat('d-MMM-yyyy').format(newDate);
          },
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        TextFormField(
          maxLines: null,
          decoration: InputDecoration(
            labelText: 'Subject Title *',
            hintText: 'Eg. Spray painting works',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.subjectTitle = value) : (invoice!.subjectTitle = value);
            });
          },
          validator: (value) {
            if(value == null || value.isEmpty)
              return 'This field is required.';
            return null;
          },
        ),
      ],
    );
  }

  void updateQuotation(Quotation importedQuotation) {
    //update document
    invoice!.fileName = importedQuotation.fileName;
    invoice!.documentID = importedQuotation.documentID;
    invoice!.term = importedQuotation.term;
    invoice!.date = importedQuotation.date;
    invoice!.subjectTitle = importedQuotation.subjectTitle;

    //update billing
    invoice!.user.company = importedQuotation.user.company;
    invoice!.user.name = importedQuotation.user.name;
    invoice!.user.address1 = importedQuotation.user.address1;
    invoice!.user.address2 = importedQuotation.user.address2;
    invoice!.user.address3 = importedQuotation.user.address3;
    invoice!.user.postalCode = importedQuotation.user.postalCode;
    invoice!.user.hdphCC = importedQuotation.user.hdphCC;
    invoice!.user.hdph = importedQuotation.user.hdph;
    invoice!.user.officeCC = importedQuotation.user.officeCC;
    invoice!.user.office = importedQuotation.user.office;
    invoice!.user.email = importedQuotation.user.email;

    //update item list
    invoice!.itemSupply = importedQuotation.itemSupply;
    invoice!.itemSections = importedQuotation.itemSections;

    //update transport
    invoice!.transport = importedQuotation.transport;
  }
}