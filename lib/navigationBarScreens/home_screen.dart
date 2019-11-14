import 'package:else_app_two/basicElements/deal_horizontal_list.dart';
import 'package:else_app_two/basicElements/event_horizontal_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Text('Events'),
        EventList(),
        Text('Deals'),
        DealList(),
        Text('Trending'),
        EventList(),
      ],
    );
  }
}