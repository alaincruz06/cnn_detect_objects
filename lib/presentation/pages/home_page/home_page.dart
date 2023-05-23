import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cnn_detect_objects/presentation/app/constants/assets.dart';
import 'package:cnn_detect_objects/presentation/widgets/pop_menu_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  List? _recognitions;
  ImagePicker imagePicker = ImagePicker();
  double _imageHeight = 200;
  double _imageWidth = 200;
  bool _busy = false;

  Future predictImageGallery() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(File(image.path));
  }

  Future predictImagePhoto() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(File(image.path));
  }

  Future predictImage(File? image) async {
    if (image == null) return;
    await yolov2Tiny(image);

    FileImage(image)
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  Future loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
        model: Assets.assetsYolov2Tiny,
        labels: Assets.assetsYolov2TinyTxt,
        // useGpuDelegate: true,
      );
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fallo al cargar modelo: $e')));
    }
  }

  Future yolov2Tiny(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "YOLO",
      threshold: 0.3,
      imageMean: 0.0,
      imageStd: 255.0,
      numResultsPerClass: 1,
    );
    setState(() {
      _recognitions = recognitions;
    });
    int endTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint("La inferencia tardó ${endTime - startTime}ms");
  }

  Future segmentMobileNet(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runSegmentationOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _recognitions = recognitions;
    });
    int endTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint("La inferencia tardó ${endTime - startTime}");
  }

  Future poseNet(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runPoseNetOnImage(
      path: image.path,
      numResults: 2,
    );

    debugPrint(recognitions.toString());

    setState(() {
      _recognitions = recognitions;
    });
    int endTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint("La inferencia tardó ${endTime - startTime}ms");
  }

  List<Widget>? renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    // if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    Color blue = const Color.fromRGBO(37, 213, 253, 1.0);
    return _recognitions?.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    stackChildren.add(_image == null
        ? const Center(child: Text('No hay imagen seleccionada'))
        : Image.file(_image!));

    stackChildren.addAll(renderBoxes(size)!);

    if (_busy) {
      stackChildren.add(const Opacity(
        opacity: 0.3,
        child: ModalBarrier(dismissible: false, color: Colors.grey),
      ));
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CNN Detector de Objetos'),
        actions: const [
          PopMenuHomePage(),
        ],
      ),
      body: Stack(
        children: stackChildren,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 30,
            bottom: 8,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: predictImagePhoto,
              tooltip: 'Tomar Imagen',
              child: const Icon(Icons.camera),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: predictImageGallery,
              tooltip: 'Escoger Imagen',
              child: const Icon(Icons.image),
            ),
          ),
        ],
      ),
    );
  }
}
