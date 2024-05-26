import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
              final response = await request.send();
              if (response.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Image uploaded successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Image upload failed.'),
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
