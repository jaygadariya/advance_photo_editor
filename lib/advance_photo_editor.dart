import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:advance_photo_editor/modules/add_emoji_screen.dart';
import 'package:advance_photo_editor/modules/bottombar_container.dart';
import 'package:advance_photo_editor/modules/colors_picker.dart';
import 'package:advance_photo_editor/modules/emoji.dart';
import 'package:advance_photo_editor/modules/sliders.dart';
import 'package:advance_photo_editor/modules/text.dart';
import 'package:advance_photo_editor/modules/textview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

import 'modules/color_filter_generator.dart';

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 300;
var height = 300;
List<Map?> widgetJson = [];
//List fontsize = [];
//List<Color> colorList = [];
var howmuchwidgetis = 0;
//List multiwidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class AdvancePhotoEditor extends StatefulWidget {
  final Color? appBarColor;
  final Color? bottomBarColor;
  final Directory? pathSave;
  final File? defaultImage;
  final double? pixelRatio;

  AdvancePhotoEditor({
    this.appBarColor,
    this.bottomBarColor,
    this.pathSave,
    this.defaultImage,
    this.pixelRatio,
  });

  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<AdvancePhotoEditor> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller = SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset?> _points = <Offset?>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  File? _image;
  ScreenshotController screenshotController = ScreenshotController();
  late Timer timeprediction;

  void timers() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.defaultImage != null && widget.defaultImage!.existsSync()) {
        loadImage(widget.defaultImage!);
      }
    });
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    _controller.clear();
    widgetJson.clear();
    heightcontroler.clear();
    widthcontroler.clear();
    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    //  fontsize.clear();
    offsets.clear();
    //  multiwidget.clear();
    howmuchwidgetis = 0;

    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;
  double blurValue = 0;
  double opacityValue = 0;
  Color colorValue = Colors.transparent;

  double hueValue = 0;
  double brightnessValue = 0;
  double saturationValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      key: scaf,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_rounded),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.boxes),
            onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Height Width'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              height = int.parse(heightcontroler.text);
                              width = int.parse(widthcontroler.text);
                            });
                            heightcontroler.clear();
                            widthcontroler.clear();
                            Navigator.pop(context);
                          },
                          child: Text('Done'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text('Define Height'),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextField(
                              controller: heightcontroler,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                hintText: 'Height',
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text('Define Width'),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextField(
                              controller: widthcontroler,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                hintText: 'Width',
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _controller.points.clear();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              bottomsheets();
            },
          ),
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              screenshotController.capture(pixelRatio: widget.pixelRatio ?? 1.5).then((binaryIntList) async {
                //print("Capture Done");

                final paths = widget.pathSave ?? await getTemporaryDirectory();

                final file = await File('${paths.path}/' + DateTime.now().toString() + '.jpg').create();
                file.writeAsBytesSync(binaryIntList!);
                Navigator.pop(context, file);
              }).catchError((onError) {
                print(onError);
              });
            },
          ),
        ],
        brightness: Brightness.dark,
        // backgroundColor: Colors.red,
        backgroundColor: widget.appBarColor ?? Colors.black87,
      ),
      bottomNavigationBar: openbottomsheet
          ? Container()
          : Container(
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: widget.bottomBarColor!.withOpacity(0.4),
                    blurRadius: 10.9,
                  ),
                ],
              ),
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.format_paint_rounded,
                    ontap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                            ),
                          ),
                          backgroundColor: Colors.white,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ColorPicker(
                                    displayThumbColor: true,
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    title: 'Free hand',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.text_fields,
                    ontap: () async {
                      var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => TextEditorImage()));
                      if (value['name'] != null) {
                        type.add(2);
                        widgetJson.add(value);
                        offsets.add(Offset.zero);
                        howmuchwidgetis++;
                      }
                    },
                    title: 'Text',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.flip,
                    ontap: () {
                      setState(() {
                        flipValue = flipValue == 0 ? math.pi : 0;
                      });
                    },
                    title: 'Flip',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.rotate_left,
                    ontap: () {
                      setState(() {
                        rotateValue--;
                      });
                    },
                    title: 'Rotate left',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.rotate_right,
                    ontap: () {
                      setState(() {
                        rotateValue++;
                      });
                    },
                    title: 'Rotate right',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.blur_on,
                    ontap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                            ),
                          ),
                          backgroundColor: Colors.black54,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setS) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 5.0,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        margin: const EdgeInsets.only(bottom: 16.0),
                                      ),
                                      filterSaturation(
                                          title: "Blur",
                                          min: 0.0,
                                          max: 10.0,
                                          data: blurValue,
                                          sliderCallBack: (v) {
                                            setS(() {
                                              blurValue = v;
                                            });
                                          },
                                          resetCallBack: () {
                                            setS(() {
                                              blurValue = 0.0;
                                            });
                                          }),
                                      filterSaturation(
                                          title: "Opacity",
                                          min: 0.00,
                                          max: 1.0,
                                          data: opacityValue,
                                          sliderCallBack: (v) {
                                            setS(() {
                                              opacityValue = v;
                                            });
                                          },
                                          resetCallBack: () {
                                            setS(() {
                                              opacityValue = 0.0;
                                            });
                                          }),
                                      filterSaturation(
                                          isColorSlider: true,
                                          title: "Color",
                                          min: 0.00,
                                          max: 0.0,
                                          data: colorValue,
                                          sliderCallBack: (v) {
                                            setS(() {
                                              colorValue = Color(v);
                                            });
                                          },
                                          resetCallBack: () {
                                            setS(() {
                                              colorValue = Colors.transparent;
                                            });
                                          }),
                                    ],
                                  ),
                                );
                              },
                            );
                          });
                    },
                    title: 'Blur',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: FontAwesomeIcons.eraser,
                    ontap: () {
                      _controller.clear();
                      //  type.clear();
                      // // fontsize.clear();
                      //  offsets.clear();
                      // // multiwidget.clear();
                      howmuchwidgetis = 0;
                    },
                    title: 'Eraser',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.photo,
                    ontap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                            ),
                          ),
                          backgroundColor: Colors.black54,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setS) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 5.0,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        margin: const EdgeInsets.only(bottom: 16.0),
                                      ),
                                      filterSaturation(
                                          title: "Hue",
                                          min: 0.0,
                                          max: 1.0,
                                          data: hueValue,
                                          sliderCallBack: (v) {
                                            setS(() {
                                              hueValue = v;
                                            });
                                          },
                                          resetCallBack: () {
                                            setS(() {
                                              hueValue = 0.0;
                                            });
                                          }),
                                      filterSaturation(
                                          title: "Saturation",
                                          min: -10.0,
                                          max: 10.0,
                                          data: saturationValue,
                                          sliderCallBack: (v) {
                                            setS(() {
                                              saturationValue = v;
                                            });
                                          },
                                          resetCallBack: () {
                                            setS(() {
                                              saturationValue = 0.0;
                                            });
                                          }),
                                      filterSaturation(
                                          title: "Brightness",
                                          min: 0.0,
                                          max: 1.0,
                                          data: brightnessValue,
                                          sliderCallBack: (v) {
                                            setS(() {
                                              brightnessValue = v;
                                            });
                                          },
                                          resetCallBack: () {
                                            setS(() {
                                              brightnessValue = 0.0;
                                            });
                                          }),
                                    ],
                                  ),
                                );
                              },
                            );
                          });
                    },
                    title: 'Filter',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: FontAwesomeIcons.smile,
                    ontap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                            ),
                          ),
                          backgroundColor: Colors.black54,
                          builder: (BuildContext context) {
                            return AddEmojiScreen();
                          }).then((value) {
                        if (value != null) {
                          if (value['name'] != null) {
                            type.add(1);
                            widgetJson.add(value);
                            offsets.add(Offset.zero);
                            howmuchwidgetis++;
                          }
                        }
                      });
                    },
                    title: 'Emoji',
                  ),
                ],
              ),
            ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: RotatedBox(
            quarterTurns: rotateValue,
            child: imageFilterLatest(
              hue: hueValue,
              brightness: brightnessValue,
              saturation: saturationValue,
              child: Container(
                margin: EdgeInsets.all(20),
                color: Colors.white,
                width: width.toDouble(),
                height: height.toDouble(),
                child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: [
                      _image != null
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(flipValue),
                              child: ClipRect(
                                // <-- clips to the 200x200 [Container] below
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  // alignment: Alignment.center,
                                  width: width.toDouble(),
                                  height: height.toDouble(),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          alignment: Alignment.center,
                                          matchTextDirection: false,
                                          repeat: ImageRepeat.noRepeat,
                                          fit: BoxFit.fitHeight,
                                          image: FileImage(File(_image!.path)))),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: blurValue,
                                      sigmaY: blurValue,
                                    ),
                                    child: Container(
                                      color: colorValue.withOpacity(opacityValue),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      GestureDetector(
                        child: Signat(),
                        onPanUpdate: (DragUpdateDetails details) {
                          setState(() {
                            RenderBox object = context.findRenderObject() as RenderBox;
                            var _localPosition = object.globalToLocal(details.globalPosition);
                            _points = List.from(_points)..add(_localPosition);
                          });
                        },
                        onPanEnd: (DragEndDetails details) {
                          _points.add(null);
                        },
                      ),
                      Stack(
                        children: widgetJson.asMap().entries.map((f) {
                          return type[f.key] == 1
                              ? EmojiView(
                                  left: offsets[f.key].dx,
                                  top: offsets[f.key].dy,
                                  ontap: () {
                                    scaf.currentState!.showBottomSheet((context) {
                                      return Sliders(
                                        index: f.key,
                                        mapValue: f.value,
                                      );
                                    });
                                  },
                                  onpanupdate: (details) {
                                    setState(() {
                                      offsets[f.key] = Offset(offsets[f.key].dx + details.delta.dx, offsets[f.key].dy + details.delta.dy);
                                    });
                                  },
                                  mapJson: f.value,
                                )
                              : type[f.key] == 2
                                  ? TextView(
                                      left: offsets[f.key].dx,
                                      top: offsets[f.key].dy,
                                      ontap: () {
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) {
                                              return Sliders(
                                                index: f.key,
                                                mapValue: f.value,
                                              );
                                            });
                                      },
                                      onpanupdate: (details) {
                                        setState(() {
                                          offsets[f.key] = Offset(offsets[f.key].dx + details.delta.dx, offsets[f.key].dy + details.delta.dy);
                                        });
                                      },
                                      mapJson: f.value,
                                    )
                                  : Container();
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget filterSaturation({
    required String title,
    required double min,
    required double max,
    required data,
    required sliderCallBack,
    required resetCallBack,
    bool isColorSlider = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: isColorSlider == true
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: BarColorPicker(
                          thumbColor: Colors.white,
                          cornerRadius: 10,
                          thumbRadius: 10,
                          width: MediaQuery.of(context).size.width - 110,
                          pickMode: PickMode.Color,
                          colorListener: (int value) {
                            sliderCallBack(value);
                          }),
                    )
                  : Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      value: data,
                      min: min,
                      max: max,
                      onChanged: (v) {
                        sliderCallBack(v);
                      }),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  resetCallBack();
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {});
    var future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 170,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text('Select Image Options'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          var image = await (_picker.pickImage(source: ImageSource.gallery));
                          await loadImage(File(image!.path));
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.photo_library),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text('Open Gallery')
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24.0,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          var image = await (_picker.pickImage(source: ImageSource.camera));
                          var decodedImage = await decodeImageFromList(File(image!.path).readAsBytesSync());

                          setState(() {
                            height = decodedImage.height;
                            width = decodedImage.width;
                            _image = File(image.path);
                          });
                          setState(() => _controller.clear());
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.camera_alt),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text('Open Camera')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  Future<void> loadImage(File imageFile) async {
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    setState(() {
      height = decodedImage.height;
      width = decodedImage.width;
      _image = imageFile;
      _controller.clear();
    });
  }

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      addSemanticIndexes: true,
      dragStartBehavior: DragStartBehavior.start,
      reverse: false,
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      clipBehavior: Clip.hardEdge,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      children: [
        Signature(
          controller: _controller,
          height: height.toDouble(),
          width: width.toDouble(),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}

Widget imageFilterLatest({required brightness, required saturation, required hue, child}) {
  return ColorFiltered(
    colorFilter: ColorFilter.matrix(
      ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      ),
    ),
    child: ColorFiltered(
      colorFilter: ColorFilter.matrix(
        ColorFilterGenerator.saturationAdjustMatrix(
          value: saturation,
        ),
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
          value: hue,
        )),
        child: child,
      ),
    ),
  );
}
