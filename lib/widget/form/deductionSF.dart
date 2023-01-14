import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/deduction.dart';
import '../../model/invoice.dart';
import '../../model/omission.dart';

class DeductionSF extends StatefulWidget {

  //deduction list
  Invoice invoice;

  DeductionSF({Key? key, required this.invoice}) : super(key: key);

  @override
  State<DeductionSF> createState() => DeductionSFState();
}

class DeductionSFState extends State<DeductionSF> {
  late Invoice invoice;

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: invoice.deductions.length,
          itemBuilder: (_, i) => DeductionDF(i),
        ),
        const SizedBox(height: 10),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 43,
              child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      invoice.deductions.add(Deduction());
                    });
                  },
                  child: const Text('+ Deduct item')
              ),
            )
        ),
      ],
    );
  }

  Widget DeductionDF(int sectionIndex){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Deduction Item #${sectionIndex+1}', style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            IconButton(
                onPressed: (){
                  setState(() {
                    invoice.deductions.removeAt(sectionIndex);
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[300],
                )
            ),
          ],
        ),
        DropdownButton(
          items: const [
            DropdownMenuItem(value: "Discount Given", child: Text("Discount Given")),
            DropdownMenuItem(value: "Omit Items", child: Text("Omit Items")),
          ],
          value: invoice.deductions[sectionIndex].type,
          onChanged: (value){
            setState(() {
              invoice.deductions[sectionIndex].type = value;
            });
          },
          isExpanded: true,
        ),
        const SizedBox(height: 15.0),
        TextFormField(
          enabled: !(getSelectedIndex(sectionIndex) == 1),
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(10),
              child: Text('\$'),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            labelText: 'Amt',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (value) => {
            if(value != ''){
              setState((){
                invoice.deductions[sectionIndex].amount = double.parse(double.parse(value).toStringAsFixed(2));
              })
            },
          },
        ),
        Visibility(
          visible: (getSelectedIndex(sectionIndex) == 1),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      'Omission Details',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      )
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: invoice.deductions[sectionIndex].omissions?.length,
                itemBuilder: (_, j) => OmissionDF(sectionIndex, j),
              ),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: ElevatedButton(
                        onPressed: (){
                          setState(() {
                            invoice.deductions[sectionIndex].omissions?.add(Omission());
                          });
                        },
                        child: const Text('+ Omit item')
                    ),
                  )
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget OmissionDF(int sectionIndex, int itemIndex){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Omitted Item #${itemIndex+1}', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            IconButton(
                onPressed: (){
                  setState(() {
                    invoice.deductions[sectionIndex].omissions?.removeAt(itemIndex);
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.orangeAccent[200],
                )
            ),
          ],
        ),
        TextFormField(
            decoration: InputDecoration(
              labelText: 'Omit Item',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onChanged: (value){
              setState(() {
                invoice.deductions[sectionIndex].omissions?[itemIndex].description = value;
              });
            }
        ),
        SizedBox(height: 15.0),
        TextFormField(
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.all(10),
                child: Text('\$'),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              labelText: 'Amt',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onChanged: (value){
              if(value != ''){
                setState((){
                  invoice.deductions[sectionIndex].omissions?[itemIndex].amount = double.parse(double.parse(value).toStringAsFixed(2));
                });
              }
            }
        ),
        SizedBox(height: 5),
        Divider(
          color: Colors.grey,
        ),
        SizedBox(height: 5),
      ],
    );
  }

  getSelectedIndex(sectionIndex){
    switch(invoice.deductions[sectionIndex].type){
      case "Discount Given":
        return 0;
      case "Omit Items":
        return 1;
      default:
        return 0;
    }
  }
}