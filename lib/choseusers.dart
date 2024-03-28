import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/PointedLine.dart';

class ChooseUsers extends StatefulWidget {
  const ChooseUsers({super.key, this.users});

  final List? users;

  @override
  State<ChooseUsers> createState() => _ChooseUsers();
}

class _ChooseUsers extends State<ChooseUsers>{

  List? users;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users=widget.users;
    print(users);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Text("Өөрийн мэдээллийг сонгоно уу",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.primary)),
            SizedBox(height: 10),
            PointedLine(),
            SizedBox(
              height: 20,
            ),
            ...users!.map((e) => drawBlock(e["name"],e["gmail"]),)
            ,
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary, width: 1),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Таны мэдээлэл байхгүй бол энэ дарна уу !!",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.surface),
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.add_circle_rounded,
                      color: Theme.of(context).colorScheme.surface)
                ],
              ),
            )
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
          ))
        ],
      ),
    );
  }
}
