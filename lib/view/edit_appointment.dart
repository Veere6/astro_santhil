import 'dart:math';

import 'package:astro_santhil_app/models/add_appointment_model.dart';
import 'package:astro_santhil_app/models/appointment_detai_model.dart';
import 'package:astro_santhil_app/models/customer_name_model.dart';
import 'package:astro_santhil_app/models/update_appointment_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/appointment.dart';
import 'package:astro_santhil_app/view/menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

class EditAppointment extends StatefulWidget {
  String id = "";

  EditAppointment(this.id);

  @override
  State<StatefulWidget> createState() => _EditAppointmentState();

}

class _EditAppointmentState extends State<EditAppointment> {

  TextEditingController fees = TextEditingController();
  TextEditingController msg = TextEditingController();

  late CustomerNameModel _customerNameModel;
  late AddAppointmentModel _addAppointmentModel;
  late UpdateAppointmentModel _updateAppointmentModel;
  late AppointmentDetailModel _detailModel;
  DateTime today = DateTime.now();
  PageController? _pageController;
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay? picked;
  int _radioSelected = 0;
  String _radioVal = "";
  String feesStatus = "";
  List<String> customer_id = ["0",];
  String selectedCustomer_id = "";
  String selectTimes = "Select Slot";
  String dropdownValue = 'Select Customer';
  bool isLoad = false;

  List <String> spinnerItems = [
    'Select Customer',
  ] ;

