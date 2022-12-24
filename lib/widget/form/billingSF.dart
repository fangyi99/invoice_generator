import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class BillingSF extends StatelessWidget {

  // final Map controllers;
  //
  // BillingSF({required this.controllers});

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
                // final importedUser = await Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => DBUser(export: true)),
                // );
                // controllers['companyController'].text = importedUser['company'];
                // controllers['addresseeController'].text = importedUser['name'];
                // controllers['addressL1Controller'].text = importedUser['addressL1'];
                // controllers['addressL2Controller'].text = importedUser['addressL2'];
                // controllers['addressL3Controller'].text = importedUser['addressL3'];
                // controllers['postalCodeController'].text = importedUser['postalCode'];
                // controllers['countryCodeController'].text = importedUser['countryCode'];
                // controllers['hdphController'].text = importedUser['hdph'];
                // controllers['countryCode2Controller'].text = importedUser['countryCode2'];
                // controllers['officeController'].text = importedUser['office'];
                // controllers['emailController'].text = importedUser['email'];
              },
              child: Text('Import User'),
            ),
          ),
        ),
        TextFormField(
          // controller: controllers['companyController'],
          decoration: InputDecoration(
            labelText: 'Company Name',
            hintText: 'ABC Company',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        TextFormField(
          // controller: controllers['addresseeController'],
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
          // controller: controllers['addressL1Controller'],
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
          // controller: controllers['addressL2Controller'],
          decoration: InputDecoration(
            labelText: 'Address Line 2 *',
            hintText: '#12-9181',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        TextFormField(
          // controller: controllers['addressL3Controller'],
          decoration: InputDecoration(
            labelText: 'Address Line 3',
            hintText: 'The Inlands',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 15),
        TextFormField(
          // controller: controllers['postalCodeController'],
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
                  // controller: controllers['countryCodeController'],
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
                // controller: controllers['hdphController'],
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
                  // controller: controllers['countryCode2Controller'],
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
                // controller: controllers['officeController'],
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
}