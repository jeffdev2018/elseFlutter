import 'package:else_app_two/profileTab/help_data.dart';
import 'package:flutter/material.dart';

class HelpSection extends StatelessWidget{
  final int index;

  HelpSection({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: SingleChildScrollView(
        child: HelpSectionData(),
      ),
    );
  }

}

class HelpSectionData extends StatefulWidget{
  @override
  _HelpSectionData createState() => _HelpSectionData();
}

class _HelpSectionData extends State<HelpSectionData>{
  final HelpDataList helpDataListClass = HelpDataList();
  List<HelpData> _helpDataList;


  @override
  void initState() {
    super.initState();
    _helpDataList = helpDataListClass.getHelpData();
  }

  _onExpansion(int index, bool isExpanded){
    setState(() {
      _helpDataList[index].expanded = !_helpDataList[index].expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> myExpansionPanelList = [];
    for(int i=0; i<_helpDataList.length; ++i){
      var _expansionData = _helpDataList[i];
      myExpansionPanelList.add(ExpansionPanel(headerBuilder: (BuildContext context, bool isExpanded){
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(_expansionData.title,
            style: TextStyle(fontSize: 15.0))
        );
      },
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(_expansionData.body,
          style: TextStyle(fontSize: 12.0))
        ),
        isExpanded: _expansionData.expanded
      ));
    }
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: new ExpansionPanelList(
        children: myExpansionPanelList,
        expansionCallback: _onExpansion,
      ),
    );
  }


}