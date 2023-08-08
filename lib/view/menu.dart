import 'package:astro_santhil_app/main.dart';
import 'package:astro_santhil_app/view/add_appointment.dart';
import 'package:astro_santhil_app/view/appointment.dart';
import 'package:astro_santhil_app/view/category_managmet.dart';
import 'package:astro_santhil_app/view/home.dart';
import 'package:astro_santhil_app/view/payments.dart';
import 'package:astro_santhil_app/view/slot_booking.dart';
import 'package:astro_santhil_app/view/upcoming_appointment.dart';
import 'package:astro_santhil_app/view/view_customer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  String tab = "";
  Menu(this.tab);

  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  String tab = "";

  void onClick(String value){
    setState(() {
      tab = value;
    });
  }

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
    tab = widget.tab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
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
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Image.asset(
                            "assets/Vector (18).png",
                            width: 22.51,
                            height: 20.58,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          "",
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
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(5, 5),
                      )
                    ]),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Color(0xFF3BB143),
                      child: Container(
                          padding: EdgeInsets.only(top: 12.0, bottom: 10.0),
                          child: Image.asset(
                            "assets/green text-01.png",
                            color: Colors.white,
                            width:80,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Astro Senthil',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      onClick("Home");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10.0),
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: tab.matchAsPrefix("Home") != null ? ShapeDecoration(
                          gradient: LinearGradient(
                            end: Alignment(-1, 0),
                            begin: Alignment(1.00, 0.00),
                            colors: [
                              Color(0x00009688),
                              Color(0xFF3BB143),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ) : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                "assets/Vector (19).png",
                                color: tab.matchAsPrefix("Home") != null ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Home",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: tab.matchAsPrefix("Home") != null ? Colors.white : Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                )),
                            Spacer(),
                          ],
                        )
                        // TAbBarr(
                        //   text: "Home",
                        //   icon: "assets/Vector (19).png",
                        // )
                        ),
                  ),
                  InkWell(
                    onTap: () {
                      onClick("Profile");
                      Fluttertoast.showToast(msg: "Coming soon");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: tab.matchAsPrefix("Profile") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/Group 93.png",
                              color: tab.matchAsPrefix("Profile") != null ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("My profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("Profile") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onClick("Add Appointment");

                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return MyDialog();
                      //   },
                      // );

                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddAppointment("", ""),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      decoration: tab.matchAsPrefix("Add Appointment") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/user_ic_white.png",
                              color: tab.matchAsPrefix("Add Appointment") != null ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Add Customer's",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("Add Appointment") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onClick("Appointment reports");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Appointment("upcoming"),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      decoration: tab.matchAsPrefix("Appointment reports") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,

                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/today_ic.png",
                              color: tab.matchAsPrefix("Appointment reports") != null ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Appointment reports",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("Appointment reports") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onClick("Today's Appointment");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UpcomingAppointment(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      decoration: tab.matchAsPrefix("Today's Appointment") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,

                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/today_ic.png",
                              color: tab.matchAsPrefix("Today's Appointment") != null ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Today's Appointment",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("Today's Appointment") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     onClick("Appointment completed");
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=> Appointment("completed"),
                  //     ));
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 10.0),
                  //     margin: EdgeInsets.symmetric(horizontal: 20.0),
                  //     decoration: tab.matchAsPrefix("Appointment completed") != null ? ShapeDecoration(
                  //       gradient: LinearGradient(
                  //         end: Alignment(-1, 0),
                  //         begin: Alignment(1.00, 0.00),
                  //         colors: [
                  //           Color(0x00009688),
                  //           Color(0xFF3BB143),
                  //         ],
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ) : null,
                  //
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         SizedBox(
                  //           height: 20,
                  //           width: 20,
                  //           child: Image.asset(
                  //             "assets/upcoming_ic.png",
                  //             color: tab.matchAsPrefix("Appointment completed") != null ? Colors.white : Colors.black,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 15,
                  //         ),
                  //         Text("Completed Appointment",
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //               color: tab.matchAsPrefix("Appointment completed") != null ? Colors.white : Colors.black,
                  //               fontSize: 15,
                  //               fontFamily: 'Poppins',
                  //               fontWeight: FontWeight.w400,
                  //             )),
                  //         Spacer(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     onClick("Appointment pending");
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=> Appointment("pending"),
                  //     ));
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 10.0),
                  //     decoration: tab.matchAsPrefix("Appointment pending") != null ? ShapeDecoration(
                  //       gradient: LinearGradient(
                  //         end: Alignment(-1, 0),
                  //         begin: Alignment(1.00, 0.00),
                  //         colors: [
                  //           Color(0x00009688),
                  //           Color(0xFF3BB143),
                  //         ],
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ) : null,
                  //
                  //     margin: EdgeInsets.symmetric(horizontal: 20.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         SizedBox(
                  //           height: 20,
                  //           width: 20,
                  //           child: Image.asset(
                  //             "assets/pending_ic.png",
                  //             color: tab.matchAsPrefix("Appointment pending") != null ? Colors.white : Colors.black,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 15,
                  //         ),
                  //         Text("Pending Appointment",
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //               color: tab.matchAsPrefix("Appointment pending") != null ? Colors.white : Colors.black,
                  //               fontSize: 15,
                  //               fontFamily: 'Poppins',
                  //               fontWeight: FontWeight.w400,
                  //             )),
                  //         Spacer(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     onClick("Appointment cancel");
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=> Appointment("cancel"),
                  //     ));
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 10.0),
                  //     margin: EdgeInsets.symmetric(horizontal: 20.0),
                  //     decoration: tab.matchAsPrefix("Appointment cancel") != null ? ShapeDecoration(
                  //       gradient: LinearGradient(
                  //         end: Alignment(-1, 0),
                  //         begin: Alignment(1.00, 0.00),
                  //         colors: [
                  //           Color(0x00009688),
                  //           Color(0xFF3BB143),
                  //         ],
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ) : null,
                  //
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         SizedBox(
                  //           height: 20,
                  //           width: 20,
                  //           child: Image.asset(
                  //             "assets/cancel_appointment_ic.png",
                  //             color: tab.matchAsPrefix("Appointment cancel") != null ? Colors.white : Colors.black,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 15,
                  //         ),
                  //         Text("Cancel Appointment",
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //               color: tab.matchAsPrefix("Appointment cancel") != null ? Colors.white : Colors.black,
                  //               fontSize: 15,
                  //               fontFamily: 'Poppins',
                  //               fontWeight: FontWeight.w400,
                  //             )),
                  //         Spacer(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      onClick("Slot Booking");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SlotBooking(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: tab.matchAsPrefix("Slot Booking") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/add_appointment_ic.png",
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Add Appointment",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("Slot Booking") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onClick("Payment");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Payments(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: tab.matchAsPrefix("Payment") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/pay_repo_ic.png",
                              color: tab.matchAsPrefix("Payment") != null ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Payment Reports",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("Payment") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onClick("Slots");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryManagement(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: tab.matchAsPrefix("Slots") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/category_manage_ic.png",
                              color: tab.matchAsPrefix("Slots") != null ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Slot Management",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("Slots") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onClick("View Customer");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewCustomer(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: tab.matchAsPrefix("View Customer") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/view_customer.png",
                              color: tab.matchAsPrefix("View Customer") != null ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("View Customers",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("View Customer") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      onClick("log");
                      navigateUser(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: tab.matchAsPrefix("log") != null ? ShapeDecoration(
                        gradient: LinearGradient(
                          end: Alignment(-1, 0),
                          begin: Alignment(1.00, 0.00),
                          colors: [
                            Color(0x00009688),
                            Color(0xFF3BB143),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ) : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/turn_off.png",
                              color: tab.matchAsPrefix("log") != null ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Log Out",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tab.matchAsPrefix("log") != null ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
