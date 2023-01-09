import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generator/widget/form/billingSF.dart';
import 'package:invoice_generator/widget/form/transport.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../model/invoice.dart';
import '../../model/quotation.dart';
import '../../page/database.dart';

class DocumentSF extends StatefulWidget {

  String mode;
  Quotation? quotation;
  Invoice? invoice;

  DocumentSF({Key? key, required this.mode, this.quotation, this.invoice}) : super(key: key);

  @override
  State<DocumentSF> createState() => _DocumentSFState();
}

class _DocumentSFState extends State<DocumentSF> {
  Quotation? quotation;
  Invoice? invoice;
  late bool isQuotation, fileNameEnabled=false;

  @override
  void initState(){
    quotation = widget.quotation;
    invoice = widget.invoice;

    if(widget.quotation != null){
      isQuotation = true;
      if(widget.mode=="update" || widget.mode=="duplicate"){
        updateQuotation(quotation!);
      }
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

  TextEditingController fileNameController = TextEditingController();
  TextEditingController documentIdController = TextEditingController();
  TextEditingController termsController = TextEditingController(text: "C.O.D");
  TextEditingController dateController = TextEditingController(text: DateFormat('d-MMM-yyyy').format(DateTime.now()));
  TextEditingController subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
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
          controller: fileNameController,
          maxLines: null,
          // readOnly: fileNameEnabled,
          decoration: InputDecoration(
            // suffixIcon: IconButton(
            //   color: fileNameEnabled ? Colors.cyan : Colors.grey,
            //     icon: Icon(Icons.remove_circle),
            //     onPressed: () {
            //       fileNameEnabled = !fileNameEnabled;
            //     }
            // ),
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
          controller: documentIdController,
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
          controller: termsController,
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
          controller: subjectController,
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
    setState(() {
      if(isQuotation){
        //update quotation values
        //update document
        quotation!.fileName = widget.mode=="duplicate" ? importedQuotation.fileName + " copy" : importedQuotation.fileName;
        quotation!.documentID = importedQuotation.documentID;
        quotation!.term = importedQuotation.term;
        quotation!.date = importedQuotation.date;
        quotation!.subjectTitle = importedQuotation.subjectTitle;

        //update billing
        quotation!.user.company = importedQuotation.user.company;
        quotation!.user.name = importedQuotation.user.name;
        quotation!.user.address1 = importedQuotation.user.address1;
        quotation!.user.address2 = importedQuotation.user.address2;
        quotation!.user.address3 = importedQuotation.user.address3;
        quotation!.user.postalCode = importedQuotation.user.postalCode;
        quotation!.user.hdphCC = importedQuotation.user.hdphCC;
        quotation!.user.hdph = importedQuotation.user.hdph;
        quotation!.user.officeCC = importedQuotation.user.officeCC;
        quotation!.user.office = importedQuotation.user.office;
        quotation!.user.email = importedQuotation.user.email;

        //update item list
        quotation!.itemSupply = importedQuotation.itemSupply;
        quotation!.itemSections = importedQuotation.itemSections;

        //update transport
        quotation!.transport = importedQuotation.transport;
      }else{
        //update invoice values
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

      //update controllers
      //update document controllers
      fileNameController.text = importedQuotation.fileName;
      documentIdController.text = importedQuotation.documentID.replaceAll("Q", "");
      termsController.text = importedQuotation.term;
      dateController.text = DateFormat('d-MMM-yyyy').format(importedQuotation.date);
      subjectController.text = importedQuotation.subjectTitle!;
      //update billing controllers
      BillingSF.companyController.text = importedQuotation.user.company!;
      BillingSF.nameController.text = importedQuotation.user.name!;
      BillingSF.addressL1Controller.text = importedQuotation.user.address1!;
      BillingSF.addressL2Controller.text = importedQuotation.user.address2!;
      BillingSF.addressL3Controller.text = importedQuotation.user.address3!;
      BillingSF.postalCodeController.text = importedQuotation.user.postalCode!;
      BillingSF.hdphCCController.text = importedQuotation.user.hdphCC!;
      BillingSF.hdphController.text = importedQuotation.user.hdph!;
      BillingSF.officeCCController.text = importedQuotation.user.officeCC!;
      BillingSF.officeController.text = importedQuotation.user.office!;
      BillingSF.emailController.text = importedQuotation.user.email!;
      //update transport controller
      TransportSF.amountController.text = importedQuotation.transport.amount.toString();

    });
  }
}