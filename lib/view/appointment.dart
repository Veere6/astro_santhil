import 'dart:math';

import 'package:astro_santhil_app/models/appointment_view_model.dart';
import 'package:astro_santhil_app/models/complete_appointment_model.dart';
import 'package:astro_santhil_app/models/upcoming_appointment_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/models/cancel_appointment_model.dart';
import 'package:astro_santhil_app/view/edit_appointment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'menu.dart';

class Appointment extends StatefulWidget {
  String tabValue = "";

  Appointment(this.tabValue);

  @override
  State<StatefulWidget> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late AppointmentViewModel _appointmentViewModel;
  late CancelAppointmentModel _cancelAppointmentModel;
  late CompleteAppointmentModel _completeAppointmentModel;
  List<Body> _list = [];
  List<uBody> _upcominglist = [];
  bool _pageLoading = false;
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
  String tab = "";
  int _radioSelected = 0;
  String _radioVal = "";
  bool? statusValue;


  // late UpcomingAppointmentModel _upcomingappointmentViewModel;
  // Future<void> UpcomingviewAppointment() async {
  //   _pageLoading = true;
  //   _upcominglist.clear();
  //   _upcomingappointmentViewModel = await Services.appointmentUpcoming();
  //   if(_upcomingappointmentViewModel.status == true){
  //     for(var i = 0; i < _upcomingappointmentViewModel.body!.length; i++){
  //       _upcominglist = _upcomingappointmentViewModel.body ?? <uBody> [];
  //     }
  //   }
  //   setState(() {
  //
  //   });
  //   _pageLoading = false;
  // }
  DateTime currentdate = DateTime.now();
  Future<void> viewAppointment(String type) async {
    _pageLoading = true;
    _list.clear();

    if(type=="upcoming"){
      _appointmentViewModel = await Services.appointmentUpcoming("${selectedFromDate}","${selectedToDate}");
    }else {
      _appointmentViewModel = await Services.appointmentView(type,"${selectedFromDate}","${selectedToDate}",);
    }
    if (_appointmentViewModel.status == true) {
      for (var i = 0; i < _appointmentViewModel.body!.length; i++) {
        _list = _appointmentViewModel.body ?? <Body>[];
      }
    }
    setState(() {});
    _pageLoading = false;
  }

