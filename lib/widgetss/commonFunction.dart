import 'package:flutter/material.dart';
import 'package:movie_app/views/details/forMovies.dart';
import 'package:movie_app/views/details/forSeries.dart';

Widget sliderList(List firstListName, String categoryTitle, String type, int itemcount){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
          padding:  EdgeInsets.only(left: 10,top: 15,bottom: 40),
          child: Text(categoryTitle.toString())),
      Container(
        height: 250,
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: itemcount,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  if(type == 'movie'){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MovieDetails(firstListName[index]['id'])));
                  }else if(type == 'tv'){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SeriesDetails(firstListName[index]['id'])));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3),
                              BlendMode.darken),
                          image: NetworkImage("https://image.tmdb.org/t/p/original/${firstListName[index]["poster_path"]}"),fit: BoxFit.cover)),
                  margin: EdgeInsets.only(left: 13),
                  width: 170,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 2,left: 6),
                          child: Text(firstListName[index]["release_date"].toString())),
                      Padding(
                        padding: EdgeInsets.only(top: 2,right: 6),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.only(top: 2,bottom: 2,left: 5,right: 5),
                            child: Row(
                              children: [
                                Icon(Icons.star,color: Colors.amber,),
                                Text(firstListName[index]["vote_average"].toString())
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      )
    ],
  );
}