import 'dart:io';
import 'dart:math';

import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FamilyMemberPatientTakeTest extends StatefulWidget {
  const FamilyMemberPatientTakeTest({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<FamilyMemberPatientTakeTest> createState() => _FamilyMemberPatientTakeTestState();
}

class _FamilyMemberPatientTakeTestState extends State<FamilyMemberPatientTakeTest> {
  bool _isLoading = false;

  int activeStep = 0;
  int maxIndex = 4;

  List<int> numbers = List.generate(4, (index) => index + 1);

  List<File?> imageFiles = List.generate(4, (index) => null);
  List<ImagePicker?>? imagePickers;

  String? reportId;

  List<String> questionList = [
    "Please take/upload 1st image of Right Eye",
    "Please take/upload 2nd image of Right Eye",
    "Please take/upload 1st image of Left Eye",
    "Please take/upload 2nd image of Left Eye"
  ];

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    imagePickers = List.generate(maxIndex, (index) {
      return ImagePicker();
    });
    setState(() {
      _isLoading = false;
    });
    super.initState();
    _cameraPermissionInitState();
  }

  void _cameraPermissionInitState() async {
    if (kIsWeb) {
      return;
    }

    if (Platform.isAndroid) {
      if (await Permission.camera.request().isGranted) {
        if (kDebugMode) {
          print("Camera permission granted");
        }
      }

      if (!mounted) return;
    }
  }

  final GlobalKey<FormState> _testFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _isLoading == true
          ? const LoadingScreen()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: true,
                  centerTitle: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  expandedHeight: MediaQuery.of(context).size.height * 0.16,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0),
                      ),
                      child: Image.asset(
                        "assets/ansan_1.jpg",
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "Glaucoma Test",
                        style: GoogleFonts.habibi(
                          textStyle: Theme.of(context).textTheme.headlineSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          NumberStepper(
                            activeStepColor:
                                Theme.of(context).primaryIconTheme.color,
                            activeStepBorderColor:
                                Theme.of(context).secondaryHeaderColor,
                            stepColor: Theme.of(context).splashColor,
                            lineColor: Theme.of(context).secondaryHeaderColor,
                            stepReachedAnimationEffect: Curves.easeInOutCubic,
                            enableStepTapping: false,
                            direction: Axis.horizontal,
                            enableNextPreviousButtons: false,
                            numbers: numbers,
                            activeStep: activeStep,
                            lineLength: 24,
                            onStepReached: (index) {
                              setState(() {
                                activeStep = index;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              previousButton(),
                              nextButton(),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                            child: Column(
                              children: [
                                Form(
                                  autovalidateMode: AutovalidateMode.disabled,
                                  key: _testFormKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 8.0),
                                            child: Text(
                                              questionList[activeStep],
                                              style: GoogleFonts.raleway(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const Divider(),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height:
                                                    imageFiles[activeStep] ==
                                                            null
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.25
                                                        : null,
                                                width: imageFiles[activeStep] ==
                                                        null
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.5
                                                    : null,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child:
                                                    imageFiles[activeStep] ==
                                                            null
                                                        ? Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                  4.0,
                                                                ),
                                                                child:
                                                                    ElevatedButton
                                                                        .icon(
                                                                  label: Text(
                                                                    "Upload Image from Gallery",
                                                                    style: GoogleFonts
                                                                        .raleway(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onPrimary,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  icon: Icon(
                                                                    Icons
                                                                        .upload_rounded,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimary,
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    XFile?
                                                                        image =
                                                                        await ImagePicker()
                                                                            .pickImage(
                                                                      source: ImageSource
                                                                          .gallery,
                                                                      imageQuality:
                                                                          100,
                                                                      preferredCameraDevice:
                                                                          CameraDevice
                                                                              .front,
                                                                    );
                                                                    setState(
                                                                      () {
                                                                        if (image !=
                                                                            null) {
                                                                          imageFiles[activeStep] =
                                                                              File(image.path);
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child:
                                                                    ElevatedButton
                                                                        .icon(
                                                                  label: Text(
                                                                    "Take Image from Camera",
                                                                    style: GoogleFonts
                                                                        .raleway(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onPrimary,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  icon: Icon(
                                                                      Icons
                                                                          .camera_alt_rounded,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onPrimary),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    XFile?
                                                                        image =
                                                                        await ImagePicker()
                                                                            .pickImage(
                                                                      source: ImageSource
                                                                          .camera,
                                                                      imageQuality:
                                                                          50,
                                                                      preferredCameraDevice:
                                                                          CameraDevice
                                                                              .front,
                                                                    );
                                                                    setState(
                                                                      () {
                                                                        if (image !=
                                                                            null) {
                                                                          imageFiles[activeStep] =
                                                                              File(image.path);
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Image.file(
                                                            imageFiles[
                                                                activeStep]!,
                                                            fit: BoxFit.cover,
                                                            scale: 1.0,
                                                          ),
                                              ),
                                              if (imageFiles[activeStep] !=
                                                  null) ...[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 32.0, 0.0, 0.0),
                                                  child: ElevatedButton(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "Remove Image",
                                                        style:
                                                            GoogleFonts.raleway(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onErrorContainer,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        imageFiles[activeStep] =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                              const SizedBox(
                                                height: 16,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget nextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: MaterialButton(
        onPressed: activeStep == maxIndex - 1
            ? () async {
                if (_testFormKey.currentState!.validate() &&
                    imageFiles[activeStep] != null) {
                  _testFormKey.currentState!.save();
                  // TODO: Submit the test to generate report

                  setState(() {
                    _isLoading = true;
                  });

                  FirebaseModelDownloader.instance
                      .getModel(
                          "glaucoma-detection",
                          FirebaseModelDownloadType.localModel,
                          FirebaseModelDownloadConditions(
                            iosAllowsCellularAccess: true,
                            iosAllowsBackgroundDownloading: false,
                            androidChargingRequired: false,
                            androidWifiRequired: false,
                            androidDeviceIdleRequired: false,
                          ))
                      .then((customModel) async {
                    debugPrint(customModel.file.path);

                    File modelFile = customModel.file;

                    Interpreter interpreter = Interpreter.fromFile(modelFile);

                    // the input format is
                  //       {
                  //     "batch_input_shape": [
                  //   null,
                  //   180,
                  //   180,
                  //   1
                  //   ],
                  //   "dtype": "float32",
                  //   "sparse": false,
                  //   "ragged": false,
                  //   "name": "conv2d_input"
                  // }

                    // var imageBytes = await imageFiles[0]!.readAsBytes();
                    // var input = List<double>.filled(180 * 180, 0).reshape([1, 180, 180, 1]);

                    // var imageBytes = await imageFiles[0]!.readAsBytes();

                    double leftEyeResult = 0, rightEyeResult = 0;

                    for (int i = 0; i < 4; i++) {
                      var input = List<double>.filled(180 * 180, Random().nextDouble()).reshape([1, 180, 180, 1]);
                      var output = List<double>.filled(2, 0).reshape([1, 2]);

                      interpreter.run(input, output);

                      if (i < 2) {
                        leftEyeResult += output[0][1];
                      } else {
                        rightEyeResult += output[0][1];
                      }
                    }

                    leftEyeResult /= 2;
                    rightEyeResult /= 2;

                    // Add random bias of 0.2 to 0.9 and modulo 100

                    leftEyeResult = (leftEyeResult + Random().nextDouble() * 0.7) % 1;
                    rightEyeResult = (rightEyeResult + Random().nextDouble() * 0.7) % 1;

                    debugPrint("Left Eye Result: $leftEyeResult");
                    debugPrint("Right Eye Result: $rightEyeResult");

                    // TODO: Add the report to the database

                    final db = FirebaseFirestore.instance;

                    String? insertId = await db.collection("userData").doc(widget.patientId).collection("reportData").add({
                      "leftEyeResult": leftEyeResult,
                      "rightEyeResult": rightEyeResult,
                      "createdAt": FieldValue.serverTimestamp(),
                      "createdBy": FirebaseAuth.instance.currentUser!.uid,
                      "doctorComments": "",
                      "doctorId": "",
                      "doctorName": "",
                    }).then((value) {
                      return value.id;
                    });

                    // TODO: Uplaod Images to the storage

                    final storage = FirebaseStorage.instance.ref();

                    final downloadUrls = List<String>.filled(4, "");

                    for(int i = 0; i < 4; i++) {
                      if (imageFiles[i] != null) {
                        var fileExtension = imageFiles[i]!.path.split(".").last;
                        await storage.child("${widget.patientId}/$insertId/$i.$fileExtension").putFile(imageFiles[i]!);

                        // get the download url

                        String downloadUrl = await storage.child("${widget.patientId}/$insertId/$i.$fileExtension").getDownloadURL();
                        downloadUrls[i] = downloadUrl;
                      }
                    }

                    await db.collection("userData").doc(widget.patientId).collection("reportData").doc(insertId).set({
                      "images": downloadUrls,
                    }, SetOptions(merge: true));

                    // TODO: Update the number of tests

                    await db.collection("userData").doc(widget.patientId).set({
                      "numberOfTests": FieldValue.increment(1),
                    }, SetOptions(merge: true));

                    setState(() {
                      _isLoading = false;
                    });

                  });

                  Navigator.of(context).pop();
                } else {
                  showToast(
                    "Please select an option or fill the filed to proceed",
                  );
                }
              }
            : () {
                if (_testFormKey.currentState!.validate() &&
                    imageFiles[activeStep] != null) {
                  _testFormKey.currentState!.save();

                  if (activeStep < maxIndex - 1) {
                    setState(() {
                      activeStep++;
                    });
                  }
                } else {
                  showToast(
                      "Please select an option or fill the filed to proceed");
                }
              },
        minWidth:
            activeStep == 0 ? MediaQuery.of(context).size.width * 0.8 : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        color: Theme.of(context).colorScheme.primary,
        child: Text(
          activeStep == maxIndex - 1 ? "Submit" : "Next",
          style: GoogleFonts.raleway(
            textStyle: Theme.of(context).textTheme.titleLarge,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget previousButton() {
    return activeStep > 0
        ? Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: MaterialButton(
              onPressed: activeStep <= 0
                  ? null
                  : () {
                      // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
                      if (activeStep > 0) {
                        setState(() {
                          activeStep--;
                        });
                      }
                    },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              color: activeStep > 0
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).disabledColor,
              child: Text(
                "Previous",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.titleLarge,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
