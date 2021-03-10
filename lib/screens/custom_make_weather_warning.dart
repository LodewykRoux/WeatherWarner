import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weather_warner/shared/shared.dart';

class CreateWarning extends StatefulWidget {
  @override
  _CreateWarningState createState() => _CreateWarningState();
}

class _CreateWarningState extends State<CreateWarning> {



  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _textController4 = TextEditingController();


  void setText (){
    final Map map = ModalRoute.of(context).settings.arguments;
    if(map != null) {
      _textController1.text = map['name'];
      _textController2.text = map['condition'];
      _textController3.text = map['sign'];
      _textController4.text = map['number'];
    }
  }

  @override
  void initState() {

    super.initState();

  }
  //TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {


    setText();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Custom Warning'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: textInputDecoration.copyWith(hintText: 'Name of warning'),
                         controller: _textController1,
                         onSubmitted: (value) {

                          }
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: textInputDecoration.copyWith(hintText: 'Condition: Wind, Temperature or storm type'),
                      controller: _textController2,

                      onChanged: (value){

                      },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: textInputDecoration.copyWith(hintText: 'greater than (<) or less than (>)'),
                      controller: _textController3,
                      onSubmitted: (value) {

                      }
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: textInputDecoration.copyWith(hintText: 'Temperature or wind speed'),
                      controller: _textController4,
                      onSubmitted: (value) {

                      }
                  ),
                ),
              ),


              SizedBox(
                height: 8,
              ),



              SizedBox(
                height: 50,
                child: RaisedButton(

                    child: Text('Submit data'),
                    onPressed: () {
                      Firestore.instance
                          .collection('weather')
                          .document(_textController1.text)
                          .setData({
                        'condition': _textController2.text,
                        'sign': _textController3.text,
                        'number': _textController4.text
                      });
                      Navigator.pop(context);
                    }),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 50,
                child: RaisedButton(
                    child: Text('Update data'),
                    onPressed: () {
                      Firestore.instance
                          .collection('weather')
                          .document(_textController1.text)
                          .setData({
                        'condition' : _textController2.text,
                        'sign': _textController3.text,
                        'number': _textController4.text,

                      }, merge: true);
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        ));
  }
}
