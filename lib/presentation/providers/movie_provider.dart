import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_app/infraestructure/models/movie_model.dart';

class MovieProvider with ChangeNotifier {
  final String apiKey = 'e7629698';
  List<MovieModel> _movies = [];
  bool _isLoading = false;

  List<MovieModel> _recentlyViewed = [];

  List<MovieModel> get movies => _movies;
  bool get isLoading => _isLoading;
  List<MovieModel> get recentlyViewed => _recentlyViewed;

  Future<void> fetchMovies(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://www.omdbapi.com/?s=$query&apikey=$apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Search'] != null) {
          _movies = (data['Search'] as List)
              .map((json) => MovieModel.fromJson(json))
              .toList();
          // Agregar las películas encontradas al historial
        } else {
          _movies = [];
        }
      } else {
        _movies = [];
      }
    } catch (e) {
      print('Error : $e');
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addRecentlyViewed(MovieModel movie) {
    if (_recentlyViewed.contains(movie)) {
      _recentlyViewed.remove(movie);
    }
    _recentlyViewed.insert(0, movie); 
    if (_recentlyViewed.length > 8) {
      _recentlyViewed.removeLast(); 
    }
    notifyListeners();
  }
}
