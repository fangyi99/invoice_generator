import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/widget/form/billingSF.dart';
import 'package:invoice_generator/widget/form/documentSF.dart';
import 'package:invoice_generator/widget/form/itemSF.dart';
import 'package:invoice_generator/widget/form/transport.dart';
import '../model/invoice.dart';
import '../widget/form/addOnSF.dart';
import '../widget/form/deductionSF.dart';
import '../widget/form/depositSF.dart';

class InvoiceForm extends StatefulWidget {

  String formMode;
  Invoice invoice;
  InvoiceForm({required this.invoice, required this.formMode});

  @override
  State<InvoiceForm> createState() => InvoiceFormState();
}

class InvoiceFormState extends State<InvoiceForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Invoice Form"),
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
            mode: widget.formMode,
            invoice: widget.invoice
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
        content: ItemSF(invoice: widget.invoice),
        isActive: currentStep >= 2,
      ),
      Step(
        title: SizedBox.shrink(),
        content: TransportSF(invoice: widget.invoice),
        isActive: currentStep >= 3,
      ),
      Step(
        title: SizedBox.shrink(),
        content: AddOnSF(invoice: widget.invoice),
        // content: TnCForm(balancePmtIndex: balancePmtIndex, progressIndex: progressIndex, validityPrdIndex: validityPrdIndex, onRadioChange: radioChangeCb),
        isActive: currentStep >= 4,
      ),
      Step(
        title: SizedBox.shrink(),
        content: DeductionSF(invoice: widget.invoice),
        // content: TnCForm(balancePmtIndex: balancePmtIndex, progressIndex: progressIndex, validityPrdIndex: validityPrdIndex, onRadioChange: radioChangeCb),
        isActive: currentStep >= 5,
      ),
      Step(
        title: SizedBox.shrink(),
        content: DepositSF(invoice: widget.invoice),
        // content: TnCForm(balancePmtIndex: balancePmtIndex, progressIndex: progressIndex, validityPrdIndex: validityPrdIndex, onRadioChange: radioChangeCb),
        isActive: currentStep >= 6,
      )
    ];
    return steps;
  }
}