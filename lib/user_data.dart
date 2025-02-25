import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static const String _ratingsKey = 'movie_ratings';
  static const String _watchedKey = 'watched_movies';

  static Future<Map<String, double>> loadRatings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? ratingsStr = prefs.getString(_ratingsKey);
      if (ratingsStr != null) {
        return Map<String, double>.from(json.decode(ratingsStr));
      }
    } catch (e) {
      print('Error loading ratings: $e');
    }
    return {};
  }

  static Future<void> saveRating(String movieId, double rating) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ratings = await loadRatings();
      ratings[movieId] = rating;
      await prefs.setString(_ratingsKey, json.encode(ratings));
    } catch (e) {
      print('Error saving rating: $e');
    }
  }

  static Future<Set<String>> loadWatchedMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? watchedStr = prefs.getString(_watchedKey);
      if (watchedStr != null) {
        final List<dynamic> data = json.decode(watchedStr);
        return data.cast<String>().toSet();
      }
    } catch (e) {
      print('Error loading watched movies: $e');
    }
    return {};
  }

  static Future<void> saveWatchedMovies(Set<String> watchedMovies) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_watchedKey, json.encode(watchedMovies.toList()));
    } catch (e) {
      print('Error saving watched movies: $e');
    }
  }

  static Future<void> toggleWatched(String movieId) async {
    try {
      final watched = await loadWatchedMovies();
      if (watched.contains(movieId)) {
        watched.remove(movieId);
      } else {
        watched.add(movieId);
      }
      await saveWatchedMovies(watched);
    } catch (e) {
      print('Error toggling watched state: $e');
    }
  }
}
