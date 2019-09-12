import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Database/FirebaseDatabaseHelper.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:connectivity/connectivity.dart';

import 'package:square_in_app_payments/google_pay_constants.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

//import 'package:square_in_app_payments/models.g.dart';
import 'package:http/http.dart' as http;

import 'Favourite.dart';
import 'Home.dart';
import 'Model/Customer.dart';
import 'Model/UserCommentsAndRating.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class Description extends StatefulWidget {
  final image;
  final title;
  final index;
  final price;

  final form;

  Description({this.image, this.title, this.index, this.price, this.form});

  bool isClicked = false;

  var current_state = 0;

  int _progress_bar_status = 0;

  FirebaseUser _current_user;

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description>
    with SingleTickerProviderStateMixin {
  List _discription_list = [
    "A Night with a Hookah is a delicious romantic comedy about a man’s first experience with a hookah. He desires to try her but loses his confidence once he gets a closer look at her attributes. Will he find the courage to explore her charms or will he change his mind when she offers herself to him?",
    "This guide was inspired by basic wrestling techniques as the children's play tool and support to their mother’s challenge with depression.",
    "A loving, devoted housewife and mother of two, struggles with the thoughts of losing her marriage. She searches for a solution by following the advice of a beautiful yet strange patient, she shared a hospital room with after falling ill from Cushing’s Syndrome.  Her decision takes a drastic turn of events, when she decides to consume Diablo, a synthetic drug to lose weight to lure her husband back into her arms. What can we expect to be her outcome?",
    "John Campbell is getting his first home won by a supportive housing lottery, but his journey to this moment has been arduous and havenless. Growing up in the Bronx at the height of the AIDS epidemic, his family is touched by this tragedy. After the death of his stepfather and a traumatic episode with his mother, John is committed to a mental institution for schizophrenia, but eventually he escapes. He then spends much of his life homeless in the Bowery and continues to experience further misfortune and repercussions. John narrates his own story of getting back on his feet after a lifetime of trials and adversity.The end of this book has an incredible Action Plan to help build self-confidence and discover your purpose, using John’s story as inspiration.",
    "A dramatic portrayal of the misunderstood lives of those residing in supportive housing. Fast-paced and exciting, this fictional narrative follows a housing facility with a wide range of colorful and memorable characters, who define life on their terms.The tough yet compassionate Mrs. Spears watches over both staff and tenants to promote a unified community. Her charges include an incompetent receptionist struggling to fit in, a transgender tenant that clashes with closed-minded neighbors, a callous social worker, intoxicated antagonist and more. With no shortage of shocking experiences and secrets, each moment emphasizes both the struggles and the inspirations of living and working in supportive housing. Through elicit affairs, tragedies, crimes, and even joyful moments, Mrs. Spears attempts to remain strong, to cultivate an atmosphere of respect, and to remind her staff to treat each tenant with dignity.",
    "A self-told narrative about a teenage girl who believes she is better than any other person her age. What happens to her after she ingests synthetic marijuana is enough to change her mind about her image or is it? ",
    "A daring and fearless Bobby, better known on the street as Bullet, abducts Dora, an old friend, who is studying to be a pharmacist at the prestigious Columbia University.  A frightened yet skilled, Dora prepares the stolen formula for AK47, a drug that is believed to be non-existent to drug enforcement agencies but dangerously addictive to users. This shocking and culturally moving story takes place on East 125th street, Harlem New York City in 2015.  Will Dora’s boyfriend, Chris and her uncle, who is a police officer find her in time, or will she meet her fate at the hands of Bullet? ",
    "I See the Supernatural is one man’s account of what happens if he has good or evil in tensions before he ingests spice. Does his accounts of engagement show us spirits are really working through us and with us. Or does it serve as proof that synthetic compounds are working at its capacity as a mind-altering drug. Judge for yourself!"
  ];

  List image_list = [
    'img/a_night_with_a_hookh.jpg',
    'img/helping.png',
    'img/delayed_reality.jpg',
    'img/past_action_plan.jpg',
    'img/i874.jpg',
    'img/image_by_gr_davies.jpg',
    'img/in_the_vally.jpg',
    'img/i_see_the.png',
  ];

  List pdf_name = [
    'a_night_with_a_Hookah',
    'helping_mommy_defeat_depression',
    'delayed_reality',
    'treading_on_the_past ',
    '1874',
    'image',
    'in_the_valley_of_spice',
    'i_see_the_supernatural',
  ];

//  List

  List pdf_download_url = [
    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/a_night_with.pdf?alt=media&token=fb585e34-aefd-4c8a-98a2-1d4189fc730f",
    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/helping_mommy_defeat_depression.pdf?alt=media&token=952b942b-4b2e-45f1-9738-f0d83c185525",
    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/delayed_reality.pdf?alt=media&token=e1fea4b2-1e04-4f3d-9440-84b560106d04",
    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/treading_on_the_Past.pdf?alt=media&token=3024ef5f-4592-4c50-ab13-716043a79d6f",
    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/1874.pdf?alt=media&token=41ed3370-301b-4f66-b4ba-5760f2e30344",
    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/image.pdf?alt=media&token=99a95e7f-b366-432c-adeb-ac859fdd5c0b",
    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/in_the_valley_of_spice.pdf?alt=media&token=3c9d8dc5-5ace-4d40-95ea-21f57a9d6130",
    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/i_see_the_supernatural.pdf?alt=media&token=44e08e47-6a43-4efa-97e3-b5056cadf736",


    "https://firebasestorage.googleapis.com/v0/b/in-my-hose.appspot.com/o/treading_on_the_past%20.pdf?alt=media&token=d6a1b59d-0c68-484a-a92d-7dc9536ac79b"



  ];

  AnimationController _controller;
  PageController _page_controller;
  Animation<double> _image_animation;
  Animation<double> _bottom_animation;

  var subscription;

  double collapsing_height_factor = 0.4;
  double expendated_height_factor = 1;

  int _count = 0;

  bool isAnimation_complete = false;

  double screen_height = 0;

  int is_fav = 0;

  bool isBuyed = false;
  bool isGoogIn = false;
  bool isInternetIsAvilable = false;

  var progress_update;

  String _download_status = '';

  String check_is_he_rate_befour;

  TextEditingController _write_comments_controller;

  List<UserCommentsAndRating> userCommentsAndRatingList = new List();

  List page_view_image = [
    "img/theading_on_the_past.png",
    "img/past_action_plan.jpg",

  ];

  //ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_page_controller = PageController(initialPage: 1, viewportFraction: 0.8);

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      //  print("Connection Status has Changed");
    });

    FirebaseAuth.instance.currentUser().then((v) {
      if (v != null) {
        firebaseDatabaseHelper
            .buyed_books(widget.index.toString())
            .then((value) {
          if (value.value != null) {
            //  print(" true  ");
            /*setState(() {*/

            setState(() {
              isBuyed = true;
            });

            /*  });*/
          } else {
            //print(" false  ");
            setState(() {
              isBuyed = false;
            });
          }
        });
      }
    });

    FirebaseAuth.instance.currentUser().then((v) {
      if (v != null) {
        firebaseDatabaseHelper
            .check_is_posted_comments_and_rating(widget.index.toString())
            .then((v) {
          if (v != null) {
            check_is_he_rate_befour = v;
          } else {
            check_is_he_rate_befour = "not";
          }

          //  print("Haave ore not ${v}");

          print(check_is_he_rate_befour);
        });
      }
    });

    firebaseDatabaseHelper
        .read_all_comments_and_ratting(widget.index.toString())
        .then((v) {
      userCommentsAndRatingList = v;
    });

    //print("Ratingggggggggggg        ${getRating()}");

    _write_comments_controller = new TextEditingController();

    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    _bottom_animation = Tween<double>(
            begin: collapsing_height_factor, end: expendated_height_factor)
        .animate(_controller);
    _image_animation = Tween<double>(
            begin: collapsing_height_factor, end: expendated_height_factor)
        .animate(_controller);

    get_fav(widget.index);

    //  print("get_fav(widget.index)   ${v} ");

    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  }

  FirebaseDatabaseHelper firebaseDatabaseHelper = new FirebaseDatabaseHelper();

  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user;
  }

  Future<bool> checkInternet() async {
    bool check_net;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      check_net = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      check_net = true;
    } else {
      check_net = false;
    }

    return check_net;
  }

  @override
  Widget build(BuildContext context) {
    print("Valueeeeeeeeeeeeeeeee    mmmmmmm ${is_fav}");

    checkInternet().then((check_net) {
      isInternetIsAvilable = check_net;
    });

    screen_height = MediaQuery.of(context).size.height;

    getUser().then((user) {
      widget._current_user = user;
    });

    firebaseDatabaseHelper.get_comments_and_rating(widget.index.toString());
    //print("isByed ${isBuyed}");

    //print("Is have or not ${check_is_he_rate_befour}");

    //  print("Progress update  ${ widget.progress_update}");

    //print("Is download status ${_download_status}");

    //print("Is Buyed   ${isBuyed}");

    //check_(widget.index);

    return MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xFFEFF3F5),
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () {
                if (_download_status == "download start") {
                  _showDialog("Please Wait...", context);
                } else {
                  if (widget.form == "fav") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Favourite()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Home()));
                  }
                }
              },
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    _add_fav(widget.index);

                    //print(widget.is_fav);
                  },
                  child: is_fav == 0 || is_fav == null
                      ? Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.favorite,
                          color: Colors.black,
                        ),
                ),
              )
            ],
          ),
          backgroundColor: Color(0xFFEFF3F5),
          body: widget._progress_bar_status != 1
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        widget.index == 3
                            ? first_section_for_index_3()
                            : first_section(),
                        second_section(
                            widget.title, _write_comments_controller),
                        isBuyed || _download_status == "download completed"
                            ? Container()
                            : Positioned(
                                bottom: 0.0,
                                child: price_and_buy(widget.price)),
                        _download_status == "download start"
                            ? Positioned(
                                bottom: 0.0,
                                child: new Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _download_status !=
                                              "download completed"
                                          ? Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: Text(
                                                  "Downloading.....",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                )),
                                                Text("${progress_update}/100"),
                                              ],
                                            )
                                          : Center(
                                              child: Text(
                                                  "Download successfully..."),
                                            )),
                                ))
                            : Container()
                      ],
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  double getRating() {
    double temp = 0;
    double final_result = 0;

    if (userCommentsAndRatingList != null) {
      for (int i = 0; i < userCommentsAndRatingList.length; i++) {
        temp += double.parse(userCommentsAndRatingList[i].rating);
      }

      final_result = temp / userCommentsAndRatingList.length;
    }

    return final_result;
  }

  Widget first_section() {
    return FractionallySizedBox(
      alignment: Alignment.topCenter,
      heightFactor: _image_animation.value + 0.1,
      widthFactor: _image_animation.value + 0.1,
      child: Hero(
          tag: 'tagImage${widget.index}',
          child: Image.asset(
            widget.image,
            fit: BoxFit.contain,
          )),
    );
  }

  Widget second_section(
      title, TextEditingController _write_comments_controller) {
    return GestureDetector(
      child: FractionallySizedBox(
        alignment: Alignment.bottomCenter,
        heightFactor: _bottom_animation.value,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isAnimation_complete ? 0.0 : 20),
                topRight: Radius.circular(isAnimation_complete ? 0.0 : 20)),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 1.0),
            child: Column(
              children: <Widget>[
                _book_name_rating_writer_name(title),
                Expanded(
                  child: SingleChildScrollView(
                    child: new Column(
                      children: <Widget>[
                        discription(),
                        SizedBox(
                          height: 15,
                        ),
                        isBuyed && check_is_he_rate_befour != 'have' ||
                                _download_status == "download completed"
                            ? _count_start()
                            : Container(),
                        isBuyed && check_is_he_rate_befour != 'have' ||
                                _download_status == "download completed"
                            ? write_comments(_write_comments_controller)
                            : Container(),
                        isBuyed && check_is_he_rate_befour != 'have' ||
                                _download_status == "download completed"
                            ? post_button()
                            : Container(),
                        userCommentsAndRatingList != null
                            ? comments_section()
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onVerticalDragUpdate: vertical_drag_update,
      onVerticalDragEnd: vertical_darag_end,
    );
  }

  Widget _book_name_rating_writer_name(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 20),
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "by GR Davies",
                style: TextStyle(color: Colors.black, fontSize: 15),
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  getRating() == 1 || getRating() > 1
                      ? new Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        )
                      : new Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 20,
                        ),
                  getRating() == 2 || getRating() > 2
                      ? new Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        )
                      : new Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 20,
                        ),
                  getRating() == 3 || getRating() > 3
                      ? new Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        )
                      : new Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 20,
                        ),
                  getRating() == 4 || getRating() > 4
                      ? new Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        )
                      : new Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 20,
                        ),
                  getRating() == 5 || getRating() > 5
                      ? new Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        )
                      : new Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 20,
                        ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              getRating().toString() != '0.0'
                  ? Text(
                      "${getRating()}",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    )
                  : Text("0.0"),
            ],
          ),
        ],
      ),
    );
  }

  Widget discription() {
    return Text(
      _discription_list[widget.index],
      style: TextStyle(
          fontStyle: FontStyle.normal, fontSize: 16, letterSpacing: 0.4),
      textAlign: TextAlign.center,
    );
  }

  Widget post_button() {
    return RaisedButton(
      color: Colors.green,
      onPressed: () {
        setState(() {
          widget._progress_bar_status = 1;
        });
//comments
        if (_count != 0 && _write_comments_controller.text != null) {
          FirebaseDatabaseHelper firebaseDatabaseHelper =
              new FirebaseDatabaseHelper();

          Future<String> value = firebaseDatabaseHelper.set_comments_and_rating(
              _write_comments_controller.text,
              _count.toString(),
              widget.index.toString());

          value.then((v) {
            if (v == "Success") {
              setState(() {
                widget._progress_bar_status = 0;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Description(
                              image: widget.image,
                              title: widget.title,
                              index: widget.index,
                              price: widget.price,
                            )));
              });
            }
          });
        } else {
          //    print("${widget._count} and ${_write_comments_controller.text} ");

        }
      },
      child: Text(
        "Post",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget write_comments(TextEditingController _write_comments_controller) {
    return Container(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _write_comments_controller,
            maxLines: 5,
            maxLength: 200,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Write your Comments..",
              hintStyle: TextStyle(color: Colors.black54),
            ),
          ),
        ));
  }

  Widget _count_start() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
                onTap: () {
                  setState(() {
                    _count = 1;
                  });
                },
                child: _count != 0 && 1 <= _count
                    ? new Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 30,
                      )
                    : new Icon(
                        Icons.star_border,
                        color: Colors.yellow,
                        size: 30,
                      )),
            InkWell(
                onTap: () {
                  setState(() {
                    _count = 2;
                  });
                },
                child: _count != 0 && 2 <= _count
                    ? new Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 30,
                      )
                    : new Icon(
                        Icons.star_border,
                        color: Colors.yellow,
                        size: 30,
                      )),
            InkWell(
                onTap: () {
                  setState(() {
                    _count = 3;
                  });
                },
                child: _count != 0 && 3 <= _count
                    ? new Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 30,
                      )
                    : new Icon(
                        Icons.star_border,
                        color: Colors.yellow,
                        size: 30,
                      )),
            InkWell(
                onTap: () {
                  setState(() {
                    _count = 4;
                  });
                },
                child: _count != 0 && 4 <= _count
                    ? new Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 30,
                      )
                    : new Icon(
                        Icons.star_border,
                        color: Colors.yellow,
                        size: 30,
                      )),
            InkWell(
                onTap: () {
                  setState(() {
                    _count = 5;
                  });
                },
                child: _count != 0 && 5 <= _count
                    ? new Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 30,
                      )
                    : new Icon(
                        Icons.star_border,
                        color: Colors.yellow,
                        size: 30,
                      )),
          ],
        ),
      ],
    );
  }

  Widget comments_section() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: userCommentsAndRatingList.length,
          itemBuilder: (BuildContext conext, int index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //top
                    Row(
                      children: <Widget>[
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: new NetworkImage(
                                      userCommentsAndRatingList[index].image))),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(userCommentsAndRatingList[index].gmail),
                            Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 20,
                                ),
                                int.parse(userCommentsAndRatingList[index]
                                                .rating) ==
                                            2 ||
                                        int.parse(
                                                userCommentsAndRatingList[index]
                                                    .rating) >
                                            2
                                    ? new Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 20,
                                      )
                                    : new Icon(
                                        Icons.star_border,
                                        color: Colors.yellow,
                                        size: 20,
                                      ),
                                int.parse(userCommentsAndRatingList[index]
                                                .rating) ==
                                            3 ||
                                        int.parse(
                                                userCommentsAndRatingList[index]
                                                    .rating) >
                                            3
                                    ? new Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 20,
                                      )
                                    : new Icon(
                                        Icons.star_border,
                                        color: Colors.yellow,
                                        size: 20,
                                      ),
                                int.parse(userCommentsAndRatingList[index]
                                                .rating) ==
                                            4 ||
                                        int.parse(
                                                userCommentsAndRatingList[index]
                                                    .rating) >
                                            4
                                    ? new Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 20,
                                      )
                                    : new Icon(
                                        Icons.star_border,
                                        color: Colors.yellow,
                                        size: 20,
                                      ),
                                int.parse(userCommentsAndRatingList[index]
                                                .rating) ==
                                            5 ||
                                        int.parse(
                                                userCommentsAndRatingList[index]
                                                    .rating) >
                                            5
                                    ? new Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 20,
                                      )
                                    : new Icon(
                                        Icons.star_border,
                                        color: Colors.yellow,
                                        size: 20,
                                      ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: <Widget>[
                          Text(
                            userCommentsAndRatingList[index].comment,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget price_and_buy(price) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              children: <Widget>[
                Text(
                  "Total Price :",
                  style: TextStyle(color: Colors.black12),
                ),
                widget.price != 'free'
                    ? Text(
                        '\$ ${widget.price}',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        "  free",
                        style: TextStyle(color: Colors.black),
                      ),
              ],
            ),
            Row(
              children: <Widget>[
                widget.price != 'free'
                    ? InkWell(
                        onTap: () {
                          if (isInternetIsAvilable) {
                            // print("Net Avilable");

                            FirebaseAuth.instance.currentUser().then((v) {
                              //  print("VVVVVVVVVVVV  ${v}");

                              if (v != null) {
                                _payment(widget.price);
                              } else {
                                //  print("Dialog");
                                _showDialog(
                                    'Please Sing In To Google Account To Download The Pdf',
                                    context);
                              }
                            });
                          } else {
                            // print("Net Not Avilable");
                          }
                        },
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.black,
                        ),
                      )
                    : new InkWell(
                        onTap: () {
                          checkInternet().then((v) {
                            if (v) {
                              FirebaseAuth.instance.currentUser().then((v) {
                                if (v.uid != null) {
                                  //_show_progress_Dialog("", context);

                                  _payment_success_and_download_the_pdf();

                                  /*     print(
                                      "By click what is update on progress bar ${_download_status}");
                                  print(
                                      "By click what is update on progress bar ${progress_update}");*/
                                } else {
                                  //  print("Dialog");
                                  _showDialog(
                                      'Please Sing In To Google Account To Download The Pdf',
                                      context);
                                }
                              });
                            } else {
                              //print("Dialog");

                              _showDialog(
                                  "Please Conect to your  phone with internet ",
                                  context);
                            }
                          });
                        },
                        child: Icon(
                          Icons.bookmark,
                          color: Colors.black,
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  vertical_drag_update(DragUpdateDetails v) {
    double fragction_drag = v.primaryDelta / screen_height;

    _controller.value = _controller.value - 5 * fragction_drag;
  }

  vertical_darag_end(DragEndDetails v) {
    if (_controller.value > 0.5) {
      _controller.forward();

      setState(() {
        isAnimation_complete = true;
      });
    } else {
      _controller.reverse();

      setState(() {
        isAnimation_complete = false;
      });
    }
  }

  Future<void> downloadFile(String url, String pdf_name) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();

      await dio.download("${url}", "${dir.path}/${pdf_name}.pdf",
          onReceiveProgress: (receive, total) {
        setState(() {
          _download_status = "download start";

          progress_update = ((receive / total) * 100).toStringAsFixed(1);

          //_show_progress_Dialog("",context);
        });
      });

      //  print(widget.po)

    } catch (e) {
      print(e);
    }

    setState(() {
      _download_status = "download completed";
    });

    // print("Completed");
  }

  // user defined function
  void _showDialog(String body, BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!!!"),
          content: new Text("${body}"),
          /*new Text("Please Sing In To Google Account To Download The Pdf"),*/
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _payment(int price) async {
    await InAppPayments.setSquareApplicationId("sq0idp-hvbA1c1CDxzuLflzqZq0lA");
    // await  InAppPayments.setSquareApplicationId("sandbox-sq0idb-sPF-Thylu2Y1omyXrE-FTw");

    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: (CardDetails result) async {
          try {
            InAppPayments.completeCardEntry(onCardEntryComplete: () {
              /*  print("Result    Nonce  "+result.nonce);
                print("Result    brand.name   "+result.card.brand.name);
                print("Result    expirationMonth.toString()  "+result.card.expirationMonth.toString());
                print("Result    expirationYear.toString() "+result.card.expirationYear.toString());
                print("Result    card.postalCode  "+result.card.postalCode);
                print("Result    card.prepaidType.name  "+result.card.prepaidType.name);
                print("Result    card.lastFourDigits  "+result.card.lastFourDigits);*/

              _create_a_customer().then((v) {
                _post_request(result.nonce, price, v);

                // print("Success");

                _payment_success_and_download_the_pdf();
              });

              // _post_request(result.nonce,10);
            });
          } on Exception catch (ex) {
            InAppPayments.showCardNonceProcessingError(ex.toString());
          }
        },
        onCardEntryCancel: () {});
  }

  Future<Customer> _create_a_customer() async {
    Customer customer;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    try {
      if (user != null) {
        String uri = 'https://connect.squareupsandbox.com/v2/customers';

        Map body = {
          "given_name": user.displayName,
          "email_address": user.email,
        };

        HttpClient httpClient = new HttpClient();

        HttpClientRequest request = await httpClient.postUrl(Uri.parse(uri));
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Accept', 'application/json');
        request.headers.set('Cache-Control', 'no-cache');
        request.headers.set('Authorization',
            'Bearer  EAAAECQ_xzO7j_ZjzU06Q2qlPZw1iIJ2SPLYIA4t-XzNCYfvJTmSES1NDuQJykpD');

        request.add(utf8.encode(json.encode(body)));

        HttpClientResponse response = await request.close();

        // response.

        String reply = await response.transform(utf8.decoder).join();

        var data = json.decode(reply);

        httpClient.close();

        // print("Customer id  is ${data['customer']['id']}");

        customer = new Customer(
            id: data['customer']['id'],
            given_name: data['customer']['given_email'],
            email_address: data['customer']['email_address']);
      }
    } catch (e) {
      print(e);
    }

    // print("Customer id  from customer class  ${customer.id}");

    return customer;
  }

  void _post_request(String nonse, int money, Customer customer) async {
    print('Nonse is         ${nonse}');

    String uri = 'https://connect.squareupsandbox.com/v2/payments';

    Map body = {
      "idempotency_key": "${DateTime.now()}",
      "amount_money": {"amount": 200, "currency": "USD"},
      "source_id": "${nonse}",

      //"card_nonce":"fake-card-nonce-ok",
      "autocomplete": true,
      "customer_id": "${customer.id}",
      "location_id": "EHQ6JE257QJ8E",
/*   "reference_id": "123456",*/
      "note": "Brief description",
      "app_fee_money": {"amount": 0, "currency": "USD"}
    };

    HttpClient httpClient = new HttpClient();

    HttpClientRequest request = await httpClient.postUrl(Uri.parse(uri));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('Cache-Control', 'no-cache');
    request.headers.set('Authorization',
        'Bearer  EAAAECQ_xzO7j_ZjzU06Q2qlPZw1iIJ2SPLYIA4t-XzNCYfvJTmSES1NDuQJykpD');
    // request.headers.set('Accept', 'application/json');

    request.add(utf8.encode(json.encode(body)));

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    httpClient.close();

    print(reply);
  }

  void _payment_success_and_download_the_pdf() {
    FirebaseDatabaseHelper firebaseDatabaseHelper =
        new FirebaseDatabaseHelper();

    firebaseDatabaseHelper.buyed(widget.index.toString());

    if(widget.index==3){


      dowload_therading_on_the_past();

    }else{

      downloadFile(pdf_download_url[widget.index], pdf_name[widget.index]);

    }


    firebaseDatabaseHelper.buyed(widget.index.toString());
  }

  void _add_fav(int index) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    int v = sp.getInt(index.toString());

    print(v);

    if (v == 0) {
      sp.setInt(index.toString(), 1);

      setState(() {
        is_fav = 1;
      });
    } else {
      sp.setInt(index.toString(), 0);

      setState(() {
        is_fav = 0;
      });
    }
  }

  void get_fav(int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int v = sharedPreferences.getInt(index.toString());

    print("Valueeeeeeeeeeeeeeeee    ${v}");

    setState(() {
      is_fav = v;
    });
  }

  Widget first_section_for_index_3() {
    return FractionallySizedBox(
        alignment: Alignment.topCenter,
        heightFactor: _image_animation.value + 0.1,
        widthFactor: _image_animation.value + 0.1,
        child: Hero(
            tag: 'tagImage${widget.index}',
            child: Swiper(


              autoplay: true,


              itemCount: page_view_image.length,
              itemBuilder: (BuildContext context,int index){
                return  Container(

                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(page_view_image[index] , fit: BoxFit.cover,)

                );


              },




            )));
  }


  /*
  *    return  Container(

                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(data , fit: BoxFit.cover,)

                );
  *
  *
  * */

  void dowload_therading_on_the_past() async{


    await downloadFile(pdf_download_url[3], "treading_on_the_past");
    await downloadFile(pdf_download_url[8], "treading_on_the_action");


  }
}

/*
*
* Container(

                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(page_view_image[position] , fit: BoxFit.cover,));
*
* */
