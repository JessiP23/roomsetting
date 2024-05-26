import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photogrammetry App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> sections = ['Wall 1', 'Wall 2', 'Wall 3', 'Wall 4', 'Roof', 'Floor'];
  final Map<String, bool> uploadStatus = {};
  bool allUploaded = false;

  @override
  void initState() {
    super.initState();
    for (var section in sections) {
      uploadStatus[section] = false;
    }
  }

  Future<void> uploadImage(String section) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final url = Uri.parse('http://localhost:3000/upload');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));
      final response = await request.send();
      if (response.statusCode == 201) {
        setState(() {
          uploadStatus[section] = true;
          allUploaded = uploadStatus.values.every((status) => status);
        });
      } else {
        print('Image upload failed.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photogrammetry App Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var section in sections) 
              ElevatedButton(
                onPressed: uploadStatus[section]! ? null : () => uploadImage(section),
                style: ElevatedButton.styleFrom(
                  backgroundColor: uploadStatus[section]! ? Colors.green : null,
                ),
                child: Text(uploadStatus[section]! ? '$section Uploaded' : 'Upload $section'),
              ),
            if (allUploaded)
              ElevatedButton(
                onPressed: () {
                  // Handle the submission of room dimensions here
                  print('All images uploaded. Submitting room dimensions...');
                },
                child: Text('Submit Room Dimensions'),
              ),
          ],
        ),
      ),
    );
  }
}
