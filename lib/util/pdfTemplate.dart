import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generator/util/pdfCreation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:number_to_words/number_to_words.dart';

import '../model/invoice.dart';
import '../model/quotation.dart';

class PDFTemplate{

  static Future<File> generatePDF(Quotation? quotation, Invoice? invoice,) async {

    bool isQuotation = (quotation != null) ? true : false;
    dynamic document = (isQuotation) ? quotation : invoice;

    final pdf = Document();
    final companyLogo = (await rootBundle.load('assets/images/retrodec_logo.png')).buffer.asUint8List();
    final valueItl = NumberFormat("#,##0.00", "en_US");
    const  primaryFontSize = 10.0;
    const  secondaryFontSize = 8.0;

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.only(left: 65, top: 35, right: 45, bottom: 30),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(pw.MemoryImage(companyLogo), width: 150),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children:[
                  pw.Text('Retro-dec Pte Ltd'.toUpperCase(), style: pw.TextStyle(fontWeight: FontWeight.bold, fontSize: primaryFontSize) ),
                  pw.Text('Blk 202B Punggol Field #03-248 Singapore 822202\nWebsite: www.retro-dec.com\nEmail: sales@retrodec.com | Tel: 6278 2402', style: const pw.TextStyle(fontSize: secondaryFontSize)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          buildInvoiceInfo(primaryFontSize, isQuotation, document),
          buildTitle(primaryFontSize, isQuotation, document),
          buildCostList(primaryFontSize, valueItl, isQuotation, document),
          pw.SizedBox(height: 20),

          if(isQuotation)
            buildTnC(primaryFontSize, quotation),

          buildClosure(primaryFontSize, isQuotation, document),
          pw.SizedBox(height: 20),
        ],
        footer: (context) => buildFooter(isQuotation, primaryFontSize)
    ));

