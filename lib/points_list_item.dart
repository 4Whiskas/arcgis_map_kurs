import 'package:arcgis/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';

import 'package:arcgis/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:latlong/latlong.dart';

import 'data.dart';

class PointsListItem extends StatefulWidget {
  const PointsListItem({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.address,
    required this.time,
    required this.description,
    required this.coordinates,
    required this.type,
    required this.subType,
  }) : super(key: key);

  final String imagePath;
  final String label;
  final String address;
  final String time;
  final String description;
  final String type;
  final String subType;
  final LatLng coordinates;

  @override
  State<PointsListItem> createState() => _PointsListItemState();
}

class _PointsListItemState extends State<PointsListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        Navigator.of(context).pop();
        mapController.move(widget.coordinates, 16);
        setState(() {
          Location loc = Location();
          loc.getLocation().then((curLoc) => {
            getRoute(LatLng(curLoc.latitude, curLoc.longitude),
                widget.coordinates)
                .then((route) => {
              polylines.clear(),
              polylines.add(Polyline(
                  points: route, color: Colors.red, strokeWidth: 3))
            })
          });
        });

      },
      onTap: () {
        Navigator.of(context).pop();
        mapController.move(widget.coordinates, 16);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            widget.imagePath,
            width: 30,
            height: 30,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.label),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(widget.address),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.time)
                ],
              ),
              Text("Тут будет описание точки")
            ],
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
