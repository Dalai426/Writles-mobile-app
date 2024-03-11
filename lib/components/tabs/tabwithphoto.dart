import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:writless/utils/image_helper.dart';

import '../../providers/generalProvider.dart';
import '../../utils/ocr.dart';

final imageHelper = ImageHelper();

class tabwithphoto extends StatefulWidget {
  const tabwithphoto({super.key, required this.title});
  final String title;

  @override
  State<tabwithphoto> createState() => _Tabwithphoto();
}

class _Tabwithphoto extends State<tabwithphoto> {
  File? _image;
  int ontext = 1;
  bool convert = false;

  void _handleTap() async {
    var file = await imageHelper.pickImage(imageQuality: 100);

    if (file != null) {
      String imagePathLowerCase = await file.path.toLowerCase();

      if (imagePathLowerCase.contains('heic')) {
        String? pngPath = await HeifConverter.convert(file.path, format: 'png');
        file = XFile(pngPath!);
      }

      final cropped = await imageHelper.crop(
          file: file, context: context, cropStyle: CropStyle.rectangle);
      if (cropped != null) {
        context.read<GeneralProvider>().emptyControllers();
        setState(() {
          ontext = 1;
          print(cropped.path);
          _image = File(cropped.path);
        });
      } else {
        imageCache.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return convert == false
        ? SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: _handleTap,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: Colors.white, width: 2)),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 7),
                              child: Text(
                                "Зураг оруулах",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ))),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () async {
                              if(_image!=null){
                                setState(() {
                                  convert=true;
                                });
                                String? str=await ocrText(_image!, context);
                                if(str!=null){
                                  context.read<GeneralProvider>().eh.text=str;
                                }
                                print("ho");
                                setState(() {
                                  ontext=2;
                                  _image=null;
                                  convert=false;
                                });
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: Colors.white, width: 2)),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 7),
                                child: Text(
                                  "Хөрвүүлэх",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.white),
                                )))),
                  ],
                ),
                ontext == 1
                    ? _image == null
                        ? InkWell(
                            onTap: _handleTap,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                ),
                                Text(
                                  "Энд дараад зургаа оруулаарай",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image(
                                    image: AssetImage("img/camera.png"),
                                    width: 150)
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                            ],
                          )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: 15, bottom: 10, left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Гарчиг",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller:
                                  context.read<GeneralProvider>().garchig,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                border: OutlineInputBorder(),
                                hintText: 'Цээж бичгийн гарчгийг оруулна',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Эх",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: context.read<GeneralProvider>().eh,
                              textAlign: TextAlign.justify,
                              minLines: 9,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                                border: OutlineInputBorder(),
                                hintText: 'Цээж бичгийн эхийг энд оруулна',
                              ),
                            ),
                          ],
                        ))
              ],
            ),
          )
        : Container(
            child: LoadingAnimationWidget.inkDrop(
            size: 70,
            color: Theme.of(context).colorScheme.secondary,
          ));
  }
}
