import 'package:arcgis/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:latlong/latlong.dart';

class PointsListItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        mapController.move(coordinates, 16);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(address),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(time)
                ],
              ),
              Text("desc")
            ],
          )
        ],
      ),
    );
  }
}
