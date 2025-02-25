import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _cleanText(String? text) {
  if (text == null) return '';
  return text
    .replaceAll('&apos;', "'")
    .replaceAll('&amp;', '&')
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'");
}

void main() => runApp(MovieAwardsApp());

class MovieAwardsApp extends StatelessWidget {
  const MovieAwardsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The 97th Academy Awards',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.grey[900]),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.amber,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const MovieBrowserScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MovieBrowserScreen extends StatefulWidget {
  const MovieBrowserScreen({Key? key}) : super(key: key);

  @override
  _MovieBrowserScreenState createState() => _MovieBrowserScreenState();
}

class _MovieBrowserScreenState extends State<MovieBrowserScreen> {
  List<Map<String, dynamic>> entries = [];
  Map<String, dynamic> cache = {};
  int currentIndex = 0;
  bool isLoading = true;
  Set<String> _watchedMovies = {};
  Map<String, double> _ratings = {};

  final Map<String, String> imdbIds = {
    "A Complete Unknown": "tt11563598",
    "A Different Man": "tt21097228",
    "A Lien": "tt27655666",
    "A Real Pain": "tt21823606",
    "Alien: Romulus": "tt18412256",
    "Anora": "tt28607951",
    "Anuja": "tt27654431",
    "Beautiful Men": "tt30835281",
    "Better Man": "tt14260836",
    "Black Box Diaries": "tt30227076",
    "Conclave": "tt20215234",
    "Death by Numbers": "tt33385063",
    "Dune: Part Two": "tt15239678",
    "Elton John: Never Too Late": "tt20316978",
    "Emilia Pérez": "tt20221436",
    "Flow": "tt4772188",
    "Gladiator II": "tt9218128",
    "I Am Ready, Warden": "tt31556921",
    "I'm Not a Robot": "tt19837932",
    "I'm Still Here": "tt14961016",
    "In the Shadow of the Cypress": "tt28768883",
    "Incident": "tt27990245",
    "Inside Out 2": "tt22022452",
    "Instruments of a Beating Heart": "tt32280470",
    "Kingdom of the Planet of the Apes": "tt11389872",
    "Magic Candies": "tt31888603",
    "Maria": "tt22893404",
    "Memoir of a Snail": "tt23770030",
    "Nickel Boys": "tt23055660",
    "No Other Land": "tt30953759",
    "Nosferatu": "tt5040012",
    "Porcelain War": "tt30294282",
    "September 5": "tt28082769",
    "Sing Sing": "tt28479262",
    "Soundtrack to a Coup d'Etat": "tt14452174",
    "Sugarcane": "tt30319854",
    "The Apprentice": "tt8368368",
    "The Brutalist": "tt8999762",
    "The Girl With the Needle": "tt10236164",
    "The Last Ranger": "tt15802124",
    "The Man Who Could Not Remain Silent": "tt20519854",
    "The Only Girl in the Orchestra": "tt29497240",
    "The Seed of the Sacred Fig": "tt32178949",
    "The Six Triple Eight": "tt24458622",
    "The Substance": "tt17526714",
    "The Wild Robot": "tt29623480",
    "Wallace & Gromit: Vengeance Most Fowl": "tt17163970",
    "Wander to Wonder": "tt28768679",
    "Wicked": "tt1262426",
    "Yuck!": "tt28356173",
  };

