
import 'package:astro_santhil_app/models/appointment_view_model.dart';
import 'package:astro_santhil_app/models/cancel_appointment_model.dart';
import 'package:astro_santhil_app/models/complete_appointment_model.dart';
import 'package:astro_santhil_app/models/upcoming_appointment_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/edit_appointment.dart';
import 'package:astro_santhil_app/view/menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingAppointment extends StatefulWidget {
  const UpcomingAppointment({super.key});

  @override
  State<UpcomingAppointment> createState() => _UpcomingAppointmentState();
}

class _UpcomingAppointmentState extends State<UpcomingAppointment> {

  late AppointmentViewModel _appointmentViewModel;
  late CancelAppointmentModel _cancelAppointmentModel;
  late CompleteAppointmentModel _completeAppointmentModel;
  List<Body> _list = [];
  int _radioSelected = 0;
  String _radioVal = "";
  bool _pageLoading = false;

  Future<void> viewAppointment() async {
    _pageLoading = true;
    _list.clear();
    _appointmentViewModel = await Services.appointmentView("today");
    if(_appointmentViewModel.status == true){
      for(var i = 0; i < _appointmentViewModel.body!.length; i++){
        _list = _appointmentViewModel.body ?? <Body> [];
      }
    }
    setState(() {

    });
    _pageLoading = false;
  }

  void updateStatus(String id) async {
    _completeAppointmentModel = await Services.completeAppointment(id);
    if(_completeAppointmentModel.status == true){
      Fluttertoast.showToast(msg: "${_completeAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      Navigator.pop(context);
      viewAppointment();
    }else {
      Fluttertoast.showToast(msg: "${_completeAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {

    });
  }

  Future<void> deleteAppointment(String id) async {
    _cancelAppointmentModel = await Services.cancelAppointment(id);
    if(_cancelAppointmentModel.status == true){
      Fluttertoast.showToast(msg: "${_cancelAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      Navigator.pop(context);
      viewAppointment();
    }else {
      Fluttertoast.showToast(msg: "${_cancelAppointmentModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {

    });
  }

  void deleteDailog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
          content: Text("Are you sure you want to delete this appointment?", style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: (){
                  deleteAppointment(id);
                },
                child: Text("Yes", style: TextStyle(fontSize: 16.0),)
            ),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("No", style: TextStyle(fontSize: 16.0),)
            )
          ]
      ),
    );
  }

  void updateStatusDailog(String id) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState){
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
                            child: Text("Appointment Status", style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold
                            ),),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Radio(
                                  value: 1,
                                  groupValue: _radioSelected,
                                  onChanged: (value) {
                                    setState((){
                                      _radioSelected = value as int;
                                      _radioVal = 'Cancel';
                                      print(_radioVal);
                                    });
                                  }
                              ),
                              Text("Cancel")
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: 2,
                                  groupValue: _radioSelected,
                                  onChanged: (value) {
                                    setState((){
                                      _radioSelected = value as int;
                                      _radioVal = 'Complete';
                                      print(_radioVal);
                                    });
                                  }
                              ),
                              Text("Complete")
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 20.0,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: (){
                                      if(_radioSelected == 1){
                                        deleteAppointment(id);
                                      }else if(_radioSelected == 2){
                                        updateStatus(id);
                                      }
                                    },
                                    child: Text("Yes")
                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")
                                )

                              ],
                            ),
                          )
                        ],
                      ),
                    )
                );
              });
        }
    );
  }

  @override
  void initState() {
    viewAppointment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Menu("Appointment upcoming")));
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
                          "Upcoming Appointment",
                          style:
                          TextStyle(color: Colors.white, fontSize: 21.61),
                        ),
                      ),
                      Spacer(),
                      // Container(
                      //   child: InkWell(
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //     },
                      //     child: Icon(
                      //       Icons.home,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: 30.0,
              // ),
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0, bottom: 70.0),
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: _pageLoading? Center(
                  child: CircularProgressIndicator(),
                ): _appointmentViewModel.status == false ?Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: Text("Appointment not available".toUpperCase(),
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  ),
                ): ListView.builder(
                    itemCount: _list.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index){
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
                                            alignment: Alignment.center,
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white                                                ),
                                            child: Image.asset("assets/Group 93.png"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10.0),
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
                                                  ),
                                                ),
                                                Text("\u{20B9}${_body.fees}", style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),)
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text("(${_body.date.toString().substring(0,10)})",style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),),
                                                Text("(${_body.from_time}-${_body.to_time})",style: TextStyle(
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
                                                  launchUrl(call);
                                                } else {
                                                  throw 'Could not launch $call';
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                                                decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(50),
                                                    )
                                                ),
                                                child: Image.asset("assets/Vector (20).png",
                                                  color: Colors.green,),
                                              ),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: (){
                                                updateStatusDailog(_body.id.toString());
                                              },
                                              child: Container(
                                                width: 40,
                                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFF74919F),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Image.asset("assets/status_ic.png",
                                                      height: 20,
                                                      color: Color(0xffFEFEFE),),
                                                    Container(
                                                        margin: EdgeInsets.only(top: 5.0),
                                                        child: Text("Status",
                                                          style: TextStyle(fontSize: 12.0, color: Color(0xFFFDFDFD)),))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => EditAppointment(_body.id.toString(),"today")));
                                              },
                                              child: Container(
                                                width: 40,
                                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFF74919F),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                ),
                                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                                child: Column(
                                                  children: [
                                                    Image.asset("assets/edit_ic.png",
                                                      height: 20,
                                                      color: Colors.white,),
                                                    Container(
                                                        margin: EdgeInsets.only(top: 5.0),
                                                        child: Text("Edit", style: TextStyle(fontSize: 12.0,
                                                            color: Colors.white),))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                deleteDailog(_body.id.toString());
                                              },
                                              child: Container(
                                                width: 40,
                                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFF74919F),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

