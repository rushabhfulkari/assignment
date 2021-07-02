import 'dart:convert';

import 'package:assignment/constants/colors.dart';
import 'package:assignment/constants/strings.dart';
import 'package:assignment/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  var data = [];
  late double scrollBarPosition = 0;
  late String headertitle;
  late String headerurl;
  late bool fetched = false;
  final PageController _pageController = PageController();
  int page = 0;

  getData() async {
    var response = await http.get(
      Uri.parse('$url'),
    );
    setState(() {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      headertitle = jsonData["data"]["title"].toString();
      headerurl = jsonData["data"]["coverUrl"].toString();
      jsonData["data"]["components"].forEach((element) {
        Map<dynamic, dynamic> map = {
          "type": element["type"],
          "url": element["url"],
          "title": element["title"],
          "desc": element["desc"],
        };
        data.add(map);
        fetched = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: c8,
        body: fetched
            ? Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    pageSnapping: false,
                    allowImplicitScrolling: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    onPageChanged: (value) {
                      setState(() {
                        page = value;
                      });
                    },
                    children: <Widget>[
                      GestureDetector(
                          onVerticalDragStart: (DragStartDetails dudetails) {
                            double positionUpdate = (dudetails.localPosition.dy)
                                .abs()
                                .floorToDouble();

                            _pageController.animateTo(
                                (dudetails.localPosition.dy),
                                duration: Duration(milliseconds: 800),
                                curve: Curves.ease);
                            if (positionUpdate < 100) {
                              setState(() {
                                scrollBarPosition = positionUpdate;
                              });
                            } else {
                              setState(() {
                                scrollBarPosition = 100;
                              });
                            }
                          },
                          onVerticalDragUpdate: (DragUpdateDetails dudetails) {
                            _pageController.animateTo(
                                -(dudetails.delta.dy * 10),
                                duration: Duration(milliseconds: 800),
                                curve: Curves.ease);
                          },
                          child: header(size, headerurl, headertitle)),
                      list(size, data),
                    ],
                  ),
                  page == 0
                      ? Positioned(
                          right: 10,
                          top: 60,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: c6.withOpacity(0.5),
                                ),
                                height: 130,
                                width: 5,
                              ),
                              Positioned(
                                top: scrollBarPosition,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: c6.withOpacity(0.8),
                                  ),
                                  height: 30,
                                  width: 5,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                ],
              )
            : progressIndicator(size),
      ),
    );
  }
}