  final Map<String, List<String>> categories = {
    "Best Picture": [
      "Anora", "The Brutalist", "A Complete Unknown", "Conclave", "Dune: Part Two",
      "Emilia Pérez", "I'm Still Here", "Nickel Boys", "The Substance", "Wicked"
    ],
    "Best Director": [
      "Anora", "The Brutalist", "A Complete Unknown", "Emilia Pérez", "The Substance"
    ],
    "Best Actress": [
      "Wicked", "Emilia Pérez", "Anora", "The Substance", "I'm Still Here"
    ],
    "Best Actor": [
      "The Brutalist", "A Complete Unknown", "Sing Sing", "Conclave", "The Apprentice"
    ],
    "Best Cinematography": [
      "The Brutalist", "Dune: Part Two", "Emilia Pérez", "Maria", "Nosferatu"
    ],
    "Best Visual Effects": [
      "Alien: Romulus", "Better Man", "Dune: Part Two", "Kingdom of the Planet of the Apes", "Wicked"
    ],
    "Best Sound": [
      "A Complete Unknown", "Dune: Part Two", "Emilia Pérez", "Wicked", "The Wild Robot"
    ],
    "Best Film Editing": [
      "Anora", "The Brutalist", "Conclave", "Emilia Pérez", "Wicked"
    ],
    "Best Production Design": [
      "The Brutalist", "Conclave", "Dune: Part Two", "Nosferatu", "Wicked"
    ],
    "Best Animated Feature Film": [
      "Flow", "Inside Out 2", "Memoir of a Snail", "Wallace & Gromit: Vengeance Most Fowl", "The Wild Robot"
    ],
    "Best International Feature Film": [
      "I'm Still Here", "The Girl With the Needle", "Emilia Pérez", "The Seed of the Sacred Fig", "Flow"
    ],
    "Best Documentary Short Film": [
      "Death by Numbers", "I Am Ready, Warden", "Incident", "Instruments of a Beating Heart", "The Only Girl in the Orchestra"
    ],
    "Best Documentary Feature Film": [
      "Black Box Diaries", "No Other Land", "Porcelain War", "Soundtrack to a Coup d'Etat", "Sugarcane"
    ],
    "Best Original Song": [
      "Emilia Pérez", "The Six Triple Eight", "Sing Sing", "Emilia Pérez", "Elton John: Never Too Late"
    ],
    "Best Supporting Actress": [
      "A Complete Unknown", "Wicked", "The Brutalist", "Conclave", "Emilia Pérez"
    ],
    "Best Original Screenplay": [
      "Anora", "The Brutalist", "A Real Pain", "September 5", "The Substance"
    ],
    "Best Adapted Screenplay": [
      "A Complete Unknown", "Conclave", "Emilia Pérez", "Nickel Boys", "Sing Sing"
    ],
    "Best Animated Short Film": [
      "Beautiful Men", "In the Shadow of the Cypress", "Magic Candies", "Wander to Wonder", "Yuck!"
    ],
    "Best Live Action Short Film": [
      "A Lien", "Anuja", "I'm Not a Robot", "The Last Ranger", "The Man Who Could Not Remain Silent"
    ],
    "Best Original Score": [
      "The Brutalist", "Conclave", "Emilia Pérez", "Wicked", "The Wild Robot"
    ],
    "Best Makeup and Hairstyling": [
      "A Different Man", "Emilia Pérez", "Nosferatu", "The Substance", "Wicked"
    ],
    "Best Costume Design": [
      "A Complete Unknown", "Conclave", "Gladiator II", "Nosferatu", "Wicked"
    ],
    "Best Supporting Actor": [
      "Anora", "A Real Pain", "A Complete Unknown", "The Brutalist", "The Apprentice"
    ]
  };

  @override
  void initState() {
    super.initState();
    // First initialize entries
    _initializeEntries();
    
    // Then load watched list and set initial index
    MovieCache.loadWatchedList().then((watchedList) {
      if (mounted) {
        setState(() {
          _watchedMovies = watchedList;
          if (entries.isNotEmpty) {
            currentIndex = Random().nextInt(entries.length);
          }
        });
      }
    });

    // Finally load cache and preload data
    MovieCache.loadCache().then((loadedCache) {
      if (mounted) {
        setState(() => cache = loadedCache);
        _preloadData();
      }
    }).catchError((error) {
      print('Error loading cache: $error');
      if (mounted) {
        _preloadData();
      }
    });

    // Load ratings in parallel
    _loadRatings();
  }

  void _initializeEntries() {
    entries.clear();
    
    categories.forEach((category, movieTitles) {
      for (String movieTitle in movieTitles) {
        if (imdbIds.containsKey(movieTitle)) {
          entries.add({
            'imdbId': imdbIds[movieTitle]!,
            'movieTitle': movieTitle,
            'category': category,
          });
        }
      }
    });

    imdbIds.forEach((movieTitle, imdbId) {
      if (!entries.any((entry) => entry['movieTitle'] == movieTitle)) {
        entries.add({
          'imdbId': imdbId,
          'movieTitle': movieTitle,
          'category': 'Uncategorized',
        });
      }
    });
  }

  Future<void> _preloadData() async {
    final client = await _createSecureClient();
    try {
      await Future.wait(
        entries.map((entry) => _loadMovieData(entry['imdbId'], client)),
      );
    } finally {
      client.close();
      await MovieCache.saveCache(cache);
    }
    setState(() => isLoading = false);
  }

  Future<http.Client> _createSecureClient() async {
    final httpClient = HttpClient();
    if (Platform.isWindows) {
      httpClient.badCertificateCallback = 
        (X509Certificate cert, String host, int port) => true;
    }
    return IOClient(httpClient);
  }

