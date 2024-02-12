import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api_key/apiKey.dart';
import '../../widgetss/commonFunction.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  List<Map<String,dynamic>> topratedmovies = [];
  List<Map<String,dynamic>> nowplayingmovies = [];
  List<Map<String,dynamic>> popularmovies = [];

  var topratedmoviesurl =  "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  var nowplayingmoviesurl = "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";
  var popularmoviesurl = "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";

  Future<void> moviesfunction() async{
    var topratedmoviesresponse = await http.get(Uri.parse(topratedmoviesurl));
    if(topratedmoviesresponse.statusCode == 200){
      var tempdata = jsonDecode(topratedmoviesresponse.body);
      var topratedmoviesjson = tempdata['results'];
      for(var i = 0; i < topratedmoviesjson.length; i++){
        topratedmovies.add({
          'title': topratedmoviesjson[i]['title'],
          "poster_path" : topratedmoviesjson[i]["poster_path"],
          "vote_average" : topratedmoviesjson[i]["vote_average"],
          "release_date" : topratedmoviesjson[i]["release_date"],
          "indexno" : i,
        });
      }
    }else{
      print(topratedmoviesresponse.statusCode);
    }

    var nowplayingmoviesresponse = await http.get(Uri.parse(nowplayingmoviesurl));
    if(nowplayingmoviesresponse.statusCode == 200){
      var tempdata = jsonDecode(nowplayingmoviesresponse.body);
      var nowplayingmoviesjson = tempdata['results'];
      for(var i = 0; i < nowplayingmoviesjson.length; i++){
        nowplayingmovies.add({
          'title': nowplayingmoviesjson[i]['title'],
          "poster_path" : nowplayingmoviesjson[i]["poster_path"],
          "vote_average" : nowplayingmoviesjson[i]["vote_average"],
          "first_air_date" : nowplayingmoviesjson[i]["release_date"],
          "indexno" : i,
        });
      }
    }else{
      print(nowplayingmoviesresponse.statusCode);
    }

    var popularmoviesresponse = await http.get(Uri.parse(popularmoviesurl));
    if(popularmoviesresponse.statusCode == 200){
      var tempdata = jsonDecode(popularmoviesresponse.body);
      var popularmoviesjson = tempdata['results'];
      for(var i = 0; i < popularmoviesjson.length; i++){
        popularmovies.add({
          'title': popularmoviesjson[i]['title'],
          "poster_path" : popularmoviesjson[i]["poster_path"],
          "vote_average" : popularmoviesjson[i]["vote_average"],
          "first_air_date" : popularmoviesjson[i]["release_date"],
          "indexno" : i,
        });
      }
    }else{
      print(popularmoviesresponse.statusCode);
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: moviesfunction(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(color: Colors.amber,),);
          else{
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sliderList(topratedmovies, "Top Rated TV Series", "movies", topratedmovies.length),
                sliderList(nowplayingmovies, "On Air TV Series", "movies", nowplayingmovies.length),
                sliderList(popularmovies, "Popular TV Series", "movies", popularmovies.length),
              ],
            );
          }
        });
  }
}

