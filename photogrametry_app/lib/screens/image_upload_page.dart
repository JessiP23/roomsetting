import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'FloorCapturePage.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final picker = ImagePicker();
  bool isUploading = false;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FloorCapturePage(),
          ),
        );
      } else {
        print('Image Upload Failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: isUploading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: captureAndUploadImage,
                child: Text('Capture or Select Image for Upload'),
              ),
      ),
    );
  }
}
