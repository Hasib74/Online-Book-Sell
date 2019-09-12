import 'dart:async';

import 'package:flutter/material.dart';

import 'Home.dart';
import 'package:video_player/video_player.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  startTime() async {
    //var _duration = new Duration(seconds: 2);
    return new Timer(Duration(microseconds: 500), navigationPage);
  }

  void navigationPage() {
    // Navigator.of(context).pushReplacementNamed('/Home');

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("Video/dreamstime_144912242.mp4")
      ..initialize().then((_) {
        setState(() {});
      });

    //startTime();

    _controller.play();

    _controller.addListener(checkVideo);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.position == _controller.value.duration) {
      print('video Ended');
    }

    return SafeArea(
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        try {
                          Navigator.pop(context, true);

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        } catch (e) {}
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )),
              SizedBox(
                height: 50,
              ),


              Stack(

                children: <Widget>[



                  Center(
                      child: Container(
                          width: 150,
                          height: 150,
                          child: Image.asset("img/logo.jpg"))),


                  Positioned(
                    bottom: 0.0,
                    left: 50,
                    right: 50,
                    child: Center(
                      child: Text("BOOKS",style: TextStyle(fontSize: 20),),

                    ),
                  ),




                ],

              ),








              SizedBox(
                height: 50,
              ),
              _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new VideoPlayer(_controller),
                      ),
                    )
                  : CircularProgressIndicator(),



              SizedBox(height: 25,),


              Text(" Welcome to In My House App! Get ready to experience amazing stories that moves the soul!",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 18),),
            ],
          ),
        ),
      ),
    );
  }

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (_controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if (_controller.value.position == _controller.value.duration) {
      print('video Ended');

      // Navigator.push(context, route)

      try {
        Navigator.pop(context, true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } catch (e) {}
    }
  }
}
