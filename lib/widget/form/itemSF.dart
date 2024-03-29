import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/model/item.dart';
import '../../model/invoice.dart';
import '../../model/quotation.dart';
import '../radioGroup.dart';

class ItemSF extends StatefulWidget {

  Quotation? quotation;
  Invoice? invoice;
  ItemSF({Key? key, this.quotation, this.invoice}) : super(key: key);

  @override
  State<ItemSF> createState() => _ItemSFState();
}

class _ItemSFState extends State<ItemSF> {
  List<String> itemSupplyList = ["Labour & Materials", "Labour Only"];
  Quotation? quotation;
  Invoice? invoice;
  late bool isQuotation;

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
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Item List",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.lightBlue, decoration: TextDecoration.underline))
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            //radio btns
            Expanded(
              child: RadioGroup(
                  display: itemSupplyList[0],
                  radioIndex: 0,
                  selectedIndex: getSelectedIndex(),
                  onChange: () {
                    setState((){
                      isQuotation ? (quotation!.itemSupply = itemSupplyList[0]) : (invoice!.itemSupply = itemSupplyList[0]);
                    });
                  }),
            ),
            Expanded(
              child: RadioGroup(
                  display: itemSupplyList[1],
                  radioIndex: 1,
                  selectedIndex: getSelectedIndex(),
                  onChange: () {
                    setState((){
                      isQuotation ? (quotation!.itemSupply = itemSupplyList[1]) : (invoice!.itemSupply = itemSupplyList[1]);
                    });
                  }),
            ),
        ]),
        const SizedBox(height: 15),
        ListView.builder(
          key: UniqueKey(),
          shrinkWrap: true,
          itemCount: isQuotation ? quotation!.itemList.length : invoice!.itemList.length,
          itemBuilder: (_, j) => ItemDF(j),
        ),
        const SizedBox(height: 10),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      isQuotation ? quotation!.itemList.add(Item()) : invoice!.itemList.add(Item());
                    });
                  },
                  child: const Text('+ Add Item')
              ),
            )
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget ItemDF(int itemIndex){
    Item item = isQuotation ? quotation!.itemList[itemIndex] : invoice!.itemList[itemIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Item #${itemIndex+1}', style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            IconButton(
                onPressed: () {
                  setState((){
                    isQuotation ? quotation!.itemList.removeAt(itemIndex) : invoice!.itemList.removeAt(itemIndex);
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[300],
                )
            )
          ],
        ),
        const SizedBox(height: 15),
        TextFormField(
          initialValue: item.description,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Item description',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.newline,
          validator: (value) {
            if(value == null || value.isEmpty)
              return 'This field is required.';
            return null;
          },
          onChanged: (value) => {
            if(value != ''){
              item.description = value
            },
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          initialValue: item.methodStm,
          decoration: const InputDecoration(
            labelText: 'Method Statement',
            hintText: 'Hit enter to input next line',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.newline,
          onChanged: (value) => {
            if(value != ''){
              item.methodStm = "$value"
            },
          },
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        const SizedBox(height: 15),
        TextFormField(
          initialValue: item.amount != 0 ? item.amount.toString() : null,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(10),
              child: Text('\$'),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            labelText: 'Amt',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          validator: (value) {
            if(value == null || value.isEmpty)
              return 'This field is required.';
            return null;
          },
          onChanged: (value) => {
            if(value != ''){
              item.amount = double.parse(double.parse(value).toStringAsFixed(2))
            },
          },
        ),
        const SizedBox(height: 5),
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  getSelectedIndex(){
    switch(isQuotation ? quotation!.itemSupply : invoice!.itemSupply){
      case "Labour & Materials":
        return 0;
      case "Labour Only":
        return 1;
      default:
        return 0;
    }
  }
}