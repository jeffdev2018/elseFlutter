import 'package:else_app_two/parkingTab/section_a_parking.dart';
import 'package:else_app_two/parkingTab/section_container.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class ParkingUIScreen extends StatefulWidget{
  @override
  _ParkingUIScreen createState() => _ParkingUIScreen();
}

class _ParkingUIScreen extends State<ParkingUIScreen>{
  List<String> _floorLevel = ['Level -1', 'Level 0', 'Level 1', 'Level 2']; // Option 2
  String _selectedLocation = 'Level 0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        textTheme: Typography.blackMountainView,
        title: Container(
          margin: EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton(
                hint: Text('Floor Level'), // Not necessary for Option 1
                value: _selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
                items: _floorLevel.map((location) {
                  return DropdownMenuItem(
                    child: new Text(location),
                    value: location,
                  );
                }).toList(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 16.0,
                        width: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        margin: EdgeInsets.only(right: 10.0,top: 5.0),
                      ),
                      Text('Empty '),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 16.0,
                        width: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[200],
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        margin: EdgeInsets.only(right: 10.0,top: 5.0),
                      ),
                      Text('Filled '),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          margin: new EdgeInsets.all(10.0),
          child: SectionContainer(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              richTextData('Vacant on this Floor','42'),
              richTextData('Total on this Floor','204'),
            ],
          ),
        ),
      ),
    );
  }

  Widget richTextData(String heading, String data){
    return RichText(
      text: TextSpan(
          text: '$heading : ',
          style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(text: '$data',
              style: TextStyle(
                  color: Constants.textColor,
                  fontWeight: FontWeight.w400
              ),
            ),
          ]
      ),
    );
  }

}