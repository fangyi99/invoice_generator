// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_generator/model/tnC.dart';
import 'package:invoice_generator/model/item.dart';
import 'package:invoice_generator/model/itemSection.dart';
import 'package:invoice_generator/model/transport.dart';
import 'package:invoice_generator/model/user.dart';
import 'package:invoice_generator/page/database.dart';
import 'package:invoice_generator/page/invoiceForm.dart';
import 'package:invoice_generator/page/quotationForm.dart';
import 'package:invoice_generator/util/quotationDB.dart';

import 'model/addOn.dart';
import 'model/deduction.dart';
import 'model/deposit.dart';
import 'model/invoice.dart';
import 'model/omission.dart';
import 'model/quotation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // initialize hive
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(ItemSectionAdapter());
  Hive.registerAdapter(TransportAdapter());
  Hive.registerAdapter(TnCAdapter());
  Hive.registerAdapter(QuotationAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Quotation>('items');
  await Hive.openBox<Quotation>('itemSections');
  await Hive.openBox<Quotation>('transports');
  await Hive.openBox<Quotation>('tnCs');
  await Hive.openBox<Quotation>('quotations');

  runApp(
      const MaterialApp(
        home: Index(),
        debugShowCheckedModeBanner: false,
    )
  );
}

class Index extends StatelessWidget{

  const Index({super.key});

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Invoice Generator'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Image.asset('assets/images/starter.png'),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            onPressed: () async {

                              var quotation = Quotation(fileName: "", documentID: "", term: "C.O.D", subjectTitle: "", itemSupply: "Labour & Materials",
                                  date: DateTime.now(), user: User(), itemSections: [ItemSection(type:"Default", itemList: [Item()])], transport: Transport(type: "Two Way"), tnC: TnC());

                              QuotationDB.createQuotation(quotation).then((value) => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => QuotationForm(
                                  formMode: "create",
                                  quotation: quotation
                                  ))
                                )
                              });

                            },
                            child: const Text(
                              'Q U O T A T I O N',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            child: const Text(
                              'I N V O I C E',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InvoiceForm(
                                    formMode: "create",
                                    invoice: Invoice("", "", "C.O.D", "", "Labour & Materials", DateTime.now(),User(),[ItemSection(type:"Default", itemList: [Item()])], Transport(), [AddOn()], [Deduction(omissions: [Omission()])], [Deposit()])
                                ))
                              )
                            }
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Database()),
                              )
                            },
                            child: const Text(
                              'D A T A B A S E',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}