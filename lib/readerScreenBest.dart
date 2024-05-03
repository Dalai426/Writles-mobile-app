import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_border/progress_border.dart';
import 'components/entity/ScreenArguments.dart';
import 'package:http/http.dart' as http;

class ReaderPageBest extends StatefulWidget {
  const ReaderPageBest({super.key, this.argument});

  final ScreenArguments? argument;

  @override
  State<ReaderPageBest> createState() => _ReaderPageBest();
}

class _ReaderPageBest extends State<ReaderPageBest> with SingleTickerProviderStateMixin {
  var texts = <String>{};
  late int count_text;
  String? title;
  int level = 1;
  dynamic tts;
  StreamSubscription? player_info;
  double progress = 0.0;
  bool fetching = true;
  bool started=false;
  Logger logger =  Logger();
  AudioPlayer player=AudioPlayer();
  StreamSubscription? introsub;
  Timer? pretimer;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {

    String dir = "${(await getApplicationDocumentsDirectory()).path}/wavs";

    if (!Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }

    String apiflask = dotenv.get("API_FLASK", fallback: "");
    String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");
    final Map<String, String> queryParams = {
      'level': '1',
      'text': 'Нэг хоёр гурвын ба ба б',
      'voice': 'female1',
      "title":"гарчиг"
    };

    var uri = Uri.http(apiflask, 'tts/extract-full', queryParams);
    final client = http.Client();

    try {
      var request = await http.Request('GET', uri);
      final response = await client.send(request);
      int i=1;
      await for (var chunk in response.stream) {
        print(chunk.length);
        if(chunk.length==1){

        }else{

        }
        // for(var audio in chunk){
        //   File file = File('$dir/3_${i}_wav.wav');
        //   file.writeAsBytes(audio);
        //   i++;
        //   print(file.path);
        // }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      client.close();
    }
  }





  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );



  void _onPlayPre() async {
    if (player.state == PlayerState.playing || pretimer!=null) {
      return;
    }
    await introsub?.cancel();

    player.stop();

    introsub=player.onPlayerComplete.listen((event) {
      player.stop();
      pretimer=Timer(const Duration(milliseconds: 2000), (){
        setState(() {
          started=true;
        });
      });
    });

    player.play(AssetSource("audios/intro.wav"));

  }

  void _onPlay() async {
    await tts.cancelDelay();
    await tts.p1.stop();
    if(tts.reading_wav_index<tts.count_text){
      if(player_info!=null){
        await player_info?.cancel();
      }
      player_info = await tts.nextWav(context, _onPlay);
      progress = tts.reading_wav_index.toDouble() / count_text.toDouble();
      setState(() {});
    }
  }

  void _prev() async {
    if(player_info!=null){
      await player_info?.cancel();
    }
    tts.prevWav();
    progress = tts.reading_wav_index.toDouble() / count_text.toDouble();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    pretimer?.cancel();
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
                      started==false?"ЭХЛЭХ":"ДАРААГИЙН ҮГ",
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
                          onTap:  started==false?_onPlayPre:_onPlay,
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: started==false?Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.primary,
                                  border: ProgressBorder.all(
                                      color: const Color(0XFFFFFFFF).withOpacity(0.4),
                                      width: 10,
                                      progress: progress)),
                              child: started==false?const Icon(Icons.play_circle_filled_outlined, color: Colors.white, size: 80):const Image(image: AssetImage("img/forward.png"))),
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



