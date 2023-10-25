import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static var stringResponse;

  static var authtoken;

  static var mapResponse;

  // static Future<LoginResponse> getLogin(
  //     Map map, LoginViewModel loginViewModel) async {
  //   var url = Constants.API_ENDPOINT + Constants.LOGIN;
  //   //encode Map to JSON
  //   var body = json.encode(map);

  //   var response = await http.post(Uri.parse(url),
  //       headers: {"Content-Type": "application/json"}, body: body);

  //   var res = json.decode(response.body);
  //   LoginResponse loginResponse = LoginResponse.fromMap(res);

  //   print("##########" + "${response.body}");

  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     // loginViewModel.addUser(loginResponse.data.user_info);
  //   }
  //   // return result;
  //   return loginResponse;
  // }

  // static Future<IncidentResponse> postIncident(
  //     Map map, TicketRaisedViewModel ticketRaisedViewModel) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   authtoken = prefs.getString('authtoken');

  //   http.Response response;
  //   var path = BASE_URL + CREATE_TICKET;

  //   // print(' path===> $path');
  //   // print('lsit authtoken===> $authtoken');

  //   var body = json.encode(map);

  //   print('api body===> ');

  //   response = await http.post(Uri.parse(path),
  //       headers: {"Content-Type": "application/json", "authtoken": authtoken},
  //       body: body);

  //   print('response==== $response');
  //   stringResponse = response.body;
  //   print('stringResponse==== $stringResponse');
  //   // mapResponse = json.decode(response.body);
  //   // print('mapResponse===> $mapResponse');

  //   if (response.statusCode == 200) {
  //     if (mapResponse["success"]) {
  //       var ticketsList = mapResponse['data'];
  //       var totalList = mapResponse['data'];
  //     }
  //   }
  //   return mapResponse;
  // }


}
