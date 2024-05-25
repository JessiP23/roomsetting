import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ThreeDViewPage extends StatefulWidget {
  @override
  _ThreeDViewPageState createState() => _ThreeDViewPageState();
}

class _ThreeDViewPageState extends State<ThreeDViewPage> {
  String? htmlContent;

  @override
  void initState() {
    super.initState();
    _loadHtmlContent();
  }

  Future<void> _loadHtmlContent() async {
    final String fileText = await rootBundle.loadString('assets/three_d_view.html');
    setState(() {
      htmlContent = Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
      ).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D View'),
      ),
      body: htmlContent == null
          ? Center(child: CircularProgressIndicator())
          : WebView(
              initialUrl: htmlContent,
              javascriptMode: JavascriptMode.unrestricted,
            ),
    );
  }
}
