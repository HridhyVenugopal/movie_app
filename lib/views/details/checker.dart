import 'package:flutter/material.dart';
import 'package:movie_app/views/details/forSeries.dart';

import 'forMovies.dart';

class DescriptionChecker extends StatefulWidget {
   DescriptionChecker(this.newId,this.newType);
   var newId;
   var newType;

  @override
  State<DescriptionChecker> createState() => _DescriptionCheckerState();
}

class _DescriptionCheckerState extends State<DescriptionChecker> {

  checktype(){
    if(widget.newType == 'movie'){
      return MovieDetails(widget.newId);
    }else if(widget.newType == 'tv'){
      return SeriesDetails(widget.newId);
    }else{
      return errorui();
    }
  }

  @override
  Widget build(BuildContext context) {
    return checktype();
  }
}

Widget errorui(){
  return Scaffold(
    body: Center(child: Text("Error"),),
  );
}
