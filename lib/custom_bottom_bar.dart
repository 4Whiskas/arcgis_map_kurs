import 'package:arcgis/constants.dart';
import 'package:arcgis/points_list_item.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';

import 'data.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  List<String> selectedCountList=[];
  List<PointsListItem> filteredPoints=[];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      currentIndex: 0,
      onTap: (index) {
        showPointsFilter(context, index, filteredSubTypes[index],
            points[index], logoPaths[index], logoDescs[index]);
      },
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
              "images/recycling.png",
              width: 50,
              height: 50,
            ),
            label: "С"),
        BottomNavigationBarItem(
            icon: Image.asset(
              "images/trading.png",
              width: 50,
              height: 50,
            ),
            label: "Т"),
        BottomNavigationBarItem(
            icon: Image.asset(
              "images/route.png",
              width: 50,
              height: 50,
            ),
            label: "Э"),
        BottomNavigationBarItem(
            icon: Image.asset(
              "images/event.png",
              width: 50,
              height: 50,
            ),
            label: "С"),
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: "l")
      ],
    );
  }

  void showPointsFilter(BuildContext context, int currentType,
      List<String> subTypes, List<PointsListItem> pointsItems, String logoPath, String logoDesc) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
            child: SizedBox(
              height: 500,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          logoPath,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 25,),
                      Text(logoDesc),
                    ],
                  ),

                  ElevatedButton(
                      onPressed: () async {
                        await FilterListDialog.display<String>(context,
                            listData: subTypes,
                            selectedListData: selectedCountList,
                            height: 480,
                            headlineText: "Выберите тип точки",
                            searchFieldHintText: "Поиск",
                            choiceChipLabel: (item) {
                          return item;
                        }, validateSelectedItem: (list, val) {
                          return list!.contains(val);
                        }, onItemSearch: (list, text) {
                          if (list!.any((element) => element
                              .toLowerCase()
                              .contains(text.toLowerCase()))) {
                            return list
                                .where((element) => element
                                    .toLowerCase()
                                    .contains(text.toLowerCase()))
                                .toList();
                          } else {
                            return [];
                          }
                        }, onApplyButtonClick: (list) {
                          if (list != null) {
                            setState(() {
                              filteredPoints.clear();
                              for (var element in pointsItems) {
                                if(selectedCountList.contains(element.subType))
                                  {
                                    filteredPoints.add(element);
                                  }
                              }

                            });
                          }
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("Фильтр")),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      children: filteredPoints.isEmpty?pointsItems:filteredPoints,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
