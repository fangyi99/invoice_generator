import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../model/invoice.dart';
import '../../model/quotation.dart';

class DocumentSF extends StatefulWidget {

  String mode;
  Quotation? quotation;
  Invoice? invoice;

  DocumentSF({required this.mode, this.quotation, this.invoice});

  @override
  State<DocumentSF> createState() => _DocumentSFState();
}

class _DocumentSFState extends State<DocumentSF> {
  late bool isQuotation;

  @override
  void initState(){
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
        SizedBox(height: 5),
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
            if(widget.quotation != null){
              widget.quotation!.fileName = value;
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
            if(widget.quotation != null) {
              widget.quotation!.documentID = value;
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
              isQuotation ? (widget.quotation!.term = value) : (widget.invoice!.term = value);
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
            if((isQuotation) ? (widget.quotation!.date!=null && widget.quotation!.date!='') : (widget.invoice!.date!=null && widget.invoice!.date!='')){
              newDate = await showDatePicker(
                  context: context,
                  initialDate: isQuotation ? DateTime.parse(widget.quotation!.date.toString()) : DateTime.parse(widget.invoice!.date.toString()),
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
              if(isQuotation == true){
                widget.quotation!.date = newDate!;
              }
              else{
                widget.invoice!.date = newDate!;
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
              isQuotation ? (widget.quotation!.subjectTitle = value) : (widget.invoice!.subjectTitle = value);
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
}