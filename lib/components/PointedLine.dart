import 'package:flutter/material.dart';

class PointedLine extends StatefulWidget {
  const PointedLine({super.key});

  @override
  State<PointedLine> createState() => _PointedLine();
}

class _PointedLine extends State<PointedLine> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary
            ),
          ),
          Expanded(child:Divider(
            color: Theme.of(context).colorScheme.primary,
          )),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary
            ),
          ),
        ]
    );
  }
}
