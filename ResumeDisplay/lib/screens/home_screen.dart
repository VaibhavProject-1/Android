import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Resume'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adjust padding as needed
        child: SfPdfViewer.asset(
          'assets/resume.pdf',
        ),
      ),
    );
  }
}