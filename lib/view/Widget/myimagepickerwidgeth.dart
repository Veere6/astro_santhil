import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHImagePickerWidget extends StatelessWidget {


  late File horoscopeImage = File("");
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
            horoscopeImage = File(pickedFile.path);
          }
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
            horoscopeImage = File(pickedFile.path);
          }
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

  void _viewHoroscopeImage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "View Horoscope Image",
            textAlign: TextAlign.center,
          ),
          titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          content: horoscopeImage != null
              ? Image.file(horoscopeImage!)
              : Text(
            "Upload Horoscope Image First",
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ));
  }


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {

              _pickedImage(0,context);
              // _uplodHoroscopeImage();
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              // margin: EdgeInsets.only(
              // top: 20.0, bottom: 20.0),
              // padding: EdgeInsets.symmetric(
              //     horizontal: 47.62, vertical: 5.0),
              decoration: ShapeDecoration(
                color: Color(0xFF526872),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/Icon-Color.png"),
                  SizedBox(width: 5.0,),
                  Text(
                    'UPLOAD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
            child: InkWell(
              onTap: () {
                _viewHoroscopeImage(context);
              },
              child: Container(
                height: 45,
                // alignment: Alignment.center,
                // margin: EdgeInsets.only(
                //     top: 20.0, bottom: 20.0),
                // padding: EdgeInsets.symmetric(
                //     horizontal: 47.62, vertical: 5.0),
                decoration: ShapeDecoration(
                  color: Color(0xFF526872),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/Group 36.png"),
                    SizedBox(width: 5.0,),
                    Text(
                      'VIEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    )                                        ],
                ),
              ),
            )
        )
      ],
    );
  }
}
