// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double progress = 0;

  late InAppWebViewController controler;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: Stack(children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse("https://www.youtube.com/"),
          ),
          onWebViewCreated: (InAppWebViewController _controller) {
            controler = _controller;
          },
          onProgressChanged:
              (InAppWebViewController _controller, int _progress) {
            setState(() {
              progress = _progress / 100;
            });
          },
        ),
        progress < 1
            ? SizedBox(
                child: LinearProgressIndicator(
                  value: progress,
                ),
              )
            : SizedBox()
      ]),
    );
  }
}
