import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Model/UserCommentsAndRating.dart';



class FirebaseDatabaseHelper {
  final databaseRef = FirebaseDatabase.instance.reference().child("User");



  Future buyed(String index) async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();


      databaseRef.child(user.uid).child(index).set("0").then((_){

        print("Success");

      }).catchError((e){

        print( "Exception   "+e);

      });

  }




  Future<String> check_is_posted_comments_and_rating(String index) async {

    String value;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();


    if(user!=null){



      try{


        await databaseRef.child(user.uid).child(index).once().then((datasnapshort){

          Map<dynamic, dynamic> values = datasnapshort.value;


          print('Commentssssssss    ${values['comments']}');


          if( values['comments'] !=null ){

            value='have';
          }else{

            value='not';
          }




        });


      }catch(e){

        value='not';
        print(e);
      }


    }


    return value;

  }



  Future<String> set_comments_and_rating(
      String comments, String rating, String book_number) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();


    if (user.uid != null) {
      await databaseRef
          .child(user.uid)
          .child(book_number)
          .set({'comments': comments, 'rating': rating,'image_url':user.photoUrl,'gmail':user.email}).then((_) {

      }).catchError((e) {
       // print("Failed to add data " + e);
      });
    } else {
    //  print("User is not avilable");
    }

    return "Success";


  }


  Future<DataSnapshot> buyed_books(String index) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();


    DataSnapshot value;


    if(user!=null){
      
      await databaseRef.child(user.uid).child(index).once().then((DataSnapshot dataSnapshot){

          //print("Datasanpshot key is ${dataSnapshot.key}");
        //  print("Datasanpshot value is ${dataSnapshot.value}");

          value=dataSnapshot;

      });
      

     return value;

    }


  }



  Future<UserCommentsAndRating> get_comments_and_rating(String index){


     databaseRef.once().then((DataSnapshot datasnapshort){



     /*  print(datasnapshort.key);
       print(datasnapshort.value);*/

        //  datasnapshort.value.

     });




  }


  Future<List<UserCommentsAndRating>> read_all_comments_and_ratting(String index) async{


    List<UserCommentsAndRating> user_list=new List();


    await  databaseRef.once().then((snapshot){

      Map<dynamic, dynamic> values = snapshot.value;
      try{


      values.forEach((key,values){

        try{
         // print("key[0]key[0]key[0]key[0]key[0]key[0]key[0]key[0]key[0]key[0]   ${values[0].toString()}");

          String comments =values[int.parse(index)]["comments"];
          String rating =values[int.parse(index)]["rating"];
          String image_url =values[int.parse(index)]["image_url"];
          String gmail=values[int.parse(index)]["gmail"];

          ///  print("comments is ${comments}  ,   rating is ${rating}  ,image url is ${image_url}");

            UserCommentsAndRating userCommentsAndRating=new UserCommentsAndRating(comment: comments,rating: rating,image: image_url,gmail: gmail);


         user_list.add(userCommentsAndRating);









       }

        catch(e){

          print("Exception    ${e}");

        }




       // print("key[0]key[0]key[0]key[0]key[0]key[0]key[0]key[0]key[0]key[0]   ${values[1].toString()}");





     /*    String comments =values[int.parse(index)]["comments"];
         String rating =values[int.parse(index)]["rating"];
         String image_url =values[int.parse(index)]["image_url"];
         String gmail=values[int.parse(index)]["gmail"];*/

       ///  print("comments is ${comments}  ,   rating is ${rating}  ,image url is ${image_url}");

       /*  UserCommentsAndRating userCommentsAndRating=new UserCommentsAndRating(comment: comments,rating: rating,image: image_url,gmail: gmail);


         user_list.add(userCommentsAndRating);*/



      });}catch (e){

        print(e);

      }




    });


    return user_list;


  }


 /*  void downloadPdf() async {

     final taskId = await FlutterDownloader.enqueue(
       url: 'https://firebasestorage.googleapis.com/v0/b/bookapp-ebc21.appspot.com/o/1874.pdf?alt=media&token=25903214-2359-4704-aef7-00b52a42e420',
       savedDir: 'the path of directory where you want to save downloaded files',
       showNotification: true, // show download progress in status bar (for Android)
       openFileFromNotification: true, // click on notification to open downloaded file (for Android)
     );


   }
*/











}
