import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:photogrametry_app/screens/image_upload_page.dart';

class WallCaptureScreen extends StatelessWidget {
  final String wallName;

  const WallCaptureScreen({Key? key, required this.wallName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Image for $wallName'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              final url = Uri.parse('http://localhost:3000/upload');
              final request = http.MultipartRequest('POST', url);
              request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));
              final response = await request.send();
              if (response.statusCode == 200) {
                // Image upload successful
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageUploadPage()),
                );
              } else {
                // Image upload failed
                print('Image upload failed.');
              }
            }
          },
          child: Text('Upload Image'),
        ),
      ),
    );
  }
}
