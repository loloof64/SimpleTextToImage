import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_content_placeholder/flutter_content_placeholder.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:file_picker/file_picker.dart';
import './core/io/image_generation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Text To Image',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
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
  fp.Option<Uint8List> _imageData = const fp.None();
  final _promptController =
      TextEditingController(text: "Astronaut riding an horse");

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _getNewImage() async {
    setState(() {
      _imageData = const fp.None();
    });
    final data = await generateImage(_promptController.text).run();
    setState(() {
      _imageData = fp.some(data);
    });
  }

  void _purposeSaveToFile() async {
    if (_imageData.isNone()) return;
    final String? path =
        await FilePicker.platform.saveFile(dialogTitle: "Save file as");

    if (path != null) {
      File file = File(path);
      await file.writeAsBytes(
        _imageData.getOrElse(
          () => Uint8List(1),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File saved.'),
        ),
      );
    }
  }

  Widget _getImageChild() {
    return switch (_imageData) {
      fp.Some(value: final bytesData) => Image.memory(
          bytesData,
          width: 500,
          height: 500,
        ),
      _ => ContentPlaceholder(
          context: context,
          width: 500,
          height: 500,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final imageChild = _getImageChild();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _purposeSaveToFile,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: imageChild,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                    ),
                  ),
                  IconButton(
                    onPressed: _getNewImage,
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