  Future<void> _loadMovieData(String movieId, http.Client client) async {
    if (cache.containsKey(movieId)) return;

    try {
      final response = await client.get(
        Uri.parse("https://www.imdb.com/title/$movieId/"),
        headers: {
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
              "AppleWebKit/537.36 (KHTML, like Gecko) "
              "Chrome/91.0.4472.124 Safari/537.36",
          "Accept-Language": "en-US,en;q=0.9",
        },
      );

      if (response.statusCode != 200) return;

      final jsonData = _extractJsonData(response.body);
      if (jsonData == null) return;

      setState(() {
        cache[movieId] = {
          "imdb_url": "https://www.imdb.com/title/$movieId/",
          "title": _cleanText(jsonData["name"]?.toString()),
          "rating": jsonData["aggregateRating"]?["ratingValue"]?.toString() ?? "N/A",
          "duration": _formatDuration(jsonData["duration"]?.toString() ?? ""),
          "genres": (jsonData["genre"] as List<dynamic>?)?.join(", ") ?? "N/A",
          "plot": _cleanText(jsonData["description"]?.toString()),
          "image_url": _extractImageUrl(response.body),
        };
      });
    } catch (e) {
      print('Error loading data for $movieId: $e');
    }
  }

  String _formatDuration(String duration) {
    return duration
        .replaceAll("PT", "")
        .replaceAll("H", "h ")
        .replaceAll("M", "m")
        .trim();
  }

  String? _extractImageUrl(String html) {
    final regex = RegExp(r'<meta property="og:image" content="(.*?)"');
    final match = regex.firstMatch(html);
    return match?.group(1);
  }

  Map<String, dynamic>? _extractJsonData(String html) {
    try {
      final regex = RegExp(r'<script type="application/ld\+json">(.*?)</script>', dotAll: true);
      final match = regex.firstMatch(html);
      return match == null ? null : json.decode(match.group(1)!);
    } catch (e) {
      print('Error parsing JSON: $e');
      return null;
    }
  }

  void _navigate(int direction) {
    setState(() {
      currentIndex = (currentIndex + direction).clamp(0, entries.length - 1);
    });
  }

  void _randomEntry() {
    final unwatchedEntries = entries.where((entry) => !_watchedMovies.contains(entry['imdbId'])).toList();
    
    if (unwatchedEntries.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No unwatched movies'),
          content: const Text('You\'ve watched all available movies!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    setState(() {
      currentIndex = entries.indexOf(unwatchedEntries[Random().nextInt(unwatchedEntries.length)]);
    });
  }

