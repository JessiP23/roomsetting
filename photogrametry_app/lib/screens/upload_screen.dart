import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // For setting content-type
import 'dart:io'; // For File operations

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  Future<void> uploadFile(String filePath) async {
    try {
      var uri = Uri.parse("YOUR_UPLOAD_ENDPOINT");
      var request = http.MultipartRequest('POST', uri);
      
      // Ensure the file exists
      if (File(filePath).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'file', 
          filePath, 
          contentType: MediaType('image', 'jpeg'), // Adjust based on your file type
        ));

        var response = await request.send();
        
        if (response.statusCode == 200) {
          print('File uploaded successfully.');
          // Navigate to the next screen after successful upload
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NextScreen()),
          );
        } else {
          print('File upload failed with status: ${response.statusCode}');
        }
      } else {
        print('File does not exist at the provided path.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload File')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String filePath = 'path/to/your/file.jpg'; // Provide the correct path
            await uploadFile(filePath);
          },
          child: Text('Upload'),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Next Screen')),
      body: Center(
        child: Text('File uploaded successfully!'),
      ),
    );
  }
}
