import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lemolite_drawing/dialog/custom_progress_dialog.dart';
import 'package:lemolite_drawing/service/device_info_service.dart';
import 'package:lemolite_drawing/utils/custom_snackbar.dart';

class FirebaseService {
  // Private constructor for singleton
  FirebaseService._privateConstructor();

  // Singleton instance
  static final FirebaseService _instance =
      FirebaseService._privateConstructor();

  // Getter to access the instance
  static FirebaseService get instance => _instance;

  // Firestore instance with assigned collection
  final CollectionReference _drawingCollection =
      FirebaseFirestore.instance.collection("Lemolite-Drawing");

  // Function to add drawing data
  Future<void> addDrawing({required List<Map<String, dynamic>> list}) async {
    try {
      CustomProgressDialog.show();
      final deviceID = await DeviceIDService().getDeviceID(); // Singleton usage
      final docRef = _drawingCollection.doc(deviceID); // Get document reference

      // Convert list into Firestore-friendly format
      final dataToStore = {"drawingData": list};

      await docRef.set(dataToStore, SetOptions(merge: true)).then(
        (value) {
          CustomProgressDialog.dismiss();
          CustomSnackBar.show(
              message: "✅ Data successfully saved in Firestore",
              color: Colors.green);
        },
      ); // Prevents overwriting
    } catch (e) {
      CustomProgressDialog.dismiss();
      CustomSnackBar.show(message: "❌ Error for saving", color: Colors.red);
      log("❌ Error adding test line: $e");
    }
  }

  Stream<QuerySnapshot> getDrawingStream() {
    return _drawingCollection.snapshots();
  }

  Stream<List<Map<String, dynamic>>> getDrawingStreamById(
      {required String id}) async* {
    final docRef = _drawingCollection.doc(id); // Get document reference

    yield* docRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        // Convert Firestore data to a List<Map<String, dynamic>>
        final data = snapshot.data() as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(data["drawingData"] ?? []);
      } else {
        return []; // Return empty list if no data exists
      }
    });
  }
}
