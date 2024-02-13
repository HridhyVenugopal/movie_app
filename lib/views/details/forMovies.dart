import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/api_key/apiKey.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/views/home/homePage.dart';

class MovieDetails extends StatefulWidget {
   MovieDetails(this.movieId);

  var movieId;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Map<String,dynamic>> moviedetails = [];
  List<Map<String,dynamic>> userreviews = [];
  List<Map<String,dynamic>> similarmovielist = [];
  List<Map<String,dynamic>> recommentedmovielist = [];
  List<Map<String,dynamic>> movietrailerlist = [];

  List<Map<String,dynamic>> Movies = [];

  Future<void> MoviesDetails() async{
    var moviedetailurl = 'https://api.themoviedb.org/3/movie/' + widget.movieId.toString() + '?api_key=$apiKey';
    var userreviewurl = 'https://api.themoviedb.org/3/movie/' + widget.movieId.toString() + '/reviews?api_key=$apiKey';
    var similarmovieurl = 'https://api.themoviedb.org/3/movie/' + widget.movieId.toString() + '/similar?api_key=$apiKey';
    var recommentedmovieurl = 'https://api.themoviedb.org/3/movie/' + widget.movieId.toString() + '/recommendations?api_key=$apiKey';
    var movietrailerurl = 'https://api.themoviedb.org/3/movie/' + widget.movieId.toString() + '/videos?api_key=$apiKey';

    var moviedetailsresponse = await http.get(Uri.parse(moviedetailurl));
    if(moviedetailsresponse.statusCode == 200){
      var moviedetailjson = jsonDecode(moviedetailsresponse.body);
      for(var i=0; i<1; i++){
        moviedetails.add({
          "backdrop_path" : moviedetailjson['backdrop_path'],
          'title' : moviedetailjson['title'],
          'vote_average' : moviedetailjson['vote_average'],
          'overview' : moviedetailjson['overview'],
          'release_date' : moviedetailjson['release_date'],
          'run_time' : moviedetailjson['run_time'],
          'budget' : moviedetailjson['budget'],
          'revenue' : moviedetailjson['revenue'],
        });
      }for(var i=0; i<moviedetailjson['genres'].length; i++){
        Movies.add(moviedetailjson['genres'][i]['name']);
      }
    }else {}

    var userreviewresponse = await http.get(Uri.parse(userreviewurl));
    if(userreviewresponse.statusCode == 200){
      var userreviewjson = jsonDecode(userreviewresponse.body);
      for(var i=0; i<userreviewjson['results'].length; i++){
        userreviews.add({
          'name' : userreviewjson['results'][i]['author'],
          'review' : userreviewjson['results'][i]['content'],
          //for checking the rating is null or not
          'rating' : userreviewjson['results'][i]['author_details']['rating']==null
          ? 'Not Rated' :
              userreviewjson['results'][i]['author_details']['rating'].toString(),
          'avatarphoto' : userreviewjson['results'][i]['author_details']['avatar_path'] == null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
          'creationdate' : userreviewjson['results'][i]['created_at'].substring(0,10),
          'fullreviewurl' : userreviewjson['results'][i]['url'],
        });
      }
    }else{}

    var recommendedmoviesresponse = await http.get(Uri.parse(recommentedmovieurl));
    if(recommendedmoviesresponse.statusCode == 200){
      var recommendedmoviesjson = jsonDecode(recommendedmoviesresponse.body);
      for(var i=0; i<recommendedmoviesjson['results'].length; i++){
        recommentedmovielist.add({
          'poster_path' : recommendedmoviesjson['results'][i]['poster_path'],
          'name' : recommendedmoviesjson['results'][i]['title'],
          'vote_average' : recommendedmoviesjson['results'][i]['vote_average'],
          'Date' : recommendedmoviesjson['results'][i]['release_date'],
          'id' : recommendedmoviesjson['results'][i]['id'],
        });
      }
    }else{}

   var movietrailersresponse = await http.get(Uri.parse(movietrailerurl));
    if(movietrailersresponse.statusCode == 200){
      var movietrailersjson = jsonDecode(movietrailersresponse.body);
      for(var i=0; i<movietrailersjson['results'].length; i++){
        if(movietrailersjson['results'][i]['type'] == "Trailer"){
          movietrailerlist.add({
            'key' : movietrailersjson['results'][i]['key'],
          });
        }
      }
      movietrailerlist.add({'key' : 'ZFlm7fFfEmU'});
    }else{}
    print(movietrailerlist);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: MoviesDetails(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(FontAwesomeIcons.circleArrowLeft),
                        color: Colors.white),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context)=>HomePage()),
                                (route) => false);
                      }, icon: Icon(FontAwesomeIcons.houseUser),
                        iconSize: 25,color: Colors.white,)
                    ],
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: FittedBox(
                        fit: BoxFit.fill,
                        child: trailerwatch(
                          trailerid : movietrailerlist[0]['key'],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(padding: EdgeInsets.only(left: 10,top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Movies.length,
                                    itemBuilder: (context,index){
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                    );
                                    }),)
                              ]),
                            Row(
                              children: [

                              ],
                            )
                          ],
                        )
                      ]))
                ],
              );
            }else{}
          }),
    );
  }
}
