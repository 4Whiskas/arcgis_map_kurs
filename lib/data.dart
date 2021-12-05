import 'dart:convert';
import 'package:arcgis/points_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<List<PointsListItem>> points = [[], [], [], []];
List<Marker> markers = [Marker(point: LatLng(47.2313, 39.7233), builder: (BuildContext){return SizedBox(width: 5,height: 5);})];

void savePoints() async {
  List<List<Map<String, dynamic>>> data = [];
  for (var typedPoints in points) {
    List<Map<String, dynamic>> subData = [];
    for (var point in typedPoints) {
      Map<String, dynamic> elData = {};
      elData['imgpath'] = point.imagePath;
      elData['latitude'] = point.coordinates.latitude;
      elData['longitude'] = point.coordinates.longitude;
      elData['time'] = point.time;
      elData['address'] = point.address;
      elData['label'] = point.label;
      elData['descrition'] = point.description;
      subData.add(elData);
    }
    data.add(subData);
  }
  var jsonData = jsonEncode(data);
  var sh = await SharedPreferences.getInstance();
  sh.setString('data', jsonData);
}

void loadPoints() async {
  var sh = await SharedPreferences.getInstance();
  if (!sh.containsKey('data')) return;
  var jsonData = sh.getString('data');
  List<dynamic> tempData = jsonDecode(jsonData);
  List<List<dynamic>> tData = [];
  tempData.forEach((element) {
    tData.add(element);
  });
  for (int i = 0; i < 4; i++) {
    List<PointsListItem> tempPointsList = [];
    for (var tMap in tData[i]) {
      Map<String, dynamic> map = tMap;
      PointsListItem point = PointsListItem(
          imagePath: map['imgpath'],
          label: map['label'],
          address: map['address'],
          time: map['time'],
          description: map['description'],
          coordinates: LatLng(map['latitude'], map['longitude']));
      tempPointsList.add(point);
    }
    points[i] = tempPointsList;
  }
}

void fillMarkers() {
  for (var pointTypeList in points) {
    for (var pointType in pointTypeList) {
      var tempMarker = Marker(
          point: pointType.coordinates,
          builder: (BuildContext context) {
            return Image.asset(pointType.imagePath);
          });
      markers.add(tempMarker);
    }
  }
}
