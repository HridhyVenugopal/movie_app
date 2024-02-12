import 'package:flutter/material.dart';

class MovieDetails extends StatefulWidget {
   MovieDetails(this.movieId);

  var movieId;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Map<String,dynamic>> movieDetails = [];
  List<Map<String,dynamic>> userReviews = [];



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
