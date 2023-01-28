import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:invoice_generator/page/quotationForm.dart';
import 'package:share_plus/share_plus.dart';

import '../model/invoice.dart';
import '../model/quotation.dart';
import '../widget/popup.dart';

class PDFPreview extends StatefulWidget{

  final Quotation? quotation;
  final Invoice? invoice;
  final String? filePath;

  PDFPreview({this.quotation, this.invoice, required this.filePath});

  @override
  State<PDFPreview> createState() => PDFPreviewState();
}

class PDFPreviewState extends State<PDFPreview>{
  int totalPages = 0;
  int currentPage = 0;
  bool pdfReady = false;
  late dynamic document;
  late bool isQuotation;
  late PDFViewController pdfViewController;

  @override
  void initState() {
    super.initState();

    if(widget.quotation != null){
      isQuotation = true;
      document = widget.quotation;
    }
    else{
      isQuotation = false;
      document = widget.invoice;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
        actions: [
          Visibility(
            visible: isQuotation,
            child: IconButton(
                icon: Icon(Icons.save),
                color: QuotationForm.saved ? Colors.white38 : Colors.white,
                onPressed: (){
                  if(QuotationForm.saved == true){
                    Popup.createToastMsg(context, 'Quotation is up to date', Colors.lightGreen[600]);
                  }
                  else{
                    widget.quotation!.save();
                    setState(() {
                      QuotationForm.saved = true;
                    });
                    Popup.createToastMsg(context, 'Quotation saved', Colors.lightGreen[600]);
                  }
                }
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                Share.shareXFiles([XFile(widget.filePath!, name: '${document.fileName}.pdf')], subject: document.subjectTitle);
              }
          ),
          IconButton(
              icon: Icon(Icons.home_filled),
              onPressed: (){
                if(QuotationForm.saved == false){
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: Text("Leave quotation?"),
                    content: Text("Changes you made so far will not be saved"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text("CANCEL")),
                      TextButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: Text("YES"))
                    ],
                  ));
                }
                else{
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              }
          ),
        ],
      ),
      body: Stack(
          children: [
            PDFView(
              filePath: widget.filePath,
              autoSpacing: true,
              pageSnap: true,
              swipeHorizontal: true,
              onError: (e) => print(e),
              onRender: (pages){
                setState(() {
                  totalPages = pages!;
                  pdfReady = true;
                });
              },
              onViewCreated: (PDFViewController vc){
                pdfViewController = vc;
              },
            ),
            !pdfReady ? Center(child: CircularProgressIndicator()) : Offstage()
          ]
      ),
    );
  }

}