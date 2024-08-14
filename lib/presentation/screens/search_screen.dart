import 'package:flutter/material.dart';
import 'package:movie_app/presentation/providers/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/presentation/screens/movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  SearchScreen({required this.query});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      movieProvider.fetchMovies(widget.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 2, 96, 122), 
        flexibleSpace: Center(
          child: Text(
            'Resultados de Busqueda',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, 
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
            fit: BoxFit.cover, 
          ),
        ),
        child: movieProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : movieProvider.movies.isEmpty
                ? Center(
                    child: Text('No se encontraron películas.',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
                : ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: movieProvider.movies.length,
                    itemBuilder: (context, index) {
                      final movie = movieProvider.movies[index];
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          leading: Image.network(
                            movie.poster,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            movie.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
