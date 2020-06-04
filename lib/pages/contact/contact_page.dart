import 'package:flutter/material.dart';
import 'package:flutter_hive_db/pages/contact/widgets/contact_form.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool showForm;
  Box contactsBox;

  @override
  void initState() {
    showForm = false;
    contactsBox = Hive.box("contacts");
    super.initState();
  }

  void deleteContact(index) {
    contactsBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: initListView()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          child: Icon(showForm ? Icons.keyboard_arrow_down : Icons.add),
          onPressed: () {
            setState(() {
              showForm = !showForm;
            });
          },
        ),
      ));
  }

  Widget initListView() {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: contactsBox.listenable(),
            builder: (context, contactsBox, _) {
              if (contactsBox.values.isEmpty) {
                return Center(child: Text('No data'));
              } else {
                return _buildListView(contactsBox);
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 70),
          child: showForm ? ContactForm() : Container(),
        ),
      ],
    );
  }

  Widget _buildListView(box) {
    return ListView.builder(
      itemCount: box.values.length,
      itemBuilder: (context, index) {
        return _buildItem(index);
      },
    );
  }

  Widget _buildItem(index) {
    var contact = contactsBox.getAt(index);
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Dialog(
                    child: ContactForm(isEdit: true, index: index,),
                  )
                ],
              ),
            );
          }
        );
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => deleteContact(index),
          )
        ],
        child: Row(
          children: <Widget>[
            Container(
              height: 80,
              width: 100,
              child: Center(
                child: Icon(
                  Icons.account_circle,
                  size: 60,
                )),
            ),
            Container(
              height: 80,
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Name:"),
                  Text("E-mail:"),
                  Text("Phone:"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${contact.name}"),
                    Text("${contact.email}"),
                    Text("${contact.phone}"),
                  ],
                ),
              ),
            ),
          ],
        )),
    );
  }
}
