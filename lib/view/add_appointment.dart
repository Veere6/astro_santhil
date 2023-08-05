import 'dart:io';

import 'package:astro_santhil_app/models/add_customer_model.dart';
import 'package:astro_santhil_app/models/category_model.dart';
import 'package:astro_santhil_app/models/sub_category_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/Widget/mycontactpickerwidget.dart';
import 'package:astro_santhil_app/view/Widget/myimagepickerwidgeth.dart';
import 'package:astro_santhil_app/view/home.dart';
import 'package:astro_santhil_app/view/menu.dart';
import 'package:astro_santhil_app/view/slot_booking.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAppointment extends StatefulWidget {
  String name = "";
  String number = "";
  AddAppointment(this.name, this.number);
  @override
  State<StatefulWidget> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  List<String> gender = ["Male", "Female", "Other"];
  String selectedGender = "Male";
  List<String> categoryList = [
    "Select Category",
  ];
  String selectedCategory = "Select Category";
  List<String> subCategoryList = [
    "Select Sub Category",
  ];
  String selectedSubCategory = "Select Sub Category";
  String categoryId = "";
  String subCategoryId = "";
  late File image = File("");
  late File horoscopeImage = File("") ;
  late AddCustomerModel _addCustomerModel;
  late CategoryModel _categoryModel;
  late SubCategoryModel _subCategoryModel;
  TextEditingController userName = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController text = TextEditingController();
  TextEditingController birthPlace = TextEditingController();
  DateTime? date;
  String dob = "(DD/MM/YYYY)";
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay? picked;
  String selectTimes = "Select Time";
  bool clickLoad = false;
  List<Contact> contacts = [];
  List<Contact> foundContacts = [];
  bool isLoading = false;

  Future<Null> selectTime(BuildContext context) async {
    picked = await showTimePicker(
        context: context,
        initialTime: _time,
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (BuildContext context, Widget? child){
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.black,
                onPrimary: Colors.black,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor:Colors.white,
            ),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() {
        _time = picked!;
        // print(picked);
        selectTimes =
            "${picked?.hour}:${picked?.minute}:${picked?.period.name.toUpperCase()}";
      });
    }
  }

  void _pickedImage(int from) {
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

  // void _uplodHoroscopeImage() {
  //   showDialog<ImageSource>(
  //     context: context,
  //     builder: (context) =>
  //         AlertDialog(content: Text("Choose image source"), actions: [
  //       TextButton(
  //           child: Text("Camera"),
  //           onPressed: () {
  //             _getHoroscopeFromCamera();
  //             Navigator.pop(context);
  //           }),
  //       TextButton(
  //           child: Text("Gallery"),
  //           onPressed: () {
  //             _getHoroscopeFromGallery();
  //             Navigator.pop(context);
  //           }),
  //     ]),
  //   );
  // }

  _getFromGallery(int from) async {
    try{
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 900,
        maxHeight: 1600,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState((){
          if(from==0) {
            image = File(pickedFile.path);
          }else{
            horoscopeImage = File(pickedFile.path);
          }
        });
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
        setState(() {
          if(from==0) {
            image = File(pickedFile.path);
          }else{
            horoscopeImage = File(pickedFile.path);
          }
        });
      }
    }catch(error){
      print(error);
    }
  }

  void _viewHoroscopeImage() {
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

  _getHoroscopeFromGallery() async {
    try{
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        horoscopeImage = File(pickedFile.path);
      });
    }
  }catch(error){
    print(error);
  }
  }

  _getHoroscopeFromCamera() async {
    try {
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
      );
      if (pickedFile != null) {
        setState(() {
          horoscopeImage = File(pickedFile.path);
        });
      }
    }catch(error){
      print(error);
    }
  }

  Future<void> categoryMethod() async {
    _categoryModel = await Services.categoryList();
    if (_categoryModel.status == true) {
      for (var i = 0; i < _categoryModel.body!.length; i++) {
        categoryList.add(_categoryModel.body![i].catName.toString());
      }
    }
    setState(() {});
  }

  Future<void> subCategoryMethod() async {
    _subCategoryModel = await Services.subCategoryList(categoryId);
    if (_subCategoryModel.status == true) {
      for (var i = 0; i < _subCategoryModel.body!.length; i++) {
        subCategoryList.add(_subCategoryModel.body![i].subCatName.toString());
      }
    }
    setState(() {});
  }

  Future<void> addCustomer() async {
    File himage = horoscopeImage;
    File uimage = image;
    setState(() {
      clickLoad = true;
    });
    _addCustomerModel = await Services.customerAdd(
        userName.text,
        selectedGender,
        city.text,
        dob.toString(),
        selectTimes,
        email.text,
        phoneNumber.text,
        categoryId,
        subCategoryId,
        text.text,
        birthPlace.text,
        uimage,
        himage);
    if (_addCustomerModel.status == true) {
      Fluttertoast.showToast(
          msg: "${_addCustomerModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      Fluttertoast.showToast(
          msg: "${_addCustomerModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }

  void getContactPermission(BuildContext context) async {
    if (await Permission.contacts.isGranted) {
      // getContacts();
      pickContact(context);
    } else {
      await Permission.contacts.request();
    }
  }

  // void getContacts() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   contacts = await ContactsService.getContacts();
  //   print(contacts[0].phones![0].value);
  //
  //   foundContacts = contacts;
  //   // print(foundContacts);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  void pickContact(BuildContext context) async {
    try {
      final Contact? contact = await ContactsService.openDeviceContactPicker();
      setState(() {
        userName.text = contact?.displayName ?? "";
        if (contact!.phones!.isNotEmpty) {
          phoneNumber.text = contact?.phones?[0].value ?? "";
        } else {
          phoneNumber.text = '';
        }
        print("???${userName.text}");
        print("???${phoneNumber.text}");
      });
    } catch (e) {
      // print(" ????  ${e}");
      // Handle any exceptions here, if necessary.
    }
  }

  @override
  void initState() {
    // userName.text = widget.name;
    // phoneNumber.text = widget.number;
    categoryMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF3BB143),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        )),
                    child: Container(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Menu("Add Appointment")));
                            },
                            child: Container(
                              child: Image.asset(
                                "assets/drawer_ic.png",
                                width: 22.51,
                                height: 20.58,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            child: Text(
                              "ADD CUSTOMER",
                              style: TextStyle(color: Colors.white, fontSize: 21.61),
                            ),
                          ),
                          Spacer(),
                          Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13.42,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                    color: Colors.white,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                )
                              ]
                          ),
                              child: InkWell(
                                onTap: () {
                                  _pickedImage(0);
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
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text("Image",
                                style: TextStyle(
                                  color: Color(0xFF8A92A2),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )),
                          ),


                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Horscope Image",
                                style: TextStyle(
                                  color: Color(0xFF8A92A2),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {

                                    _pickedImage(1);
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
                                      _viewHoroscopeImage();
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
                          ),
                          // MyHImagePickerWidget(),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0,top:10),
                            child: Text(
                              'NAME',
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            child:
                            // MyContactPickerWidget()
                            TextField(
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
                                    ))),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              ' GENDER',
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                              child: DropdownButton<String>(
                                value: selectedGender,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down),
                                underline: Container(
                                  width: 0,
                                ),
                                onChanged: (String? data) {
                                  setState(() {
                                    selectedGender = data!;
                                  });
                                },
                                items: gender.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                              )
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          //   child: Text("Place"),
                          // ),
                          // Container(
                          //   padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                          //   decoration: BoxDecoration(
                          //       color: Color(0xffF8F8F9),
                          //       borderRadius: BorderRadius.all(
                          //           Radius.circular(5.0)
                          //       )
                          //   ),
                          //   child: TextField(
                          //     controller: place,
                          //       textAlignVertical: TextAlignVertical.center,
                          //       textAlign: TextAlign.left,
                          //       keyboardType: TextInputType.text,
                          //       decoration: InputDecoration(
                          //         isDense: true,
                          //         hintText: 'Place',
                          //         hintStyle: const TextStyle(
                          //           fontSize: 14.0,
                          //           color: Color(0xff6C7480),
                          //         ),
                          //         border: InputBorder.none,
                          //       )
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Current City",
                                style: TextStyle(
                                  color: Color(0xFF8A92A2),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: TextField(
                                controller: city,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Current City',
                                  hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff6C7480),
                                  ),
                                  border: InputBorder.none,
                                )),
                          ),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),
                                          child: Text("D.O.B",
                                              style: TextStyle(
                                                color: Color(0xFF8A92A2),
                                                fontSize: 13.55,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              )
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime.now(),
                                              builder: (BuildContext context, Widget? child){
                                                  return Theme(
                                                    data: ThemeData.dark().copyWith(
                                                      colorScheme: ColorScheme.dark(
                                                        primary: Colors.black,
                                                        onPrimary: Colors.white,
                                                        surface: Colors.white,
                                                        onSurface: Colors.black,
                                                      ),
                                                      dialogBackgroundColor:Colors.white,
                                                    ),
                                                    child: child!,
                                                  );
                                              },
                                            );
                                            int? month = date?.month;
                                            String? fm = "" + "${month}";
                                            String? fd = "" + "${date?.day}";
                                            if (month! < 10) {
                                              fm = "0" + "${month}";
                                              // print("fm ${fm}");
                                            }
                                            if (date!.day < 10) {
                                              fd = "0" + "${date?.day}";
                                              // print("fd ${fd}");
                                            }
                                            if (date != null) {
                                              // print(
                                              //     'Date Selecte : ${date?.day ?? ""}-${date?.month ?? ""}-${date?.year ?? ""}');
                                              setState(() {
                                                dob =
                                                    '${date?.year ?? ""}-${fm}-${fd}';
                                                // print(
                                                //     "selectedFromDate ${dob?.split(" ")[0]}");
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin:
                                                EdgeInsets.only(right: 10.0),
                                            padding: EdgeInsets.only(
                                                left: 10.0,
                                                top: 10.0,
                                                right: 10.0,
                                                bottom: 10.0),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              dob.toString(),
                                              style: TextStyle(
                                                color: Color(0xff6C7480),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),
                                          child: Text("Birth-Time",
                                              style: TextStyle(
                                                color: Color(0xFF8A92A2),
                                                fontSize: 13.55,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              )
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            selectTime(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.only(
                                                left: 10.0,
                                                top: 10.0,
                                                right: 10.0,
                                                bottom: 10.0),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              selectTimes != null
                                                  ? selectTimes
                                                  : "(00:00) AM",
                                              style: TextStyle(
                                                color: Color(0xff6C7480),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Email",
                                style: TextStyle(
                                  color: Color(0xFF8A92A2),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: TextField(
                                controller: email,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff6C7480),
                                  ),
                                  border: InputBorder.none,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Phone Number",
                                style: TextStyle(
                                  color: Color(0xFF8A92A2),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: TextField(
                                controller: phoneNumber,
                                maxLength: 10,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  counterText: "",
                                  isDense: true,
                                  hintText: 'Phone Number',
                                  hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff6C7480),
                                  ),
                                  border: InputBorder.none,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Category",
                                style: TextStyle(
                                  color: Color(0xFF8A92A2),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedCategory,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    underline: Container(
                                      width: 0,
                                    ),
                                    onChanged: (String? data) {
                                      setState(() {
                                        selectedCategory = data!;
                                        subCategoryList.clear();
                                        subCategoryList
                                            .add("Select Sub Category");
                                        selectedSubCategory =
                                            "Select Sub Category";
                                        if (selectedCategory !=
                                            "Select Category") {
                                          for (var i = 0;
                                              i < _categoryModel.body!.length;
                                              i++) {
                                            if (data ==
                                                _categoryModel
                                                    .body![i].catName) {
                                              categoryId = _categoryModel
                                                  .body![i].catId
                                                  .toString();
                                              subCategoryMethod();
                                            }
                                          }
                                        }
                                      });
                                    },
                                    items: categoryList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value, child: Text(value));
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  padding: EdgeInsets.only(left: 10.0),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedSubCategory,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    underline: Container(
                                      width: 0,
                                    ),
                                    onChanged: (String? data) {
                                      setState(() {
                                        selectedSubCategory = data!;
                                        if (selectedSubCategory !=
                                            "Select Sub Category") {
                                          for (var i = 0;
                                              i <
                                                  _subCategoryModel
                                                      .body!.length;
                                              i++) {
                                            if (data ==
                                                _subCategoryModel
                                                    .body![i].subCatName) {
                                              subCategoryId =
                                                  _subCategoryModel
                                                      .body![i].subCatId
                                                      .toString();
                                            }
                                          }
                                        }
                                      });
                                    },
                                    items: subCategoryList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value, child: Text(value));
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          //   child: Text("Horscope Image",
                          //       style: TextStyle(
                          //         color: Color(0xFF8A92A2),
                          //         fontSize: 13.55,
                          //         fontFamily: 'Poppins',
                          //         fontWeight: FontWeight.w400,
                          //       )
                          //   ),
                          // ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: InkWell(
                          //         onTap: () {
                          //
                          //           _pickedImage(1);
                          //           // _uplodHoroscopeImage();
                          //         },
                          //         child: Container(
                          //           height: 45,
                          //           alignment: Alignment.center,
                          //           // margin: EdgeInsets.only(
                          //               // top: 20.0, bottom: 20.0),
                          //           // padding: EdgeInsets.symmetric(
                          //           //     horizontal: 47.62, vertical: 5.0),
                          //           decoration: ShapeDecoration(
                          //             color: Color(0xFF526872),
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(10),
                          //             ),
                          //           ),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: [
                          //               Image.asset("assets/Icon-Color.png"),
                          //               SizedBox(width: 5.0,),
                          //               Text(
                          //                 'UPLOAD',
                          //                 style: TextStyle(
                          //                   color: Colors.white,
                          //                   fontSize: 14,
                          //                   fontFamily: 'Poppins',
                          //                   fontWeight: FontWeight.w400,
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: 10.0,
                          //     ),
                          //     Expanded(
                          //         child: InkWell(
                          //           onTap: () {
                          //             _viewHoroscopeImage();
                          //           },
                          //           child: Container(
                          //             height: 45,
                          //             // alignment: Alignment.center,
                          //             // margin: EdgeInsets.only(
                          //             //     top: 20.0, bottom: 20.0),
                          //             // padding: EdgeInsets.symmetric(
                          //             //     horizontal: 47.62, vertical: 5.0),
                          //             decoration: ShapeDecoration(
                          //               color: Color(0xFF526872),
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.circular(10),
                          //               ),
                          //             ),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [
                          //                 Image.asset("assets/Group 36.png"),
                          //                 SizedBox(width: 5.0,),
                          //                 Text(
                          //                   'VIEW',
                          //                   style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontSize: 14,
                          //                     fontFamily: 'Poppins',
                          //                     fontWeight: FontWeight.w400,
                          //                   ),
                          //                 )                                        ],
                          //             ),
                          //           ),
                          //         )
                          //     )
                          //   ],
                          // ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Birth-Place",
                                style: TextStyle(
                                  color: Color(0xFF8A92A2),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: TextField(
                                controller: birthPlace,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Birth-Place',
                                  hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff6C7480),
                                  ),
                                  border: InputBorder.none,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Your Text",
                                style: TextStyle(
                                  color: Color(0xFF8A92A2),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          ),
                          Container(
                            height: 90,
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: TextField(
                                controller: text,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Your Text',
                                  hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff6C7480),
                                  ),
                                  border: InputBorder.none,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              // if (image == null) {
                              //   Fluttertoast.showToast(msg: "Select customer image");
                              // }
                              // else
                                if (userName.text.isEmpty) {
                                Fluttertoast.showToast(msg: "Enter name");
                              }
                              // else if (city.text.isEmpty) {
                              //   Fluttertoast.showToast(
                              //       msg: "Enter current city");
                              // }
                              // else if (dob == "(DD/MM/YYYY)") {
                              //   Fluttertoast.showToast(
                              //       msg: "Enter Date of bith");
                              // }
                              // else if (selectTimes == "Select Time") {
                              //   Fluttertoast.showToast(msg: "Enter time");
                              // }
                              else if (phoneNumber.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Enter phone number");
                              }
                              else if (selectedCategory == "Select Category") {
                                Fluttertoast.showToast(
                                    msg: "Select category");
                              }
                              else if (selectedSubCategory == "Select Sub Category") {
                                Fluttertoast.showToast(
                                    msg: "Select sub category");
                              }
                              // else if (birthPlace.text.isEmpty) {
                              //   Fluttertoast.showToast(
                              //       msg: "Enter birth place");
                              // }
                              else {
                                addCustomer();
                              }
                            },
                            child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.75, vertical: 5.0),
                                decoration: ShapeDecoration(
                                  color: Color(0xFF3BB143),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    clickLoad
                                        ? Container(
                                            width: 24,
                                            height: 24,
                                            padding:
                                                const EdgeInsets.all(2.0),
                                            child:
                                                const CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        :
                                    Text(
                                      'SAVE CHANGES',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
