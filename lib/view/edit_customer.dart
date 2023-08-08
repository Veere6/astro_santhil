import 'dart:io';

import 'package:astro_santhil_app/commonpackage/SearchChoices.dart';
import 'package:astro_santhil_app/models/category_model.dart';
import 'package:astro_santhil_app/models/counrty_model.dart';
import 'package:astro_santhil_app/models/customer_detail_model.dart';
import 'package:astro_santhil_app/models/sub_category_model.dart';
import 'package:astro_santhil_app/models/update_customer_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/menu.dart';
import 'package:astro_santhil_app/view/view_customer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';

class EditCustomer extends StatefulWidget {
  String id = "";

  EditCustomer(this.id);

  @override
  State<StatefulWidget> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {

  List<String> gender = ["Male", "Female", "Other"];
  String selectedGender = "Male";
  List<String> categoryList = ["Select Category",];
  String selectedCategory = "Select Category";
  List<String> subCategoryList = ["Select Sub Category",];
  String selectedSubCategory = "Select Sub Category";
  String categoryId = "";
  String subCategoryId = "";
  late File image = File("");
  String networkImage = "";
  late File horoscopeImage = File("");
  late CategoryModel _categoryModel;
  late SubCategoryModel _subCategoryModel;
  late CustomerDetailModel _customerDetailModel;
  late UpdateCustomerModel _updateCustomerModel;
  TextEditingController userName = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController text = TextEditingController();
  TextEditingController birthPlace = TextEditingController();
  DateTime? date;
  String? dob;
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay? picked;
  String selectTimes = "Select Slot";
  bool clickLoad = false;
  bool isLoad = true;

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
    if(picked != null){
      setState(() {
        _time = picked!;
        print(picked);
        selectTimes = "${picked?.hour}:${picked?.minute}:${picked?.period.name.toUpperCase()}";
      });
    }
  }

