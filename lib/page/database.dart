import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_generator/page/userForm.dart';
import '../util/userDB.dart';
import '../model/user.dart';

class Database extends StatelessWidget {
  Database({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: DefaultTabController(
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
                  icon: Icon(Icons.add),
                  onPressed: () => {
                    navigateAndDisplayToastMsg(context, null)
                  }
              )
            ],
          ),
          body: TabBarView(
            children: [
              Text("Quotation"),
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

  Widget buildUserList(List<User> users) {
    if (users.isEmpty) {
      return Center(
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
              padding: EdgeInsets.all(8),
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
          motion: DrawerMotion(),
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
            // if(widget.export == true){
            //   Navigator.pop(context, widget.filteredUserList[index])
            // }else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserForm(formMode: 'read', user: user)),
              )
            // }
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