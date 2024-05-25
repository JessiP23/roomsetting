import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'three_d_view.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Photogrammetry App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  List<XFile> _images = [];

  Future<void> captureAndUploadImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles;
      });

      for (var image in _images) {
        var request = http.MultipartRequest('POST', Uri.parse('http://YOUR_SERVER_URL/upload'));
        request.files.add(await http.MultipartFile.fromPath('images', image.path));
        var response = await request.send();

        if (response.statusCode == 200) {
          print('Image uploaded successfully.');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThreeDViewPage(),
            ),
          );
        } else {
          print('Image upload failed.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: captureAndUploadImages,
              child: const Text('Capture and Upload Images'),
            ),
          ],
        ),
      ),
    );
  }
}