  void _pickedImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Color(0xFFCBFCCB),
          content: Text("Choose image source"),
          actions: [
            TextButton(
                child: Text("Camera",
                    style: TextStyle(color: Color(0xFF3BB143))),
                onPressed: () {
                  _getFromCamera();
                  Navigator.pop(context);
                }
            ),
            TextButton(
                child: Text("Gallery",
                    style: TextStyle(color: Color(0xFF3BB143))),
                onPressed: () {
                  _getFromGallery();
                  Navigator.pop(context);
                }
            ),
          ]
      ),
    );
  }

  void _uplodHoroscopeImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
          content: Text("Choose image source"),
          actions: [
            TextButton(
                child: Text("Camera",
                    style: TextStyle(color: Color(0xFF3BB143))),
                onPressed: () {
                  _getHoroscopeFromCamera();
                  Navigator.pop(context);
                }
            ),
            TextButton(
                child: Text("Gallery",
                    style: TextStyle(color: Color(0xFF3BB143))),
                onPressed: () {
                  _getHoroscopeFromGallery();
                  Navigator.pop(context);
                }
            ),
          ],
          backgroundColor: Color(0xFFCBFCCB)
      ),
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState((){
        image = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState((){
        image = File(pickedFile.path);
      });

    }
  }

  void _viewHoroscopeImage() {
    showDialog(context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFFCBFCCB),
          title: Text("View Horoscope Image", textAlign: TextAlign.center,),
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          content: horoscopeImage.path != "" ?
          Image.file(horoscopeImage!):
              Image.network(_customerDetailModel.data![0].hImage.toString())
          //     :
          // Text("Upload Horoscope Image First", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //   textAlign: TextAlign.center,),

        ));
  }

  _getHoroscopeFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState((){
        horoscopeImage = File(pickedFile.path);
      });
    }
  }

  _getHoroscopeFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState((){
        horoscopeImage = File(pickedFile.path);
      });

    }
  }

  Future<void> categoryMethod() async {
    setState(() {
      isLoad = true;
    });
    _categoryModel = await Services.categoryList();
    if(_categoryModel.status == true){
      for(var i=0; i < _categoryModel.body!.length; i++){
        categoryList.add(_categoryModel.body![i].catName.toString());
        if(selectedCategory == _categoryModel.body![i].catName){
          categoryId = _categoryModel.body![i].catId.toString();
          subCategoryMethod();
        }
        // selectedSubCategory = _customerDetailModel.data![0].subCatName.toString();
      }
    }
    setState(() {

    });
  }

  Future<void> subCategoryMethod() async {
    setState(() {
      isLoad = true;
    });
    _subCategoryModel = await Services.subCategoryList(categoryId);
    if(_subCategoryModel.status == true){
      for(var i=0; i < _subCategoryModel.body!.length; i++){
        if(selectedSubCategory == _subCategoryModel.body![i].subCatName){
          subCategoryId = _subCategoryModel.body![i].subCatId.toString();
        }
        subCategoryList.add(_subCategoryModel.body![i].subCatName.toString());
      }
    }
    setState(() {
      isLoad = false;
    });
  }
  String dropdownValue = "";
  Future<void> viewCustomer() async {
    setState(() {
      isLoad = true;
    });
    _customerDetailModel = await Services.customerDetail(widget.id);
    if(_customerDetailModel.status == true){
      networkImage = _customerDetailModel.data![0].uImage.toString();
      userName.text = _customerDetailModel.data![0].name.toString();
      selectedGender = _customerDetailModel.data![0].gender.toString();
      place.text = _customerDetailModel.data![0].place.toString();
      city.text = _customerDetailModel.data![0].city.toString();
      dob = _customerDetailModel.data![0].dob.toString().substring(0,10);
      selectTimes = _customerDetailModel.data![0].birthTime.toString().substring(0,5);
      email.text = _customerDetailModel.data![0].email.toString();
      phoneNumber.text = _customerDetailModel.data![0].phone.toString();
      birthPlace.text = _customerDetailModel.data![0].birthPlace.toString();
      text.text = _customerDetailModel.data![0].text.toString();
      selectedCustomer_id = _customerDetailModel.data![0].country_id.toString();
      // selectedCategory = _customerDetailModel.data![0].catName.toString();
      // categoryId = _customerDetailModel.data![0].catId.toString();
      // subCategoryId = _customerDetailModel.data![0].subCatId.toString();
      country();
    }
    setState(() {
      isLoad = false;
    });
  }

  late File filea = File("");
  late File uFilea = File("");

  Future<void> updateCustomer() async {
    setState(() {
      clickLoad = true;
    });

    if(image.path.isEmpty){
      if(_customerDetailModel.data![0].uImage.toString().isEmpty){
      }else {
        print("bhb");
        uFilea = await Services.urlToFile(
            _customerDetailModel.data![0].uImage.toString());
      }
    }else{
      uFilea = File(image.path);
      print("php");
    }

    if(horoscopeImage.path.isEmpty){
      if(_customerDetailModel.data![0].hImage.toString().isEmpty){
      }else {
        print("bhb");
        filea = await Services.urlToFile(
            _customerDetailModel.data![0].hImage.toString());
      }
    }else{
      filea = File(horoscopeImage.path);
      print("php");
    }

    print("uFilea $uFilea");
    print("filea $filea");
    _updateCustomerModel = await Services.updateCustomer(widget.id, userName.text, selectedGender, city.text,
        dob.toString(), selectTimes, email.text, phoneNumber.text, categoryId, subCategoryId, place.text,
        text.text, birthPlace.text, uFilea, filea,selectedCustomer_id);
    if(_updateCustomerModel.status == true){
      Fluttertoast.showToast(msg: "${_updateCustomerModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ViewCustomer()));
    }else{

      Fluttertoast.showToast(msg: "${_updateCustomerModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }

  @override
  void initState() {
    viewCustomer();
    categoryMethod();
    super.initState();
  }


  List<String> country_id = ["0"];
  List<String> countryList = ["Select Country",];
  String selectedCountry = "Select Country";
  late CountryModel _countryModel;
  List<DropdownMenuItem> countryItems = [];
  String selectedCustomer_id = "";
  Future<void> country() async {
    _countryModel = await Services.countryList();
    if(_countryModel.status == true){
      for(var i = 0; i < _countryModel.data!.length; i++){
        countryList.add("${_countryModel.data![i].name}");
        countryItems.add(DropdownMenuItem(
          child: Text(_countryModel.data![i].name.toString()),
          value: _countryModel.data![i].name.toString(),
        ));
        country_id.add(_countryModel.data![i].id.toString());
        if(selectedCustomer_id=="${_countryModel.data![i].id.toString()}"){
          dropdownValue = _countryModel.data![i].name.toString();
        }
      }
    }else {
      Fluttertoast.showToast(
          msg: "not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad ? Center(
        child: CircularProgressIndicator(),
      ):SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
        color: Colors.white,
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
                        )
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Menu("Edit Customer")));
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
                              "EDIT CUSTOMER",
                              style:
                              TextStyle(color: Colors.white, fontSize: 21.61),
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
                    padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                    color: Colors.white,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: (){
                                  _pickedImage();
                                },
                                child: image.path == "" && _customerDetailModel.data![0].uImage!.isEmpty
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
                                ):
                                image.path != "" ?
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child:  Image.file(File(image!.path),
                                        height: 100.0,
                                        width: 100.0,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                ):ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.network("${_customerDetailModel.data![0].uImage}",
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,),
                                  ),
                                ),
                              )
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'IMAGE',
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
                                    _uplodHoroscopeImage();
                                  },
                                  child: Container(
                                    height: 45,
                                    alignment: Alignment.center,
                                    // margin: EdgeInsets.only(
                                    // top: 20.0, bottom: 20.0),
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: 47.62, vertical: 5.0),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF3BB143),
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
                                        color: Color(0xFF3BB143),
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

                          Container(
                            margin: EdgeInsets.only(bottom: 10.0,top: 10),
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
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: TextField(
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
                                )
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Gender",
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                                onChanged: (String? data){
                                  setState(() {
                                    selectedGender = data!;
                                  });
                                },
                                items: gender
                                    .map<DropdownMenuItem<String>>((String value){
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value)
                                  );
                                }).toList(),
                              )
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          //   child: Text("Place",
                          //     style: TextStyle(
                          //       color: Color(0xFF8A92A2),
                          //       fontSize: 13.55,
                          //       fontFamily: 'Poppins',
                          //       fontWeight: FontWeight.w400,
                          //     ),),
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
                          //       controller: place,
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
                            child: Text(
                              'Country',
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0),
                            padding: EdgeInsets.only(left: 10.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: SearchChoices.single(
                              value: dropdownValue,
                              items: countryItems,
                              hint: "Select Country",
                              searchHint: "Select Country",
                              style: TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (value) {
                                setState(() {
                                  dropdownValue = value;
                                  if (dropdownValue != "Select Country") {
                                    for (var i = 0;
                                    i < countryItems.length;
                                    i++) {
                                      if (countryList[i] ==
                                          dropdownValue) {
                                        print(
                                            "fghfdsasdfghgfdsasdfghgfdsaASDFG  " +
                                                country_id[i]);

                                        selectedCustomer_id =
                                        country_id[i];
                                      }
                                    }
                                    print(
                                        "fghfdsasdfghgfdsasdfghgfdsaASDFG  " +
                                            selectedCustomer_id);
                                  }
                                });
                              },
                              displayClearIcon: false,
                              isExpanded: true,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("City",
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
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
                                  hintText: 'City',
                                  hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff6C7480),
                                  ),
                                  border: InputBorder.none,
                                )
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                          child: Text("D.O.B",
                                            style: TextStyle(
                                              color: Color(0xFF8A92A2),
                                              fontSize: 13.55,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),),
                                        ),
                                        InkWell(
                                          onTap: () async{
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
                                                        secondary: Colors.green,
                                                        onSecondary: Colors.green,
                                                        secondaryContainer: Colors.green,
                                                      ),
                                                      datePickerTheme: DatePickerThemeData(
                                                          yearStyle: TextStyle(color: Colors.grey)
                                                      ),
                                                      dialogBackgroundColor:Colors.white,
                                                    ),
                                                    child: child!,
                                                  );
                                                });
                                            int? month = date?.month;
                                            String? fm=""+ "${month}";
                                            String? fd=""+"${date?.day}";
                                            if(month!<10){
                                              fm ="0"+"${month}";
                                              print("fm ${fm}");
                                            }
                                            if (date!.day<10){
                                              fd="0"+"${date?.day}";
                                              print("fd ${fd}");
                                            }
                                            if(date != null){
                                              print('Date Selecte : ${date?.day ??""}-${date?.month ??""}-${date?.year ??""}');
                                              setState(() {
                                                dob ='${date?.year??""}-${fm}-${fd}';
                                                print("selectedFromDate ${dob?.split(" ")[0]}");
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(right: 10.0),
                                            padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text(dob != null ? dob.toString():
                                            "(DD/MM/YYYY)", style: TextStyle( color: Color(0xff6C7480),),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                          child: Text(
                                              "Birth-time".toUpperCase(),
                                            style: TextStyle(
                                              color: Color(0xFF8A92A2),
                                              fontSize: 13.55,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            selectTime(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text( selectTimes != null ? selectTimes:
                                            "(00:00) AM", style: TextStyle(color: Color(0xff6C7480),),
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
                              ),),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
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
                                )
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Phone number",
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: TextField(
                                controller: phoneNumber,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Phone Number',
                                  hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff6C7480),
                                  ),
                                  border: InputBorder.none,
                                )
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Categorey",
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF8F8F9),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)
                                      )
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
                                    onChanged: (String? data){
                                      setState(() {
                                        selectedCategory = data!;
                                        subCategoryList.clear();
                                        subCategoryList.add("Select Sub Category");
                                        selectedSubCategory = "Select Sub Category";
                                        if(selectedCategory != "Select Category"){
                                          for(var i = 0; i < _categoryModel.body!.length; i++){
                                            if(data == _categoryModel.body![i].catName) {
                                              categoryId = _categoryModel.body![i].catId.toString();
                                              subCategoryMethod();
                                            }
                                          }
                                        }
                                      });
                                    },
                                    items: categoryList
                                        .map<DropdownMenuItem<String>>((String value){
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value)
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  padding: EdgeInsets.only(left: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF8F8F9),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)
                                      )
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
                                    onChanged: (String? data){
                                      setState(() {
                                        selectedSubCategory = data!;
                                        if(selectedSubCategory != "Select Sub Category"){
                                          for(var i = 0; i < _subCategoryModel.body!.length; i++){
                                            if(data == _subCategoryModel.body![i].subCatName) {
                                              subCategoryId = _subCategoryModel.body![i].subCatId.toString();
                                            }
                                          }
                                        }

                                      });
                                    },
                                    items: subCategoryList
                                        .map<DropdownMenuItem<String>>((String value){
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value)
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Birth-Place",
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
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
                                )
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text("Your Text",
                              style: TextStyle(
                                color: Color(0xFF8A92A2),
                                fontSize: 13.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),),
                          ),
                          Container(
                            height: 90,
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
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
                                )
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  updateCustomer();
                                },
                                child: Container(
                                    height: 45,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    padding: EdgeInsets.symmetric(horizontal: 12.75, vertical: 5.0),
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF3BB143),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                    child: clickLoad ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3.0,
                                          ),
                                        )
                                      ],
                                    ) : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'SAVE CHANGES',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )                                      ],
                                    )
                                ),
                              )
                            ],
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