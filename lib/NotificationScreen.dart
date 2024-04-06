import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:writles/components/entity/UserNotidyScreen.dart';
import 'package:writles/utils/SecureStorage.dart';
import 'components/PointedLine.dart';

class NotificatierScreen extends StatefulWidget {
  const NotificatierScreen({super.key, this.garchig, this.eh});

  final String? garchig;
  final String? eh;

  @override
  State<NotificatierScreen> createState() => _NotificatierScreen();
}

class _NotificatierScreen extends State<NotificatierScreen>{



  TextEditingController comment=TextEditingController();
  final ScrollController _firstController = ScrollController();

  DateTime date=DateTime.now();
  List<UserNotify> userData = [];
  Map<String, bool> checkedValues = {};

  pickDateTime() async {
    DateTime? da = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              onBackground: Theme.of(context).colorScheme.secondary,
              primary: Theme.of(context).colorScheme.primary, // <-- SEE HERE
              onPrimary: Colors.white,  // <-- SEE HERE
              onSurface: Theme.of(context).colorScheme.primary, // <-- SEE HERE
            )
          ),
          child: child!,
        );
      },
    );

    if(da!=null){
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  tertiary: Theme.of(context).colorScheme.secondary,
                  onBackground: Theme.of(context).colorScheme.secondary,
                  primary: Theme.of(context).colorScheme.primary, // <-- SEE HERE
                  onPrimary: Colors.white,  // <-- SEE HERE
                  onSurface: Theme.of(context).colorScheme.primary, // <-- SEE HERE
                )
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        setState(() {
          date = DateTime(
            da.year,
            da.month,
            da.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
  notify() async {
    String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
    String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");
    final Map<String, String> header = {
      'Content-Type': 'application/json', "X-API-KEY": flaskapikey};

    var uri = Uri.http(apiflask, 'notification/notify');

    var jsonData = {
      'title':"Цээж бичиг бичих цаг боллоо !!!",
      'body': comment.value.text.isEmpty?"Цээж бичиг сануулсан байна":comment.value.text,
      'token':userData.map((e){
        if(checkedValues[e.name]==true){
          return e.token;
        }}).toList(),
      'obj':{
        "title":widget.garchig,
        "body":widget.eh
      },
      "date": date.toString().split(".")[0]
    };
    var body = json.encode(jsonData);

    var response =  http.post(uri,
        headers: header,
        body: body
    );
      CherryToast.success(
        title: Text(
          "Амжилттай илгээгдлээ",
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ).show(context);

  }




  bool isAll=true;


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
    var uri = Uri.http(apiflask, 'user/getusers');

    String jwt=await SecureStorage().readSecureData("token");

    http.Response response = await http.get(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${jwt}'

        }
    );
    if (response.statusCode == 200) {
      List <dynamic> responseBodyJson = json.decode(response.body);
      print(responseBodyJson);
      final fetchedData=responseBodyJson.map((e){
        final user=UserNotify(e["name"],e["gmail"],e["device_token"]);
        return user;
      }).toList();
      setState(() {
        userData = fetchedData;
        for (var user in userData) {
          checkedValues[user.name] = true;
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("   Мэдэгдэх хэрэглэгчид",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary)),
                    SizedBox(height: 5),
                    PointedLine(),
                    Wrap(
                      crossAxisAlignment:WrapCrossAlignment.center,
                      children: [
                      Checkbox(value: isAll, onChanged: (bool? value){
                        setState(() {
                          isAll=value!;
                          checkedValues.forEach((key, val){
                            setState(() {
                              checkedValues[key]=value;
                            });
                          });
                        });
                      }),
                      Text(
                        "Бүгдийг сонгох",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Theme.of(context).colorScheme.primary),
                      )
                    ]),
                    Container(
                      height: MediaQuery.of(context).size.height/4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                      child: Scrollbar(
                          controller: _firstController,
                          thumbVisibility: true,
                          child: ListView(
                            padding: EdgeInsets.only(top: 10),
                            controller: _firstController,
                            children: userData.map((item) {
                              return Container(
                                  margin: EdgeInsets.only(bottom: 10,left:10, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:Row(
                                    children: [
                                    Checkbox(value: checkedValues[item.name],
                                      onChanged:(bool? val){
                                      setState(() {
                                      checkedValues[item.name]=val!;
                                    });
                                  }),
                                  Text(
                                    item.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: Theme.of(context).colorScheme.primary),
                                  )
                                ],
                              ));
                            }).toList(),))
                    ),
                    SizedBox(height: 10,),
                    Text("   Хэзээ сануулах",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary)),
                    SizedBox(height: 5),
                    PointedLine(),
                    SizedBox(height: 10),
                    InkWell(onTap:pickDateTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20,
                          children: [
                            Icon(Icons.calendar_month,color: Theme.of(context).colorScheme.primary),
                            Text("${date.year}/${date.month}/${date.day}",
                                style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Theme.of(context).colorScheme.primary)),
                            Text("${date.hour}:${date.minute}:00",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      minLines: 8,
                      maxLines: null,
                      controller: comment,
                      autofocus: false,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme
                          .of(context)
                          .colorScheme
                          .primary),
                      decoration: InputDecoration(
                        labelText: 'Сануулах коммент оруулаарай',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        labelStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme
                            .of(context)
                            .colorScheme
                            .surface),
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                        onTap:notify,
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding:
                            const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                color:
                                Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Сануулах",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.white),
                            ))),

                  ],
                ),
              )),
    );
  }


}
