import 'package:hive/hive.dart';
import 'package:arcgis/controllers.dart';
import 'package:arcgis/data.dart';
import 'package:arcgis/points_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:select_form_field/select_form_field.dart';
import 'constants.dart';
import 'custom_bottom_bar.dart';

main(){
  runApp(MaterialApp(
      home: MyApp(),
    ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  String imgPath = "images/recycling.png";
  List<Map<String, dynamic>>? pointSubType;

  @override
  void initState() {
    setState(() {
      loadPoints();
      fillMarkers();
    });
    super.initState();
  }
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ArcGIS')),
      body: FlutterMap(
        options: MapOptions(
            center: LatLng(47.2313, 39.7233),
            zoom: 16.0,
            plugins: [EsriPlugin()],
            onLongPress: (point) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                controller: pointNameController,
                                decoration: const InputDecoration(
                                    label: Text("Название")),
                              ),
                              TextField(
                                controller: pointDescriptionController,
                                decoration: const InputDecoration(
                                    label: Text("Описание")),
                              ),
                              TextField(
                                controller: pointAddressController,
                                decoration: const InputDecoration(
                                    label: Text("Адресс")),
                              ),
                              SelectFormField(
                                labelText: "Тип точки",
                                type: SelectFormFieldType.dropdown,
                                items: pointType,
                                controller: pointTypeController,
                                onChanged: (selectedType) {
                                  switch (selectedType) {
                                    case "remake":
                                      setState(() {
                                        index = 0;
                                        imgPath = "images/recycling.png";
                                        pointSubType = remakeType;
                                      });
                                      break;
                                    case "trade":
                                      setState(() {
                                        index = 1;
                                        imgPath = "images/trading.png";
                                        pointSubType = tradeType;
                                      });
                                      break;
                                    case "routes":
                                      setState(() {
                                        index = 2;
                                        imgPath = "images/route.png";
                                        pointSubType = routesType;
                                      });
                                      break;
                                    case "events":
                                      setState(() {
                                        index = 3;
                                        imgPath = "images/event.png";
                                        pointSubType = eventType;
                                      });
                                      break;
                                  }
                                },
                              ),
                              SelectFormField(
                                labelText: "Вид сдаваемого объекта",
                                type: SelectFormFieldType.dropdown,
                                items: pointSubType,
                                controller: pointSubTypeController,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    var tempPoint = PointsListItem(
                                      imagePath: imgPath,
                                      label: pointNameController.text,
                                      address: pointAddressController.text,
                                      time: "0:00",
                                      description: pointSubTypeController.text,
                                      coordinates: point,
                                    );
                                    var tempMarker = Marker(
                                      point: point,
                                      builder: (BuildContext context){
                                        return Image.asset(imgPath);
                                      }
                                    );
                                    points[index].add(tempPoint);
                                    savePoints();
                                    setState(() {
                                      markers.add(tempMarker);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Создать"))
                            ],
                          ),
                        );
                      },
                    ),
                    title: const Text("Создание метки"),
                    scrollable: true,
                  );
                })),
        mapController: mapController,
        layers: [
          MarkerLayerOptions(markers: [
            Marker(builder: (BuildContext context){
              return SizedBox(
                height: 50,
                width: 50,
              );
            }, point: LatLng(47.2313, 39.7233),)
          ]),
          TileLayerOptions(
            urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
            tileProvider: const CachedNetworkTileProvider(),
          ),
          FeatureLayerOptions(
            url:
                "https://services.arcgis.com/P3ePLMYs2RVChkJx/arcgis/rest/services/USA_Congressional_Districts/FeatureServer/0",
            geometryType: "polygon",
            onTap: (attributes, LatLng location) {
              print(attributes);
            },
            render: (dynamic attributes) {
              // You can render by attribute
              return const PolygonOptions(
                  borderColor: Colors.blueAccent,
                  color: Colors.black12,
                  borderStrokeWidth: 2);
            },
          ),
          FeatureLayerOptions(
            url:
                "https://services8.arcgis.com/1p2fLWyjYVpl96Ty/arcgis/rest/services/Forest_Service_Recreation_Opportunities/FeatureServer/0",
            geometryType: "point",
            render: (dynamic attributes) {
              // You can render by attribute
              return Marker(
                width: 30.0,
                height: 30.0,
                point: LatLng(47.2313, 39.7233),
                builder: (ctx) => Container(color: Colors.red, width: 100, height: 100,),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
