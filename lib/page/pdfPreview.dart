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
  final String? filePath, fileSubj;
  // final String? quoteRef, formMode, formType;

  PDFPreview({this.quotation, this.invoice, required this.filePath, required this.fileSubj});

  @override
  State<PDFPreview> createState() => PDFPreviewState();
}

class PDFPreviewState extends State<PDFPreview>{
  int totalPages = 0;
  int currentPage = 0;
  bool pdfReady = false;
  Quotation? quotation;
  Invoice? invoice;
  late bool isQuotation;
  late PDFViewController pdfViewController;

  @override
  void initState() {
    super.initState();
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
                // if(defaultTargetPlatform == TargetPlatform.windows){
                //   print('sharing files on desktop...');
                //   Share.shareXFiles([XFile(widget.filePath!, name:'testSub.pdf')], subject: widget.fileSubj);
                // }
                // else if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS){
                //   print('sharing files on mobile...');
                //   Share.shareFiles([widget.filePath!], subject: widget.fileSubj);
                // }
                // else{
                //   print("Sharing of files is not supported on this platform");
                //   Snackbar.createToastMsg(context, 'Sharing of files is not supported on this platform.', Colors.red[400]);
                // }
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