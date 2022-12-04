import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invoice_generator/util/userDB.dart';
import '../model/user.dart';

class UserForm extends StatefulWidget {

  String formMode;
  User? user;

  UserForm({required this.formMode, this.user});

  @override
  State<UserForm> createState() => UserFormState();

}

class UserFormState extends State<UserForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // @override
  // void dispose(){
  //   Hive.close();
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    final TextEditingController companyController = TextEditingController(text: widget.user?.company ?? "");
    final TextEditingController nameController = TextEditingController(text: widget.user?.name ?? "");
    final TextEditingController addressL1Controller = TextEditingController(text: widget.user?.address1 ?? "");
    final TextEditingController addressL2Controller = TextEditingController(text: widget.user?.address2 ?? "");
    final TextEditingController addressL3Controller = TextEditingController(text: widget.user?.address3 ?? "");
    final TextEditingController postalCodeController = TextEditingController(text: widget.user?.postalCode ?? "");
    final TextEditingController countryCodeController = TextEditingController(text: widget.user?.hdphCC ?? "65");
    final TextEditingController hdphController = TextEditingController(text: widget.user?.hdph ?? "");
    final TextEditingController countryCode2Controller = TextEditingController(text: widget.user?.officeCC ?? "65");
    final TextEditingController officeController = TextEditingController(text: widget.user?.office ?? "");
    final TextEditingController emailController = TextEditingController(text: widget.user?.email ?? "");

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: (widget.user!=null) ? ((widget.formMode == "edit") ? Text('Edit User') : Text('User Details')) : Text('Add a User'),
        actions: [
          Visibility(
            visible: widget.user!=null && widget.formMode == "read",
            child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    widget.formMode = "edit";
                  });
                }
            ),
          ),
          Visibility(
            visible: widget.user!=null && widget.formMode == "edit",
            child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  UserDB.deleteUser(context, widget.user!);
                }
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 5.0),
                TextFormField(
                  enabled: widget.formMode=="edit",
                  controller: companyController,
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                    hintText: 'ABC Company',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: widget.formMode=="edit",
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Addressee / Attn *',
                    hintText: 'Ms Emma',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if(value == null || value.isEmpty)
                      return 'This field is required.';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: widget.formMode=="edit",
                  controller: addressL1Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 1 *',
                    hintText: '39 Scotts Road',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if(value == null || value.isEmpty)
                      return 'This field is required.';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: widget.formMode=="edit",
                  controller: addressL2Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 2 *',
                    hintText: '#12-9181',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if(value == null || value.isEmpty)
                      return 'This field is required.';
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: widget.formMode=="edit",
                  controller: addressL3Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 3',
                    hintText: 'The Inlands',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: widget.formMode=="edit",
                  controller: postalCodeController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('S'),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    labelText: 'Postal Code',
                    hintText: '123456',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          enabled: widget.formMode=="edit",
                          controller: countryCodeController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('\+'),
                            ),
                            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            labelText: 'Ctry *',
                            hintText: '65',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if(value == null || value.isEmpty)
                              return 'This field is required.';
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        enabled: widget.formMode=="edit",
                        controller: hdphController,
                        decoration: InputDecoration(
                          labelText: 'Hdph *',
                          hintText: '1234 1234',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if(value == null || value.isEmpty)
                            return 'This field is required.';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          enabled: widget.formMode=="edit",
                          controller: countryCode2Controller,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('\+'),
                            ),
                            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            labelText: 'Ctry',
                            hintText: '65',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        enabled: widget.formMode=="edit",
                        controller: officeController,
                        decoration: InputDecoration(
                          labelText: 'Office',
                          hintText: '1234 1234',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: widget.formMode=="edit",
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'emma@gmail.com',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    String pattern = r'\w+@\w+\.\w+';
                    if(value!=null && value.isNotEmpty){
                      if(!RegExp(pattern).hasMatch(value))
                        return 'Invalid email format';
                    }
                  },
                ),
                SizedBox(height: 15),
                Visibility(
                  visible: widget.formMode=="edit",
                  child: ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        final user = {
                          "company": companyController.text,
                          "name": nameController.text,
                          "address1": addressL1Controller.text,
                          "address2": addressL2Controller.text,
                          "address3": addressL3Controller.text,
                          "postalCode": postalCodeController.text,
                          "hdphCC": countryCodeController.text,
                          "hdph": hdphController.text,
                          "officeCC": countryCode2Controller.text,
                          "office": officeController.text,
                          "email": emailController.text
                        };
                        
                        (widget.user != null) ? UserDB.updateUser(_scaffoldKey.currentContext!, widget.user!, user) : UserDB.createUser(_scaffoldKey.currentContext!, user);
                      }
                    },
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}