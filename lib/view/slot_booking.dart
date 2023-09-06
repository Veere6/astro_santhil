import 'package:astro_santhil_app/commonpackage/SearchChoices.dart';
import 'package:astro_santhil_app/models/add_appointment_model.dart';
import 'package:astro_santhil_app/models/customer_name_model.dart';
import 'package:astro_santhil_app/models/slot_view_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/add_appointment.dart';
import 'package:astro_santhil_app/view/appointment.dart';
import 'package:astro_santhil_app/view/menu.dart';
// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class SlotBooking extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking> {
  TextEditingController fees = TextEditingController();
  TextEditingController msg = TextEditingController();
  List<DropdownMenuItem> cutomerItems = [];
  List<DropdownMenuItem> slotItems = [];
  // List<Contact> contacts = [];
  // List<Contact> foundContacts = [];
  bool isLoading = false;

  late CustomerNameModel _customerNameModel;
  late AddAppointmentModel _addAppointmentModel;
  DateTime today = DateTime.now();
  PageController? _pageController;
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay? picked;
  int _radioSelected = 0;
  String _radioVal = "";
  String feesStatus = "";
  List<String> customer_id = [
    "0",
  ];
  List<String> slot_id = [
    "0",
  ];
  String selectedCustomer_id = "";
  String selectedSlot_id = "";
  String selectTimes = "Select Time";
  String dropdownValue = "";
  String dropdownValue2 = "";
  bool clickLoad = false;

  List<String> spinnerItems = [
    'Select Customer',
  ];

  dynamic formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    var format = DateFormat('hh:mm a').format(dateTime);
    return format.replaceAll(" ", "");
  }


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
    if (picked != null) {
      setState(() {
        _time = picked!;
        print(picked);
        selectTimes =
            "${picked?.hour}:${picked?.minute}:${picked?.period.name.toUpperCase()}";
      });
    }
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      slots();
      print(today);
    });
  }

  Future<void> viewDropDown() async {
    _customerNameModel = await Services.nameListApi();
    if (_customerNameModel.status == true) {
      for (var i = 0; i < _customerNameModel.body!.length; i++) {
        spinnerItems.add("${_customerNameModel.body![i].name}");
        cutomerItems.add(DropdownMenuItem(
          child: Text(_customerNameModel.body![i].name.toString()),
          value: _customerNameModel.body![i].name.toString(),
        ));
        customer_id.add(_customerNameModel.body![i].userId.toString());
      }
    } else {
      Fluttertoast.showToast(
          msg: "not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {});
  }

  Future<void> addAppointment() async {
    setState(() {
      clickLoad = true;
    });
    _addAppointmentModel = await Services.addAppointment(
        selectedCustomer_id,
        today.toString().substring(0, 10),
        // selectTimes,
        msg.text,
        fees.text,
        _radioSelected.toString(),selectedSlot_id);

    if (_addAppointmentModel.status == true) {
      Fluttertoast.showToast(
          msg: "${_addAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Appointment("upcoming")));
    } else {
      Fluttertoast.showToast(
          msg: "${_addAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }

  void getContactPermission() async {

    if(await Permission.contacts.isGranted) {
      // getContacts();
    }else {
      await Permission.contacts.request();
    }
  }

  // void getContacts() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //  contacts = await ContactsService.getContacts();
  //  print(contacts[0].phones![0].value);
  //
  //  foundContacts = contacts;
  //  print(foundContacts);
  //  setState(() {
  //    isLoading = false;
  //  });
  // }


  // void contactList(){
  //   showBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.white,
  //       elevation: 10,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //       builder: (context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState){
  //               return ListView.builder(
  //                 itemCount: contacts.length,
  //                   itemBuilder: (context, index){
  //                   return ListTile(
  //                     leading: Text(contacts[index].displayName.toString()),
  //                   );
  //                   });
  //             }
  //         );
  //       }
  //   );
  // }

  @override
  void initState() {
    super.initState();
    viewDropDown();
    slots();
  }


  List<String> _list = [];
  bool _pageLoading = false;
  String dob="";

  late ViewSlotModel _viewSlotModel;
  void slots() async {
    _pageLoading = true;
    dob = today.toString().substring(0, 10);
    if(dob != "Select Date"){
      dob = dob;
    }else{
      dob = "";
    }
    _list.clear();
    slot_id.clear();
    slotItems.clear();
    _viewSlotModel = await Services.SlotView(dob);

    if(_viewSlotModel.status == true){
      for(var i = 0; i < _viewSlotModel.body!.length; i++) {
        // _list = _viewSlotModel.body[i]. ?? [];

        SlotBody _body = _viewSlotModel.body![i];
        final fromTime =_body.fromTime.toString().toUpperCase();

        final toTime =_body.toTime.toString().toUpperCase();
        TimeOfDay now = TimeOfDay.now();
        print(formatTimeOfDay(now));

        if (_body.bookStatus != "1") {
          _list.add("${fromTime} - ${toTime}");
          slot_id.add("${_body.slotId}");
          slotItems.add(DropdownMenuItem(
            child: Text("${fromTime} - ${toTime}"),
            value: "${fromTime} - ${toTime}",
          ));
        }
      }
    }
    setState(() {
      _pageLoading = false;
    });
  }


  // void searchFilter(String enteredKeyword, StateSetter dState) {
  //   List<Contact> results = [];
  //   if(enteredKeyword.isEmpty){
  //     results = contacts;
  //   }else{
  //     results = contacts
  //         .where((element) =>
  //         element.givenName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
  //   }
  //   dState(() {
  //     foundContacts = results;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
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
                                  MaterialPageRoute(builder: (context) => Menu("Slot Booking")));
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
                              "SLOT BOOKING",
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
                        //         color: Colors.black,),
                        //       ),
                        //       Spacer(),
                        //       Image.asset("assets/send_ic.png",
                        //       color: Colors.black,),
                        //       SizedBox(width: 10.0,),
                        //       Image.asset("assets/fav_ic.png",
                        //       color: Colors.black,)
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                        padding:
                                        EdgeInsets.only(left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(
                                            border:
                                            Border.all(color: Color(0xFFD0D4E0)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: SearchChoices.single(
                                          value: dropdownValue,
                                          items: cutomerItems,
                                          hint: "Select Customer",
                                          searchHint: "Select Customer",
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(),
                                          onChanged: (value) {
                                            setState(() {
                                              dropdownValue = value;
                                              if (dropdownValue != "Select Customer") {
                                                for (var i = 0;
                                                i < spinnerItems.length;
                                                i++) {
                                                  if (spinnerItems[i] ==
                                                      dropdownValue) {
                                                    selectedCustomer_id =
                                                    customer_id[i];
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
                                        )
                                      // DropdownButton<String>(
                                      //         value: dropdownValue,
                                      //         isExpanded: true,
                                      //         icon: Icon(Icons.keyboard_arrow_down_sharp),
                                      //         iconSize: 20,
                                      //         elevation: 16,
                                      //         style: const TextStyle(
                                      //             color: Colors.black,
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w400),
                                      //         underline: Container(
                                      //             height: 0,
                                      //             color: Colors.deepPurpleAccent,
                                      //           ),
                                      //         onChanged: (String? data) {
                                      //           setState(() {
                                      //             dropdownValue = data!;
                                      //             if(dropdownValue != "Select Customer"){
                                      //               for(var i = 0; i < spinnerItems.length; i++){
                                      //                 if(spinnerItems[i] == dropdownValue){
                                      //                   selectedCustomer_id = customer_id[i];
                                      //                 }
                                      //               }
                                      //               print("fghfdsasdfghgfdsasdfghgfdsaASDFG  "+selectedCustomer_id);
                                      //             }
                                      //           });
                                      //         },
                                      //         items: spinnerItems
                                      //             .map<DropdownMenuItem<String>>((String value){
                                      //               return DropdownMenuItem(
                                      //                 value: value,
                                      //                   child: Text(value)
                                      //               );
                                      //         }).toList(),
                                      //       )
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text("General Practitioner", style: TextStyle(fontSize: 16.82, color: Color(0xffB2B9C4)),),
                              //     Spacer(),
                              //     Container(
                              //       margin: EdgeInsets.only(top: 10.0),
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
                            firstDay: DateTime.now(),
                            lastDay: DateTime.utc(2050, 10, 16),
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: Color(0xFF3BB143),
                                shape: BoxShape.circle
                              ),
                              todayDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0x9E009688)
                              )
                            ),
                            onCalendarCreated: (controller) =>
                            _pageController = controller,
                            onDaySelected: _onDaySelected,
                            selectedDayPredicate: (day) => isSameDay(day, today),
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
                          margin:
                          EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                          child: Text("SELECT SLOT",
                          style: TextStyle(color: Color(0xFF8A92A2)),),
                        ),

                        Container(
                          margin: EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                        padding:
                                        EdgeInsets.only(left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(
                                            border:
                                            Border.all(color: Color(0xFFD0D4E0)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: SearchChoices.single(
                                          value: dropdownValue2,
                                          items: slotItems,
                                          hint: "Select Slot",
                                          searchHint: "Select Slot",
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(),
                                          onChanged: (value) {
                                            setState(() {
                                              dropdownValue2 = value;
                                              print(dropdownValue2);
                                              if (dropdownValue2 != "Select Slot") {
                                                for (var i = 0; i < spinnerItems.length; i++) {
                                                  if (_list[i] == dropdownValue2) {
                                                    selectedSlot_id = slot_id[i];
                                                  }
                                                }
                                              }
                                            });
                                          },
                                          displayClearIcon: false,
                                          isExpanded: true,
                                        )
                                      // DropdownButton<String>(
                                      //         value: dropdownValue,
                                      //         isExpanded: true,
                                      //         icon: Icon(Icons.keyboard_arrow_down_sharp),
                                      //         iconSize: 20,
                                      //         elevation: 16,
                                      //         style: const TextStyle(
                                      //             color: Colors.black,
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w400),
                                      //         underline: Container(
                                      //             height: 0,
                                      //             color: Colors.deepPurpleAccent,
                                      //           ),
                                      //         onChanged: (String? data) {
                                      //           setState(() {
                                      //             dropdownValue = data!;
                                      //             if(dropdownValue != "Select Customer"){
                                      //               for(var i = 0; i < spinnerItems.length; i++){
                                      //                 if(spinnerItems[i] == dropdownValue){
                                      //                   selectedCustomer_id = customer_id[i];
                                      //                 }
                                      //               }
                                      //               print("fghfdsasdfghgfdsasdfghgfdsaASDFG  "+selectedCustomer_id);
                                      //             }
                                      //           });
                                      //         },
                                      //         items: spinnerItems
                                      //             .map<DropdownMenuItem<String>>((String value){
                                      //               return DropdownMenuItem(
                                      //                 value: value,
                                      //                   child: Text(value)
                                      //               );
                                      //         }).toList(),
                                      //       )
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text("General Practitioner", style: TextStyle(fontSize: 16.82, color: Color(0xffB2B9C4)),),
                              //     Spacer(),
                              //     Container(
                              //       margin: EdgeInsets.only(top: 10.0),
                              //         child: Text("See All Reviews",
                              //           style: TextStyle(fontSize: 12.62, color: Color(0xffB2B9C4)),))
                              //   ],
                              // )
                            ],
                          ),
                        ),
                        // Container(
                        //   margin:
                        //   EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                        //   child: Text("SELECT TIME",
                        //   style: TextStyle(color: Color(0xFF8A92A2)),),
                        // ),
                        // InkWell(
                        //   onTap: () {
                        //     selectTime(context);
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         border: Border.all(color: Color(0xFFD0D4E0)),
                        //         borderRadius:
                        //         BorderRadius.all(Radius.circular(5.0))),
                        //     margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 20.0, vertical: 10.0),
                        //     child: Row(
                        //       children: [
                        //         Text(selectTimes),
                        //         Spacer(),
                        //         Icon(Icons.keyboard_arrow_down)
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Container(
                          margin:
                          EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                          child: Text("Fees",
                              style: TextStyle(color: Color(0xFF8A92A2))),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFD0D4E0)),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5.0))),
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: TextField(
                              controller: fees,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Fees',
                                prefixText: "\u{20B9}",
                                prefixStyle: TextStyle(color: Colors.black),
                                hintStyle: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xff6C7480),
                                ),
                                border: InputBorder.none,
                              )),
                        ),
                        Container(
                          margin:
                          EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                          child: Text("Fees Type",style: TextStyle(color: Color(0xFF8A92A2))),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                activeColor: Colors.greenAccent,
                                value: 2,
                                groupValue: _radioSelected,
                                onChanged: (value) {
                                  setState(() {
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
                                  setState(() {
                                    _radioSelected = value as int;
                                    _radioVal = 'UnPaid';
                                    print(_radioVal);
                                  });
                                },
                              ),
                              Text('UnPaid'),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                          EdgeInsets.only(left: 30.0, top: 20.0, bottom: 5.0),
                          child: Text("Message",
                              style: TextStyle(color: Color(0xFF8A92A2))),
                        ),
                        Container(
                          height: 90,
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFD0D4E0)),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5.0))),
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
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 0.0, top: 20.0, right: 0.0, bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  // width: MediaQuery.of(context).size.width / 2.4,
                                  width: 160,
                                  height: 45,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 10.0),
                                  decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Color(0xFF3BB143)),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Text("CANCEL", style: TextStyle(color: Color(0xFF3BB143)),),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  if (dropdownValue == "Select Customer") {
                                    Fluttertoast.showToast(
                                        msg: "Please Select Customer",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR);
                                  }
                                  else if (dropdownValue2 == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please Select Slot",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR);
                                  }
                                  else if (fees.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please Enter Fees",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR);
                                  } else if (_radioSelected == 0) {
                                    Fluttertoast.showToast(
                                        msg: "Please Select Fess Type",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR);
                                  }
                                  // else if (msg.text.isEmpty) {
                                  //   Fluttertoast.showToast(
                                  //       msg: "Please Enter Message",
                                  //       toastLength: Toast.LENGTH_SHORT,
                                  //       gravity: ToastGravity.SNACKBAR);
                                  // }
                                  else {
                                    addAppointment();
                                  }
                                },
                                child: Container(
                                  // width: MediaQuery.of(context).size.width / 2.4,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  alignment: Alignment.center,
                                  // width: 140,
                                  height: 45,
                                  margin: EdgeInsets.only(right: 10.0),
                                  decoration: BoxDecoration(
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Color(0xff1BBF57).withOpacity(0.2),
                                    //     spreadRadius: 2,
                                    //     blurRadius: 10,
                                    //     offset: Offset(
                                    //         0, 10), // changes position of shadow
                                    //   ),
                                    // ],
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    color: Color(0xFF3BB143)
                                  ),
                                  child: clickLoad
                                      ? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3.0,
                                        ),
                                      )
                                    ],
                                  )
                                      : Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Make appointment'
                                            .toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class MYBottomSheet extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => _BottomSheetState();
