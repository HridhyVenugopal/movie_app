import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/widgetss/commonFunction.dart';
import '../../api_key/apiKey.dart';

class TvSeries extends StatefulWidget {
  const TvSeries({super.key});

  @override
  State<TvSeries> createState() => _TvSeriesState();
}

class _TvSeriesState extends State<TvSeries> {
  List<Map<String,dynamic>> topratedtvseries = [];
  List<Map<String,dynamic>> onairtvseries = [];
  List<Map<String,dynamic>> populartvseries = [];

  var topratedtvseriesurl = "https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey";
  var onairtvseriesurl = "https://api.themoviedb.org/3/tv/on_the_air?api_key=$apiKey";
  var populartvseriesurl = "https://api.themoviedb.org/3/tv/popular?api_key=$apiKey";

  Future<void> tvseriesfunction() async{
    var topratedtvseriesresponse = await http.get(Uri.parse(topratedtvseriesurl));
    if(topratedtvseriesresponse.statusCode == 200){
      var tempdata = jsonDecode(topratedtvseriesresponse.body);
      var topseriesjson = tempdata['results'];
      for(var i = 0; i < topseriesjson.length; i++){
        topratedtvseries.add({
          'name': topseriesjson[i]['title'],
          "poster_path" : topseriesjson[i]["poster_path"],
          "vote_average" : topseriesjson[i]["vote_average"],
          "release_date" : topseriesjson[i]["release_date"],
          "indexno" : i,
        });
      }
    }else{
      print(topratedtvseriesresponse.statusCode);
    }

    var onairtvseriesresponse = await http.get(Uri.parse(onairtvseriesurl));
    if(onairtvseriesresponse.statusCode == 200){
      var tempdata = jsonDecode(onairtvseriesresponse.body);
      var onairtvseriesjson = tempdata['results'];
      for(var i = 0; i < onairtvseriesjson.length; i++){
        onairtvseries.add({
          'name': onairtvseriesjson[i]['title'],
          "poster_path" : onairtvseriesjson[i]["poster_path"],
          "vote_average" : onairtvseriesjson[i]["vote_average"],
          "first_air_date" : onairtvseriesjson[i]["release_date"],
          "indexno" : i,
        });
      }
    }else{
      print(onairtvseriesresponse.statusCode);
    }

    var populartvseriesresponse = await http.get(Uri.parse(populartvseriesurl));
    if(populartvseriesresponse.statusCode == 200){
      var tempdata = jsonDecode(populartvseriesresponse.body);
      var populartvseriesjson = tempdata['results'];
      for(var i = 0; i < populartvseriesjson.length; i++){
        populartvseries.add({
          'name': populartvseriesjson[i]['title'],
          "poster_path" : populartvseriesjson[i]["poster_path"],
          "vote_average" : populartvseriesjson[i]["vote_average"],
          "first_air_date" : populartvseriesjson[i]["release_date"],
          "indexno" : i,
        });
      }
    }else{
      print(populartvseriesresponse.statusCode);
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tvseriesfunction(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(color: Colors.amber,),);
          else{
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sliderList(topratedtvseries, "Top Rated TV Series", "tv", topratedtvseries.length),
                sliderList(onairtvseries, "On Air TV Series", "tv", onairtvseries.length),
                sliderList(populartvseries, "Popular TV Series", "tv", populartvseries.length),
              ],
            );
          }
        });
  }
}
