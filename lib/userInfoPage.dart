import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:writles/providers/generalProvider.dart';
import 'package:writles/utils/SecureStorage.dart';
import 'package:writles/utils/checkInternet.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key, required this.title});

  final String title;

  @override
  State<UserInfoPage> createState() => _UserInfoPage();
}

class _UserInfoPage extends State<UserInfoPage> {

  _update() async {
    if(! await connectiveCheck(context)){
      return;
    }
    if (context.read<GeneralProvider>().userId == null) {
      return;
    }
    String jwt = await SecureStorage().readSecureData("token");
    String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
    var uri = Uri.http(apiflask, 'user/update');

    var jsonData ={
      "id": context.read<GeneralProvider>().userId,
      "name": context.read<GeneralProvider>().username.value.text,
      "gmail": context.read<GeneralProvider>().useremail.value.text
    };
    var body = json.encode(jsonData);
    http.Response response = await http.post(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${jwt}'
    }, body: body);

    Map<String, dynamic> responseBodyJson = json.decode(response.body);

    if (response.statusCode == 200) {
      String access_token = responseBodyJson["accesstoken"];
      SecureStorage().writeSecureData("token", access_token);
      CherryToast.success(
        title: Text(
          "Амжилттай !!!",
          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ).show(context);
    } else {
      CherryToast.error(
        title: Text(
          responseBodyJson["detail"],
          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ).show(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height-56,
      child: Stack(
        children: [
          Positioned(
            bottom: 200,
            right: 0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 200,
                      spreadRadius: 200,
                      color: Color(0xFFFFDBC5).withOpacity(0.3))
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child:Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 4,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Нэр",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                            controller: context.watch<GeneralProvider>().username,
                        keyboardType: TextInputType.name,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.surface),
                          hintText: 'Нэр',
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 4,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("И-мэйл",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                              color:
                              Theme.of(context).colorScheme.primary)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                            controller: context.watch<GeneralProvider>().useremail,
                            keyboardType: TextInputType.name,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                color: Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                      Theme.of(context).colorScheme.secondary),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                      Theme.of(context).colorScheme.secondary),
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                  color: Theme.of(context).colorScheme.surface),
                              hintText: 'И-мэйл',
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            )
                        ),
                        child: Text("Шинэчлэх", style: TextStyle(fontSize: 15),),
                        onPressed:_update,
                      )
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 4,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Хэрэглэгчийн түвшин",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                              color:
                              Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10),
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2)),
                    ),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: "Энэхүү түвшин нь хэрэглэгчийн Монгол хэл сурлцсан жил болно. Хэрвээ ЕБС сурагч бол одоо суралцаж байгаа анги нь түвшнийг илэрхийлнэ.",
                          style:Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Theme.of(context).colorScheme.surface),
                        children: <TextSpan>[
                          TextSpan(text: ' Жишээ нь нэг дүгээр анги бол 1 түвшин болно.', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                        ],
                      )

                    )
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height/1.1,
                      child: Row(
                    children: [
                      RotatedBox(
                          quarterTurns: -1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Slider(
                              inactiveColor:
                                  Theme.of(context).colorScheme.surface,
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
                          )),
                      Expanded(
                          child: Column(children: [
                        getBlocks(5, "Түвшин 5",
                            "Нэг дүгээр ангийн хүүхдэд зориулсан үелж унших түвшин"),
                        const SizedBox(
                          height: 10,
                        ),
                        getBlocks(4, "Түвшин 4",
                            "Нэг дүгээр ангийн хүүхдэд зориулсан үелж унших түвшин"),
                        const SizedBox(
                          height: 10,
                        ),
                        getBlocks(3, "Түвшин 3",
                            "Нэг дүгээр ангийн хүүхдэд зориулсан үелж унших түвшин"),
                        const SizedBox(
                          height: 10,
                        ),
                        getBlocks(2, "Түвшин 2",
                            "Нэг дүгээр ангийн хүүхдэд зориулсан үелж унших түвшин"),
                        const SizedBox(
                          height: 10,
                        ),
                        getBlocks(1, "Түвшин 1",
                            "Нэг дүгээр ангийн хүүхдэд зориулсан үелж унших түвшин"),
                      ])),
                    ],
                  )
                  ),
                  const SizedBox(height: 30,)
                ],
              )))
        ],
      ),
    );
  }

  Widget getBlocks(int no, String lab, String info) {
    return Expanded(
        child: Row(children: [
      AnimatedContainer(
        width: (context.read<GeneralProvider>().userLevel.toInt()) == no ? 15 : 0,
        duration: const Duration(seconds: 0),
      ),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lab,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  info,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Theme.of(context).colorScheme.surface),
                ),
              ],
            ))
          ],
        ),
      )),
      AnimatedContainer(
        width: (context.read<GeneralProvider>().userLevel.toInt()) == no ? 0 : 15,
        duration: const Duration(seconds: 0),
      ),
    ]));
  }
}
