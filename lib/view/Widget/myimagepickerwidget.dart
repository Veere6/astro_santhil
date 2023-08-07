import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePickerWidget extends StatelessWidget {


  late File image = File("");
  _getFromGallery(int from) async {
    try{
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 900,
        maxHeight: 1600,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        // setState((){
          if(from==0) {
            image = File(pickedFile.path);
          }
          // else{
          //   horoscopeImage = File(pickedFile.path);
          // }
        // });
      }
    }catch(error){
      print(error);
    }
  }

  _getFromCamera(int from) async {
    try {
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 900,
        maxHeight: 1600,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        // setState(() {
          if(from==0) {
            image = File(pickedFile.path);
          }
        //   else{
        //     horoscopeImage = File(pickedFile.path);
        //   }
        // });
      }
    }catch(error){
      print(error);
    }
  }

  void _pickedImage(int from,BuildContext context) {
    showDialog<ImageSource>(
      context: context,
      builder: (context) =>
          AlertDialog(content: Text("Choose image source"), actions: [
            TextButton(
                child: Text("Camera"),
                onPressed: () {
                  _getFromCamera(from);
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text("Gallery"),
                onPressed: () {
                  _getFromGallery(from);
                  Navigator.pop(context);
                }),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _pickedImage(0,context);
      },
      child: image == null || image.path.isEmpty
          ? ClipRRect(
        borderRadius:
        BorderRadius.circular(50.0),
        child: Container(
          height: 100,
          width: 100,
          color: Color(0xFF3BB143),
          child: Image.asset(
            "assets/Group 48.png",
            color: Colors.white,
            // height: 100.0,
            // width: 100.0,
            // fit: BoxFit.cover,
          ),
        ),
      )
          : ClipRRect(
          borderRadius:
          BorderRadius.circular(50.0),
          child: Container(
            height: 100,
            width: 100,
            child: Image.file(
              File(image!.path),
              height: 100.0,
              width: 100.0,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
