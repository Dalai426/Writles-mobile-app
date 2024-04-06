import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:writles/components/OtpDialog.dart';
import 'components/PointedLine.dart';

class ForgottenPass extends StatefulWidget {
  const ForgottenPass({super.key});
  @override
  State<ForgottenPass> createState() => _ForgottenPass();
}

class _ForgottenPass extends State<ForgottenPass>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                TextField(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                      color:
                      Theme.of(context).colorScheme.primary),
                  decoration: InputDecoration(
                    labelText: 'Ангийн аль нэг хэрэглэгчийн email',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 15),
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .surface),
                  ),
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
                    child: Text("Хайх", style: TextStyle(fontSize: 15),),
                    onPressed: (){},
                  )
                ),
                SizedBox(height: 10),
                Text("Нууц үг сэргээх анги сонгох",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary)),
                PointedLine(),
                SizedBox(
                  height: 20,
                ),
                drawBlock("Г.Далайжамц", "gadalai426@gmail.com")
              ],
            ),
          ),
        ));
  }

  Widget drawBlock(String name, String gmail) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 30,
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
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    gmail,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ],
              )),
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                )
            ),
            child: Text("Сонгох", style: TextStyle(fontSize: 12),),
            onPressed: (){
              onPressedOtp(context);
            },
          )
        ],
      ),);
  }

  onPressedOtp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OtpDialog();
      },
    );
  }

}
