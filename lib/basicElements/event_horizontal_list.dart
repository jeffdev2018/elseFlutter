import 'package:else_app_two/Models/events_model.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  @override
  EventListState createState() => new EventListState();
}

class EventListState extends State<EventList> {
  List<EventModel> events = new List();
  final DatabaseManager manager = DatabaseManager();

  @override
  void initState() {
    super.initState();
    manager.getEventsDBRef().onChildAdded.listen(_newEventAdded);
  }

  void _newEventAdded(Event e) {
    EventModel newEvent = new EventModel(e.snapshot);
    if (newEvent.status == 'active') {
      setState(() {
        events.add(newEvent);
      });
    } else if (newEvent.status == 'inactive') {
      if (events.contains(newEvent)) {
        setState(() {
          events.remove(newEvent);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Card(
                child: Container(
                    child: Image(image: NetworkImage(events[index].url))),
              ),
            );
          }),
    );
  }

}