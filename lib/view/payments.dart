import 'dart:math';

import 'package:astro_santhil_app/models/payment_view_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/menu.dart';
import 'package:flutter/material.dart';

class Payments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
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
  late PaymentViewModel _paymentViewModel = PaymentViewModel();
  List<Body> _list = [];
  DateTime? fromDate;
  String selectedFromDate = "";
  DateTime? toDate;
  String selectedToDate = "";
  bool isLoad = false;

  void fromdateMethod() async {
    fromDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
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
              datePickerTheme:
                  DatePickerThemeData(yearStyle: TextStyle(color: Colors.grey)),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        });
    int? month = fromDate?.month;
    String? fm = "" + "${month}";
    String? fd = "" + "${fromDate?.day}";
    if (month! < 10) {
      fm = "0" + "${month}";
      print("fm ${fm}");
    }
    if (fromDate!.day < 10) {
      fd = "0" + "${fromDate?.day}";
      print("fd ${fd}");
    }
    if (fromDate != null) {
      print(
          'Date Selecte : ${fromDate?.day ?? ""}-${fromDate?.month ?? ""}-${fromDate?.year ?? ""}');
      setState(() {
        selectedFromDate = '${fromDate?.year ?? ""}-${fm}-${fd}';
        print("selectedFromDate ${selectedFromDate?.split(" ")[0]}");
      });
    }
  }

  void toDateMethod() async {
    toDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
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
              datePickerTheme:
                  DatePickerThemeData(yearStyle: TextStyle(color: Colors.grey)),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        });
    int? month = toDate?.month;
    String? fm = "" + "${month}";
    String? fd = "" + "${toDate?.day}";
    if (month! < 10) {
      fm = "0" + "${month}";
      print("fm ${fm}");
    }
    if (toDate!.day < 10) {
      fd = "0" + "${toDate?.day}";
      print("fd ${fd}");
    }
    if (toDate != null) {
      print(
          'Date Selecte : ${toDate?.day ?? ""}-${toDate?.month ?? ""}-${toDate?.year ?? ""}');
      setState(() {
        selectedToDate = '${toDate?.year ?? ""}-${fm}-${fd}';
        print("selectedFromDate ${selectedToDate?.split(" ")[0]}");
      });
    }
  }

  Future<void> payment() async {
    setState(() {
      isLoad = true;
    });
    _paymentViewModel = await Services.paymentList(
        selectedFromDate.toString(), selectedToDate.toString());
    if (_paymentViewModel.status == true) {
      for (var i = 0; i < _paymentViewModel.body!.length; i++) {
        _list = _paymentViewModel.body ?? <Body>[];
      }
    }
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(),
                child: Container(
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Menu("Payment")));
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
                            "PAYMENTS",
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
              ),
              SizedBox(
                height: 66.69,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From Date',
                        style: TextStyle(
                          color: Color(0xFF8A92A2),
                          fontSize: 13.55,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          fromdateMethod();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.50, color: Color(0xFFD0D4E0)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                selectedFromDate.isNotEmpty
                                    ? "${selectedFromDate}"
                                    : "(DD/MM/YYYY)",
                                style: TextStyle(
                                  color: Color(0xFF262A3F),
                                  fontSize: 13.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 11.0),
                                child: Image.asset(
                                  "assets/ic_down.png",
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To Date',
                        style: TextStyle(
                          color: Color(0xFF8A92A2),
                          fontSize: 13.55,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          toDateMethod();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.50, color: Color(0xFFD0D4E0)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                  selectedToDate.isNotEmpty
                                      ? "${selectedToDate}"
                                      : "(DD/MM/YYYY)",
                                  style: TextStyle(
                                    color: Color(0xFF262A3F),
                                    fontSize: 13.55,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  )),
                              Container(
                                margin: EdgeInsets.only(left: 11.0),
                                child: Image.asset(
                                  "assets/ic_down.png",
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      payment();
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Color(0xFF3BB143),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(top: 15.0),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 69.12,
              ),
              Text(
                'TOTAL AMOUNT',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 13.94, left: 30.0, right: 30.0),
                padding: EdgeInsets.only(
                    left: 43.62, top: 26.9, right: 43.62, bottom: 12.0),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50, color: Color(0xFF607D8B)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Text("Rs.${_paymentViewModel.totalFees ?? ""}",
                        style: TextStyle(
                          color: Color(0xFF3BB143),
                          fontSize: 32,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        )),
                    Container(
                      height: 45,
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: Color(0xFF3BB143),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.only(
                          left: 39.13, top: 6.35, right: 37.26, bottom: 7.19),
                      child: Text(
                        "View",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25.89,
              ),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 26.93, bottom: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Latest Payment History',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: selectedFromDate.isEmpty
                          ? Center(
                              child: Text(
                              "Choose From Date",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ))
                          : selectedToDate.isEmpty
                              ? Center(
                                  child: Text(
                                  "Choose To Date",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              : isLoad
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    )
                                  : _paymentViewModel.status == false
                                      ? Center(
                                          child: Text(
                                            _paymentViewModel.msg.toString(),
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(
                                              left: 10.0,
                                              top: 21.53,
                                              right: 10.0),
                                          child: ListView.builder(
                                              itemCount: _list.length,
                                              shrinkWrap: true,
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                Body _body = _list[index];
                                                int randomNumber =
                                                    _random.nextInt(5);
                                                return Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 20.0),
                                                    child: Card(
                                                        color: Colors.white,
                                                        shadowColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        20.0))),
                                                        elevation: 10.0,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xFF607D8B),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20.0))),
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20.0,
                                                                    vertical:
                                                                        20.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: 35,
                                                                      height:
                                                                          35,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color:
                                                                              Colors.white),
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/Group 93.png"),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              10.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "${_body.name ?? "Name"}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontFamily: 'Inter',
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          // Row(
                                                                          //   children: [
                                                                          //     Text("Payment Status"),
                                                                          //     Container(
                                                                          //       height: 8.0,
                                                                          //       width: 8.0,
                                                                          //       margin: EdgeInsets.only(left: 5.0),
                                                                          //       decoration: BoxDecoration(
                                                                          //           shape: BoxShape.circle,
                                                                          //           gradient: LinearGradient(
                                                                          //               colors: [
                                                                          //                 Color(0xffFF3D3D),
                                                                          //                 Color(0xffFF663D)
                                                                          //               ],
                                                                          //               begin: const FractionalOffset(0.0, 0.0),
                                                                          //               end: const FractionalOffset(0.0, 1.0),
                                                                          //               stops: [0.0, 1.0],
                                                                          //               tileMode: TileMode.clamp
                                                                          //           )
                                                                          //       ),
                                                                          //     )
                                                                          //   ],
                                                                          // )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    Container(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "(${_body.date.toString().substring(0, 10) ?? "(DD/MM/YYYY)"})",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontFamily: 'Inter',
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "(${_body.time ?? "(00:00AM)"})",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontFamily: 'Inter',
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              20.0),
                                                                  child: Row(
                                                                    children: [
                                                                      // Container(
                                                                      //   child: Column(
                                                                      //     children: [
                                                                      //       Image.asset("assets/status_ic.png"),
                                                                      //       Container(
                                                                      //           margin: EdgeInsets.only(top: 5.0),
                                                                      //           child: Text("Status", style: TextStyle(fontSize: 12.0),))
                                                                      //     ],
                                                                      //   ),
                                                                      // ),
                                                                      // Container(
                                                                      //   margin: EdgeInsets.symmetric(horizontal: 10.0),
                                                                      //   child: Column(
                                                                      //     children: [
                                                                      //       Image.asset("assets/edit_ic.png"),
                                                                      //       Container(
                                                                      //           margin: EdgeInsets.only(top: 5.0),
                                                                      //           child: Text("Edit", style: TextStyle(fontSize: 12.0),))
                                                                      //     ],
                                                                      //   ),
                                                                      // ),
                                                                      // Container(
                                                                      //   child: Column(
                                                                      //     children: [
                                                                      //       Image.asset("assets/delete_ic.png"),
                                                                      //       Container(
                                                                      //           margin: EdgeInsets.only(top: 5.0),
                                                                      //           child: Text("Delete", style: TextStyle(fontSize: 12.0),))
                                                                      //     ],
                                                                      //   ),
                                                                      // ),
                                                                      Spacer(),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Rs.${_body.fees ?? "2,030.80"}",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                'Inter',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )));
                                              }),
                                        ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
