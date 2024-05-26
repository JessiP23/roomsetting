import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:photogrametry_app/screens/RoofCaptureScreen.dart';

class FloorCaptureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Image for Floor'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              // Upload the image to the server
              final url = Uri.parse('http://localhost:3000/upload');
              final request = http.MultipartRequest('POST', url);
              request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));
              final response = await request.send();
              if (response.statusCode == 200) {
                // Image upload successful, navigate to the next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoofCaptureScreen(), // Replace NextScreen with the appropriate screen/widget
                  ),
                );
              } else {
                // Image upload failed
                print('Image upload failed.');
              }
            }
          },
          child: Text('Capture or Select Image'),
        ),
      ),
    );
  }
}
