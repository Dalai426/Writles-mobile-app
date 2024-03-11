import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/generalProvider.dart';

class tabwithtext extends StatefulWidget {
  const tabwithtext({super.key, required this.title});
  final String title;

  @override
  State<tabwithtext> createState() => _Tabwithtext();
}

class _Tabwithtext extends State<tabwithtext> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Гарчиг",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: context.read<GeneralProvider>().garchig,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintStyle: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.surface),
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
                    .copyWith(color: Theme.of(context).colorScheme.secondary)),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller:context.read<GeneralProvider>().eh,
              textAlign: TextAlign.justify,
              minLines: 9,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintStyle: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.surface),
                border: OutlineInputBorder(),
                hintText: 'Цээж бичгийн эхийг энд оруулна',
              ),
            ),
          ],
        ));
  }
}
