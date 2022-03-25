import 'dart:io';

import 'package:advance_photo_editor/advance_photo_editor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerDefaultImage = TextEditingController();
  File? _defaultImage;
  File? _image;

  Future<void> getimageditor() => Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AdvancePhotoEditor(
          appBarColor: Colors.black87,
          bottomBarColor: Colors.black87,
          pathSave: null,
          defaultImage: _defaultImage,
        );
      })).then((geteditimage) {
        if (geteditimage != null) {
          setState(() {
            _image = geteditimage;
          });
        }
      }).catchError((er) {
        print(er);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image Editor Pro example',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      /*floatingActionButton: Icons.add.xIcons().xFloationActiobButton(
            color: Colors.red,
            onTap: () {
              // TODO: I don't know what I'm doing in here
            },
          ),*/
      body: condition(
        condtion: _image == null,
        isTrue: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: controllerDefaultImage,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'No default image',
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  onPressed: () async {
                    final imageGallery = await ImagePicker().getImage(source: ImageSource.gallery);
                    if (imageGallery != null) {
                      _defaultImage = File(imageGallery.path);
                      setState(() => controllerDefaultImage.text = _defaultImage!.path);
                    }
                  },
                  child: Text('Set Default Image'),
                ),
                RaisedButton(
                  onPressed: () {
                    getimageditor();
                  },
                  child: Text('Open Editor'),
                )
              ],
            ),
          ),
        ),
        isFalse: _image == null
            ? Container()
            : Center(
                child: Image.file(_image!),
              ),
      ),
    );
  }
}

Widget? condition({required bool condtion, Widget? isTrue, Widget? isFalse}) {
  return condtion ? isTrue : isFalse;
}
