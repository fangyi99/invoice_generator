// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_generator/model/TnC.dart';
import 'package:invoice_generator/model/item.dart';
import 'package:invoice_generator/model/itemSection.dart';
import 'package:invoice_generator/model/transport.dart';
import 'package:invoice_generator/model/user.dart';
import 'package:invoice_generator/page/database.dart';
import 'package:invoice_generator/page/quotationForm.dart';

import 'model/quotation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

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
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => QuotationForm(
                                  formMode: "create",
                                  quotation: Quotation("", "", "C.O.D", "", "Labour & Materials", DateTime.now(),User(),[ItemSection(type:"Default", itemList: [Item()])], Transport(type: "Two Way"),TnC())
                                ),
                                )
                              )
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
                            onPressed: () => {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => DBQuotation(export: true)),
                              // )
                            },
                            child: const Text(
                              'I N V O I C E',
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