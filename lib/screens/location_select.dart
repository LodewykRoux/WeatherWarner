import 'package:flutter/material.dart';
import 'package:weather_warner/services/weather_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class Location extends StatelessWidget {
//
//   final AuthService _auth = AuthService();
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<List<Location>>.value(
//         value: DatabaseService2.location,
//       child: Scaffold(
//         backgroundColor: Colors.brown,
//         appBar: AppBar(
//           title: Text('Locations'),
//           centerTitle: true,
//         ),
//         body: Scaffold(
//
//         ),
//       ),
//     );
//   }
// }

class Location extends StatelessWidget {
  var _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Locations',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      //Method
                      final WeatherService weather = WeatherService();
                      final locationID =
                          await weather.getLocationID(_controller.text);
                      Firestore.instance
                          .collection('ids')
                          .document(_controller.text)
                          .setData({
                        'id': locationID,
                      });
                      if (locationID == null) {
                        //final snackbar = SnackBar(content: Text('Failed to get location.'));
                      } else {
                        Navigator.pop(context, _controller.text);
                      }
                    },
                    icon: Icon(Icons.arrow_forward_sharp),
                  )),
              onSubmitted: (text) async {
                //Method
                final WeatherService weather = WeatherService();
                final locationID = await weather.getLocationID(text.toString());
                Firestore.instance
                    .collection('ids')
                    .document(text.toString())
                    .setData({
                  'id': locationID,
                });
                if (locationID == null) {
                  //final snackbar = SnackBar(content: Text('Failed to get location.'));
                } else {
                  Navigator.pop(context, text.toString());
                }
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('ids').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.documents[index];
                    return Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Card(
                        margin: EdgeInsets.fromLTRB(10, 6, 10, 0),
                        child: ListTile(
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete?'),
                                        content: Text(
                                            'Are you sure you want to delete ${documentSnapshot.documentID}?'),
                                        actions: [
                                          FlatButton(
                                              onPressed: () {
                                                Firestore.instance
                                                    .collection('ids')
                                                    .document(documentSnapshot
                                                        .documentID
                                                        .toString())
                                                    .delete();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Delete')),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel')),
                                        ],
                                      );
                                    });
                              },
                            ),
                            leading: Icon(Icons.location_on),
                            title: Text(documentSnapshot.documentID.toString()),
                            onTap: () {
                              Navigator.pop(context,
                                  documentSnapshot.documentID.toString());
                            }),
                      ),
                    );
                  },
                );
              } else {
                return Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
