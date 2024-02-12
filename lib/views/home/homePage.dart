import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/api_key/allapi.dart';
import 'package:http/http.dart' as http;
import '../sections/movies.dart';
import '../sections/upComing.dart';
import '../sections/tvseries.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  List<Map<String,dynamic>> topratedList = [];

  Future<void> topratedmovieshome()async{
    if(uval == 1){
      var topratedresponse = await http.get(Uri.parse(topratedmoviesurl));
      if(topratedresponse.statusCode == 200){
        var tempdata = jsonDecode(topratedresponse.body);
        var topratedjson = tempdata['results'];
        for(var i = 0 ; i < topratedjson.length; i++){
          topratedList.add({
            "id" : topratedjson[i]["id"],
            "poster_path" : topratedjson[i]["poster_path"],
            "vote_average" : topratedjson[i]["vote_average"],
            "release_date" : topratedjson[i]["release_date"],
            "indexno" : i,
          });
        }
      }
    }else if(uval == 2){
      var topratedtvseriesresponse = await http.get(Uri.parse(topratedtvseriesurl));
      if(topratedtvseriesresponse.statusCode == 200){
        var tempdata = jsonDecode(topratedtvseriesresponse.body);
        var topratedjson = tempdata['results'];
        for(var i = 0 ; i < topratedjson.length; i++){
          topratedList.add({
            "id" : topratedjson[i]["id"],
            "poster_path" : topratedjson[i]["poster_path"],
            "vote_average" : topratedjson[i]["vote_average"],
            "release_date" : topratedjson[i]["release_date"],
            "indexno" : i,
          });
        }
      }
    }else {}
}

  int uval = 1;

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        // physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                  future: topratedmovieshome(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      return CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            height: MediaQuery.of(context).size.height),
                      items: topratedList.map((i){
                            return Builder(builder: (context){
                              return GestureDetector(
                                onTap: (){},
                                child: GestureDetector(
                                  onTap: (){},
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3),
                                        BlendMode.darken),
                                        image: NetworkImage(
                                          "https://image.tmdb.org/t/p/original/${i["poster_path"]}"
                                        ),fit: BoxFit.fill
                                      )
                                    ),
                                  ),
                                ),
                              );
                            });
                    }).toList(),
                      );
                    }else{
                      return Center(
                        child: CircularProgressIndicator(color: Colors.amber,),
                      );
                    }
                  }),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Trending' + ' 🔥',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 16)),
                SizedBox(width: 10,),
                Container(
                  height: 45,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                  child: Padding(padding: EdgeInsets.all(4),
                  child: DropdownButton(
                      items: [
                        DropdownMenuItem(
                            child: Text("Top Rated Movies",style: TextStyle(
                                decoration: TextDecoration.none,color: Colors.white,fontSize: 16),),
                        value: 1
                        ),
                        DropdownMenuItem(
                            child: Text("Top Rated TV Series",style: TextStyle(
                                decoration: TextDecoration.none,color: Colors.white,fontSize: 16),),
                            value: 2
                        ),
                      ],
                      onChanged: (value){
                        setState(() {
                          topratedList.clear();
                          uval = int.parse(value.toString());
                        });
                      },
                    autofocus: true,
                    underline: Container(height: 0,color: Colors.transparent,),
                    dropdownColor: Colors.black.withOpacity(0.6),
                    icon: Icon(Icons.arrow_drop_down,color: Colors.amber,size: 30,),
                    value: uval,

                  ),),
                )
              ],
            ),
          ),

          SliverList(delegate: SliverChildListDelegate([
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                physics: BouncingScrollPhysics(),
                labelPadding: EdgeInsets.symmetric(horizontal: 25),
                isScrollable: true,
                controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.amber.withOpacity(0.4)
                  ),
                  tabs: [
                    Tab(child: Text("TV Series")),
                    Tab(child: Text("Movies")),
                    Tab(child: Text("On Air")),
                  ]),),
            Container(
              height: 1020,
              child: TabBarView(
                controller: _tabController,
                  children: [
                TvSeries(),
                Movies(),
                Upcoming(),
              ]),
            ),
          ]))
        ],
      ),
    );
  }
}
