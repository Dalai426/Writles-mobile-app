import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:progress_border/progress_border.dart';
import 'components/entity/ScreenArguments.dart';
import 'levels/Level_four.dart';
import 'levels/Level_three.dart';
import 'levels/Level_two.dart';
import 'levels/level_one.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, this.argument});

  final ScreenArguments? argument;

  @override
  State<ReaderPage> createState() => _ReaderPage();
}

class _ReaderPage extends State<ReaderPage>
    with SingleTickerProviderStateMixin {
  var texts = <String>{};
  late int count_text;
  String? title;
  int level = 1;
  dynamic tts;
  StreamSubscription? player_info;
  double progress = 0.0;
  bool fetching = true;

  Logger logger =  Logger();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    level = widget.argument!.level.toInt();
    if(level==1){
      tts = LevelOne();
    }else if(level==2){
      tts=LevelTwo();
    }else if(level==3){
      tts=LevelThree();
    }else{
      tts=LevelFour();
    };
    String replacedText = widget.argument!.title.replaceAll(RegExp(r'\s+'), '');
    if (replacedText.isNotEmpty) {
      title = widget.argument!.title;
      await tts.init(widget.argument!.text, level, title: title);
    } else {
      await tts.init(widget.argument!.text, level);
    }
    count_text = tts.count_text;

    setState(() {
      fetching = false;
    });
  }

  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );



  void _onPlay() async {
    await tts.cancelDelay();
    await tts.p1.stop();
    if(tts.reading_wav_index<tts.count_text){
      if(player_info!=null){
        await player_info!.cancel();
      }
      player_info = await tts.nextWav(context, _onPlay);
      progress = tts.reading_wav_index.toDouble() / count_text.toDouble();
      setState(() {});
    }
  }

  void _prev() async {
    if(player_info!=null){
      player_info!.cancel();
    }
    tts.prevWav();
    progress = tts.reading_wav_index.toDouble() / count_text.toDouble();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    try{
      tts.dispose();
    }catch(err){
      logger.t('end yumuu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fetching
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
            ))
          : SingleChildScrollView(
              child: Center(
                  child: Container(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Түвшин ${level}",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      PopupMenuButton(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.0))),
                          icon: Icon(
                            Icons.format_list_bulleted_outlined,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          itemBuilder: (context) {
                            return <PopupMenuEntry<int>>[
                              PopupMenuItem(
                                child: const ListTile(
                                  leading: Icon(Icons.read_more),
                                  title: Text("Эхийг унших"),
                                ),
                                onTap: () async {
                                  await _displayBottomSheet(context);
                                },
                              )
                            ];
                          })
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, '/finish');
                      },
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1)),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "ДУУСГАХ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    size: 40,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )
                                ],
                              ),
                            ],
                          ))),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _prev,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1)),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RotatedBox(
                                      quarterTurns: -2,
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        size: 40,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "ӨМНӨХ ҮГ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  )
                                ],
                              )
                            ],
                          ))),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "ДАРААГИЙН ҮГ",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            color: Theme.of(context).colorScheme.secondary,
                            thickness: 2,
                          )),
                          Container(
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  AspectRatio(
                      aspectRatio: 4 / 3,
                      child: GestureDetector(
                        onTap: _onPlay,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                                border: ProgressBorder.all(
                                    color: const Color(0XFFFFFFFF).withOpacity(0.4),
                                    width: 10,
                                    progress: progress)),
                            child: const Image(image: AssetImage("img/forward.png"))),
                      ))
                ],
              ),
            ))),
    );
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: ListView(
                  controller: scrollController,
                  children: [
                    if (title != null)
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 3,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Гарчиг  :  ",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          Text(
                            "${title}",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        child: Text(
                      widget.argument!.text,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.justify,
                    ))
                  ],
                ),
              );
            }));
  }
}
