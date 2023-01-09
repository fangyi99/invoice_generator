import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_generator/page/quotationForm.dart';
import 'package:invoice_generator/page/userForm.dart';
import '../model/quotation.dart';
import '../util/quotationDB.dart';
import '../util/userDB.dart';
import '../model/user.dart';

class Database extends StatelessWidget {
  String? exportType;
  Database({super.key, this.exportType});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: DefaultTabController(
        initialIndex: exportType == "user" ? 1 : 0,
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
              ValueListenableBuilder<Box<Quotation>>(
                  valueListenable: QuotationDB.getQuotations().listenable(),
                  builder: (context, box, _){
                    final quotations = box.values.toList().cast<Quotation>();
                    return buildQuotationList(quotations);
                  }
              ),
              ValueListenableBuilder<Box<User>>(
                  valueListenable: UserDB.getUsers().listenable(),
                  builder: (context, box, _){
                    final users = box.values.toList().cast<User>();
                    return buildUserList(users);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuotationList(List<Quotation> quotations) {
    if (quotations.isEmpty) {
      return const Center(
        child: Text(
          'No quotations yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: quotations.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = quotations[index];

                return buildQuotationCard(context, index, transaction);
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => QuotationForm(formType: "quotation", formMode: "duplicate", data: widget.filteredQuotationList[index])),
                // );
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
                QuotationDB.deleteQuotation(context, quotation);
              },
            )
          ],
        ),
        child: ListTile(
          title: Text(quotation.fileName),
          onTap: () => {
            if(exportType == "quotation"){
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
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No users yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = users[index];

                return buildUserCard(context, index, transaction);
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
                UserDB.deleteUser(context, user);
              },
            )
          ],
        ),
        child: ListTile(
          title: Text(user.name),
          subtitle: (user.company != '') ? Text(user.company!) : null,
          onTap: () => {
            if(exportType == "user"){
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
  }
}