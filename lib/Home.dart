import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_database/firebase_database.dart';

import 'Database/FirebaseDatabaseHelper.dart';
import 'Discription.dart';
import 'Favourite.dart';
import 'Model/UserCommentsAndRating.dart';

class Home_State extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List image_list = [
    'img/a_night_with_a_hookh.jpg',
    'img/helping.png',
    'img/delayed_reality.jpg',
    'img/theading_on_the_past.png',
    'img/i874.jpg',
    'img/image_by_gr_davies.jpg',
    'img/in_the_vally.jpg',
    'img/i_see_the.png',
  ];

  List name_list = [
    "A Night With A Hookah ",
    'Helping Mommy Defeat Depression',
    'Delayed Reality',
    'Treading On The Past ',
    '1874',
    'Image ',
    'In The Valley Of Spice  ',
    'I See The',
  ];

  List price_list = [
    "free",
    "free",
    "2.99",
    "7.99",
    "7.99",
    "2.99",
    "2.99",
    "2.99",
    "2.99",
  ];

  double screen_height = 0;

  bool isClicked = false;

  String _image_url;

  FirebaseUser _current_user;

  AnimationController _controller;

  Animation<double> _open_drawer;

  Animation<double> _open_icon;

  FirebaseDatabaseHelper firebaseDatabaseHelper = new FirebaseDatabaseHelper();

  int vab = 0;

  _change_state() {
    if (isClicked) {
      isClicked = false;

      _controller.reverse();
    } else {
      _controller.forward();

      isClicked = true;
    }
  }


  List<List<UserCommentsAndRating>> userCommentsAndRatingList=new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    ;
    _open_drawer = new Tween<double>(begin: 0.0, end: 100).animate(_controller);
    _open_icon = new Tween<double>(begin: 100, end: 10).animate(_controller);


    for (int i=0;i<8;i++){
      firebaseDatabaseHelper
          .read_all_comments_and_ratting(i.toString())
          .then((v) {
          userCommentsAndRatingList.add(v);
      });


    }



  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser currentUser;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    assert(user.photoUrl != null);

    //  print("Image Url ${user.photoUrl}");

    return 'signInWithGoogle succeeded: $user';
  }

  Future<void> signOut() async {
    await _auth.signOut().then((_) {
      //try the following
      googleSignIn.signOut();
      //try the following
    });

   // print(_current_user.email);
  }

  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user;
  }









  @override
  Widget build(BuildContext context) {







    screen_height = MediaQuery.of(context).size.height;

    getUser().then((user) {
      //print('User ${user}');

      setState(() {
        if (user != null) {
          // _image_url=user.photoUrl;
          _current_user = user;
        } else {
          _current_user = null;
        }
      });
    });

    //  print('Google Image    2${_image_url} ');




    
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext buildercontext, Widget child) {
        return SafeArea(

          child: Scaffold(

            backgroundColor: Color(0xFFEFF3F5),
            body: Stack(
              children: <Widget>[
                drawer(),
                Transform(
                    transform:
                        Matrix4.translationValues(_open_drawer.value, 0.0, 0.0),
                    child: home()),
                //  Image.network("https://image.shutterstock.com/image-photo/beautiful-water-drop-on-dandelion-260nw-789676552.jpg",width: 300,height: 300,)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget drawer() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        /* physics: BouncingScrollPhysics(),

                          shrinkWrap: true,*/

        children: <Widget>[
          _current_user == null
              ? InkWell(
                  onTap: () {
                   signInWithGoogle();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Icon(
                      Icons.perm_identity,
                      size: 30,
                    ),
                  ),
                )
              : Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                      border: Border.all(color: Colors.black, width: 1),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(_current_user.photoUrl),
                      ))),
          SizedBox(
            height: _open_icon.value,
          ),
          InkWell(
            onTap: () {
              //favourite
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  border: Border.all(color: Colors.black, width: 1)),
              child: InkWell(
                onTap: () {
                  //do_something


                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Favourite()));


                },
                child: Icon(
                  Icons.favorite_border,
                  size: 30,
                ),
              ),
            ),
          ),
          SizedBox(
            height: _open_icon.value,
          ),
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  border: Border.all(color: Colors.black, width: 1)),
              child: Icon(Icons.info)),
          SizedBox(
            height: _open_icon.value,
          ),
          _current_user != null
              ? InkWell(
                  onTap: () {
                    //log _out

                    signOut();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image(
                        image: AssetImage(
                          'img/logout.png',
                        ),
                      ),
                    ),
                  ),
                )
              : Icon(
                  Icons.remove,
                  size: 40,
                  color: Color(0xFFEFF3F5),
                ),

          /*   :null*/
        ],
      ),
    );
  }

  Widget home() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: new Scaffold(
          backgroundColor: Color(0xFFEFF3F5),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                _change_state();
              },
              child: Icon(
                isClicked ? Icons.close : Icons.menu,
                color: Colors.black54,
              ),
            ),
            title: Text(
              "In My House",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 19),
            ),
          ),
          body: image_list.length > 0
              ? GridView.builder(
                  itemCount: image_list.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {



                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Description(
                                  image: image_list[index],
                                  title: name_list[index],
                                  index: index,
                                  price: price_list[index],
                                )));
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            width: 200,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 8.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                    width: 200,
                                    height: 200,
                                    child: Hero(
                                      tag: 'tagImage$index',
                                      child: new Image.asset(
                                        image_list[index],
                                        fit: BoxFit.cover,
                                      ),
                                    )),

                                //Bottom
                                Positioned(
                                  bottom: 0.0,
                                  width: 200,
                                  height: 30,
                                  child: Container(
                                    color: Colors.black54,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 3.0,
                                          ),
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                getRating(index) == 1 || getRating(index) > 1
                                                    ? new Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                )
                                                    : new Icon(
                                                  Icons.star_border,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                ),
                                                getRating(index) == 2 || getRating(index) > 2
                                                    ? new Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                )
                                                    : new Icon(
                                                  Icons.star_border,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                ),
                                                getRating(index) == 3 || getRating(index) > 3
                                                    ? new Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                )
                                                    : new Icon(
                                                  Icons.star_border,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                ),
                                                getRating(index) == 4 || getRating(index) > 4
                                                    ? new Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                )
                                                    : new Icon(
                                                  Icons.star_border,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                ),
                                                getRating(index) == 5 || getRating(index) > 5
                                                    ? new Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                )
                                                    : new Icon(
                                                  Icons.star_border,
                                                  color: Colors.yellow,
                                                  size: 13,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        /*:const EdgeInsets.only(right:10),*/
                                        Padding(
                                          padding: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  380
                                              ? const EdgeInsets.only(
                                                  right: 35.0)
                                              : const EdgeInsets.only(
                                                  right: 65.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "\$7.99",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: Colors.white60,
                                                    fontSize: 9),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              set_price(index),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //love
                               /* Positioned(
                                    right: 6,
                                    top: 4,
                                    child: InkWell(
                                      *//*
                                      onTap: (){
                                        
                                        
                                        _add_fav(index);
                                        
                                      },
                                      *//*

                                      child: vab == 0
                                          ? new Icon(
                                              Icons.favorite_border,
                                              color: Colors.redAccent,
                                            )
                                          : new Icon(
                                              Icons.favorite,
                                              color: Colors.redAccent,
                                            ),
                                    ))*/
                              ],
                            ),
                          )),
                    );
                  })
              : CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )),
    );
  }







  double getRating(int index) {

    double temp = 0;
    double final_result = 0;


    try{


      if (userCommentsAndRatingList[index]  != 0) {
        for (int i = 0; i < userCommentsAndRatingList[index].length; i++) {


          //  print("Leangth        ${userCommentsAndRatingList[index][i].rating}");

          temp += double.parse(userCommentsAndRatingList[index][i].rating);
        }

        final_result = temp / userCommentsAndRatingList[index].length;
      }else{


        //  print( "   Nullllllllllllll  ");

      }







    }catch(e){

    }




   // print("Final result   ${final_result}");

    return final_result;
  }


}


Widget set_price(index) {
  switch (index) {
    case 0:
      return Text(
        "free",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );
    case 1:
      return Text(
        "free",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );
    case 2:
      return Text(
        "\$2.99",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );
    case 3:
      return Text(
        "\$7.99",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );

    case 4:
      return Text(
        "\$7.99",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );

    case 5:
      return Text(
        "\$2.99",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );

    case 6:
      return Text(
        "\$2.99",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );
    case 7:
      return Text(
        "\$2.99",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );
    case 8:
      return Text(
        "\$2.99",
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      );
  }
}

Future<int> check_is_fav(int index) async {
  SharedPreferences sp = await SharedPreferences.getInstance();

  return sp.getInt(index.toString());
}

