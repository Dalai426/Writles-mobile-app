import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:writless/providers/generalProvider.dart';
import 'package:writless/utils/image_helper.dart';
import 'package:writless/utils/ocr.dart';

final imageHelper = ImageHelper();

class FromPhotoPage extends StatefulWidget {
  const FromPhotoPage({super.key, required this.title});

  final String title;

  @override
  State<FromPhotoPage> createState() => _FromPhotoPage();
}

class _FromPhotoPage extends State<FromPhotoPage> {

  File? _image;
  int ontext=1;
  bool convert=false;


  void _pickImage()async{
    var file = await imageHelper.pickImage(imageQuality: 100);

    if (file != null) {
      String imagePathLowerCase =await file.path.toLowerCase();

      if (imagePathLowerCase.contains('heic')) {
        String? pngPath = await HeifConverter.convert(file.path, format: 'png');
        file=XFile(pngPath!);
      }

      final cropped = await imageHelper.crop(
          file: file,
          context: context,
          cropStyle: CropStyle.rectangle);
      if (cropped != null) {
        context.read<GeneralProvider>().emptyControllers();
        setState(() {
          ontext=1;
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
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 1,),
                Text(
                  "Хэрэглэгчийн цээж бичгийн түвшин :",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.surface),
                ),
                Text(
                  "Түвшин ${context.read<GeneralProvider>().userLevel.toInt()}",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(width: 1,),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Slider(
              inactiveColor: Theme.of(context).colorScheme.surface,
              min: 1,
              value: context.watch<GeneralProvider>().userLevel,
              max: 5,
              divisions: 4,
              label: context.read<GeneralProvider>().userLevel.round().toString(),
              onChanged: (double value) {
                setState(() {
                  context.read<GeneralProvider>().changeLevel(value);
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: _pickImage,
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2)),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "1",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.secondary),
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 25,
                        width: 3,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Зураг оруулах",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.surface),
                      ),
                    ],
                  ),
                  Image(
                    image: AssetImage("img/ig.png"),
                    width: 30,
                  )
                ],
              ),
            )),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height/2.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ontext==1?SingleChildScrollView(
                child:convert==false?
                _image == null ? Image.asset(
                  "img/camera.png",
                  width: 150,
                ):
                Image.file(_image!, fit: BoxFit.cover,)
                    :
                LoadingAnimationWidget.inkDrop(
                  size: 100, color: Theme.of(context).colorScheme.secondary,
                ),
              ):Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 4,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Гарчиг",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: context.read<GeneralProvider>().garchig,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                            color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                              color:
                              Theme.of(context).colorScheme.surface),
                          border: OutlineInputBorder(),
                          hintText: 'Цээж бичгийн гарчгийг оруулна',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 4,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Эх",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary))
                        ],
                      ),
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
                            color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                              color:
                              Theme.of(context).colorScheme.surface),
                          border: OutlineInputBorder(),
                          hintText: 'Цээж бичгийн эхийг энд оруулна',
                        ),
                      ),
                    ],
                  )))
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: _image == null ? Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.primary,
                          width: 2)),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "2",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.primary),
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 25,
                        width: 3,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Хөрвүүлэх",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: _image==null?Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.document_scanner_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
            )),
            SizedBox(
              height: 15,
            ),
            InkWell(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notfication ашиглан дараа тоглуулах",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  Icon(
                    Icons.notifications_active,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
            )),
          ],
        ));
  }
}
