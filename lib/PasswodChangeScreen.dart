import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});
  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreen();
}

class _PasswordChangeScreen extends State<PasswordChangeScreen>{

    bool passwordVisible = false;





    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                        color:
                        Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off, color: Theme.of(context).colorScheme.surface,),
                        onPressed: () {
                          setState(
                                () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      labelText: 'Нууц үг',
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
                    obscureText: !passwordVisible,
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                        color:
                        Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off, color: Theme.of(context).colorScheme.surface,),
                        onPressed: () {
                          setState(
                                () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      labelText: 'Нууц үг давтах',
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
                    obscureText: !passwordVisible,
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                      onTap: () async {

                      },
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
                            "Солих",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.white),
                          ))),

                ],
              ),
            ),
          ));
  }
}