  Future<Null> selectTime(BuildContext context) async {
    picked = await showTimePicker(
        context: context,
        initialTime: _time,
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        }
    );
    if(picked != null){
      setState(() {
        _time = picked!;
        print(picked);
        selectTimes = "${picked?.hour}:${picked?.minute}:${picked?.period.name.toUpperCase()}";
      });
    }
  }

  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today = day;
      print(today);
    });
  }

  Future<void> viewDropDown() async {
    setState(() {
      isLoad = true;
    });
    _customerNameModel = await Services.nameListApi();
    if(_customerNameModel.status == true){
      for(var i=0; i < _customerNameModel.body!.length; i++){
        spinnerItems.add("${_customerNameModel.body![i].name}");
        customer_id.add(_customerNameModel.body![i].userId.toString());
      }
      print(spinnerItems);
      appointmentDetail();
    }else{
      Fluttertoast.showToast(
          msg: "not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      isLoad = false;
    });
  }

  Future<void> updateAppointment() async {
    _updateAppointmentModel = await Services.updateAppointment(widget.id, today.toString().substring(0,10),
        selectTimes, msg.text, fees.text, _radioSelected.toString());

    if(_updateAppointmentModel.status == true){
      Fluttertoast.showToast(msg: "${_updateAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Appointment("today")));
    }else{
      Fluttertoast.showToast(msg: "${_updateAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
  }

  Future<void> appointmentDetail() async {
    isLoad = true;
    _detailModel = await Services.appointmentDetail(widget.id);
    if(_detailModel.status == true){
      dropdownValue = "${_detailModel.body![0].name} (${_detailModel.body![0].phone})";
      today = DateTime.parse(_detailModel.body![0].date.toString());
      selectTimes = _detailModel.body![0].time.toString();
      fees.text = _detailModel.body![0].fees.toString();
      _radioSelected = int.parse(_detailModel.body![0].feesStatus.toString());
      msg.text = _detailModel.body![0].message.toString();
    }
    isLoad = false;
    setState(() {

    });

  }
  @override
  void initState() {
    super.initState();
    viewDropDown();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad ? Center(
        child: CircularProgressIndicator(),
      ): Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF009688),
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
                              MaterialPageRoute(builder: (context) => Menu("Edit Appointment")));
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
                          "EDIT APPOINTMENT",
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
              Container(
                margin: EdgeInsets.only(top: 12.13),
                color: Colors.white,
                // height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    //   child: Row(
                    //     children: [
                    //       InkWell(
                    //         onTap: () {
                    //           Navigator.pop(context);
                    //         },
                    //         child: Image.asset("assets/back_arrow_ic.png",
                    //           color: Colors.black,),
                    //       ),
                    //       Spacer(),
                    //       Image.asset("assets/send_ic.png",
                    //         color: Colors.black,),
                    //       SizedBox(width: 10.0,),
                    //       Image.asset("assets/fav_ic.png",
                    //         color: Colors.black,)
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Color(0xFFD0D4E0)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0))
                        ),
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down_sharp),
                                iconSize: 20,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                underline: Container(
                                  height: 0,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? data) {
                                  setState(() {
                                    dropdownValue = data!;
                                    if(dropdownValue != "Select Customer"){
                                      for(var i = 0; i < spinnerItems.length; i++){
                                        if(spinnerItems[i] == dropdownValue){
                                          selectedCustomer_id = customer_id[i];
                                        }
                                      }
                                      print("fghfdsasdfghgfdsasdfghgfdsaASDFG  "+selectedCustomer_id);
                                    }
                                  });
                                },
                                items: spinnerItems
                                    .map<DropdownMenuItem<String>>((String value){
                                  return DropdownMenuItem(
                                      value: value,
                                      child: Text(value)
                                  );
                                }).toList(),
                              )
                          ),
                          // Row(
                          //   children: [
                          //     Text("General Practitioner", style: TextStyle(fontSize: 16.82, color: Color(0xffB2B9C4)),),
                          //     Spacer(),
                          //     Container(
                          //         margin: EdgeInsets.only(top: 10.0),
                          //         child: Text("See All Reviews",
                          //           style: TextStyle(fontSize: 12.62, color: Color(0xffB2B9C4)),))
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Color(0xFFD0D4E0)),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0))
                      ),
                      child: TableCalendar(
                        focusedDay: today,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2050,10,16),
                          calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                  color: Color(0xFF009688),
                                  shape: BoxShape.circle
                              ),
                              todayDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0x9E009688)
                              )
                          ),
                        onCalendarCreated: (controller) => _pageController = controller,
                        onDaySelected: _onDaySelected,
                        selectedDayPredicate: (day) =>isSameDay(day, today),
                        availableGestures: AvailableGestures.all,
                        headerStyle: HeaderStyle(
                            headerMargin: EdgeInsets.only(bottom: 10.0),
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.black,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                            ),
                            titleTextStyle:
                            TextStyle(fontSize: 25.24, color: Color(0xFF828282)),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Color(0xFFD0D4E0))
                                )
                              // image: DecorationImage(
                              //     image:
                              //     AssetImage("assets/calender_bg.png"))
                            )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                      child: Text("SELECT TIME",
                      style: TextStyle(
                        color: Color(0xFF8A92A2),
                      ),),
                    ),
                    InkWell(
                      onTap: (){
                        selectTime(context);
                      },
                      child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Text(selectTimes),
                            Spacer(),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                      child: Text("Fees",
                          style: TextStyle(color: Color(0xFF8A92A2))),
                    ),
                    Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0,),
                      child: TextField(
                          controller: fees,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Fees',
                            hintStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xff6C7480),
                            ),
                            border: InputBorder.none,
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                      child: Text("Fees Type",
                          style: TextStyle(color: Color(0xFF8A92A2))),
                    ),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              activeColor: Colors.greenAccent,
                              value: 2,
                              groupValue: _radioSelected,
                              onChanged: (value) {
                                setState((){
                                  _radioSelected = value as int;
                                  _radioVal = 'Paid';
                                  print(_radioVal);
                                });
                              },
                            ),
                            Text('Paid'),
                            Radio(
                              activeColor: Colors.greenAccent,
                              value: 1,
                              groupValue: _radioSelected,
                              onChanged: (value) {
                                setState((){
                                  _radioSelected = value as int;
                                  _radioVal = 'UnPaid';
                                  print(_radioVal);
                                });
                              },
                            ),
                            Text('Un Paid'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                      child: Text("Messages",
                          style: TextStyle(color: Color(0xFF8A92A2))),
                    ),
                    Container(
                      height: 90,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                          controller: msg,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Message',
                            hintStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xff6C7480),
                            ),
                            border: InputBorder.none,
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, top: 20.0, right:20.0, bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              updateAppointment();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2.4,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              alignment: Alignment.center,
                              height: 45,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF009688),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'update'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(width: 10.0,),
                          // Container(
                          //   width: MediaQuery.of(context).size.width/2.4,
                          //   height: 60,
                          //   alignment: Alignment.center,
                          //   margin: EdgeInsets.only(left: 10.0),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           color: Color(0xffFF663D)
                          //       ),
                          //       borderRadius: BorderRadius.all(
                          //           Radius.circular(5.0)
                          //       )
                          //   ),
                          //   padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          //   child: Text("CANCEL"),
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}