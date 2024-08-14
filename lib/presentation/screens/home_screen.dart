import 'package:flutter/material.dart';
import 'package:movie_app/presentation/providers/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/presentation/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _searchMovies() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(query: query),
        ),
      );
    }
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
            'Buscador de Películas',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mostrar el logo centrado en la parte superior
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ),
              ),
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: '¿Qué película quieres buscar?',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 51, 189, 231),
                              width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.cyanAccent, width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: _searchMovies,
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Últimas Películas Vistas', // Título del carrusel
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Mostrar historial de búsquedas en un carrusel
              if (movieProvider.recentlyViewed.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieProvider.recentlyViewed.length,
                    itemBuilder: (context, index) {
                      final movie = movieProvider.recentlyViewed[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 5,
                          child: Image.network(
                            movie.poster,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Espacio reservado para evitar el desbordamiento
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
