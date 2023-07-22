import 'package:astro_santhil_app/models/login_model.dart';
import 'package:astro_santhil_app/networking/services.dart';
import 'package:astro_santhil_app/view/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Astro Senthil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    getContactPermission();
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      navigate();
    });
  }
  void navigate() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    bool? status  = _preferences.getBool("_login");

    if(status == true){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()));
    }else{
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  void getContactPermission() async {

    if(await Permission.contacts.isGranted) {
      // getContacts();
    }else {
      await Permission.contacts.request();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset("assets/green text-01.png")
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  late SharedPreferences _prefs;
  bool _boxValue = false;
  late LoginModel _loginModel;
  bool clickLoad = false;
  bool _isHidden = true;

  Future<void> loginMethod() async{
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      clickLoad = true;
    });
    _loginModel = await Services.loginApi(userName.text.trim(), password.text.trim());
    if(_loginModel.status == true){
      _prefs.setBool("_login", true);
      Fluttertoast.showToast(msg: "${_loginModel.msg}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()));
    }else{
      Fluttertoast.showToast(msg: "${_loginModel.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }
  void navigate() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    bool? status  = _preferences.getBool("_login");

    if(status == true){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()));
    }
  }

  void _togglePasswordView(){
    setState((){
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     // resizeToAvoidBottomInset: false,
     body: SafeArea(
       child: SingleChildScrollView(
         child: Container(
           color: Colors.white,
           // decoration: BoxDecoration(
           //   image: DecorationImage(
           //       image: AssetImage("assets/background.png"),
           //   fit: BoxFit.fitWidth)
           // ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Container(
                 child: Text("ASTRO SENTHIL",
                   style: TextStyle(fontSize: 34.09, color: Colors.white, fontWeight: FontWeight.w700),),
               ),
               Container(
                 child: Text("log in to continue",
                   style: TextStyle(fontSize: 16, color: Colors.white),),
               ),
               Container(
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
                 child: CircleAvatar(
                   radius: 70.0,
                   backgroundColor: Color(0xff009688),
                   child: Container(
                     padding: EdgeInsets.only(top: 12.0, bottom: 10.0),
                       child: Image.asset("assets/green text-01.png",
                       color: Colors.white,
                       width: 120,)),
                 ),
               ),
               Text(
                 'ASTRO SENTHIL',
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 24.09,
                   fontFamily: 'Poppins',
                   fontWeight: FontWeight.w700,
                 ),
               ),
               Text(
                 'log in to continue',
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 16,
                   fontFamily: 'Inter',
                   fontWeight: FontWeight.w400,
                 ),
               ),
               SizedBox(
                 height: 60,
               ),
               Container(
                 alignment: Alignment.centerLeft,
                 margin: EdgeInsets.only(left: 40.0),
                 child: Text(
                   'USERNAME',
                   textAlign: TextAlign.start,
                   style: TextStyle(
                     color: Color(0xFF8A92A2),
                     fontSize: 13.55,
                     fontFamily: 'Poppins',
                     fontWeight: FontWeight.w400,
                   ),
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(left: 40.0, top: 5.0, right: 40.0),
                 decoration: ShapeDecoration(
                     shape: RoundedRectangleBorder(
                       side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                       borderRadius: BorderRadius.circular(5),
                     )
                 ),
                 child: TextField(
                   controller: userName,
                   textAlignVertical: TextAlignVertical.center,
                   textAlign: TextAlign.left,
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                     isDense: true,
                     hintText: 'Username',
                     hintStyle: const TextStyle(
                       fontSize: 14.0,
                       color: Colors.black26,
                     ),
                     border: InputBorder.none,
                     prefixIcon: IconButton(
                       icon: Image.asset("assets/Group 117.png", width: 20, height: 20,), onPressed: () { },
                     ),
                   ),
                 ),
               ),
               SizedBox(
                 height: 20.0,
               ),
               Container(
                 alignment: Alignment.centerLeft,
                 margin: EdgeInsets.only(left: 40.0),
                 child: Text(
                   'PASSWORD',
                   style: TextStyle(
                     color: Color(0xFF8A92A2),
                     fontSize: 13.55,
                     fontFamily: 'Poppins',
                     fontWeight: FontWeight.w400,
                   ),
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(left: 40.0, top: 5.0, right: 40.0),
                 decoration: ShapeDecoration(
                     shape: RoundedRectangleBorder(
                       side: BorderSide(width: 0.50, color: Color(0xFFD0D4E0)),
                       borderRadius: BorderRadius.circular(5),
                     )
                 ),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Container(
                       margin: EdgeInsets.only(right: 6.0),
                       // decoration: BoxDecoration(
                       //     color: Colors.black,
                       //     borderRadius: BorderRadius.all(
                       //         Radius.circular(5.0)
                       //     )
                       // ),
                       child: IconButton(
                         icon: Image.asset("assets/lock.png", width: 20, height: 20,), onPressed: () { },
                       ),
                     ),
                     Expanded(
                       child: TextField(
                         controller: password,
                         obscureText: _isHidden,
                         textAlignVertical: TextAlignVertical.center,
                         textAlign: TextAlign.left,
                         keyboardType: TextInputType.text,
                         decoration: InputDecoration(
                           contentPadding: EdgeInsets.only(bottom: 0.0),
                           isDense: true,
                           hintText: 'Password',
                           hintStyle: const TextStyle(
                             fontSize: 14.0,
                             color: Colors.black26,
                           ),
                           border: InputBorder.none,
                         ),
                       ),
                     ),
                     InkWell(
                       onTap: _togglePasswordView,
                       child: Container(
                         margin: EdgeInsets.only(right: 8.0),
                         child: Icon(
                           _isHidden
                               ? Icons.visibility_outlined
                               : Icons.visibility_off_outlined,
                           color: Color(0xff262A3F),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(left: 30.0),
                 child: Row(
                   children: [
                     Checkbox(
                         value: this._boxValue,
                         focusColor: Colors.white,
                         side: BorderSide(
                           color: Colors.white
                         ),
                         onChanged: (bool? value) {
                           setState(() {
                             this._boxValue = value!;
                           });
                         }
                     ),
                     Container(
                       child: Text("Remember Me", style: TextStyle(color: Colors.white),),
                     )
                   ],
                 ),
               ),
               InkWell(
                 onTap: (){
                   if(userName.text.isEmpty){
                     Fluttertoast.showToast(msg: "Please Enter User Name");
                   }else if(password.text.isEmpty){
                     Fluttertoast.showToast(msg: "Please Enter Password");
                   }else{
                     loginMethod();
                   }
                 },
                 child: Container(
                   height: 50,
                   margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                     decoration: ShapeDecoration(
                       color: Color(0xFF009688),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                     ),
                   child: Container(
                     margin: EdgeInsets.symmetric(horizontal: 20.44),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           clickLoad ? Container(
                             width: 24,
                             height: 24,
                             padding: EdgeInsets.all(2.0),
                             child: const CircularProgressIndicator(
                               color: Colors.white,
                               strokeWidth: 3.0,
                             ),
                           ):
                           Text(
                             'Login',
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 14,
                               fontFamily: 'Poppins',
                               fontWeight: FontWeight.w500,
                             ),
                           )                         ],
                       )),
                 ),
               ),
             ],
           ),
         ),
       ),
     )
   );
  }


}
