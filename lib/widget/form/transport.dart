import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/invoice.dart';
import '../../model/quotation.dart';
import '../radioGroup.dart';

class TransportSF extends StatefulWidget {

  Quotation? quotation;
  Invoice? invoice;
  static TextEditingController amountController = TextEditingController();
  TransportSF({Key? key, this.quotation, this.invoice}) : super(key: key);

  @override
  State<TransportSF> createState() => _TransportSFState();

}

class _TransportSFState extends State<TransportSF> {
  List<String> transportList = ['One Way', 'Two Way', 'Self Collect', 'Others'];
  Quotation? quotation;
  Invoice? invoice;
  late bool isQuotation;

  @override
  void initState(){
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
    int selectedIndex = getSelectedIndex();

    return Column(
      children: [
        Row(
          children: <Widget>[
            //radio btns
            Expanded(
                child: RadioGroup(
                    display: transportList[0],
                    radioIndex: 0,
                    selectedIndex: selectedIndex,
                    onChange: (){
                      setState((){
                        isQuotation ? quotation!.transport.type = transportList[0] : invoice!.transport.type = transportList[0];
                      });
                    }
                )
            ),
            Expanded(
                child: RadioGroup(
                    display: transportList[1],
                    radioIndex: 1,
                    selectedIndex: selectedIndex,
                    onChange: (){
                      setState((){
                        isQuotation ? quotation!.transport.type = transportList[1] : invoice!.transport.type = transportList[1];
                      });
                    }
                )
            ),
            Expanded(
                child: RadioGroup(
                    display: transportList[2],
                    radioIndex: 2,
                    selectedIndex: selectedIndex,
                    onChange: (){
                      setState((){
                        isQuotation ? (quotation!.transport.type = "Self Collection") : (invoice!.transport.type = "Self Collection");
                        isQuotation ? (quotation!.transport.amount = 0) : (invoice!.transport.amount = 0);
                        TransportSF.amountController.text = "0";
                      });
                    }
                )
            ),
            Expanded(
                child: RadioGroup(
                    display: transportList[3],
                    radioIndex: 3,
                    selectedIndex: selectedIndex,
                    onChange: (){
                      setState((){
                        isQuotation ? (quotation!.transport.type = transportList[3]) : (invoice!.transport.type = transportList[3]);
                      });
                    }
                )
            ),
          ],
        ),
        Visibility(
          visible: selectedIndex == 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Please specify',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onChanged: (value){
                setState((){
                  isQuotation ? (quotation!.transport.otherType = value) : (invoice!.transport.otherType = value);
                });
              },
            ),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: TransportSF.amountController,
          enabled: selectedIndex == 2 ? false : true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(10),
              child: Text('\$'),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            labelText: 'Amount *',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (value){
            setState(() {
              isQuotation ? (quotation!.transport.amount = double.parse(value)) : (invoice!.transport.amount = double.parse(value));
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

  getSelectedIndex(){
    switch(isQuotation ? widget.quotation!.transport.type : widget.invoice!.transport.type){
      case "One Way":
        return 0;
      case "Two Way":
        return 1;
      case "Self Collection":
        return 2;
      case "Others":
        return 3;
      default:
        return 3;
    }
  }
}