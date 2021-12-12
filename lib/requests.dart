import 'dart:convert';
import 'dart:developer';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
Future<List<LatLng>> getRoute(LatLng startPoint, LatLng endPoint)async
{
  print(startPoint);
  print(endPoint);
  var f = 'f=json&';
  var token = 'token=AAPKaf3085f2feb642ca9087fd3573644bdc_QsFicjZgUdoP70nVMEMCnuAOMycXXTrmkJvc9IrED0PMOvrUnnOqHWKw6LKz3S3&';
  var stops = 'stops=${startPoint.latitude},${startPoint.longitude};${endPoint.latitude},${endPoint.longitude}&';
  var startTimer = 'startTime=now&';
  var rDir = 'returnDirections=false&';
  var dirL = 'directionsLanguage=ru&';
  var url = Uri.parse("https://route-api.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World/solve?"+f+token+stops+startTimer+rDir+dirL);
  var response = await http.get(url);
  //print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  Map<String, dynamic> routes = data['routes'];
  //print(data);
  List<dynamic> features = routes['features'];
  //print(features);
  Map<String, dynamic> temp = features[0];
  //print(temp);
  Map<String, dynamic> geometry = temp['geometry'];
  //print(geometry);
  List<dynamic> paths = geometry['paths'];
  //print(paths);
  List<dynamic> points = paths[0];
  //print(points);
  List<LatLng> route = [];
  points.forEach((element) {
    LatLng tempLatLng = LatLng(element[0],element[1]);
    route.add(tempLatLng);
  });
  //Map<String, dynamic> paths = geometry['paths'];
  //print(paths);
  //print(response.statusCode);
  //print()=>log(response.body);
  //print(route);
  print(route);
  return route;
}