import 'package:flutter/material.dart';
import 'package:flutter_hive_db/models/contact.dart';
import 'package:hive/hive.dart';

class ContactForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  const ContactForm({Key key, this.isEdit = false, this.index = -1})
      : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formContactKey = GlobalKey<FormState>();
  Box contactsBox;
  Contact currentContact;

  String _name;
  String _email;
  String _phone;

  @override
  void initState() {
    contactsBox = Hive.box("contacts");
    super.initState();
  }

  void addContact(Contact contact) {
    contactsBox.add(contact);
  }

  void editContact(int index, Contact contact) {
    contactsBox.putAt(index, contact);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              blurRadius: 1.0, offset: Offset(0.0, 0.1), color: Colors.grey),
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formContactKey,
        child: Column(
          children: [
            Text(
              widget.isEdit ? "Edit Contact" : "New Contact",
              style: TextStyle(fontSize: 28.0),
            ),
            TextFormField(
              initialValue:
                  widget.isEdit ? contactsBox.getAt(widget.index).name : "",
              decoration: InputDecoration(
                  labelText: "Contact name",
                  contentPadding: EdgeInsets.only(left: 5)),
              onSaved: (value) => _name = value,
            ),
            TextFormField(
              initialValue:
                  widget.isEdit ? contactsBox.getAt(widget.index).email : "",
              decoration: InputDecoration(
                  labelText: "E-mail address",
                  contentPadding: EdgeInsets.only(left: 5)),
              onSaved: (value) => _email = value,
            ),
            TextFormField(
              initialValue:
                  widget.isEdit ? contactsBox.getAt(widget.index).phone : "",
              decoration: InputDecoration(
                  labelText: "Phone number",
                  contentPadding: EdgeInsets.only(left: 5)),
              keyboardType: TextInputType.phone,
              onSaved: (value) => _phone = value,
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: () {
                Navigator.of(context).pop();
                _formContactKey.currentState.save();
                _formContactKey.currentState.reset();
                FocusScope.of(context).requestFocus(FocusNode());
                widget.isEdit
                    ? editContact(widget.index, Contact(_name, _email, _phone))
                    : addContact(Contact(_name, _email, _phone));
              },
            )
          ],
        ),
      ),
    );
  }
}
