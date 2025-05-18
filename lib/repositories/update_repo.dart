import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateRepo {
  //final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> updateInfo(String collectionName, String docID,
      String fieldName, String? newData, List<String>? newDataList) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docID)
          .update({fieldName: newData ?? newDataList});
      return '';
    } catch (e) {
      return 'Failed to update. Please try again later';
    }
  }

  Future<bool> checkDuplicatedInfo(String collectionName, String docID,
      String fieldName, String? newData, List<String>? newDataList) async {
    final existingUsers = await FirebaseFirestore.instance
        .collection(collectionName)
        .where(fieldName, isEqualTo: newData)
        .get();

    return existingUsers.docs.any((doc) => doc.id != docID);
  }

  Future<String> updateDoubleInfo(
    String collectionName,
    String docID,
    String fieldName,
    double newData,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docID)
          .update({fieldName: newData});
      return '';
    } catch (e) {
      return 'Failed to update. Please try again later';
    }
  }

  Future<String> updateIntInfo(
    String collectionName,
    String docID,
    String fieldName,
    int newData,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docID)
          .update({fieldName: newData});
      return '';
    } catch (e) {
      return 'Failed to update. Please try again later';
    }
  }

  Future<String> addNewRecordForSubcollection(
      String collectionName,
      String docID,
      String subCollectionName,
      Map<String, Object?> newData) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docID)
          .collection(subCollectionName)
          .add(newData);
      return '';
    } catch (e) {
      return 'Failed to update. Please try again later';
    }
  }

  Future<String> updateMultipleRecords(String collectionGrp, String fieldName,
      String targetField, String dataFieldName, String newData) async {
    try {
      await FirebaseFirestore.instance
          .collectionGroup(collectionGrp)
          .where(fieldName, isEqualTo: targetField)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({dataFieldName: newData});
        }
      });
      return '';
    } catch (e) {
      return 'Failed to update. Please try again later';
    }
  }
}
