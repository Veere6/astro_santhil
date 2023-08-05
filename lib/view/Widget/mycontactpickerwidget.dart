import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MyContactPickerWidget extends StatelessWidget {

  TextEditingController userName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  void pickContact(BuildContext context) async {
    try {
      final Contact? contact = await ContactsService.openDeviceContactPicker();
      // setState(() {
        userName.text = contact?.displayName ?? "";
        if (contact!.phones!.isNotEmpty) {
          phoneNumber.text = contact?.phones?[0].value ?? "";
        } else {
          phoneNumber.text = '';
        }
        // print("???${userName.text}");
        // print("???${phoneNumber.text}");
      // });
    } catch (e) {
      // print(" ????  ${e}");
      // Handle any exceptions here, if necessary.
    }
  }

  void getContactPermission(BuildContext context) async {
    if (await Permission.contacts.isGranted) {
      // getContacts();
      pickContact(context);
    } else {
      await Permission.contacts.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: userName,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Name',
            hintStyle: const TextStyle(
              fontSize: 14.0,
              color: Color(0xff6C7480),
            ),
            border: InputBorder.none,
            suffixIcon: InkWell(
              onTap: () {

                getContactPermission(context);

                // Navigator.pushReplacement
                //   (context, MaterialPageRoute(builder: (context)=> MYBottomSheet()));
              },
              child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 10.0),
                  padding: EdgeInsets.only(
                      left: 10,
                      top: 10,
                      right: 10,
                      bottom: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xff6C7480)),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0))),
                  child: Icon(Icons.contacts)),
            )));
  }
}
