import 'package:assignment/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget progressIndicator(Size size) {
  return Container(
    height: size.height - 50,
    width: size.width,
    child: Center(
        child: CircularProgressIndicator(
      color: c1,
    )),
  );
}

Widget header(Size size, headerurl, headertitle) {
  return Stack(
    children: [
      Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: c4,
                blurRadius: 40.0,
              ),
            ],
          ),
          child: ClipRRect(
              child: Image.network(
            "$headerurl",
            fit: BoxFit.cover,
          ))),
      Positioned(
        bottom: 50,
        left: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "$headertitle",
                      style: TextStyle(
                          fontFamily: 'Neue', fontSize: 20, color: c6)),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget list(Size size, data) {
  return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (data[index]["type"] == "image") {
          return Container(
              width: size.width,
              decoration: BoxDecoration(),
              child: ClipRRect(child: Image.network("${data[index]["url"]}")));
        } else if (data[index]["type"] == "text") {
          return Container(
            width: size.width,
            color: c1,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "${data[index]["title"]}\n\n",
                          style: TextStyle(
                              fontFamily: 'Neue',
                              fontSize: 14,
                              color: c6.withOpacity(0.7))),
                      TextSpan(
                          text: "${data[index]["desc"]}",
                          style: TextStyle(
                              fontFamily: 'Neue', fontSize: 16, color: c6)),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      });
}