  Future<void> deleteAppointment(String id) async {
    _cancelAppointmentModel = await Services.cancelAppointment(id);
    if (_cancelAppointmentModel.status == true) {
      Fluttertoast.showToast(
          msg: "${_cancelAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      viewAppointment(tab);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "${_cancelAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {});
  }

  void updateStatus(String id) async {
    _completeAppointmentModel = await Services.completeAppointment(id);
    if (_completeAppointmentModel.status == true) {
      Fluttertoast.showToast(
          msg: "${_completeAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      viewAppointment(tab);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "${_completeAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {});
  }

  void onClick2(bool istrue) {
    setState(() {
      statusValue = istrue;
    });
  }

  void deleteDailog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),

          content: Text(
            "Are you sure you want to delete this appointment?",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  deleteAppointment(id);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF3BB143),),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF3BB143),),
                ))
          ]),
    );
  }

  void updateStatusDailog(String id) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  height: 200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Appointment Status",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Radio(
                              value: 1,
                              groupValue: _radioSelected,
                              activeColor: Color(0xFF3BB143),
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected = value as int;
                                  _radioVal = 'Cancel';
                                  print(_radioVal);
                                });
                              }),
                          Text("Cancel")
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: 2,
                              groupValue: _radioSelected,
                              activeColor: Color(0xFF3BB143),
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected = value as int;
                                  _radioVal = 'Complete';
                                  print(_radioVal);
                                });
                              }),
                          Text("Complete")
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 8.0,
                          top: 8.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  if (_radioSelected == 1) {
                                    deleteAppointment(id);
                                  } else if (_radioSelected == 2) {
                                    updateStatus(id);
                                  }
                                },
                                child: Text("Yes",
                                  style: TextStyle(color: Color(0xFF3BB143)),)),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No",
                                  style: TextStyle(color: Color(0xFF3BB143)),))
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          });
        });
  }


  @override
  void initState() {
    tab = widget.tabValue;
    selectedFromDate = "${currentdate.year}-${currentdate.month}-${currentdate.day}";
    selectedToDate = "${currentdate.year}-${currentdate.month}-${currentdate.day}";
    viewAppointment(tab);
    super.initState();
  }

  void onClick(String value) {
    setState(() {
      tab = value;
      // if(tab=="upcoming"){
      //   UpcomingviewAppointment();
      // }else {
        viewAppointment(tab);
      // }
    });
  }




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
        lastDate: DateTime(2030),
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
        lastDate: DateTime(2030),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.white),
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
                      )),
                  child: Container(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    margin:
                        EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Menu("Appointment $tab")));
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
                            "APPOINTMENTS",
                            style: TextStyle(
                                color: Colors.white, fontSize: 21.61),
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
                  height: 10.0,
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
                        viewAppointment(tab);
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
                  height: 10.0,
                ),

                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: ShapeDecoration(
                    color: Color(0xFF3BB143),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          onClick("upcoming");
                        },
                        child: Container(
                          width: tab.matchAsPrefix("upcoming") != null
                              ? 90
                              : null,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: tab.matchAsPrefix("upcoming") != null
                              ? ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                )
                              : null,
                          child: Text(
                            'UPCOMING',
                            style: TextStyle(
                              color: tab.matchAsPrefix("upcoming") != null ? Colors.green:Colors.white,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onClick("pending");
                        },
                        child: Container(
                          width: tab.matchAsPrefix("pending") != null
                              ? 90
                              : null,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: tab.matchAsPrefix("pending") != null
                              ? ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                )
                              : null,
                          child: Text(
                            'PENDING',
                            style: TextStyle(
                              color: tab.matchAsPrefix("pending") != null ? Colors.green:Colors.white,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onClick("cancel");
                        },
                        child: Container(
                          width:
                              tab.matchAsPrefix("cancel") != null ? 90 : null,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: tab.matchAsPrefix("cancel") != null
                              ? ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                )
                              : null,
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: tab.matchAsPrefix("cancel") != null ? Colors.green:Colors.white,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onClick("completed");
                        },
                        child: Container(
                          width: tab.matchAsPrefix("completed") != null
                              ? 90
                              : null,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: tab.matchAsPrefix("completed") != null
                              ? ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                )
                              : null,
                          child: Text(
                            'COMPLETE',
                            style: TextStyle(
                              color: tab.matchAsPrefix("completed") != null ? Colors.green:Colors.white,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 20.0, right: 10.0, bottom: 0),
                    color: Colors.white,
                    // height: MediaQuery.of(context).size.height,
                    child: _pageLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _appointmentViewModel.status == false
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 80.0),
                                  child: Text(
                                    "Appointment not available".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : tab.matchAsPrefix("upcoming") != null
                                ? ListView.builder(
                                    itemCount: _list.length,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Body _body = _list[index];
                                      int randomNumber = _random.nextInt(5);
                                      // final time =
                                      // _body.time!.substring(0,2).contains("13") ? "01${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("14") ? "02${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("15") ? "03${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("16") ? "04${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("17") ? "05${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("18") ? "06${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("19") ? "07${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("20") ? "08${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("21") ? "09${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("22") ? "10${_body.time!.substring(2,5)} PM":
                                      // _body.time!.substring(0,2).contains("23") ? "11${_body.time!.substring(2,5)} PM":
                                      // "${_body.time!.substring(0,5)} AM";
                                      return Container(
                                          margin: EdgeInsets.only(bottom: 20.0),
                                          child: Card(
                                              color: Colors.white,
                                              shadowColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              elevation: 10.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF607D8B),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 20.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                            alignment: Alignment
                                                                .center,
                                                            width: 35,
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                            child: Image.asset(
                                                                "assets/Group 93.png"),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  _body.name
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "\u{20B9}${_body.fees}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "(${_body.date.toString().substring(0, 10)})",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "(${_body.from_time}-${_body.to_time})",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 20.0),
                                                        child: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                final call =
                                                                    Uri.parse(
                                                                        'tel:${_body.phone}');
                                                                if (await canLaunchUrl(
                                                                    call)) {
                                                                  launchUrl(
                                                                      call);
                                                                } else {
                                                                  throw 'Could not launch $call';
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            25.0,
                                                                        vertical:
                                                                            5.0),
                                                                decoration:
                                                                    ShapeDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(50),
                                                                        )),
                                                                child:
                                                                    Image.asset(
                                                                  "assets/Vector (20).png",
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              onTap: () {
                                                                updateStatusDailog(
                                                                    _body.id
                                                                        .toString());
                                                              },
                                                              child: Container(
                                                                width: 40,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5.0),
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  color: Color(
                                                                      0xFF74919F),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/status_ic.png",
                                                                      height:
                                                                          20,
                                                                      color: Color(
                                                                          0xffFEFEFE),
                                                                    ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                5.0),
                                                                        child:
                                                                            Text(
                                                                          "Status",
                                                                          style: TextStyle(
                                                                              fontSize: 12.0,
                                                                              color: Color(0xFFFDFDFD)),
                                                                        ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => EditAppointment(_body
                                                                            .id
                                                                            .toString(),tab)));
                                                              },
                                                              child: Container(
                                                                width: 40,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5.0),
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  color: Color(
                                                                      0xFF74919F),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                ),
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.0),
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/edit_ic.png",
                                                                      height:
                                                                          20,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                5.0),
                                                                        child:
                                                                            Text(
                                                                          "Edit",
                                                                          style: TextStyle(
                                                                              fontSize: 12.0,
                                                                              color: Colors.white),
                                                                        ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                deleteDailog(_body
                                                                    .id
                                                                    .toString());
                                                              },
                                                              child: Container(
                                                                width: 40,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5.0),
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  color: Color(
                                                                      0xFF74919F),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/delete_ic.png",
                                                                      height:
                                                                          20,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                5.0),
                                                                        child:
                                                                            Text(
                                                                          "Delete",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12.0),
                                                                        ))
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
                                              )));
                                    })
                                : tab.matchAsPrefix("pending") != null
                                    ? ListView.builder(
                                        itemCount: _list.length,
                                        shrinkWrap: true,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          Body _body = _list[index];
                                          int randomNumber = _random.nextInt(5);
                                          // final time =
                                          // _body.time!.substring(0,2).contains("13") ? "01${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("14") ? "02${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("15") ? "03${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("16") ? "04${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("17") ? "05${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("18") ? "06${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("19") ? "07${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("20") ? "08${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("21") ? "09${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("22") ? "10${_body.time!.substring(2,5)} PM":
                                          // _body.time!.substring(0,2).contains("23") ? "11${_body.time!.substring(2,5)} PM":
                                          // "${_body.time!.substring(0,5)} AM";
                                          return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 20.0),
                                              child: Card(
                                                  color: Colors.white,
                                                  shadowColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.0))),
                                                  elevation: 10.0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF607D8B),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.0,
                                                              vertical: 20.0),
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
                                                                height: 35,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child: Image.asset(
                                                                    "assets/Group 93.png"),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10.0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _body.name
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "\u{20B9}${_body.fees}",
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
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      "(${_body.date.toString().substring(0, 10)})",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "(${_body.from_time}-${_body.to_time})",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 20.0),
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    final call =
                                                                        Uri.parse(
                                                                            'tel:${_body.phone}');
                                                                    if (await canLaunchUrl(
                                                                        call)) {
                                                                      launchUrl(
                                                                          call);
                                                                    } else {
                                                                      throw 'Could not launch $call';
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            25.0,
                                                                        vertical:
                                                                            5.0),
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xfff5f5f5),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(50.0))),
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/Vector (20).png",
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                InkWell(
                                                                  onTap: () {
                                                                    updateStatusDailog(
                                                                        _body.id
                                                                            .toString());
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 40,
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            5.0),
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      color: Color(
                                                                          0xFF74919F),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6)),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/status_ic.png",
                                                                          height:
                                                                              20,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 5.0),
                                                                            child: Text(
                                                                              "Status",
                                                                              style: TextStyle(color: Colors.white, fontSize: 12.0),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                EditAppointment(_body.id.toString(),tab)));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 40,
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            5.0),
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      color: Color(
                                                                          0xFF74919F),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6)),
                                                                    ),
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/edit_ic.png",
                                                                          height:
                                                                              20,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 5.0),
                                                                            child: Text(
                                                                              "Edit",
                                                                              style: TextStyle(color: Colors.white, fontSize: 12.0),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    deleteDailog(
                                                                        _body.id
                                                                            .toString());
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 40,
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            5.0),
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      color: Color(
                                                                          0xFF74919F),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6)),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/delete_ic.png",
                                                                          height:
                                                                              20,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 5.0),
                                                                            child: Text(
                                                                              "Delete",
                                                                              style: TextStyle(color: Colors.white, fontSize: 12.0),
                                                                            ))
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
                                                  )));
                                        })
                                    : tab.matchAsPrefix("cancel") != null
                                        ? ListView.builder(
                                            itemCount: _list.length,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              Body _body = _list[index];
                                              int randomNumber =
                                                  _random.nextInt(5);
                                              // final time =
                                              // _body.time!.substring(0,2).contains("13") ? "01${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("14") ? "02${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("15") ? "03${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("16") ? "04${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("17") ? "05${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("18") ? "06${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("19") ? "07${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("20") ? "08${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("21") ? "09${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("22") ? "10${_body.time!.substring(2,5)} PM":
                                              // _body.time!.substring(0,2).contains("23") ? "11${_body.time!.substring(2,5)} PM":
                                              // "${_body.time!.substring(0,5)} AM";
                                              return Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20.0),
                                                  child: Card(
                                                      color: Colors.white,
                                                      shadowColor: Colors.white,
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
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
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
                                                                    height: 35,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .white),
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/Group 93.png"),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          _body
                                                                              .name
                                                                              .toString(),
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
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "₹${_body.fees}",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontFamily: 'Inter',
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                            // Container(
                                                                            //   height: 8.0,
                                                                            //   width: 8.0,
                                                                            //   margin: EdgeInsets.only(left: 5.0),
                                                                            //   decoration: BoxDecoration(
                                                                            //       shape: BoxShape.circle,
                                                                            //       gradient: LinearGradient(
                                                                            //           colors: [
                                                                            //             Color(0xffFF3D3D),
                                                                            //             Color(0xffFF663D)
                                                                            //           ],
                                                                            //           begin: const FractionalOffset(0.0, 0.0),
                                                                            //           end: const FractionalOffset(0.0, 1.0),
                                                                            //           stops: [0.0, 1.0],
                                                                            //           tileMode: TileMode.clamp
                                                                            //       )
                                                                            //   ),
                                                                            // )
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Container(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          "(${_body.date.toString().substring(0, 10)})",
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
                                                                        Text(
                                                                          "(${_body.from_time}-${_body.to_time})",
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
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        final call =
                                                                            Uri.parse('tel:${_body.phone}');
                                                                        if (await canLaunchUrl(
                                                                            call)) {
                                                                          launchUrl(
                                                                              call);
                                                                        } else {
                                                                          throw 'Could not launch $call';
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                25.0,
                                                                            vertical:
                                                                                5.0),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Color(0xfff5f5f5),
                                                                            borderRadius: BorderRadius.all(Radius.circular(50.0))),
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/Vector (20).png",
                                                                          color:
                                                                              Colors.green,
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
                                            })
                                        : tab.matchAsPrefix("completed") != null
                                            ? ListView.builder(
                                                itemCount: _list.length,
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  int randomNumber =
                                                      _random.nextInt(5);
                                                  Body _body = _list[index];
                                                  // final time =
                                                  // _body.time!.substring(0,2).contains("13") ? "01${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("14") ? "02${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("15") ? "03${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("16") ? "04${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("17") ? "05${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("18") ? "06${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("19") ? "07${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("20") ? "08${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("21") ? "09${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("22") ? "10${_body.time!.substring(2,5)} PM":
                                                  // _body.time!.substring(0,2).contains("23") ? "11${_body.time!.substring(2,5)} PM":
                                                  // "${_body.time!.substring(0,5)} AM";
                                                  return Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 20.0),
                                                      child: Card(
                                                          color: Colors.white,
                                                          shadowColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
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
                                                                            Alignment.center,
                                                                        width:
                                                                            35,
                                                                        height:
                                                                            35,
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: Colors.white),
                                                                        child: Image.asset(
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
                                                                              _body.name.toString(),
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontFamily: 'Inter',
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  "₹${_body.fees}",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 14,
                                                                                    fontFamily: 'Inter',
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
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
                                                                              "(${_body.date.toString().substring(0, 10)})",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontFamily: 'Inter',
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "(${_body.from_time}-${_body.to_time})",
                                                                              style: TextStyle(
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
                                                                        InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            final call =
                                                                                Uri.parse('tel:${_body.phone}');
                                                                            if (await canLaunchUrl(call)) {
                                                                              launchUrl(call);
                                                                            } else {
                                                                              throw 'Could not launch $call';
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                                                                            decoration:
                                                                                BoxDecoration(color: Color(0xfff5f5f5), borderRadius: BorderRadius.all(Radius.circular(50.0))),
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/Vector (20).png",
                                                                              color: Colors.green,
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
                                                })
                                            : Container(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
