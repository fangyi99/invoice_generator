import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/model/item.dart';
import 'package:invoice_generator/model/itemSection.dart';
import '../../model/quotation.dart';
import '../dynamicForm/itemSectionDF.dart';
import '../radioGroup.dart';

class ItemSF extends StatefulWidget {

  Quotation? quotation;
  ItemSF({this.quotation});

  @override
  State<ItemSF> createState() => _ItemSFState();
}

class _ItemSFState extends State<ItemSF> {
  //radio grp
  List<String> itemSupplyList = ["Labour & Materials", "Labour Only"];

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const SizedBox(height: 4),
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
                      widget.quotation!.itemSupply = itemSupplyList[0];
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
                      widget.quotation!.itemSupply = itemSupplyList[1];
                    });
                  }),
            ),
        ]),
        const SizedBox(height: 15),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.quotation!.itemSections.length,
          itemBuilder: (_, i) => ItemSectionDF(
              dropdownIndex: i,
              sectionIndex: i,
              quotation: widget.quotation!,
          ),
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: !((widget.quotation!.itemSections.map((e) => e.type)).contains("Default")) && widget.quotation!.itemSections.length < 2,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 43,
                child: ElevatedButton(
                  onPressed: (){
                    setState((){
                      widget.quotation!.itemSections.add(ItemSection(type: "", itemList: [Item()]));
                    });
                  },
                  child: const Text('+ Add Option'),
                ),
              )
          ),
        ),
      ],
    );
  }

  getSelectedIndex(){
    switch(widget.quotation!.itemSupply){
      case "Labour & Materials":
        return 0;
      case "Labour Only":
        return 1;
      default:
        return;
    }
  }
}