// }
//
// class _BottomSheetState extends State<MYBottomSheet>{
//
//   // List<Contact> contacts = [];
//   // List<Contact> foundContacts = [];
//   bool isLoading = false;
//
//   // void getContactPermission() async {
//   //
//   //   if(await Permission.contacts.isGranted) {
//   //     getContacts();
//   //   }else if(await Permission.contacts.isPermanentlyDenied) {
//   //     await Permission.contacts.request();
//   //     if (await Permission.contacts.isGranted) {
//   //       getContacts();
//   //     }
//   //   }else {
//   //     await Permission.contacts.request();
//   //     if (await Permission.contacts.isGranted) {
//   //       getContacts();
//   //     }
//   //   }
//   // }
//
//   // void getContacts() async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   contacts = await ContactsService.getContacts();
//   //   print(contacts[0].phones![0].value);
//   //
//   //   foundContacts = contacts;
//   //   print(foundContacts);
//   //   setState(() {
//   //     isLoading = false;
//   //   });
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     // getContactPermission();
//   }
//
//   // void searchFilter(String enteredKeyword, StateSetter dState) {
//   //   List<Contact> results = [];
//   //   if(enteredKeyword.isEmpty){
//   //     results = contacts;
//   //   }else{
//   //     results = contacts
//   //         .where((element) =>
//   //         element.givenName!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
//   //             element.phones![0].value!.contains(enteredKeyword)).toList();
//   //   }
//   //   dState(() {
//   //     foundContacts = results;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState){
//             return isLoading ? Center(
//               child: CircularProgressIndicator(),
//             ):Container(
//               height: MediaQuery.of(context).size.height,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 50.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: InkWell(
//                           onTap: (){
//                             Navigator.pop(context);
//                           },
//                           child: Icon(Icons.arrow_back_rounded)),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Color(0xff6C7480)),
//                           borderRadius:
//                           BorderRadius.all(Radius.circular(5.0))),
//                       margin: EdgeInsets.only(left: 20.0, right: 20.0),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20.0,
//                       ),
//                       child: TextField(
//                         // controller: fees,
//                         textAlignVertical: TextAlignVertical.center,
//                         textAlign: TextAlign.left,
//                         decoration: InputDecoration(
//                           isDense: true,
//                           hintText: 'Search Contact',
//                           prefixStyle: TextStyle(color: Colors.black),
//                           hintStyle: const TextStyle(
//                             fontSize: 14.0,
//                             color: Color(0xff6C7480),
//                           ),
//                           border: InputBorder.none,
//                         ),
//                         // onChanged: (value) => searchFilter(value, setState),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                           itemCount: foundContacts.length,
//                           shrinkWrap: true,
//                           itemBuilder: (context, index){
//                             return InkWell(
//                               onTap: (){
//                                 setState((){
//                                   // dropdownValue = foundContacts[index].displayName.toString();
//                                 });
//                                 // cutomerItems.add(DropdownMenuItem(
//                                 //   child: Text(foundContacts[index].displayName.toString()),
//                                 //   value: foundContacts[index].displayName.toString(),
//                                 // ));
//                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
//                                     AddAppointment(foundContacts[index].displayName.toString(), foundContacts[index].phones![0].value.toString())));
//                               },
//                               child: ListTile(
//                                 leading: Container(
//                                   height: 30,
//                                   width: 30,
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                             blurRadius: 7,
//                                             color: Colors.white.withOpacity(0.1),
//                                             offset: Offset(-3, -3)
//                                         ),
//                                         BoxShadow(
//                                             blurRadius: 7,
//                                             color: Colors.black.withOpacity(0.1),
//                                             offset: Offset(3, -3)
//                                         )
//                                       ],
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(6.0)
//                                       ),
//                                       color: Color(0xff262626)
//                                   ),
//                                   child: Text(
//                                     "${foundContacts[index].givenName?.substring(0,1).toUpperCase()}",
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.white
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   "${foundContacts[index].displayName}",
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   "${foundContacts[index].phones![0].value}",
//                                   style: TextStyle(
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w400
//                                   ),
//                                 ),
//                                 horizontalTitleGap: 12,
//                               ),
//                             );
//                           }),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           }),
//     );
//   }
//
// }