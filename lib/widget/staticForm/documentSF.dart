import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../model/quotation.dart';

class DocumentSF extends StatelessWidget {

  String type, mode;
  Quotation? quotation;

  DocumentSF({required this.type, required this.mode, this.quotation});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        TextFormField(
          maxLines: null,
          enabled: mode!="update",
          decoration: InputDecoration(
            labelText: 'PDF File Name *',
            border: OutlineInputBorder(),
            errorMaxLines: 3,
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value){
            if(quotation != null){
              quotation!.fileName = value;
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
          inputFormatters: (type != 'quotation') ? [invNumberMask] : [quoNumberMask],
          decoration: InputDecoration(
            labelText: (type != 'quotation') ? 'Invoice No. *' : 'Quotation No. *',
            hintText: (type != 'quotation') ? 'RD/####/YY' : 'RD/####Q/YY',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (value){
            if(quotation != null) {
              quotation!.documentID = value;
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
            if(quotation != null) {
              quotation!.term = value;
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
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_month),
            labelText: 'Date *',
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? newDate;
            if(quotation!.date!=null && quotation!.date!=''){
              newDate = await showDatePicker(context: context, initialDate: DateTime.parse(quotation!.date.toString()), firstDate: DateTime(2000), lastDate: DateTime(2200));
            }else{
              newDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2200));
            }
            //if 'CANCEL'
            if(newDate == null) return;
            //if 'OK'
            // dateDisplay.text = DateFormat('d-MMM-yyyy').format(newDate);
            if(quotation != null) {
              quotation!.date = newDate!;
            }
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
            if(quotation != null) {
              quotation!.subjectTitle = value;
            }
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