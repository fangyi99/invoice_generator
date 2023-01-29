import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/addOn.dart';
import '../../model/invoice.dart';

class AddOnSF extends StatefulWidget{

  Invoice invoice;
  AddOnSF({Key? key, required this.invoice}) : super(key: key);

  @override
  State<AddOnSF> createState() => AddOnSFState();
}

class AddOnSFState extends State<AddOnSF> {
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
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Add-Ons",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.lightBlue, decoration: TextDecoration.underline))
        ),
        ListView.builder(
            itemCount: invoice.addOns.length,
            shrinkWrap: true,
            itemBuilder: (_, i) => AddOnDF(i)
        ),
        SizedBox(height: 10),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      invoice.addOns.add(AddOn());
                    });
                  },
                  child: Text('+ Add Item')
              ),
            )
        ),
      ],
    );
  }

  Widget AddOnDF(int sectionIndex){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add-on #${sectionIndex+1}', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  IconButton(
                      onPressed: (){
                        setState(() {
                          invoice.addOns.removeAt(sectionIndex);
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[300],
                      )
                  )
                ],
              ),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Additional Cost',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => {
                    setState(() {
                      invoice.addOns[sectionIndex].description = value;
                    })
                  }
              ),
              SizedBox(height: 15),
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
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => {
                    if(value != ''){
                      setState((){
                        invoice.addOns[sectionIndex].amount = double.parse(double.parse(value).toStringAsFixed(2));
                      })
                    },
                  }
              ),
              SizedBox(height: 5),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 5)
            ]
        )
    );
  }

}