
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Discription.dart';
import 'Home.dart';

class Favourite extends StatefulWidget {

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

  List name_list = [
    "A Night With A Hookah ",
    'Helping Mommy Defeat Depression',
    'Delayed Reality',
    'Treading On The Past ',
    '1874',
    'Image ',
    'In The Valley Of Spice  ',
    'img/I See The',
  ];

  List price_list = [
    "free",
    "free",
    "2.99",
    "2.99",
    "4.99",
    "2.99",
    "2.99",
    "2.99",
    "2.99",
  ];

  @override
  _FavouriteState createState() => _FavouriteState();

}


class _FavouriteState extends State<Favourite> {

  List<int>  fav_list=new List();




  Future<List<int>> _read_all_favourate_books()  async {

    List<int>  fav_list_c=new List();

    SharedPreferences   sp= await SharedPreferences.getInstance();


    for(int i=0;i<8;i++){

      int index=sp.getInt(i.toString());


   //   print(" ${i}    ${index}  ");


      if(index==1){

        fav_list_c.add(i);

      }


    }

    return fav_list_c;


  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {


    _read_all_favourate_books().then((v){

      setState(() {

        fav_list=v;

      });


    });


  //  print("length  ${fav_list.length} ");


 /*   for(int i=0;i<fav_list.length;i++){


   //   print("Fav       ${fav_list[i]} ");


    }
*/



    return MaterialApp(

      debugShowCheckedModeBanner: false,


      home: Scaffold(

        backgroundColor: Color(0xFFEFF3F5),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: InkWell(

            onTap: (){


              Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));

            },

            child: Icon(

              Icons.arrow_back,color: Colors.black54,


            ),
          ),
          title: Text(
            "Favourite",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 19),
          ),
        ),

        body: GridView.builder(
            itemCount: fav_list.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {



              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Description(
                        image: widget.image_list[fav_list[index]],
                        title: widget.name_list[fav_list[index]],
                        index: index,
                        price: widget.price_list[fav_list[index]],
                        form: 'fav',



                      )));
                },
                child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      width: 200,
                      height: 200,
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
                              height: 250,
                              child: Hero(
                                tag: 'tagImage$index',
                                child: new Image.asset(
                                  widget.image_list[fav_list[index]],
                                  fit: BoxFit.cover,
                                ),
                              )),

                        ],
                      ),
                    )),
              );
            }),



      ),

    );
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
          "\$2.99",
          style: TextStyle(color: Colors.redAccent, fontSize: 12),
        );

      case 4:
        return Text(
          "\$4.99",
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



}
