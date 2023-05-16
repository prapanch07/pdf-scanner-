import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> main() async {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? file;
  ImagePicker image = ImagePicker();
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(img!.path);
    });
  }

  getImagecam() async {
    var img = await image.pickImage(source: ImageSource.camera);

    setState(() {
      file = File(img!.path);
    });
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, file) async {
    final pdf = pw.Document();

    final showimage = pw.MemoryImage(file.readAsBytesSync());

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
            child: pw.Image(showimage, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: file == null
          ? Center(
              child: MaterialButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text("Choose ur Option"),
                        children: [
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.of(context).pop();
                              getImage();
                            },
                            child: const Text('Scan from gallary'),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.of(context).pop();
                              getImagecam();
                            },
                            child: const Text("Scan from Camera"),
                          )
                        ],
                      );
                    },
                  );
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text("scan pdf"),
              ),
            )
          : PdfPreview(
              build: (format) => _generatePdf(format, file),
            ),
    );
   
  }
}
