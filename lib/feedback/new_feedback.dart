import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/basicElements/camera_impl.dart';
import 'package:else_app_two/feedback/FeedbackStatus.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/firebaseUtil/storage_manager.dart';
import 'package:else_app_two/models/feedback_crud_model.dart';
import 'package:else_app_two/models/feedback_model.dart';
import 'package:else_app_two/models/user_crud_model.dart';
import 'package:else_app_two/models/user_feedback_crud_model.dart';
import 'package:else_app_two/models/user_feedback_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';

class NewFeedBack extends StatefulWidget{

  @override
  _NewFeedBack createState() => _NewFeedBack()
;}

class _NewFeedBack extends State<NewFeedBack>{
  final _formKey = GlobalKey<FormState>();
  bool isUserLogged = false;
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _typeOfFeedBack = true;
  double _intensityValue = 0.0;
  List imageUrls = [];
  static String pathFeedbackCollection = StartupData.dbreference+'/feedback/allfeedbacks';
  final FeedbackCrudModel feedbackCrudModel = FeedbackCrudModel(new Api(pathFeedbackCollection));

  UserFeedBackCrudModel userFeedBackCrudModel;
  final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));
  final StorageManager _storageManager = StorageManager(StartupData.dbreference+'/feedback/');

  onImageSelectedFromCamera(file) async {
//    print('Uploading File :: ' + file.toString());
    int id = new DateTime.now().millisecondsSinceEpoch;
    String path = StartupData.dbreference+'/feedback/$id';
    _storageManager.addFilePath(path);
    String uploadUrl = await _storageManager.uploadImageUrl(file);
    setState(() {
      imageUrls.add(uploadUrl);
      print('Values in image url list '+imageUrls.toString());
    });
  }

  removeImage(int index) async{
    String path = imageUrls[index];
//    _storageManager.addFilePath(path);
//    await _storageManager.removeImageUrl();
    setState(() {
      imageUrls.remove(path);
      print(imageUrls);
    });
  }

  void _signIn(){
    setState(() {
      isUserLogged = true;
    });
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    final BaseAuth _auth = AuthProvider.of(context).auth;
    final String userId = await _auth.currentUser();
    String path = 'users/$userId/feedbacks';
    userFeedBackCrudModel = UserFeedBackCrudModel(new Api(path));
  }

  void _addFeedBack(String subject, bool typeOfFeedBack,
      double feedbackIntensity, String content, List images) async{
    List<String> imageUrls = images.cast<String>();
    FeedBack feedBack = new FeedBack(subject, typeOfFeedBack, feedbackIntensity,
        content, imageUrls, Status.PENDING.index, DateTime.now(), DateTime.now());

    String feedBackUrl = await feedbackCrudModel.addFeedBack(feedBack);
    if(feedBackUrl != null){
      UserFeedBack userFeedBack = new UserFeedBack(feedBackUrl);
      await userFeedBackCrudModel.addUserFeedBack(userFeedBack);
      showModalBottomSheet(context: context, builder: (context){
        return getModal();
      });
    }

  }

  void _popContext(BuildContext context){
    Navigator.pop(context);
  }

  Widget getModal(){
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white70,
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Feedback Registered", textAlign: TextAlign.center,),
            subtitle: Text("Our team has started working on this......"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
          ),
          FlatButton(
            color: Colors.white,
            onPressed: (){
              Navigator.pop(context);
              _popContext(context);
            },
            child: Text('Ok', style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20.0),),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.textColor),
        backgroundColor: Constants.titleBarBackgroundColor,
        title: Text(
          "New Feedback",
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      body: Card(
        borderOnForeground: true,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Subject'
                    ),
                    controller: _subjectController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  paddingData(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Type Of FeedBack"),
                      Row(children: <Widget>[
                        Radio(value: true, groupValue: _typeOfFeedBack,
                          onChanged: (bool newValue) {
                            setState(() {
                              _typeOfFeedBack=newValue;
                            });
                          }),
                        Text("Positive"),
                      ]),
                      Row(
                        children: <Widget>[
                          Radio(value: false, groupValue: _typeOfFeedBack,
                            onChanged: (bool newValue) {
                              setState(() {
                                _typeOfFeedBack=newValue;
                              });
                            }),
                          Text("Negative")
                        ],
                      )
                    ],
                  ),
                  paddingData(),
                  Text("Rate your experience"),
                  Slider(
                    value: _intensityValue,
                    min: 0.0,
                    max: 5.0,
                    divisions: 5,
                    onChanged: (double newValue) {
                      setState(() {
                        _intensityValue = newValue;
                      });
                    },
                    activeColor: Colors.blue,
                    inactiveColor: Colors.black45,
                    label: _intensityValue.toString(),
                  ),
                  paddingData(),
                  TextFormField(
                    maxLines: 8,
                    decoration: const InputDecoration(
                        labelText: 'Content'
                    ),
                    controller: _contentController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  paddingData(),
                  paddingData(),
                  paddingData(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Upload Image (If any)"),
                      CameraImpl(onImageSelectedFromCamera),
                    ],
                  ),
                  paddingData(),
                  Container(
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.height / 4,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index){
                        return imageCard(index);
                      }
                    ),
                  ),
                  paddingData(),
                  paddingData(),
                  FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        print("Inside Data");
                        _addFeedBack(_subjectController.text, _typeOfFeedBack,
                            _intensityValue, _contentController.text, imageUrls);
                      }
                    },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
  
  Widget imageCard(int index){
    return Stack(
      children: <Widget>[
        Card(
          child: Image(
            image: NetworkImage('${imageUrls[index]}'),
          ),
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          child: Container(
            height: 20.0, // height of the button
            width: 20.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,// You can use like this way or like the below line
              color: Colors.white,
              border:  Border.all(
                color: Constants.textColor,
                width: 1.0,
              ),
            ),
            child: Center(
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                iconSize: 18.0,
                color: Colors.black,
                icon: Icon(Icons.close),
                onPressed: (){removeImage(index);},
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget paddingData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
    );
  }
}