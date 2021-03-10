import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_warner/services/location_model.dart';

class DatabaseService2 {
  final String uid;

  DatabaseService2({this.uid});

  //Collection reference
  final CollectionReference idCollection = Firestore.instance.collection('ids');

  Future<void> updateUserData(String city, String locationID) async {
    return await idCollection.document(uid).setData({
      'locationID': locationID,
      'uid': uid,
    });
  }

  List<Location> _locationFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) {
      return Location(
          city: e.data['name'] ?? '', locationID: e.data['locationID'] ?? '');
    }).toList();
  }

  Stream<List<Location>> get location {
    return idCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_locationFromSnapshot);
  }
}
