import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/infraestructure/models/movie_model.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:movie_app/presentation/providers/movie_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final MovieModel movie;

  MovieDetailScreen({required this.movie});

  Future<Map<String, dynamic>> fetchMovieDetails() async {
    final response = await http.get(
        Uri.parse('http://www.omdbapi.com/?i=${movie.imdbID}&apikey=e7629698'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No se puedo obtener informacion');
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    // Asegurarse de que la adición a las vistas recientes ocurra después de la construcción
    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieProvider.addRecentlyViewed(movie);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 2, 96, 122), // Cambia el color de la AppBar
        flexibleSpace: Center(
          child: Text(
            movie.title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Asegura que el color del texto sea blanco
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover, // Asegura que la imagen cubra toda la pantalla
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchMovieDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              final movieDetails = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      movieDetails['Poster'] != 'N/A'
                          ? Image.network(movieDetails['Poster'])
                          : Container(), 
                      SizedBox(height: 16),
                      Text(
                        movieDetails['Title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Estilo del título
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Year: ${movieDetails['Year']}',
                        style: TextStyle(color: Colors.white), // Estilo del año
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Director: ${movieDetails['Director']}',
                        style: TextStyle(
                            color: Colors.white), // Estilo del director
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plot: ${movieDetails['Plot']}',
                        style: TextStyle(
                            color: Colors.white), // Estilo del resumen
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