  Future<void> _loadRatings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ratingsStr = prefs.getString('movie_ratings');
      if (ratingsStr != null) {
        setState(() {
          _ratings = Map<String, double>.from(json.decode(ratingsStr));
        });
      }
    } catch (e) {
      print('Error loading ratings: $e');
      // Initialize empty ratings if there's an error
      setState(() {
        _ratings = {};
      });
    }
  }

  Future<void> _saveRating(String movieId, double rating) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ratings[movieId] = rating;
    });
    await prefs.setString('movie_ratings', json.encode(_ratings));
  }

  Widget _buildStarRating(String movieId) {
    final rating = _ratings[movieId] ?? 0.0;
    
    return Column(
      children: [
        Text(
          'Rating: ${rating > 0 ? rating.toStringAsFixed(1) : "Not rated"}',
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,  // Increased from 16
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),  // Increased from 8
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reset rating button
            GestureDetector(
              onTap: () => _saveRating(movieId, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),  // Increased from 8
                child: Icon(
                  Icons.refresh,
                  color: Colors.grey[600],
                  size: 24,  // Increased from 20
                ),
              ),
            ),
            const SizedBox(width: 8),  // Added spacing
            ...List.generate(10, (index) {
              final value = (index + 1).toDouble();
              final halfValue = value - 0.5;
              
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTapDown: (details) {
                    // Calculate if click is on left or right half of the star
                    final box = context.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(details.globalPosition);
                    final isLeftHalf = localPosition.dx % 28 < 14; // Adjusted for new size
                    _saveRating(movieId, isLeftHalf ? halfValue : value);
                  },
                  child: Icon(
                    rating >= value 
                        ? Icons.star
                        : rating >= halfValue 
                            ? Icons.star_half
                            : Icons.star_border,
                    color: Colors.amber,
                    size: 28,  // Increased from 24
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = entries[currentIndex];
    final cachedData = cache[entry['imdbId']];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "The 97th Academy Awards",
          style: TextStyle(
            color: Colors.amber,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNominationInfo(entry),
                      const SizedBox(height: 20),
                      _buildNavigationControls(),
                      const SizedBox(height: 20),
                      _buildPoster(cachedData),
                      const SizedBox(height: 20),
                      _buildMovieDetails(cachedData, entry),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildNominationInfo(Map<String, dynamic> entry) {
    return Column(
      children: [
        const Text(
          "Nomination",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          entry['category'],
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          _cleanText(entry['movieTitle']),
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationControls() {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 600;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildControlButton(
            "Previous", 
            Icons.arrow_back, 
            () => _navigate(-1),
            isDesktop: isDesktop
          ),
          SizedBox(width: isDesktop ? 20 : 0),
          _buildControlButton(
            "Random", 
            Icons.shuffle, 
            _randomEntry,
            isDesktop: isDesktop
          ),
          SizedBox(width: isDesktop ? 20 : 0),
          _buildControlButton(
            "Next", 
            Icons.arrow_forward, 
            () => _navigate(1),
            isDesktop: isDesktop
          ),
        ],
      );
    });
  }

  Widget _buildControlButton(String text, IconData icon, VoidCallback action, {required bool isDesktop}) {
    return ElevatedButton.icon(
      icon: Icon(
        icon, 
        color: Colors.amber, 
        size: isDesktop ? 24 : 20
      ),
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isDesktop ? 16 : 12,
          height: 1.0,
        ),
      ),
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 16 : 8,
          vertical: isDesktop ? 0 : 4,
        ),
        alignment: Alignment.center,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildPoster(Map<String, dynamic>? data) {
    final imageUrl = data?["image_url"] as String?;
    return Container(
      width: 250,
      height: 375,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
            )
          : const Center(child: Text("Image unavailable", style: TextStyle(color: Colors.white))),
    );
  }

  Widget _buildMovieDetails(Map<String, dynamic>? data, Map<String, dynamic> entry) {
    final isWatched = _watchedMovies.contains(entry['imdbId']);
    
    return Column(
      children: [
        Text(
          _cleanText(data?["title"]),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        if (data?["imdb_url"] != null)
          InkWell(
            onTap: () => launchUrl(Uri.parse(data!["imdb_url"])),
            child: const Text(
              "🔗 View on IMDb",
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        const SizedBox(height: 10),
        Text(
          "⭐ ${data?["rating"] ?? "N/A"}/10",
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          "⏱️ ${data?["duration"] ?? "N/A"} | 🎭 ${data?["genres"] ?? "N/A"}",
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        _buildStarRating(entry['imdbId']),  // Moved here for better flow
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SizedBox(
              width: 700,
              child: Text(
                _cleanText(data?["plot"]) ?? "No synopsis available",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            setState(() {
              if (isWatched) {
                _watchedMovies.remove(entry['imdbId']);
              } else {
                _watchedMovies.add(entry['imdbId']);
              }
            });
            MovieCache.saveWatchedList(_watchedMovies.toList());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isWatched ? Colors.amber.withOpacity(0.2) : Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isWatched ? Colors.amber : Colors.grey[600]!,
                width: 1
              )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isWatched ? Icons.check_circle : Icons.check_circle_outline,
                  color: isWatched ? Colors.amber : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isWatched ? "Watched" : "Mark as watched",
                  style: TextStyle(
                    color: isWatched ? Colors.amber : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieCache {
  static Map<String, dynamic> _cache = {};
  static const String _cacheFileName = 'movie_cache.json';
  static const String _watchedFileName = 'watched_movies.json';

  static Future<String> _getValidDirectory() async {
    if (Platform.isAndroid) {
      return (await getApplicationDocumentsDirectory()).path;
    }
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  static Future<Map<String, dynamic>> loadCache() async {
    try {
      final dirPath = await _getValidDirectory();
      final file = File(p.join(dirPath, _cacheFileName));
      if (await file.exists()) {
        return json.decode(await file.readAsString());
      }
      return {};
    } catch (e) {
      print('Error loading cache: $e');
      return {};
    }
  }

  static Future<void> saveCache(Map<String, dynamic> cacheData) async {
    try {
      final dirPath = await _getValidDirectory();
      final file = File(p.join(dirPath, _cacheFileName));
      await file.writeAsString(json.encode(cacheData));
    } catch (e) {
      print('Error saving cache: $e');
    }
  }

  static Future<void> saveWatchedList(List<String> watchedIds) async {
    try {
      final dirPath = await _getValidDirectory();
      final file = File(p.join(dirPath, _watchedFileName));
      await file.writeAsString(json.encode(watchedIds));
    } catch (e) {
      print('Error saving watched list: $e');
    }
  }

  static Future<Set<String>> loadWatchedList() async {
    try {
      final dirPath = await _getValidDirectory();
      final file = File(p.join(dirPath, _watchedFileName));
      if (await file.exists()) {
        final List<dynamic> data = json.decode(await file.readAsString());
        return data.cast<String>().toSet();
      }
      return {};
    } catch (e) {
      print('Error loading watched list: $e');
      return {};
    }
  }
}