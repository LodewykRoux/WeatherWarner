import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Warning extends StatefulWidget {
  @override
  _WarningState createState() => _WarningState();
}

class _WarningState extends State<Warning> {
  // final List<Map<String, dynamic>> entries = [{
  //   'name': 'blizzard warning',
  //   'condition' : 'blizzard'
  // }];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Custom Warning'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('weather').snapshots(),
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
                                                .collection('weather')
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
                        leading: Icon(Icons.warning_amber_sharp),
                        title: Text(documentSnapshot.documentID.toString()),
                        subtitle: Text(
                            '${documentSnapshot['condition']} ${documentSnapshot['sign'] != null ? documentSnapshot['sign'] : ''} ${documentSnapshot['number'] != null ? documentSnapshot['number'] : ''}'),
                        onTap: () {
                          Navigator.pushNamed(context, '/createWarning',
                              arguments: {
                                'name': documentSnapshot.documentID,
                                'condition': documentSnapshot['condition'],
                                'sign': documentSnapshot['sign'],
                                'number': documentSnapshot['number']
                              });
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/createWarning',
          );
          setState(() {});
        },
      ),
    );
  }
}
