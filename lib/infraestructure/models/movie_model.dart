class MovieModel {
  final String title;
  final String year;
  final String poster;
  final String imdbID;

  MovieModel({
    required this.title,
    required this.year,
    required this.poster,
    required this.imdbID,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['Title'] ?? 'No Title',
      year: json['Year'] ?? 'No Year',
      poster: json['Poster'] ?? 'N/A',
      imdbID: json['imdbID'] ?? '',
    );
  }
}
