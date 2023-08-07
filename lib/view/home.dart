import 'package:astro_santhil_app/main.dart';
import 'package:astro_santhil_app/models/dashboard.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/add_appointment.dart';
import 'package:astro_santhil_app/view/appointment.dart';
import 'package:astro_santhil_app/view/category_managmet.dart';
import 'package:astro_santhil_app/view/menu.dart';
import 'package:astro_santhil_app/view/payments.dart';
import 'package:astro_santhil_app/view/slot_booking.dart';
import 'package:astro_santhil_app/view/view_customer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var image = [
    "assets/user_ic_white.png",
    "assets/today_ic.png",
    "assets/upcoming_ic.png",
    "assets/pending_ic.png",
    "assets/cancel_appointment_ic.png",
    "assets/add_appointment_ic.png",
    "assets/pay_repo_ic.png",
    "assets/category_manage_ic.png",
    "assets/view_customer.png"
  ];

  var bgImgae = [
    "assets/Vector (1).png",
    "assets/Vector (2).png",
    "assets/Vector (3).png",
    "assets/Vector (4).png",
    "assets/Vector (5).png",
    "assets/Vector (6).png",
    "assets/Vector (7).png",
    "assets/Vector (8).png",
    "assets/Vector (9).png",
  ];

  var name = [
    "Add\nCustomer",
    "Today`s Appointment",
    "Upcoming Appointment",
    "Pending Appointment",
    "Cancelled Appointment",
    "Add Appointment",
    "Payment Reports",
    "Category Management",
    "Customer Managment"
  ];
  var navigate = [
    AddAppointment("", ""),
    Appointment("today"),
    Appointment("today"),
    Appointment("pending"),
    Appointment("cancel"),
    SlotBooking(),
    Payments(),
    CategoryManagement(),
    ViewCustomer(),
  ];

  void navigateUser(BuildContext context) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    _preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (route) => false);
  }


  @override
  void initState() {
    dashboardmethod();
  }

  int appointment_counts=0;
  String total_amount="0";
  void dashboardmethod()async{
    Dashboard dashboard = await Services.DashboardApi();
    if(dashboard.status==true){
      appointment_counts=dashboard.body?[0].appointmentCounts ?? 0;
      total_amount=dashboard.body?[0].totalAmount ?? "0";
      setState(() {
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                  margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Menu("Home")));
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
                          "HOME",
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
              Container(
                margin: EdgeInsets.only(left: 20.22, top: 30.0, right: 20.22),
                padding: EdgeInsets.all(15.0),
                decoration: ShapeDecoration(
                  color: Color(0xFF3BB143),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ]),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.white,
                        child: Container(
                            child: Image.asset(
                          "assets/green text-01.png",
                          width: 90,
                        )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin',
                            style: TextStyle(
                              color: Color(0xFFF6F2FA),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Astro Senthil',
                            style: TextStyle(
                              color: Color(0xFFF6F2FA),
                              fontSize: 28,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 38,
              ),
              Container(
                height: 0.5,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFD3D3D3),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ]),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage("assets/Vector (2).png"),
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        "assets/today_ic.png",
                        height: 20.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Today's Total Appointment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${appointment_counts}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ]),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage("assets/Vector (8).png"),
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        "assets/pay_repo_ic.png",
                        height: 20.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Monthly Total Earning's",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "\u{20B9}${total_amount}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              )
              // GridView.builder(
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 3,
              //       mainAxisSpacing: 20.0,
              //       // crossAxisSpacing: 20.0
              //     ),
              //     itemCount: name.length,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         margin: EdgeInsets.only(left: 10, right: 10),
              //         padding: EdgeInsets.symmetric(vertical: 15.0),
              //         decoration: ShapeDecoration(
              //           color: Colors.white,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //           shadows: [
              //             BoxShadow(
              //               color: Color(0x26000000),
              //               blurRadius: 20,
              //               offset: Offset(0, 4),
              //               spreadRadius: 0,
              //             )
              //           ],
              //         ),
              //         child: InkWell(
              //           onTap: (){
              //             Navigator.push(
              //                 context, MaterialPageRoute(builder: (context) => navigate[index]));
              //           },
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               CircleAvatar(
              //                 radius: 20.0,
              //                 backgroundImage: AssetImage("${bgImgae[index]}"),
              //                 backgroundColor: Colors.transparent,
              //                 child: Image.asset("${image[index]}",
              //                 height: 20.0,),
              //               ),
              //               Expanded(
              //                 child: Text("${name[index]}", textAlign: TextAlign.center,
              //                 style: TextStyle(),),
              //               )
              //             ],
              //           ),
              //         ),
              //       );
              //     })
            ],
          ),
        ),
      ),
    );
  }
}
