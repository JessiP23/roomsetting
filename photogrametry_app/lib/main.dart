import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photogrammetry App Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WallCaptureScreen(wallName: 'Wall 1')),
            );
          },
          child: Text('Start Capturing Images'),
        ),
      ),
    );
  }
}

class WallCaptureScreen extends StatefulWidget {
  final String wallName;

  const WallCaptureScreen({Key? key, required this.wallName}) : super(key: key);

  @override
  _WallCaptureScreenState createState() => _WallCaptureScreenState();
}

class _WallCaptureScreenState extends State<WallCaptureScreen> {
  final picker = ImagePicker();
  bool isUploading = false;
  int currentWallIndex = 0;
  final List<String> walls = ['Wall 1', 'Wall 2', 'Wall 3']; // Add more walls as needed

  Future<void> captureAndUploadImage() async {
  final pickedFile = await picker.getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      isUploading = true;
    });

    print('Picked file path: ${pickedFile.path}');

    final url = Uri.parse('http://localhost:3000/upload'); // Replace with your server URL
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));

    try {
      final response = await request.send();
      if (response.statusCode == 201) { // Change this to the appropriate status code returned by your server
        setState(() {
          isUploading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ImageUploadPage(),
          ),
        );
      } else {
        setState(() {
          isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image upload failed. Server responded with status code ${response.statusCode}.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image upload failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wallName),
      ),
      body: Center(
        child: isUploading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: captureAndUploadImage,
                child: Text('Capture or Select Image for ${widget.wallName}'),
              ),
      ),
    );
  }
}

class ImageUploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              final url = Uri.parse('http://localhost:3000/upload');
              final request = http.MultipartRequest('POST', url);
              request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));
              try {
                final response = await request.send();
                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Image uploaded successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Image upload failed. Server responded with status code ${response.statusCode}.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Image upload failed: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: Text('Upload Image'),
        ),
      ),
    );
  }
}

class ThreeDViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D View'),
      ),
      body: Center(
        child: Text('3D view of the captured images will be displayed here.'),
      ),
    );
  }
}
