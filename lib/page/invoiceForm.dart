import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/page/pdfPreview.dart';
import 'package:invoice_generator/widget/form/billingSF.dart';
import 'package:invoice_generator/widget/form/documentSF.dart';
import 'package:invoice_generator/widget/form/itemSF.dart';
import 'package:invoice_generator/widget/form/transport.dart';
import '../model/invoice.dart';
import '../util/pdfTemplate.dart';
import '../widget/form/addOnSF.dart';
import '../widget/form/deductionSF.dart';
import '../widget/form/depositSF.dart';
import '../widget/popup.dart';

class InvoiceForm extends StatefulWidget {
  
  String formMode;
  Invoice invoice;
  InvoiceForm({super.key, required this.invoice, required this.formMode});

  @override
  State<InvoiceForm> createState() => InvoiceFormState();
}

class InvoiceFormState extends State<InvoiceForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await Popup.exitDialog(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Invoice Form"),
        ),
        body: Stepper(
          type: StepperType.horizontal,
          steps: formSteps(),
          currentStep: currentStep,
          onStepTapped: (step){
            setState((){
              currentStep = step;
            });
          },
          onStepContinue: (){
            if(currentStep < formSteps().length){
              setState(() {
                currentStep = currentStep + 1;
              });
            }
          },
          onStepCancel: (){
            setState(() {
              if(currentStep > 0){
                currentStep = currentStep - 1;
              }else{
                currentStep = 0;
              }
            });
          },
          controlsBuilder: (context, controls) {
            final isLastStep = currentStep == formSteps().length - 1;
            return Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 15),
              child: Row(
                children: [if (currentStep > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controls.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLastStep ? previewPDF : controls.onStepContinue,
                      child: (isLastStep)
                          ? const Text('View Preview')
                          : const Text('Next'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //stepper sections
  List<Step> formSteps() {
    List<Step> steps = [
      Step(
        title: const SizedBox.shrink(),
        content: DocumentSF(
            mode: widget.formMode,
            invoice: widget.invoice
        ),
        isActive: currentStep >= 0,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: BillingSF(invoice: widget.invoice),
        isActive: currentStep >= 1,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: ItemSF(invoice: widget.invoice),
        isActive: currentStep >= 2,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: TransportSF(invoice: widget.invoice),
        isActive: currentStep >= 3,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: AddOnSF(invoice: widget.invoice),
        isActive: currentStep >= 4,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: DeductionSF(invoice: widget.invoice),
        isActive: currentStep >= 5,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: DepositSF(invoice: widget.invoice),
        isActive: currentStep >= 6,
      )
    ];
    return steps;
  }

  previewPDF() async {
    final pdfFile;
    pdfFile = await PDFTemplate.generatePDF(null, widget.invoice);

    //navigate to PDF Preview page
    if(pdfFile.path != null){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => PDFPreview(
              quotation: null,
              invoice: widget.invoice,
              filePath: pdfFile.path,
              fileSubj: widget.invoice!.subjectTitle
          )
      ));
    }
  }
}