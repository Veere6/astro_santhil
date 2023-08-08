import 'dart:math';

import 'package:astro_santhil_app/commonpackage/SearchChoices.dart';
import 'package:astro_santhil_app/models/category_model.dart';
import 'package:astro_santhil_app/models/counrty_model.dart';
import 'package:astro_santhil_app/models/delete_customer_model.dart';
import 'package:astro_santhil_app/models/sub_category_model.dart';
import 'package:astro_santhil_app/models/view_customer_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/edit_customer.dart';
import 'package:astro_santhil_app/view/menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCustomer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {

  late ViewCustomerModel _customerModel;
  List<Datum> _list = [];
  List<Datum> filtterList = [];
  List<DropdownMenuItem> countryItems = [];
  String dropdownValue = "";
  String selectedCustomer_id = "";
  bool _pageLoading = false;
  List<String> categoryList = ["Select Category",];
  String selectedCategory = "Select Category";
  List<String> subCategoryList = ["Select Sub Category",];
  String selectedSubCategory = "Select Sub Category";
  List<String> countryList = ["Select Country",];
  String selectedCountry = "Select Country";
  List<String> country_id = [];
  String categoryId = "";
  String subCategoryId = "";
  String countryId = "";
  late CategoryModel _categoryModel;
  late SubCategoryModel _subCategoryModel;
  late DeleteCustomerModel _deleteCustomerModel;
  late CountryModel _countryModel;

  List<Color> gradientColorList = [
    Color(0xff1C3B70),
    Color(0xff019AD6),
    Color(0xff1C5870),
    Color(0xffFF9900),
    Color(0xffFF3D3D),
  ];

  List<Color> gradientColorListLight = [
    Color(0xff006093),
    Color(0xff30D4FD),
    Color(0xff009393),
    Color(0xffFFBF00),
    Color(0xffFF663D),
  ];

  final _random = Random();
  Future<void> categoryMethod() async {
    _categoryModel = await Services.categoryList();
    if(_categoryModel.status == true){
      for(var i=0; i < _categoryModel.body!.length; i++){
        categoryList.add(_categoryModel.body![i].catName.toString());
      }
    }
    setState(() {

    });
  }

  Future<void> subCategoryMethod() async {
    _subCategoryModel = await Services.subCategoryList(categoryId);
    if(_subCategoryModel.status == true){
      for(var i=0; i < _subCategoryModel.body!.length; i++){
        subCategoryList.add(_subCategoryModel.body![i].subCatName.toString());
      }
    }
    setState(() {

    });
  }

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
      }
    }else {
      Fluttertoast.showToast(
          msg: "not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {});
  }

  Future<void> customerVeiw(String name, String catId, String subCatId, String countryId) async {
    _pageLoading = true;
    _customerModel = await Services.veiwCustomer(name, name, catId, subCatId, countryId);
    if(_customerModel.status == true){
      for(var i = 0; i < _customerModel.data!.length; i++){
        _list = _customerModel.data ?? <Datum> [];
      }
      filtterList = _list;
    }
    _pageLoading = false;
    setState(() {

    });
  }

  void searchFilter(String enteredKeyword, StateSetter dState) {
    List<Datum> results = [];
    if(enteredKeyword.isEmpty){
      results = _list;
    }else{
      results = _list
          .where((element) =>
          element.name!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              element.phone!.contains(enteredKeyword)).toList();
    }
    dState(() {
      filtterList = results;
    });
  }

  void deleteDailog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFCBFCCB),
          content: Text("Are you sure you want to delete this appointment?", style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: (){
                  deleteCustomer(id);
                },
                child: Text("Yes", style: TextStyle(fontSize: 16.0, color: Color(0xFF3BB143),),)
            ),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("No", style: TextStyle(fontSize: 16.0,color: Color(0xFF3BB143),),)
            )
          ]
      ),
    );
  }

  Future<void> deleteCustomer(String id) async {
    _deleteCustomerModel = await Services.customerDelete(id);
    if(_deleteCustomerModel.status == true){
      Fluttertoast.showToast(msg: "${_deleteCustomerModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      customerVeiw("", "", "","");
      Navigator.pop(context);
    }else {
      Fluttertoast.showToast(msg: "${_deleteCustomerModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {

    });
  }

  @override
  void initState() {
    categoryMethod();
    subCategoryMethod();
    customerVeiw("", "", "","");
    country();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu("View Customer")));
        return true;
      },
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                MaterialPageRoute(builder: (context) => Menu("View Customer")));
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
                            "VIEW CUSTOMERS",
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
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0, bottom: 70.0),
                  color: Colors.white,
                  child: Column(
                    children: [
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
                                          customerVeiw("", categoryId, "","");
                                        }
                                      }
                                    }else{
                                      customerVeiw("", "", "","");
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
                                onChanged: (String? data){
                                  setState(() {
                                    selectedSubCategory = data!;
                                    if(selectedSubCategory != "Select Sub Category"){
                                      for(var i = 0; i < _subCategoryModel.body!.length; i++){
                                        if(data == _subCategoryModel.body![i].subCatName) {
                                          subCategoryId = _subCategoryModel.body![i].subCatId.toString();
                                          customerVeiw("", categoryId, subCategoryId,"");
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
                        margin: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
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
                              customerVeiw("", categoryId, subCategoryId, selectedCustomer_id);
                            });
                          },
                          displayClearIcon: false,
                          isExpanded: true,
                        ),
                      ),
                      Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                        child: TextField(
                          // controller: fees,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Search Customers',
                            prefixIcon: Icon(
                                Icons.search
                            ),
                            hintStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xff6C7480),
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => searchFilter(value, setState),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.only(bottom: 320),
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height,
                        child: _pageLoading? Center(
                          child: CircularProgressIndicator(),
                        ): _customerModel.msg == "No Data Found!.." ? Center(
                          child: Text("${_customerModel.msg}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20
                            ),),
                        ):ListView.builder(
                            itemCount: filtterList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              Datum _body = filtterList[index];
                              int randomNumber = _random.nextInt(5);

                              final time =
                              _body.birthTime!.substring(0,2).contains("13") ? "01${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("14") ? "02${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("15") ? "03${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("16") ? "04${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("17") ? "05${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("18") ? "06${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("19") ? "07${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("20") ? "08${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("21") ? "09${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("22") ? "10${_body.birthTime!.substring(2,5)} PM":
                              _body.birthTime!.substring(0,2).contains("23") ? "11${_body.birthTime!.substring(2,5)} PM":
                                  "${_body.birthTime!.substring(0,5)} AM";

                              return Container(
                                  margin: EdgeInsets.only(bottom: 20.0),
                                  child: Card(
                                      color: Colors.white,
                                      shadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)
                                          )
                                      ),
                                      elevation: 10.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFF607D8B),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)
                                            )
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                          // boxShadow: [
                                                          //   BoxShadow(
                                                          //     color: Colors.grey.withOpacity(0.7),
                                                          //     spreadRadius: 1,
                                                          //     blurRadius: 2,
                                                          //     offset: const Offset(5, 5), // changes position of shadow
                                                          //   ),
                                                          // ],
                                                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                                                          // color: Colors.white
                                                      ),
                                                      padding: const EdgeInsets.all(0),
                                                      child: _body.uImage!.isNotEmpty ? Stack(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius: BorderRadius.circular(30.0),
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  padding: const EdgeInsets.all(0),
                                                                  child: FadeInImage.assetNetwork(
                                                                    placeholder: "assets/Group 93.png",
                                                                    image: "${_body.uImage}",
                                                                    fit: BoxFit.cover,
                                                                  )

                                                              )
                                                          ),
                                                          ClipRRect(
                                                              borderRadius: BorderRadius.circular(30.0),
                                                              child: Container(
                                                                height: 40,
                                                                width: 40,
                                                              )
                                                          ),
                                                        ],
                                                      ):Stack(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius: BorderRadius.circular(30.0),
                                                              child: Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  padding: const EdgeInsets.all(0),
                                                                  child: Image.asset(
                                                                     "assets/Group 93.png",
                                                                  )

                                                              )
                                                          ),
                                                          ClipRRect(
                                                              borderRadius: BorderRadius.circular(30.0),
                                                              child: Container(
                                                                height: 40,
                                                                width: 40,
                                                              )
                                                          ),
                                                        ],
                                                      )
                                                  ),

                                              //     Container(
                                              //       alignment: Alignment.center,
                                              //       width: 35,
                                              //       height: 35,
                                              //       decoration: BoxDecoration(
                                              //           shape: BoxShape.circle,
                                              //           gradient: LinearGradient(
                                              //               colors: [
                                              //                 gradientColorList[randomNumber],
                                              //                 gradientColorListLight[randomNumber],
                                              //               ],
                                              //               begin: const FractionalOffset(0.0, 0.0),
                                              //               end: const FractionalOffset(0.0, 1.0),
                                              //               stops: [0.0, 1.0],
                                              //               tileMode: TileMode.clamp
                                              //           )
                                              //       ),
                                              //       child: ClipRRect(
                                              //         borderRadius: BorderRadius.circular(50.0),
                                              //         child: _body.hImage != null ? Image.network("${_body.hImage}"):
                                              //         Image.asset("assets/user_ic_white.png"),
                                              //       )
                                              // // FadeInImage.assetNetwork(
                                              // //           placeholder: ,
                                              // //           image: "${_body.hImage}")
                                              //     ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 20.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(_body.name.toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w400,
                                                          ),),
                                                        Row(
                                                          children: [
                                                            Text("(${_body.phone})",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14,
                                                                fontFamily: 'Inter',
                                                                fontWeight: FontWeight.w400,
                                                              ),),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text("(${_body.dob.toString().substring(0,10)})",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w400,
                                                          ),),
                                                        Text("(${time})",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w400,
                                                          ),)
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 20.0),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        final call = Uri.parse('tel:${_body.phone}');
                                                        if (await canLaunchUrl(call)) {
                                                          await launchUrl(call);
                                                        } else {
                                                          throw 'Could not launch $call';
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                                                        decoration: BoxDecoration(
                                                            color: Color(0xfff5f5f5),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(50.0)
                                                            )
                                                        ),
                                                        child: Image.asset("assets/Vector (20).png",
                                                          color: Colors.green,),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => EditCustomer(_body.userId.toString())));
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/edit_ic.png",
                                                              height: 20,
                                                              color: Colors.white,),
                                                            Container(
                                                                margin: EdgeInsets.only(top: 5.0),
                                                                child: Text("Edit", style: TextStyle(
                                                                  color: Colors.white,
                                                                    fontSize: 12.0),))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        deleteDailog(_body.userId.toString());
                                                      },
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/delete_ic.png",
                                                              height: 20,
                                                              color: Colors.white,),
                                                            Container(
                                                                margin: EdgeInsets.only(top: 5.0),
                                                                child: Text("Delete", style: TextStyle(
                                                                  color: Colors.white,
                                                                    fontSize: 12.0),))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                  )
                              );
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}