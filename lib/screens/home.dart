import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_warner/services/weather_api.dart';
import 'package:weather_warner/services/weather_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class Temperature {
  final String day;
  final double temperature;

  Temperature(this.day, this.temperature);
}

List<charts.Series<Temperature, int>>
_createVisualizationData(Weather w1, Weather w2, Weather w3, Weather w4, Weather w5) {
  final data = [
    Temperature(w1.date,w1.tempMax),
    Temperature(w2.date,w2.tempMax),
    Temperature(w3.date,w3.tempMax),
    Temperature(w4.date,w4.tempMax),
    Temperature(w5.date,w5.tempMax),
  ];

  return [
    charts.Series(
      id: 'Temperature',
      data: data,
      domainFn: (Temperature temp, _) => int.parse(temp.day.substring(4,)),
      measureFn: (Temperature temp, _) => temp.temperature,

    )
  ];
}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Shared Preferences to be used here
  dynamic location = 'Johannesburg';
  dynamic id = "305448";


  //Get a list of weather objects
  Future<List<Weather>> setupWeather(String id) async {
    final WeatherService weather = WeatherService();
    return await weather.getWeather(id);
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Locations':
        location = await Navigator.pushNamed(context, '/location');
        DocumentSnapshot ids =
        await Firestore.instance.collection('ids').document(location).get();
        id = ids.data['id'];
        setState(() {});
        if (location == null) {}
        break;
      case 'Custom warning':
        Navigator.pushNamed(context, '/warning');
        break;
    }
  }

  showAlertDialog(BuildContext context, String alert, String condition,
      String date) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          backgroundColor: Colors.blue[200],
          title: Row(
            children: [
              Image.network(
                'https://previews.123rf.com/images/mykub/mykub1902/mykub190200411/117044255-the-attention-icon-danger-symbol-alert-icon.jpg',
                height: 50, width: 50, fit: BoxFit.contain,),
              Column(
                children: [
                  Text('$condition alert'),
                  Text('Date: $date'),
                ],
              )
            ],
          ),
          content: Text(alert),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'))
          ],
        );
      },
    );
  }

  //Warnings
  void getWarnings(Weather test) async {
    final QuerySnapshot result =
    await Firestore.instance.collection('weather').getDocuments();
    final List<DocumentSnapshot> weatherWarnings = result.documents;

    weatherWarnings.forEach((element) {
      if (element['condition'] == test.conditionsDay ||
          element['condition'] == test.conditionsNight) {
        showAlertDialog(context, element['condition'], 'Storm', test.date);
      } else if (element['condition'] == 'Temperature') {
        if (element['sign'] == ">") {
          if (double.parse(element['number']) < test.tempMax) {
            showAlertDialog(context,
                '${element['condition']} more than ${element['number']}',
                'Temperature', test.date);
          }
        } else {
          if (double.parse(element['number']) > test.tempMin) {
            showAlertDialog(context,
                '${element['condition']} less than ${element['number']}',
                'Temperature', test.date);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text(
          'Weather Warner',
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Locations', 'Custom warning'}.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: setupWeather(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitCircle(
                color: Colors.white,
                size: 80,
              ),
            );
          }

          Weather w1 = snapshot.data[0];
          Weather w2 = snapshot.data[1];
          Weather w3 = snapshot.data[2];
          Weather w4 = snapshot.data[3];
          Weather w5 = snapshot.data[4];

          getWarnings(w1);
          getWarnings(w2);
          getWarnings(w3);
          getWarnings(w4);
          getWarnings(w5);

          return Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        FlatButton.icon(
                            onPressed: () async {
                              // location = await Navigator.pushNamed(
                              //     context, '/location');
                              // DocumentSnapshot ids =
                              // await Firestore.instance.collection('ids').document(location).get();
                              // id = ids.data['id'];
                              // setState(() {});
                            },
                            icon: Icon(Icons.location_on_sharp),
                            label: Text(location)),
                        Text(
                          '${w1.tempMax}\u00B0C',
                          style: TextStyle(color: Colors.white, fontSize: 50),
                        ),
                        Text(
                          '${w1.conditionsDay}',
                          style: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 60,
                  color: Colors.grey,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.lightBlueAccent,
                  height: 209,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        children: [
                          Text(
                            w1.date,
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.network(
                              'https://developer.accuweather.com/sites/default/files/${w1
                                  .iconCode.length > 1 ? w1.iconCode : '0' +
                                  w1.iconCode}-s.png'),
                          Text(
                            'High: ${w1.tempMax.round()}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Low: ${w1.tempMin.round()}',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            w2.date,
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.network(
                              'https://developer.accuweather.com/sites/default/files/${w2
                                  .iconCode.length > 1 ? w2.iconCode : '0' +
                                  w2.iconCode}-s.png'),
                          Text(
                            'High: ${w2.tempMax.round()}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Low: ${w2.tempMin.round()}',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            w3.date,
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.network(
                              'https://developer.accuweather.com/sites/default/files/${w3
                                  .iconCode.length > 1 ? w3.iconCode : '0' +
                                  w3.iconCode}-s.png'),
                          Text(
                            'High: ${w3.tempMax.round()}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Low: ${w3.tempMin.round()}',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            w4.date,
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.network(
                              'https://developer.accuweather.com/sites/default/files/${w4
                                  .iconCode.length > 1 ? w4.iconCode : '0' +
                                  w4.iconCode}-s.png'),
                          Text(
                            'High: ${w4.tempMax.round()}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Low: ${w4.tempMin.round()}',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            w5.date,
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.network(
                              'https://developer.accuweather.com/sites/default/files/${w5
                                  .iconCode.length > 1 ? w5.iconCode : '0' +
                                  w5.iconCode}-s.png'),
                          Text(
                            'High: ${w5.tempMax.round()}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Low: ${w5.tempMin.round()}',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )

                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                    child: charts.LineChart(
                        _createVisualizationData(w1,w2,w3,w4,w5)


                    )
                )

              ],
            ),
          );
        },
      ),
    );
  }
}


