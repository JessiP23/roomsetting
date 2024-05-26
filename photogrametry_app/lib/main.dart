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

      final url = Uri.parse('http://localhost:3000/upload'); // Replace with your server URL
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));
      final response = await request.send();

      setState(() {
        isUploading = false;
      });

      if (response.statusCode == 200) {
        if (currentWallIndex < walls.length - 1) {
          setState(() {
            currentWallIndex++;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WallCaptureScreen(wallName: walls[currentWallIndex]),
            ),
          );
        } else {
          // If all walls are captured, navigate to the 3D view page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ThreeDViewPage(),
            ),
          );
        }
      } else {
        print('Image Upload Failed');
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
