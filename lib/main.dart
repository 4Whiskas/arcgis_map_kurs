import 'package:location/location.dart';
import 'package:arcgis/requests.dart';
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

main() async {
  //var s = await getRoute(LatLng(47.2313, 39.7233), LatLng(47.23, 39.7233));
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoadingPage(),
  ));
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    loadPage();
  }

  loadPage() {
    loadPoints().then((userStatus) {
      fillMarkers().then((value) =>
      {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MyApp()))
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  String imgPath = "images/recycling.png";
  List<Map<String, dynamic>>? pointSubType;
  List<Polyline> pol=[];

  @override
  void initState() {
    //makeReq();
    //print(markers);
    super.initState();
  }

  Future<void> makeReq() async
  {

  }

  @override
  void dispose() {
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
            onLongPress: (point) =>
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
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
                                        //print(point);
                                        var tempPoint = PointsListItem(
                                          imagePath: imgPath,
                                          label: pointNameController.text,
                                          address: pointAddressController.text,
                                          time: "0:00",
                                          description: pointSubTypeController
                                              .text,
                                          coordinates: point,
                                          subType: pointSubTypeController.text,
                                          type: pointTypeController.text,
                                        );
                                        var tempMarker = Marker(
                                            point: point,
                                            height: 30,
                                            width: 30,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: IconButton(
                                                    icon: Image.asset(imgPath),
                                                    onPressed: () {
                                                      showBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            Container(
                                                                padding: EdgeInsets
                                                                    .all(10),
                                                                height: 150,
                                                                child: tempPoint),
                                                      );
                                                    },
                                                  ));
                                            });
                                        points[index].add(tempPoint);
                                        savePoints();
                                        setState(() {
                                          markers.add(tempMarker);
                                          //print(markers);
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
          TileLayerOptions(
            urlTemplate:
            'https://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}?token=AAPKaf3085f2feb642ca9087fd3573644bdc_QsFicjZgUdoP70nVMEMCnuAOMycXXTrmkJvc9IrED0PMOvrUnnOqHWKw6LKz3S3',
            // subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
            // tileProvider: const CachedNetworkTileProvider(),
          ),
          MarkerLayerOptions(markers: markers),
          PolylineLayerOptions(polylines: polylines )
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  void updatePolilyne() {
    setState(() {

    });
  }
}
