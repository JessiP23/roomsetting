import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

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
    print('Picking file for $section');
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;
      print('Picked file: $fileName');

      final url = Uri.parse('http://localhost:3000/upload');
      final request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        fileBytes,
        filename: fileName,
      ));
      print('Sending request to server');
      final response = await request.send();
      if (response.statusCode == 201) {
        print('Upload successful for $section');
        setState(() {
          uploadStatus[section] = true;
          allUploaded = uploadStatus.values.every((status) => status);
        });
      } else {
        print('Image upload failed with status: ${response.statusCode}');
      }
    } else {
      print('File picking cancelled.');
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
