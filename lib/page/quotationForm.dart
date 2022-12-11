import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/model/quotation.dart';
import 'package:invoice_generator/widget/staticForm/billingSF.dart';
import 'package:invoice_generator/widget/staticForm/documentSF.dart';
import 'package:invoice_generator/widget/staticForm/itemSF.dart';
import 'package:invoice_generator/widget/staticForm/transport.dart';
import '../widget/staticForm/tncSF.dart';

class QuotationForm extends StatefulWidget {

  final String formMode;
  Quotation? quotation;
  QuotationForm({required this.formMode, required this.quotation});

  @override
  State<QuotationForm> createState() => QuotationFormState();
}

class QuotationFormState extends State<QuotationForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        title: Text("Quotation Form"),
        ),
        body: Stepper(
          type: StepperType.horizontal,
          steps: formSteps(),
          currentStep: currentStep,
          onStepTapped: (step){
            setState((){
              this.currentStep = step;
            });
          },
          onStepContinue: (){
            setState(() {
              if(this.currentStep < formSteps().length){
                this.currentStep = this.currentStep + 1;
              }
            });
          },
          onStepCancel: (){
            setState(() {
              if(this.currentStep > 0){
                this.currentStep = this.currentStep - 1;
              }else{
                this.currentStep = 0;
              }
            });
          },
        ),
    );
  }

  //stepper sections
  List<Step> formSteps() {
    List<Step> steps = [
      Step(
        title: SizedBox.shrink(),
        content: DocumentSF(
            type: "quotation",
            mode: widget.formMode,
            quotation: widget.quotation
        ),
        isActive: currentStep >= 0,
      ),
      Step(
        title: SizedBox.shrink(),
        content: BillingSF(),
        isActive: currentStep >= 1,
      ),
      Step(
        title: SizedBox.shrink(),
        content: ItemSF(quotation: widget.quotation),
        // content: ItemListSF(supplyTypeIndex: supplyTypeIndex, onSupplyTypeChange: radioChangeCb, itemSections: itemSections, onAddItemSection: onAddItemSection, onSaveItemSection: onSaveItemSection, onDeleteItemSection: onDeleteItemSection, itemSectionValues: itemSectionDropdownValues, onItemSectionChange: onItemSectionDropdownChange),
        isActive: currentStep >= 2,
      ),
      Step(
        title: SizedBox.shrink(),
        content: TransportSF(quotation: widget.quotation),
        // content: TransportationForm(radioIndex: transportIndex, onRadioChange: radioChangeCb, controllers: transportControllers),
        isActive: currentStep >= 3,
      ),
      Step(
        title: SizedBox.shrink(),
        content: TnCSF(quotation: widget.quotation),
        // content: TnCForm(balancePmtIndex: balancePmtIndex, progressIndex: progressIndex, validityPrdIndex: validityPrdIndex, onRadioChange: radioChangeCb),
        isActive: currentStep >= 4,
      )
    ];
    return steps;
  }
}