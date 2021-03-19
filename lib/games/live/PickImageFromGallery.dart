import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ludobettings/models/winnerModel.dart';
import 'package:ludobettings/screens/home_page.dart';
import 'package:ludobettings/services/firestore_services.dart';
import 'package:ludobettings/widget/message_dialog_with_ok.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:video_player/video_player.dart';

class PickImageFromGallery extends StatefulWidget {
  final int eventId;
  final uid;

  const PickImageFromGallery({Key key, this.eventId, this.uid})
      : super(key: key);

  @override
  _PickImageFromGalleryState createState() => _PickImageFromGalleryState();
}

class _PickImageFromGalleryState extends State<PickImageFromGallery> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context,
        (double maxWidth, double maxHeight, int quality) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile.path);
      } else {
        return Semantics(
            child: Image.file(File(_imageFile.path)),
            label: 'image_picker_example_picked_image');
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Select The screenshot of the event \nresult to declare the winner, '
        '\nremember the screenshot will be \nchecked throughtly before approving your payment',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  StorageUploadTask _storageUploadTask;
  final FirebaseStorage _storage = FirebaseStorage();

  Future<void> _startUploadingTheImage() async {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    progressDialog.show();
    if (_imageFile != null) {
      File selected = File(_imageFile.path);
      String filePath = 'images/Event${widget.eventId}/${widget.uid}.png';
      _storageUploadTask =
          await _storage.ref().child(filePath).putFile(selected);
      var download_url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      var url = download_url.toString();
      print(url);

      addWinnerScreenshot(widget.eventId, url);
    } else {
      showToastt("Please Select the screenshot of the Winning Result");
    }
  }

  showToastt(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  FirestoreServices fireStoreServices = FirestoreServices();

  addWinnerScreenshot(int gameId, String url) async {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    progressDialog.show();
    await fireStoreServices.addWinningScreenShot(gameId, url).then((val) {
      progressDialog.hide();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomDialogWithOk(
                title: "Winner Screenshot Added Successfully",
                description:
                    "Thanks for adding the Winning Screenshot Successfully, Admin will verify your screenshot immediately",
                primaryButtonText: "Ok",
                primaryButtonRoute: HomePage.routeName,
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update The Winner"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * .6,
                child: Center(
                    child: FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'Select The screenshot of the event \nresult to declare the winner, '
                          '\nremember the screenshot will be \nchecked throughtly before approving your payment\n Remember- Anyone found trying to mislead will be banned for ever',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.done:
                        return _previewImage();
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'Select The screenshot of the event \nresult to declare the winner, '
                            '\nremember the screenshot will be \nchecked throughtly before approving your payment \nRemember- Anyone found trying to mislead will be banned for ever',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Text("Game Id: " + widget.eventId.toString()),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                _startUploadingTheImage();
              },
              child: Text("Update the Winner"),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Screenshot of The Event Result',
              child: const Icon(Icons.photo_library),
            ),
          ),
        ],
      ),
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Notes'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  enabled: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Make Sure  Game code is Visible"),
                ),
                TextField(
                  controller: maxHeightController,
                  enabled: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Make Sure Your name is visible"),
                ),
                TextField(
                  controller: qualityController,
                  enabled: false,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: "All The Best"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    double width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    double height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    int quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}
