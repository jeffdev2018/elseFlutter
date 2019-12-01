import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/singleEvent/WinnerSectionView.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/singleEvent/submission_grid_view.dart';
import 'package:flutter/material.dart';

class SubmissionGridViewHandler {
  EventModel event;
  SubmissionGridViewHandler(EventModel model){
    this.event=model;
  }
  Widget renderSuitableSubmissionGridView() {
    if (this.event.endDate.isBefore(DateTime.now())) {
        return WinnerSectionView(event.uid);
    }
    else{
      return SubmissionGridView(this.event.uid);
    }
  }
}