import 'package:flutter/cupertino.dart';
import '../../model/quotation.dart';
import '../radioGroup.dart';

class TnCSF extends StatefulWidget {

  Quotation? quotation;

  TnCSF({Key? key, required this.quotation}) : super(key: key);

  @override
  State<TnCSF> createState() => _TnCSFState();
}

class _TnCSFState extends State<TnCSF> {
  List<String> balancePmtList = ['Upon Completion', 'Progress Claims'];
  List<String> progressPmtList = ['Weekly', 'Fortnightly'];
  List<String> validityPrdList = ['2 weeks', '1 month'];

  @override
  Widget build(BuildContext context) {
    int selectedBPIndex = getSelectedIndex("balance payment");
    int selectedPPIndex = getSelectedIndex("progress payment");
    int selectedVPIndex = getSelectedIndex("validity period");

    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: Text('Balance Payment', style: TextStyle(decoration: TextDecoration.underline))),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            //radio btns
            Expanded(
                child: RadioGroup(
                    display: balancePmtList[0],
                    radioIndex: 0,
                    selectedIndex: selectedBPIndex,
                    onChange: (){
                      setState((){
                        widget.quotation!.tnC.balancePmt = balancePmtList[0];
                      });
                    }
                )
            ),
            Expanded(
                child: RadioGroup(
                    display: balancePmtList[1],
                    radioIndex: 1,
                    selectedIndex: selectedBPIndex,
                    onChange: (){
                      setState((){
                        widget.quotation!.tnC.balancePmt = balancePmtList[1];
                      });
                    }
                )
            ),
          ],
        ),
        Visibility(
          visible: (selectedBPIndex == 1) ? true : false,
          child: Row(
            children: <Widget>[
              //radio btns
              Expanded(
                  child: RadioGroup(
                      display: progressPmtList[0],
                      radioIndex: 0,
                      selectedIndex: selectedPPIndex,
                      onChange: (){
                        setState((){
                          widget.quotation!.tnC.progressPmt = progressPmtList[0];
                        });
                      }
                  )
              ),
              Expanded(
                  child: RadioGroup(
                      display: progressPmtList[1],
                      radioIndex: 1,
                      selectedIndex: selectedPPIndex,
                      onChange: (){
                        setState((){
                          widget.quotation!.tnC.progressPmt = progressPmtList[1];
                        });
                      }
                  )
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Align(alignment: Alignment.centerLeft, child:Text('Validity Period', style: TextStyle(decoration: TextDecoration.underline))),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            //radio btns
            Expanded(
                child: RadioGroup(
                    display: validityPrdList[0],
                    radioIndex: 0,
                    selectedIndex: selectedVPIndex,
                    onChange: (){
                      setState((){
                        widget.quotation!.tnC.validityPrd = validityPrdList[0];
                      });
                    }
                )
            ),
            Expanded(
                child: RadioGroup(
                    display: validityPrdList[1],
                    radioIndex: 1,
                    selectedIndex: selectedVPIndex,
                    onChange: (){
                      setState((){
                        widget.quotation!.tnC.validityPrd = validityPrdList[1];
                      });
                    }
                )
            ),
          ],
        ),
      ],
    );
  }

  getSelectedIndex(String type){
    if(type == "balance payment"){
      switch(widget.quotation!.tnC.balancePmt){
        case "Upon Completion":
          return 0;
        case "Progress Claims":
          return 1;
        default:
          return;
      }
    }
    else if(type == "validity period"){
      switch(widget.quotation!.tnC.validityPrd){
        case "2 weeks":
          return 0;
        case "1 month":
          return 1;
        default:
          return;
      }
    }
    else{
      switch(widget.quotation!.tnC.progressPmt){
        case "Weekly":
          return 0;
        case "Fortnightly":
          return 1;
        default:
          return;
      }
    }
  }
}