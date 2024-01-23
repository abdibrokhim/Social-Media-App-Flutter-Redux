import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data'; // Import for Uint8List

class MyTestClass {
  late FirebaseStorage firebaseStorage;
  late Uint8List imageData;
  String? imageUrl;

  MyTestClass() {
    firebaseStorage = FirebaseStorage.instance;
  }

  Future<void> uploadImageToFirebase() async {
    try {
      String fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference firebaseStorageRef = firebaseStorage.ref().child('uploads/$fileName');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName},
      );

      UploadTask uploadTask = firebaseStorageRef.putData(imageData, metadata);
      
      TaskSnapshot taskSnapshot = await uploadTask;
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image to firebase storage: $e');
      imageUrl = null;
    }
  }
}

// Mock Classes
class MockFirebaseStorage extends Mock implements FirebaseStorage {}
class MockReference extends Mock implements Reference {}
class MockUploadTask extends Mock implements UploadTask {}
class MockTaskSnapshot extends Mock implements TaskSnapshot {}

void main() {

  String image = 'https://source.unsplash.com/random/200x200?sig=incrementingIdentifier';
  Uint8List imageData = Uint8List.fromList([0, 1, 2, 3]);

  group('uploadImageToFirebase Tests', () {
    late MockFirebaseStorage mockFirebaseStorage;
    late MockReference mockReference;
    late MockUploadTask mockUploadTask;
    late MockTaskSnapshot mockTaskSnapshot;
    late MyTestClass myTestClass;

    setUp(() {
      mockFirebaseStorage = MockFirebaseStorage();
      mockReference = MockReference();
      mockUploadTask = MockUploadTask();
      mockTaskSnapshot = MockTaskSnapshot();
      myTestClass = MyTestClass();

      // Setup the mock methods
      when(mockFirebaseStorage.ref()).thenReturn(mockReference);
      when(mockReference.child(image)).thenReturn(mockReference);
      when(mockReference.putData(imageData, any)).thenReturn(mockUploadTask);
      when(mockUploadTask.whenComplete((){})).thenAnswer((_) async => mockTaskSnapshot);
      when(mockTaskSnapshot.ref).thenReturn(mockReference);
      when(mockReference.getDownloadURL()).thenAnswer((_) async => image);

      // Setup dummy image data
      myTestClass.imageData = Uint8List.fromList([0, 1, 2, 3]); // Dummy data
      myTestClass.firebaseStorage = mockFirebaseStorage;
    });

    test('Successful Image Upload', () async {
      await myTestClass.uploadImageToFirebase();
      expect(myTestClass.imageUrl, equals(image));
    });

    test('Failed Image Upload', () async {
      when(mockReference.putData(imageData, any)).thenThrow(Exception('Failed to upload'));
      await myTestClass.uploadImageToFirebase();
      expect(myTestClass.imageUrl, isNull);
    });
  });
}
