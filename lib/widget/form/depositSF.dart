import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generator/model/deposit.dart';
import '../../model/invoice.dart';
import '../radioGroup.dart';

class DepositSF extends StatefulWidget {

  Invoice invoice;
  DepositSF({required this.invoice});

  @override
  State<DepositSF> createState() => _DepositFormState();
}

class _DepositFormState extends State<DepositSF> {

  late Invoice invoice;
  List<TextEditingController> depositDateControllers = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        ListView.builder(
          shrinkWrap: true,
          itemCount: invoice.deposits.length,
          itemBuilder: (_, i) => DepositDF(i),
        ),
        SizedBox(height: 10),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: ElevatedButton(
                  onPressed: (){
                    setState((){
                      invoice.deposits.add(Deposit());
                    });
                    depositDateControllers.add(TextEditingController());
                  },
                  child: Text('+ Add Deposit')
              ),
            )
        ),
      ],
    );
  }

  Widget DepositDF(int sectionIndex){
    final List depositMthdList = ['Down Payment', 'Advanced Payment', 'Progress Payment'];
    List<String> depositModeList = ['Cash', 'Bank', 'PayNow', 'Cheque'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Deposit #${sectionIndex+1}', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            IconButton(
                onPressed: (){
                  setState(() {
                    invoice.deposits.removeAt(sectionIndex);
                  });
                  depositDateControllers.removeAt(sectionIndex);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[300],
                )
            )
          ],
        ),
        SizedBox(height: 15),
        DropdownButton(
          items: const [
            DropdownMenuItem(value: "Down Payment", child: Text("Down Payment")),
            DropdownMenuItem(value: "Advanced Payment", child: Text("Advanced Payment")),
            DropdownMenuItem(value: "Progress Payment", child: Text("Progress Payment")),
          ],
          value: invoice.deposits[sectionIndex].type,
          onChanged: (value){
            setState(() {
              invoice.deposits[sectionIndex].type = value;
            });
          },
          isExpanded: true,
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
                setState(() {
                  invoice.deposits[sectionIndex].amount = double.parse(double.parse(value).toStringAsFixed(2));
                })
              }
            }
        ),
        SizedBox(height: 15),
        Visibility(
          visible: invoice.deposits[sectionIndex].type == "Progress Payment",
          child: Column(
            children: [
              Slider(
                value: invoice.deposits[sectionIndex].progressCounter!,
                onChanged: (value){
                  setState(() {
                    invoice.deposits[sectionIndex].progressCounter = value;
                  });
                },
                min: 1,
                max: 5,
                divisions: 4,
                label: '${invoice.deposits[sectionIndex].progressCounter?.toInt()}',
              ),
              Text('Progress Count: ${invoice.deposits[sectionIndex].progressCounter?.toInt()}'),
              SizedBox(height: 15)
            ],
          ),
        ),
        TextFormField(
          readOnly: true,
          controller: depositDateControllers[sectionIndex],
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_month),
            labelText: 'Date',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onTap: () async {
            DateTime? newDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2200));

            //if 'CANCEL'
            if(newDate == null) return;

            //if 'OK'
            //update display
            depositDateControllers[sectionIndex].text = DateFormat('d MMM yyyy').format(newDate);
            setState(() {
              invoice.deposits[sectionIndex].date = newDate;
            });
          },
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //radio btns
            Expanded(
              child: RadioGroup(
                  display: depositModeList[0],
                  radioIndex: 0,
                  selectedIndex: getSelectedIndex(sectionIndex),
                  onChange: () {
                    setState((){
                      invoice.deposits[sectionIndex].method = depositModeList[0];
                    });
                  }),
            ),
            Expanded(
              child: RadioGroup(
                  display: depositModeList[1],
                  radioIndex: 1,
                  selectedIndex: getSelectedIndex(sectionIndex),
                  onChange: () {
                    setState((){
                      invoice.deposits[sectionIndex].method = depositModeList[1];
                    });
                  }),
            ),
            Expanded(
              child: RadioGroup(
                  display: depositModeList[2],
                  radioIndex: 2,
                  selectedIndex: getSelectedIndex(sectionIndex),
                  onChange: () {
                    setState((){
                      invoice.deposits[sectionIndex].method = depositModeList[2];
                    });
                  }),
            ),
            Expanded(
              child: RadioGroup(
                  display: depositModeList[3],
                  radioIndex: 3,
                  selectedIndex: getSelectedIndex(sectionIndex),
                  onChange: () {
                    setState((){
                      invoice.deposits[sectionIndex].method = depositModeList[3];
                    });
                  }),
            ),
          ],
        ),
        Visibility(
          visible: (invoice.deposits[sectionIndex].method == "Cheque") ? true : false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                    hintText: 'Eg. DBS / OCBC',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => {
                    if(value != ''){
                      setState(() {
                        invoice.deposits[sectionIndex].bankName = value;
                      })
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Cheque No.',
                      hintText: 'Eg. 123456',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) => {
                      if(value != ''){
                        setState(() {
                          invoice.deposits[sectionIndex].chequeNo = value;
                        })
                      }
                    }
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Divider(color: Colors.grey),
        SizedBox(height: 5),
      ],
    );
  }

  getSelectedIndex(int sectionIndex){
    switch(invoice.deposits[sectionIndex].method){
      case "Cash":
        return 0;
      case "Bank":
        return 1;
      case "PayNow":
        return 2;
      case "Cheque":
        return 3;
      default:
        return 0;
    }
  }

}