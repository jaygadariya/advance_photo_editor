import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'colors_picker.dart';

class TextEditorImage extends StatefulWidget {
  @override
  _TextEditorImageState createState() => _TextEditorImageState();
}

class _TextEditorImageState extends State<TextEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.black;
  double slider = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          align == TextAlign.left
              ? Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            align = null;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(FontAwesomeIcons.alignLeft),
                        ),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      align = TextAlign.left;
                    });
                  },
                  icon: Icon(FontAwesomeIcons.alignLeft),
                ),
          align == TextAlign.center
              ? Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            align = null;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(FontAwesomeIcons.alignCenter),
                        ),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      align = TextAlign.center;
                    });
                  },
                  icon: Icon(FontAwesomeIcons.alignCenter),
                ),
          align == TextAlign.right
              ? Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Material(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                align = null;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(FontAwesomeIcons.alignRight),
                            ))),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      align = TextAlign.right;
                    });
                  },
                  icon: Icon(FontAwesomeIcons.alignRight),
                ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: FlatButton(
          onPressed: () {
            Navigator.pop(context, {'name': name.text, 'color': currentColor, 'size': slider.toDouble(), 'align': align});
          },
          color: Colors.black,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Add Text',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Insert Your Message',
                    hintStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                  ),
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 99999,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: true,
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Slider Color'),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      verticalDirection: VerticalDirection.down,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: BarColorPicker(
                              width: MediaQuery.of(context).size.width - 100,
                              thumbColor: Colors.white,
                              cornerRadius: 10,
                              pickMode: PickMode.Color,
                              colorListener: (int value) {
                                setState(() {
                                  currentColor = Color(value);
                                });
                              }),
                        ),
                        FlatButton(onPressed: () {}, child: Text('Reset'))
                      ],
                    ),
                    Text('Slider White Black Color'),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        Expanded(
                          child: BarColorPicker(
                              width: 300,
                              thumbColor: Colors.white,
                              cornerRadius: 10,
                              pickMode: PickMode.Grey,
                              colorListener: (int value) {
                                setState(() {
                                  currentColor = Color(value);
                                });
                              }),
                        ),
                        FlatButton(onPressed: () {}, child: Text('Reset')),
                      ],
                    ),
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Text(
                              'Size Adjust'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Slider(
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                              value: slider,
                              min: 0.0,
                              max: 100.0,
                              onChangeEnd: (v) {
                                setState(() {
                                  slider = v;
                                });
                              },
                              onChanged: (v) {
                                setState(() {
                                  slider = v;
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextAlign? align;
}
