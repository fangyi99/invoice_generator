import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/model/quotation.dart';
import 'package:invoice_generator/page/pdfPreview.dart';
import 'package:invoice_generator/util/quotationDB.dart';
import 'package:invoice_generator/widget/form/billingSF.dart';
import 'package:invoice_generator/widget/form/documentSF.dart';
import 'package:invoice_generator/widget/form/itemSF.dart';
import 'package:invoice_generator/widget/form/transport.dart';
import '../util/pdfTemplate.dart';
import '../widget/form/tncSF.dart';
import '../widget/popup.dart';

class QuotationForm extends StatefulWidget {

  final String formMode;
  static bool saved = false;
  Quotation? quotation;
  QuotationForm({Key? key, required this.formMode, required this.quotation}) : super(key: key);

  @override
  State<QuotationForm> createState() => QuotationFormState();
}

class QuotationFormState extends State<QuotationForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>()];
  int currentStep = 0;

  @override
  initState(){
    if(widget.formMode == "create"){
      QuotationForm.saved = false;
    }else{
      QuotationForm.saved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.formMode=="create" && QuotationForm.saved == false){
          final shouldPop = await Popup.exitDialog(context);
          if(shouldPop == true){
            QuotationDB.deleteQuotation(context, "form", widget.quotation!);
          }
          return shouldPop ?? false;
        }
        else{
          return true;
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
          title: const Text("Quotation Form"),
          ),
          body: Stepper(
            type: StepperType.horizontal,
            steps: formSteps(),
            currentStep: currentStep,
            onStepTapped: (step){
              if((currentStep == 0 || currentStep == 1) ? _formKeys[currentStep].currentState!.validate() : true){
                setState((){
                  currentStep = step;
                });
              }
            },
            onStepContinue: (){
              if(currentStep < formSteps().length && ((currentStep == 0 || currentStep == 1) ? _formKeys[currentStep].currentState!.validate() : true)){
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
        content: Form(
          key: _formKeys[0],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: DocumentSF(
              mode: widget.formMode,
              quotation: widget.quotation
          ),
        ),
        isActive: currentStep >= 0,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: Form(
            key: _formKeys[1],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: BillingSF(quotation: widget.quotation)
        ),
        isActive: currentStep >= 1,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: ItemSF(quotation: widget.quotation),
        isActive: currentStep >= 2,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: TransportSF(quotation: widget.quotation),
        isActive: currentStep >= 3,
      ),
      Step(
        title: const SizedBox.shrink(),
        content: TnCSF(quotation: widget.quotation),
        isActive: currentStep >= 4,
      )
    ];
    return steps;
  }

  previewPDF() async {

    if(_formKeys.every((key) => key.currentState!.validate())){
      final pdfFile;
      pdfFile = await PDFTemplate.generatePDF(widget.quotation, null);

      //navigate to PDF Preview page
      if(pdfFile.path != null){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => PDFPreview(
                quotation: widget.quotation,
                invoice: null,
                filePath: pdfFile.path,
            )
        ));
      }
    }
    //prompt error if form is invalid
    else{
      Popup.createToastMsg(context, 'Form Validation Error.\nPlease correct the marked fields in order to continue.', Colors.red[400]);
    }
  }

}