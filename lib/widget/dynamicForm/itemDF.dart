import 'package:flutter/material.dart';
import 'package:invoice_generator/model/quotation.dart';

import '../../model/item.dart';
import '../../model/itemSection.dart';

class ItemDF extends StatefulWidget{
  final int itemIndex, sectionIndex;
  Quotation? quotation;
  late ItemSection itemSection = quotation?.itemSections[sectionIndex] ?? quotation!.itemSections[sectionIndex];
  late Item item = itemSection.itemList[itemIndex];
  final state = ItemDFState();

  ItemDF({required key, required this.itemIndex, required this.sectionIndex, required this.quotation}) : super(key: key);

  @override
  ItemDFState createState() => state;

}
class ItemDFState extends State<ItemDF>{

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Item #${widget.itemIndex+1}', style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            IconButton(
                onPressed: () {
                  setState((){
                    widget.quotation!.itemSections[widget.sectionIndex].itemList.removeAt(widget.itemIndex);
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
          initialValue: widget.item.description,
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
              widget.item.description = value
            },
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          initialValue: widget.item.methodStm,
          decoration: const InputDecoration(
            labelText: 'Method Statement',
            hintText: 'Hit enter to input next line',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.newline,
          onChanged: (value) => {
            if(value != ''){
              widget.item.methodStm = "/nvalue"
            },
          },
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        const SizedBox(height: 15),
        TextFormField(
          initialValue: widget.item.amount != 0 ? widget.item.amount.toString() : null,
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
              widget.item.amount = double.parse(double.parse(value).toStringAsFixed(2))
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
}