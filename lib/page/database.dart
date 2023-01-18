import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_generator/page/quotationForm.dart';
import 'package:invoice_generator/page/userForm.dart';
import '../model/quotation.dart';
import '../util/quotationDB.dart';
import '../util/userDB.dart';
import '../model/user.dart';
import '../widget/popup.dart';

class Database extends StatefulWidget {
  String? exportType;
  String userSearchQuery = "";
  String quotationSearchQuery = "";

  Database({super.key, this.exportType});

  @override
  State<Database> createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: DefaultTabController(
        initialIndex: widget.exportType == "user" ? 1 : 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Database'),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Quotation"),
                Tab(text: 'User'),
              ],
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => {
                    navigateAndDisplayToastMsg(context, null)
                  }
              )
            ],
          ),
          body: TabBarView(
            children: [
              Column(children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: TextField(
                      // controller: widget.quotationSearchQuery,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search for Quotations',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value){
                        setState(() {
                          widget.quotationSearchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<Box<Quotation>>(
                        valueListenable: QuotationDB.getQuotations().listenable(),
                        builder: (context, box, _){
                          final quotations = box.values.toList().cast<Quotation>();
                          return buildQuotationList(quotations);
                        }
                    ),
                  ),
                ]),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: TextField(
                        // controller: widget.userSearchQuery,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search for Customers',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      onChanged: (value){
                          setState(() {
                            widget.userSearchQuery = value;
                          });
                      },
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: UserDB.getUsers().listenable(),
                        builder: (context, box, _){
                          final users = box.values.toList();
                          return buildUserList(users);
                        }
                    ),
                  ),
                ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuotationList(List<Quotation> quotations) {
    final allQuotations = quotations;
    var filteredQuotations;

    if(widget.quotationSearchQuery!=""){
      filteredQuotations = allQuotations.where((quotation) => quotation.fileName.toLowerCase().contains(widget.quotationSearchQuery.toLowerCase())).toList();
    }else{
      filteredQuotations = allQuotations;
    }

    if (allQuotations.isEmpty) {
      return const Center(
        child: Text(
          'No quotations yet!',
          style: TextStyle(fontSize: 24),
        ),
      );

    }
    else if (filteredQuotations.isEmpty) {
      return const Center(
        child: Text(
          'No results found!',
          style: TextStyle(fontSize: 24),
        ),
      );
    }
    else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              key: ValueKey(widget.quotationSearchQuery),
              padding: const EdgeInsets.all(8),
              itemCount: filteredQuotations.length,
              itemBuilder: (BuildContext context, int index) {
                final quotation = filteredQuotations[index];

                return buildQuotationCard(context, index, quotation);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildQuotationCard(BuildContext context, int index, Quotation quotation) {

    return Card(
      child: Slidable(
        key: ValueKey(index),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.orangeAccent,
              icon: Icons.copy,
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuotationForm(formMode: 'duplicate', quotation: quotation)),
                );
              },
            ),
            SlidableAction(
              backgroundColor: Colors.blue,
              icon: Icons.edit,
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuotationForm(formMode: 'update', quotation: quotation)),
                );
              },
            ),
            SlidableAction(
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) {
                QuotationDB.deleteQuotation(_scaffoldKey.currentContext!, "db", quotation);
              },
            )
          ],
        ),
        child: ListTile(
          title: Text(quotation.fileName),
          onTap: () => {
            if(widget.exportType == "quotation"){
              //navigate to invoice form to use quotation
              Navigator.pop(context, quotation)
            }else{
                //navigate to quotation form to update quotation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuotationForm(formMode: 'update', quotation: quotation)),
                )
            }
          },
        ),
      ),
    );
  }

  Widget buildUserList(List<User> users) {
    final allUsers = users;
    var filteredUsers;

    if(widget.userSearchQuery!=""){
      filteredUsers = allUsers.where((user) =>
        user.name.toLowerCase().contains(widget.userSearchQuery.toLowerCase()) ||
        user.company!.toLowerCase().contains(widget.userSearchQuery.toLowerCase()))
      .toList();

    }else{
      filteredUsers = allUsers;
    }

    if (allUsers.isEmpty) {
      return const Center(
        child: Text(
          'No users yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    }
    else if(filteredUsers.isEmpty){
      return const Center(
        child: Text(
          'No results found!',
          style: TextStyle(fontSize: 24),
        ),
      );
    }
    else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              key: ValueKey(widget.userSearchQuery),
              padding: const EdgeInsets.all(8),
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final user = filteredUsers[index];

                return buildUserCard(context, index, user);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildUserCard(BuildContext context, int index, User user) {

    return Card(
      child: Slidable(
        key: ValueKey(index),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.blue,
              label: 'Edit',
              icon: Icons.edit,
              onPressed: (context) {
                navigateAndDisplayToastMsg(context, user);
              },
            ),
            SlidableAction(
              backgroundColor: Colors.red,
              label: 'Delete',
              icon: Icons.delete,
              onPressed: (context) {
                UserDB.deleteUser(_scaffoldKey.currentContext!, user);
              },
            )
          ],
        ),
        child: ListTile(
          title: Text(user.name),
          subtitle: (user.company != '') ? Text(user.company!) : null,
          onTap: () => {
            if(widget.exportType == "user"){
              Navigator.pop(context, user)
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserForm(formMode: 'read', user: user)),
              )
            }
          },
        ),
      ),
    );
  }

  Future<void> navigateAndDisplayToastMsg(BuildContext context, User?user) async{
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserForm(formMode: 'edit', user: user)),
    );

    if(!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbar and show the new result.
    if(result!=null){
      Popup.displayReturnedMsg(_scaffoldKey.currentContext!, result["msg"], result["bgColor"]);
    }
  }
}