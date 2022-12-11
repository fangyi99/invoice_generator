import 'package:flutter/material.dart';
import 'package:invoice_generator/model/item.dart';
import '../../model/quotation.dart';
import 'itemDF.dart';

typedef OnDeleteItemSection = Function();

class ItemSectionDF extends StatefulWidget{
  final int dropdownIndex, sectionIndex;
  Quotation? quotation;
  final state = ItemSectionDFState();

  ItemSectionDF({Key? key,
    required this.dropdownIndex,
    required this.sectionIndex,
    this.quotation,

  }) : super(key: key);

  @override
  ItemSectionDFState createState() => state;

}

class ItemSectionDFState extends State<ItemSectionDF>{
  final form = GlobalKey<FormState>();
  Quotation? quotation;

  @override
  void initState() {
    super.initState();
    quotation = widget.quotation;
  }

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Option Item #${widget.dropdownIndex+1}', style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[300],
                )
            ),
          ],
        ),
        DropdownButton(
            items: const [
              DropdownMenuItem(value: "Default", child: Text("Default"), enabled: true),
              DropdownMenuItem(value: "Internal", child: Text("Internal"), enabled: true),
              DropdownMenuItem(value: "External", child: Text("External"), enabled: true),
            ],
            value: quotation?.itemSections[widget.sectionIndex].type ?? "Default",
            onChanged: (value){
              setState(() {
                quotation!.itemSections[widget.sectionIndex].type = value!;
              });
            },
          isExpanded: true,
        ),
        const SizedBox(height: 15.0),
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: quotation!.itemSections[widget.sectionIndex].itemList.length,
              itemBuilder: (_, j) => ItemDF(
                key: UniqueKey(),
                itemIndex: j,
                sectionIndex: widget.sectionIndex,
                quotation: quotation!
              ),
            ),
            const SizedBox(height: 10),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 43,
                  child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          quotation!.itemSections[widget.sectionIndex].itemList.add(Item());
                        });
                        },
                      child: const Text('+ Add Item')
                  ),
                )
            ),
          ],
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