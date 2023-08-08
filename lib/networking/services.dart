
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:astro_santhil_app/models/add_appointment_model.dart';
import 'package:astro_santhil_app/models/add_customer_model.dart';
import 'package:astro_santhil_app/models/appointment_detai_model.dart';
import 'package:astro_santhil_app/models/appointment_view_model.dart';
import 'package:astro_santhil_app/models/category_model.dart';
import 'package:astro_santhil_app/models/complete_appointment_model.dart';
import 'package:astro_santhil_app/models/counrty_model.dart';
import 'package:astro_santhil_app/models/customer_detail_model.dart';
import 'package:astro_santhil_app/models/customer_name_model.dart';
import 'package:astro_santhil_app/models/dashboard.dart';
import 'package:astro_santhil_app/models/delete_customer_model.dart';
import 'package:astro_santhil_app/models/login_model.dart';
import 'package:astro_santhil_app/models/payment_view_model.dart';
import 'package:astro_santhil_app/models/slot_view_model.dart';
import 'package:astro_santhil_app/models/sub_category_model.dart';
import 'package:astro_santhil_app/models/cancel_appointment_model.dart';
import 'package:astro_santhil_app/models/upcoming_appointment_model.dart';
import 'package:astro_santhil_app/models/update_appointment_model.dart';
import 'package:astro_santhil_app/models/update_customer_model.dart';
import 'package:astro_santhil_app/models/view_customer_model.dart';
import 'package:http/http.dart'as http;
import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Services {

  static String mainUrl = "https://eyellowpagesafrica.com/astro_senthil/api/";

  static String login = "${mainUrl}admin";
  static String appointment = "${mainUrl}Apointment";
  static String category = "${mainUrl}Cat_manage";
  static String addCustomer = "${mainUrl}Add_customer";
  static String nameList = "${mainUrl}Customer_api";
  static String payment = "${mainUrl}Admin";

  static Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    print("objectffgfgfgfg $imageUrl");
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    print("objectmnbnnv ${file}");
    return file;
  }

  static Future<LoginModel> loginApi(String name, String pass) async {
    final params = {
    "flag":"login",
    "username":name,
    "password":pass
    };

    http.Response response = await http.post(Uri.parse(login), body: params);
    print("loginApi ${params}");
    print("loginApi ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      LoginModel user = LoginModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      LoginModel user = LoginModel.fromJson(data);
      return user;
    }
  }
  static Future<Dashboard> DashboardApi() async {
    final params = {
    "flag":"dashboard_count_view",
    };

    http.Response response = await http.post(Uri.parse(payment), body: params);
    print("DashboardApi ${params}");
    print("DashboardApi ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Dashboard user = Dashboard.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      Dashboard user = Dashboard.fromJson(data);
      return user;
    }
  }

  static Future<AppointmentViewModel> appointmentView(String type,String fromdate,todate) async {
    final params = {
      "flag":"view_type",
      "view_type":type,
      "s_date":fromdate,
      "e_date":todate
    };

    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("appointmentView ${params}");
    print("appointmentView ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AppointmentViewModel user = AppointmentViewModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      AppointmentViewModel user = AppointmentViewModel.fromJson(data);
      return user;
    }
  }

  static Future<CategoryModel> categoryList() async {
    final params = {
      "flag":"view_cat",
    };

    http.Response response = await http.post(Uri.parse(category), body: params);

    print("categoryList ${params}");
    print("categoryList ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CategoryModel user = CategoryModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CategoryModel user = CategoryModel.fromJson(data);
      return user;
    }
  }

  static Future<SubCategoryModel> subCategoryList(String catId) async {
    final params = {
      "flag":"view_sub_cat",
      "cat_id": catId
    };

    http.Response response = await http.post(Uri.parse(category), body: params);

    print("subCategoryList ${params}");
    print("subCategoryList ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      SubCategoryModel user = SubCategoryModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      SubCategoryModel user = SubCategoryModel.fromJson(data);
      return user;
    }
  }

  static Future<AddCustomerModel> customerAdd(String name, String gender, String city, String dob, String birt_time,
      String email, String phone, String catId, String subCatId, String countryId, String text, String birthPlace,
      File image, File hImage) async {
    var request = new http.MultipartRequest("POST", Uri.parse(addCustomer));
    var Image;
    var fImage;
    if(hImage!=null && hImage.path!=""){
       fImage = await http.MultipartFile.fromPath("h_image", hImage.path);
    }
    if(image!=null && image.path!=""){
      Image = await http.MultipartFile.fromPath("u_image", image.path);
    }

    request.fields["name"] = name;
    request.fields["gender"] = gender;
    request.fields["city"] = city;
    request.fields["dob"] = dob;
    request.fields["birth_time"] = birt_time;
    request.fields["email"] = email;
    request.fields["phone"] = phone;
    request.fields["cat_id"] = catId;
    request.fields["sub_cat_id"] = subCatId;
    request.fields["text"] = text;
    request.fields["country_id"] = countryId;
    request.fields["birth_place"] = birthPlace;
    if(Image != null){
      request.files.add(Image);
    }
    if(fImage != null) {
      request.files.add(fImage);
    }


    var response = await request.send();
    var response2 = await http.Response.fromStream(response);
    print("appointmentView ${request.fields}");
    print("appointmentView ${response2.body}");

    if (response2.statusCode == 200) {
      var data = jsonDecode(response2.body);
      AddCustomerModel user = AddCustomerModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response2.body);
      AddCustomerModel user = AddCustomerModel.fromJson(data);
      return user;
    }
  }

  static Future<CustomerNameModel> nameListApi() async {
    final params = {
      "flag":"customer_name_list",
    };
    http.Response response = await http.post(Uri.parse(nameList), body: params);
    print("nameListApi ${params}");
    print("nameListApi ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CustomerNameModel user = CustomerNameModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CustomerNameModel user = CustomerNameModel.fromJson(data);
      return user;
    }
  }

  static Future<AddAppointmentModel> addAppointment(String cId, String date, /*String time,*/ String msg, String fees,
      String fessStatus,selectedSlot_id) async {
    final params = {
      "flag":"add_appointment",
      "c_id": cId,
      "date": date,
      // "time": time,
      "msg": msg,
      "fees": fees,
      "fees_status": fessStatus,
      "slot_id":selectedSlot_id
    };
    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("addAppointment ${params}");
    print("addAppointment ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AddAppointmentModel user = AddAppointmentModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      AddAppointmentModel user = AddAppointmentModel.fromJson(data);
      return user;
    }
  }
  static Future<AddAppointmentModel> addAppointment2(String date, String starttime, String endtime) async {
    final params = {
      "flag":"create_slot",
      "date": date,
      "from_time": starttime,
      "to_time": endtime
    };
    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("addAppointment ${params}");
    print("addAppointment ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AddAppointmentModel user = AddAppointmentModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      AddAppointmentModel user = AddAppointmentModel.fromJson(data);
      return user;
    }
  }
  static Future<AddAppointmentModel> EditAppointment2(String date, String starttime, String endtime,slot_id) async {
    final params = {
      "flag":"slot_edit",
      "slot_id": slot_id,
      "date": date,
      "from_time": starttime,
      "to_time": endtime
    };
    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("addAppointment ${params}");
    print("addAppointment ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AddAppointmentModel user = AddAppointmentModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      AddAppointmentModel user = AddAppointmentModel.fromJson(data);
      return user;
    }
  }

  static Future<PaymentViewModel> paymentList(String fromDate, String toDate) async {
    final params = {
      "flag": "payment_view",
      "from_date": fromDate,
      "to_date": toDate
    };

    http.Response response = await http.post(Uri.parse(payment), body: params);
    print("paymentList ${params}");
    print("paymentList ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      PaymentViewModel user = PaymentViewModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      PaymentViewModel user = PaymentViewModel.fromJson(data);
      return user;
    }
  }

  static Future<CancelAppointmentModel> cancelAppointment(String id) async {
    final params = {
      "flag": "appointment_cancel",
      "id": id
    };

    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("cancelAppointment ${params}");
    print("cancelAppointment ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CancelAppointmentModel user = CancelAppointmentModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CancelAppointmentModel user = CancelAppointmentModel.fromJson(data);
      return user;
    }
  }

  static Future<CompleteAppointmentModel> completeAppointment(String id) async {
    final params = {
      "flag": "appointment_completed",
      "id": id
    };

    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("completeAppointment ${params}");
    print("completeAppointment ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CompleteAppointmentModel user = CompleteAppointmentModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CompleteAppointmentModel user = CompleteAppointmentModel.fromJson(data);
      return user;
    }
  }

  static Future<ViewCustomerModel> veiwCustomer(String name, String phone, String catId, String subCatId,
      String countryId) async {
    final params = {
      "flag": "customer_list",
      "name": name,
      "phone": phone,
      "cat_id": catId,
      "sub_cat_id": subCatId,
      "country_id":countryId,
    };

    http.Response response = await http.post(Uri.parse(nameList), body: params);
    print("veiwCustomer ${params}");
    print("veiwCustomer ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ViewCustomerModel user = ViewCustomerModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      ViewCustomerModel user = ViewCustomerModel.fromJson(data);
      return user;
    }
  }

  static Future<AppointmentDetailModel> appointmentDetail(String id) async {
    final params = {
      "flag": "appointment_dtl",
      "id": id
    };

    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("appointmentDetail ${params}");
    print("appointmentDetail ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AppointmentDetailModel user = AppointmentDetailModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      AppointmentDetailModel user = AppointmentDetailModel.fromJson(data);
      return user;
    }
  }

  static Future<CustomerDetailModel> customerDetail(String id) async {
    final params = {
      "flag": "get_customer",
      "user_id": id
    };

    http.Response response = await http.post(Uri.parse(nameList), body: params);
    print("customerDetail ${params}");
    print("customerDetail ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CustomerDetailModel user = CustomerDetailModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CustomerDetailModel user = CustomerDetailModel.fromJson(data);
      return user;
    }
  }

  static Future<UpdateAppointmentModel> updateAppointment(String id, String date, String time, String msg, String fees,
      String fessStatus,selectedSlot_id) async {
    final params = {
      "flag":"update_appointment",
      "id": id,
      "date": date,
      // "time": time,
      "message": msg,
      "fees": fees,
      "fees status": fessStatus,
      "slot_id": selectedSlot_id,
    };
    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("updateAppointment ${params}");
    print("updateAppointment ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UpdateAppointmentModel user = UpdateAppointmentModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      UpdateAppointmentModel user = UpdateAppointmentModel.fromJson(data);
      return user;
    }
  }

  static Future<UpdateCustomerModel> updateCustomer(String cId, String name, String gender, String city, String dob, String birt_time,
      String email, String phone, String catId, String subCatId, String place, String text, String birthPlace,
      File image, File hImage,String selectedCustomer_id) async {
    var request = new http.MultipartRequest("POST", Uri.parse(nameList));
    // var Image;
    // var hImage;
    var Image;
    var fImage;
    if(hImage!=null && hImage.path!=""){
      fImage = await http.MultipartFile.fromPath("h_image", hImage.path);
    }
    if(image!=null && image.path!=""){
      Image = await http.MultipartFile.fromPath("u_image", image.path);
    }

    // if(hImage != null){
    //   hImage = await http.MultipartFile.fromPath("h_image", hImage.path);
    // }
    // if(Image != null){
    //   Image = await http.MultipartFile.fromPath("u_image", image.path);
    // }

    request.fields["flag"] = "edit_customer";
    request.fields["customer_id"] = cId;
    request.fields["name"] = name;
    request.fields["gender"] = gender;
    request.fields["city"] = city;
    request.fields["dob"] = dob;
    request.fields["birth_time"] = birt_time;
    request.fields["email"] = email;
    request.fields["phone"] = phone;
    request.fields["cat_id"] = catId;
    request.fields["sub_cat_id"] = subCatId;
    request.fields["place"] = place;
    request.fields["text"] = text;
    request.fields["birth_place"] = birthPlace;
    request.fields["country_id"] = selectedCustomer_id;

    if(Image != null){
      request.files.add(Image);
    }
    if(fImage != null) {
      request.files.add(fImage);
    }

    // if(Image != null){
    //   request.files.add(Image);
    // }
    // if(hImage != null) {
    //   request.files.add(hImage);
    // }

    var response = await request.send();
    var response2 = await http.Response.fromStream(response);
    print("updateCustomer ${request.files}");
    print("updateCustomer ${request.fields}");
    print("updateCustomer ${response2.body}");

    if (response2.statusCode == 200) {
      var data = jsonDecode(response2.body);
      UpdateCustomerModel user = UpdateCustomerModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response2.body);
      UpdateCustomerModel user = UpdateCustomerModel.fromJson(data);
      return user;
    }
  }

  static Future<DeleteCustomerModel> customerDelete(String id) async {
    final params = {
      "flag": "delete_user",
      "user_id": id
    };

    http.Response response = await http.post(Uri.parse(nameList), body: params);
    print("customerDelete ${params}");
    print("customerDelete ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      DeleteCustomerModel user = DeleteCustomerModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      DeleteCustomerModel user = DeleteCustomerModel.fromJson(data);
      return user;
    }
  }
  static Future<DeleteCustomerModel> SlotDelete(String id) async {
    final params = {
      "flag": "slot_delete",
      "slot_id": id
    };

    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("customerDelete ${params}");
    print("customerDelete ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      DeleteCustomerModel user = DeleteCustomerModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      DeleteCustomerModel user = DeleteCustomerModel.fromJson(data);
      return user;
    }
  }

  static Future<ViewSlotModel> SlotView(String date) async {
    final params = {
      "flag": "slot_view",
      "date": date
    };

    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("SlotView ${params}");
    print("SlotView ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ViewSlotModel user = ViewSlotModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      ViewSlotModel user = ViewSlotModel.fromJson(data);
      return user;
    }
  }

  static Future<AppointmentViewModel> appointmentUpcoming(String fromdate,todate) async {
    final params = {
      "flag": "upcoming_appointment",
      "s_date": fromdate,
      "e_date":todate
    };

    http.Response response = await http.post(Uri.parse(appointment), body: params);
    print("appointmentUpcoming ${params}");
    print("appointmentUpcoming ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AppointmentViewModel user = AppointmentViewModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      AppointmentViewModel user = AppointmentViewModel.fromJson(data);
      return user;
    }
  }

  static Future<CountryModel> countryList() async {
    final params = {
      "flag": "get_country_list",
    };

    http.Response response = await http.post(Uri.parse(nameList), body: params);
    print("countryList ${params}");
    print("countryList ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CountryModel user = CountryModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(response.body);
      CountryModel user = CountryModel.fromJson(data);
      return user;
    }
  }


}