    // List<int> bytes = await pdf.save();
    // return PdfCreation.saveDocument(bytes);
    return PdfCreation.saveDocument(name: document.fileName, pdf: pdf);
  }

  static pw.Widget buildInvoiceInfo(fontSize, isQuotation, document) {

    return document.user.company == '' ?

    pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(document.user.name, style: pw.TextStyle(fontSize: fontSize)),
            pw.Text(document.user.address1, style: pw.TextStyle(fontSize: fontSize)),
            pw.Text(document.user.address2, style: pw.TextStyle(fontSize: fontSize)),
            if(document.user.address3 != '')
              pw.Text(document.user.address1, style: pw.TextStyle(fontSize: fontSize)),
            pw.Text('Singapore ' + document.user.postalCode, style: pw.TextStyle(fontSize: fontSize)),
            pw.SizedBox(height: 10),
            pw.Table(
                children: [
                  pw.TableRow(
                      children: [
                        pw.Text("Hdph", style: pw.TextStyle(fontSize: fontSize)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                            child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                        ),
                        pw.Text('(+${document.user.hdphCC}) ${document.user.hdph}', style: pw.TextStyle(fontSize: fontSize)),
                      ]),
                  if (document.user.office != '')
                    pw.TableRow(
                        children: [
                          pw.Text("Office", style: pw.TextStyle(fontSize: fontSize)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                              child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                          ),
                          pw.Text('(+${document.user.officeCC}) ${document.user.office}', style: pw.TextStyle(fontSize: fontSize)),
                        ]),
                  if (document.user.email != '')
                    pw.TableRow(
                        children: [
                          pw.Text("Email", style: pw.TextStyle(fontSize: fontSize)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                              child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                          ),
                          pw.Text(document.user.email, style: pw.TextStyle(fontSize: fontSize)),
                        ]),
                ]
            ),
            pw.SizedBox(height: 20),
            pw.Text('Dear ' + document.user.name, style: pw.TextStyle(fontSize: fontSize)),
          ],
        ),
        pw.Table(
            children: [
              pw.TableRow(
                  children: [
                    pw.Text((!isQuotation) ? 'Invoice No.' : 'Our Ref', style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text(document.documentID, style: pw.TextStyle(fontSize: fontSize)),
                  ]),
              pw.TableRow(
                  children: [
                    pw.Text("Date", style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text(DateFormat('d-MMM-yyyy').format(document.date), style: pw.TextStyle(fontSize: fontSize)),
                  ]),
              pw.TableRow(
                  children: [
                    pw.Text("Term", style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text(document.term, style: pw.TextStyle(fontSize: fontSize)),
                  ]),
            ]
        )
      ],
    )
        :
    pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(document.user.company, style: pw.TextStyle(fontSize: fontSize)),
            pw.Text(document.user.address1, style: pw.TextStyle(fontSize: fontSize)),
            pw.Text(document.user.address2, style: pw.TextStyle(fontSize: fontSize)),
            if(document.user.address3 != '')
              pw.Text(document.user.address3, style: pw.TextStyle(fontSize: fontSize)),
            pw.Text('Singapore ' + document.user.postalCode, style: pw.TextStyle(fontSize: fontSize)),
            pw.SizedBox(height: 10),
            pw.Table(
                children: [
                  pw.TableRow(
                      children: [
                        pw.Text('Attn', style: pw.TextStyle(fontSize: fontSize)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                            child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                        ),
                        pw.Text(document.user.name, style: pw.TextStyle(fontSize: fontSize)),
                      ]),
                  pw.TableRow(
                      children: [
                        pw.Text("Hdph", style: pw.TextStyle(fontSize: fontSize)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                            child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                        ),
                        pw.Text('(+${document.user.hdphCC}) ${document.user.hdph}', style: pw.TextStyle(fontSize: fontSize)),
                      ]),
                  if (document.user.office != '')
                    pw.TableRow(
                        children: [
                          pw.Text("Office", style: pw.TextStyle(fontSize: fontSize)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                              child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                          ),
                          pw.Text('(+${document.user.officeCC}) ${document.user.office}', style: pw.TextStyle(fontSize: fontSize)),
                        ]),
                  if (document.user.email != '')
                    pw.TableRow(
                        children: [
                          pw.Text("Email", style: pw.TextStyle(fontSize: fontSize)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                              child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                          ),
                          pw.Text(document.user.email, style: pw.TextStyle(fontSize: fontSize)),
                        ]),
                ]
            ),
            pw.SizedBox(height: 30),
            pw.Text('Dear ' + document.user.name, style: pw.TextStyle(fontSize: fontSize)),
          ],
        ),
        pw.Table(
            children: [
              pw.TableRow(
                  children: [
                    pw.Text((!isQuotation) ? 'Invoice No.' : 'Our Ref', style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text(document.documentID, style: pw.TextStyle(fontSize: fontSize)),
                  ]),
              pw.TableRow(
                  children: [
                    pw.Text("Date", style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text(DateFormat('d-MMM-yyyy').format(document.date), style: pw.TextStyle(fontSize: fontSize)),
                  ]),
              pw.TableRow(
                  children: [
                    pw.Text("Term", style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text(document.term, style: pw.TextStyle(fontSize: fontSize)),
                  ]),
            ]
        )
      ],
    );
  }

  static pw.Widget buildTitle(fontSize, isQuotation, document) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        pw.Text(document.subjectTitle.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
        pw.SizedBox(height: 10),
        pw.Text(isQuotation ?
        'Thank you for the invitation extended to us to quote for the above.\nWe are pleased to submit our quotation for your consideration as follows: -'
            : 'Being claim for the above-mentioned job done as follows: -', style: pw.TextStyle(fontSize: fontSize)),
        pw.SizedBox(height: 10),
      ],
    );
  }

  static pw.Widget buildCostList(fontSize, valueItl, isQuotation, document) {

    var data, data2;
    var total;

    final headers = [
      '',
      'To Supply ' + document.itemSupply,
      'Total'
    ];

    //create item list (items + add-ons + transportation)
    var itemCost = createItemList(valueItl, isQuotation, data, document);
    data = itemCost[0];
    total = itemCost[1];

    if(!isQuotation) {
      //add total contract price
      data.add(['', 'Total Contract Price', '\$${total.toStringAsFixed(2)}']);

      //create deduction list (discount + omissions + downpayment)
      var deductionCost = createDeductionList(data, total, document);
      data = deductionCost[0];
      total = deductionCost[1];

      //add total amount payable
      data.add(['', 'Total Amount Payable', '\$${total.toStringAsFixed(2)}']);
    }

    //format total amount payable in text
    var totalToWords = total.toStringAsFixed(2).split('.');
    var dollars = totalToWords[0];
    var cents = totalToWords[1];
    if(dollars != '0') {
      if (cents != '00') {
        total = '${NumberToWord().convert(
            'en-in', int.parse(dollars))}and cents ${NumberToWord().convert(
            'en-in', int.parse(cents))}only';
      } else {
        total = '${NumberToWord().convert('en-in', int.parse(dollars))}only';
      }
      data2 = [['', '(Singapore Dollars: ${captilize(total)})']];
    }

    return pw.Container(
        child: pw.Column(
            children: [
              pw.Table.fromTextArray(
                headerAlignment: Alignment.center,
                headerStyle: TextStyle(fontSize: fontSize),
                cellStyle: TextStyle(fontSize: fontSize),
                cellAlignment: pw.Alignment.centerRight,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerRight,
                },
                cellPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                headers: headers,
                columnWidths: {
                  0: const pw.FractionColumnWidth(0.1),
                  1: const pw.FractionColumnWidth(0.6),
                  2: const pw.IntrinsicColumnWidth()
                },
                data: data,
              ),
              if(dollars != '0')
                pw.Table.fromTextArray(
                  headerAlignment: Alignment.centerLeft,
                  headerStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: fontSize),
                  cellPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  columnWidths: {
                    0: const pw.FractionColumnWidth(0.112),
                    1: const pw.FractionColumnWidth(0.8)
                  },
                  data: data2,
                ),
            ]
        )
    );
  }

  static createItemList(valueItl, isQuotation, data, document){

    var calculationList = [];
    data = [[]];
    var itemCounter = 1;

    //add item costs
    for(int i=0; i<document.itemList.length; i++){
      var item = document.itemList[i];
      if(item.methodStm != null && item.methodStm != ''){
        data.add([itemCounter, item.description + "\n- " + item.methodStm.replaceAll("\n", "\n- "), '\$${valueItl.format(item.amount)}']);
      }
      else{
        data.add([itemCounter, item.description, '\$${valueItl.format(item.amount)}']);
      }
      calculationList.add(item.amount);
      itemCounter++;
    }

    //add transport cost
    if(document.transport.type != 'None'){
      data.add([itemCounter, document.transport.type, '\$${valueItl.format(document.transport.amount)}']);
      itemCounter++;
      calculationList.add(document.transport.amount);
    }

    //calculate item cost
    var totalContractPrice = calculateContractPrice(calculationList);

    //add add-on cost
    if(!isQuotation){
      var addOnCost = addAddOnCost(data, totalContractPrice, document);
      data = addOnCost[0];
      totalContractPrice = addOnCost[1];
    }

    //add total contract price
    if(isQuotation){
      data.add(['', 'Total Contract Price', '\$${valueItl.format(totalContractPrice)}']);
    }

    return [data, totalContractPrice];

  }

  static addAddOnCost(data, total, document){
    //add add-on costs
    document.addOns.forEach((item) => {
      if(item.description.toString().isNotEmpty && item.description.toString().isNotEmpty){
        data.add(['Add', item.description, '\$${item.amount.toStringAsFixed(2)}']),
        total += item.amount,
      }
    });

    return [data, total];
  }

  static createDeductionList(data, total, document){
    var firstDeduction = true;

    //add deduction costs (discount + omissions)
    document.deductions.forEach((item) =>
    {
      if(item.type == 'Omit Items'){
        item.omissions.forEach((omitted) {
          if(omitted.description != "" && omitted.amount != 0) {
            if (firstDeduction) {
              data.add([
                'Less',
                'Omission of ${omitted['item']}',
                '\$${omitted['amount'].toStringAsFixed(2)}'
              ]);
              firstDeduction = false;
            } else {
              data.add([
                '',
                'Omission of ${omitted.description}',
                '\$${omitted.amount.toStringAsFixed(2)}'
              ]);
            }
            total -= omitted.amount;
          }
        })
      } else
        {
          if(item.amount != 0){
            if(firstDeduction){
              data.add([
                'Less',
                item.type,
                '\$${item.amount.toStringAsFixed(2)}'
              ]),
              firstDeduction = false
            } else
              {
                data.add([
                  '',
                  item.type,
                  '\$${item.amount.toStringAsFixed(2)}'
                ]),
              },
            total -= item.amount
          }
        }
    });

    //add downpayment costs
    document.deposits.forEach((item) => {
      if(item.amount != 0 && item.date.toString().isNotEmpty){
        if(firstDeduction){
          if(total - item.amount == 0){
            data.add([
              'Less',
              'Full Payment Received on ${DateFormat('d MMM yyyy').format(item.date)} thru '
                  '${item.method=='Cheque' ? ('Cheque No. ${item.bankName} ${item.chequeNo}') : item.method}',
              '\$${item.amount.toStringAsFixed(2)}'
            ]),
          }
          else if(item.type == 'Progress Payment'){
            data.add([
              'Less',
              '${progressCountString(item.progressCounter)} ${item.type} Received on ${DateFormat('d MMM yyyy').format(item.date)} thru '
                  '${item.method == 'Cheque' ? ('Cheque No. ${item.bankName} ${item.chequeNo}') : item.method}',
              '\$${item.amount.toStringAsFixed(2)}'
            ]),
          }else{
            data.add([
              'Less',
              '${item.type} Received on ${DateFormat('d MMM yyyy').format(item.date)} thru '
                  '${item.method == 'Cheque' ? ('Cheque No. ${item.bankName} ${item.chequeNo}') : item.method}',
              '\$${item.amount.toStringAsFixed(2)}'
            ]),
          },
          firstDeduction = false,
        } else {
          if(total - item.amount == 0){
            data.add([
              '',
              'Full Payment Received on ${DateFormat('d MMM yyyy').format(item.date)} thru '
                  '${item.method == 'Cheque' ? ('Cheque No. ${item.bankName} ${item.chequeNo}') : item.method}',
              '\$${item['amount'].toStringAsFixed(2)}'
            ]),
          }
          else if(item['type'] == 'Progress Payment'){
            data.add([
              '',
              '${progressCountString(item.progressCounter)} ${item.type} Received on ${DateFormat('d MMM yyyy').format(item.date)} thru '
                  '${item.method == 'Cheque' ? ('Cheque No. ${item.bankName} ${item.chequeNo}') : item.method}',
              '\$${item.amount.toStringAsFixed(2)}'
            ]),
          }else
            {
              data.add([
                '',
                '${item.type} Received on ${DateFormat('d MMM yyyy').format(item.date)} thru '
                    '${item.method == 'Cheque' ? ('Cheque No. ${item.bankName} ${item.chequeNo}') : item.method}',
                '\$${item.amount.toStringAsFixed(2)}'
              ])
            }
        },
        total -= item.amount
      }
    });

    return [data, total];
  }

  static calculateContractPrice(items){
    double totalContractPrice = 0;
    for(var i=0; i<items.length; i++){
      totalContractPrice += items[i];
    }
    return totalContractPrice;
  }

  static captilize(string){
    string = string.split(' ').map((str) => str[0].toUpperCase() + str.substring(1)).join(' ');
    return string;
  }

  static progressCountString(progressionCount){
    var progressionText;
    switch(progressionCount){
      case 1:
        progressionText = '1st';
        break;
      case 2:
        progressionText = '2nd';
        break;
      case 3:
        progressionText = '3rd';
        break;
      default:
        progressionText = progressionCount.toString().substring(0,1) + 'th';
    }
    return progressionText;
  }

  static pw.Widget buildTnC(fontSize, document) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Terms & Conditions: -', style: TextStyle(fontStyle: FontStyle.italic, fontSize: fontSize)),
      pw.Text('a)   35% Down Payment upon confirmation of quotation.', style: pw.TextStyle(fontSize: fontSize)),
      pw.Text('b)   ${document.tnC.balancePmt == 'Progress Claims' ?
      'Balance Payment: ${document.tnC.balancePmt} every ${document.tnC.progressPmt.toString().toLowerCase()}.'
          : 'Balance payment upon completion of work done.'}', style: TextStyle(fontSize: fontSize)),
      pw.Text('c)   Validity Period of this quotation is ${document.tnC.validityPrd}.', style: TextStyle(fontSize: fontSize)),
      pw.Text('d)   Holding cost of \$100/mth will be charged after completion of work done.', style: TextStyle(fontStyle: FontStyle.italic, fontSize: fontSize)),
      pw.SizedBox(height: 10),
    ],
  );

  static pw.Widget buildClosure(fontSize, isQuotation, document) => isQuotation ?

  pw.Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pw.Text('We trust that the above is in order, and look forward to your favourable reply.\n\nThank you.', textAlign: TextAlign.left, style: TextStyle(fontSize: fontSize)),
        pw.SizedBox(height: 40),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Yours faithfully', style: TextStyle(fontSize: fontSize)),
                    pw.Text('Retro-Dec Pte Ltd', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                    pw.Text('Ronnie Ong', style: TextStyle(fontSize: fontSize)),
                    pw.Text('Hdph: 9823 1248', style: TextStyle(fontSize: fontSize)),
                  ]
              ),
              Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Acceptable by', style: TextStyle(fontSize: fontSize)),
                    pw.Text(document.user.company, style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                    pw.Text(document.user.name, style: TextStyle(fontSize: fontSize)),
                  ]
              )
            ]
        )
      ]
  ) :

  pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('We trust that the above is in order, please do not hesitate to contact us should you require further clarification.', style: TextStyle(fontSize: fontSize)),
        pw.SizedBox(height: 10),
        pw.Text('Thank you.', style: TextStyle(fontSize: fontSize)),
        pw.SizedBox(height: 20),
        pw.Text('Retro-Dec Pte Ltd', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
        pw.Text('Ronnie Ong', style: TextStyle(fontSize: fontSize)),
        pw.Text('Hdph: 9823 1248', style: TextStyle(fontSize: fontSize)),
      ]
  );

  static pw.Widget buildFooter(isQuotation, fontSize) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Bank Details'.toUpperCase(), style: pw.TextStyle(decoration: pw.TextDecoration.underline, fontSize: fontSize)),
      pw.Container(
        width: 200,
        child: pw.Table(
            children: [
              pw.TableRow(
                  children: [
                    pw.Text('Beneficiary Name', style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text('Retro-Dec Pte Ltd', style: pw.TextStyle(fontSize: fontSize)),
                  ]
              ),
              pw.TableRow(
                  children: [
                    pw.Text("Account Number", style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text('004-020427-1', style: pw.TextStyle(fontSize: fontSize)),
                  ]
              ),
              pw.TableRow(
                  children: [
                    pw.Text("DBS Bank Code", style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text('7171', style: pw.TextStyle(fontSize: fontSize)),
                  ]
              ),
              pw.TableRow(
                  children: [
                    pw.Text("PayNow / Transfer", style: pw.TextStyle(fontSize: fontSize)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: pw.Text(":", style: pw.TextStyle(fontSize: fontSize))
                    ),
                    pw.Text('199508856W', style: pw.TextStyle(fontSize: fontSize)),
                  ]
              ),
            ]
        ),
      ),
      pw.SizedBox(height: 20),
      if(!isQuotation)
        pw.Text('This is computer generated invoice no signature required.', style: pw.TextStyle(fontSize: fontSize)),
      pw.SizedBox(height: 20),
    ],
  );
}