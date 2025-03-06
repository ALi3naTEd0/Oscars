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
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';  // Add this import
import 'package:share_plus/share_plus.dart';    // Add this import
import 'oscar_winners.dart'; // Add this import
import 'user_data.dart';

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
  final GlobalKey _shareWidgetKey = GlobalKey();  // Change to normal GlobalKey
  int _lastFoundSongIndex = -1;

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

  // Add nomination titles mapping
  final Map<String, Map<String, String>> nominationTitles = {
    "Best Actor": {
      "The Brutalist": "The Brutalist (Adrien Brody)",
      "A Complete Unknown": "A Complete Unknown (Timothée Chalamet)",
      "Sing Sing": "Sing Sing (Colman Domingo)",
      "Conclave": "Conclave (Ralph Fiennes)",
      "The Apprentice": "The Apprentice (Sebastian Stan)"
    },
    "Best Supporting Actor": {
      "Anora": "Anora (Yura Borisov)",
      "A Real Pain": "A Real Pain (Kieran Culkin)",
      "A Complete Unknown": "A Complete Unknown (Edward Norton)",
      "The Brutalist": "The Brutalist (Guy Pearce)",
      "The Apprentice": "The Apprentice (Jeremy Strong)"
    },
    "Best Actress": {
      "Wicked": "Wicked (Cynthia Erivo)",
      "Emilia Pérez": "Emilia Pérez (Karla Sofía Gascón)",
      "Anora": "Anora (Mikey Madison)",
      "The Substance": "The Substance (Demi Moore)",
      "I'm Still Here": "I'm Still Here (Fernanda Torres)"
    },
    "Best Supporting Actress": {
      "A Complete Unknown": "A Complete Unknown (Monica Barbaro)",
      "Wicked": "Wicked (Ariana Grande)",
      "The Brutalist": "The Brutalist (Felicity Jones)",
      "Conclave": "Conclave (Isabella Rossellini)",
      "Emilia Pérez": "Emilia Pérez (Zoe Saldaña)"
    },
    "Best Director": {
      "Anora": "Anora (Sean Baker)",
      "The Brutalist": "The Brutalist (Brady Corbet)",
      "A Complete Unknown": "A Complete Unknown (James Mangold)",
      "Emilia Pérez": "Emilia Pérez (Jacques Audiard)",
      "The Substance": "The Substance (Coralie Fargeat)"
    },
    "Best Original Song": {
      // First appearance - El Mal (winner)
      "Emilia Pérez/0": "Emilia Pérez - 'El Mal' (Clément Ducol, Camille, Jacques Audiard)",
      "The Six Triple Eight": "The Six Triple Eight - 'The Journey' (Diane Warren)",
      "Sing Sing": "Sing Sing - 'Like A Bird' (Abraham Alexander, Adrian Quesada)",
      // Second appearance - Mi Camino
      "Emilia Pérez/1": "Emilia Pérez - 'Mi Camino' (Camille, Clément Ducol)",
      "Elton John: Never Too Late": "Elton John: Never Too Late - 'Never Too Late' (Elton John, Brandi Carlile, Andrew Watt, Bernie Taupin)"
    },
    "Best Cinematography": {
      "The Brutalist": "The Brutalist (Lol Crawley)",
      "Dune: Part Two": "Dune: Part Two (Greig Fraser)",
      "Emilia Pérez": "Emilia Pérez (Paul Guilhaume)",
      "Maria": "Maria (Ed Lachman)",
      "Nosferatu": "Nosferatu (Jarin Blaschke)"
    },
    "Best Costume Design": {
      "A Complete Unknown": "A Complete Unknown (Arianne Phillips)",
      "Conclave": "Conclave (Lisy Christl)",
      "Gladiator II": "Gladiator II (Janty Yates and Dave Crossman)",
      "Nosferatu": "Nosferatu (Linda Muir)",
      "Wicked": "Wicked (Paul Tazewell)"
    },
    "Best International Feature Film": {
      "I'm Still Here": "I'm Still Here (Brazil)",
      "The Girl With the Needle": "The Girl with the Needle (Denmark)",
      "Emilia Pérez": "Emilia Pérez (France)",
      "The Seed of the Sacred Fig": "The Seed of the Sacred Fig (Germany)",
      "Flow": "Flow (Latvia)"
    },
    "Best Makeup and Hairstyling": {
      "A Different Man": "A Different Man (Mike Marino, David Presto, Crystal Jurado)",
      "Emilia Pérez": "Emilia Pérez (Julia Floch Carbonel, Emmanuel Janvier)",
      "Nosferatu": "Nosferatu (David White, Traci Loader, Suzanne Stokes-Munton)",
      "The Substance": "The Substance (Pierre-Olivier Persin, Stéphanie Guillon)",
      "Wicked": "Wicked (Frances Hannon, Laura Blount, Sarah Nuth)"
    },
    "Best Original Score": {
      "The Brutalist": "The Brutalist (Daniel Blumberg)",
      "Conclave": "Conclave (Volker Bertelmann)",
      "Emilia Pérez": "Emilia Pérez (Clément Ducol and Camille)",
      "Wicked": "Wicked (John Powell and Stephen Schwartz)",
      "The Wild Robot": "The Wild Robot (Kris Bowers)"
    },
    "Best Production Design": {
      "The Brutalist": "The Brutalist (Judy Becker, Patricia Cuccia)",
      "Conclave": "Conclave (Suzie Davies, Cynthia Sleiter)",
      "Dune: Part Two": "Dune: Part Two (Patrice Vermette, Shane Vieau)",
      "Nosferatu": "Nosferatu (Craig Lathrop, Beatrice Brentnerová)",
      "Wicked": "Wicked (Nathan Crowley, Lee Sandales)"
    },
    "Best Sound": {
      "A Complete Unknown": "A Complete Unknown (Tod A. Maitland, Donald Sylvester)",
      "Dune: Part Two": "Dune: Part Two (Gareth John, Richard King)",
      "Emilia Pérez": "Emilia Pérez (Erwan Kerzanet, Aymeric Devoldère)",
      "Wicked": "Wicked (Simon Hayes, Nancy Nugent Title)",
      "The Wild Robot": "The Wild Robot (Randy Thom, Brian Chumney)"
    },
    "Best Adapted Screenplay": {
      "A Complete Unknown": "A Complete Unknown (James Mangold, Jay Cocks)",
      "Conclave": "Conclave (Peter Straughan)",
      "Emilia Pérez": "Emilia Pérez (Jacques Audiard, Thomas Bidegain, Léa Mysius)",
      "Nickel Boys": "Nickel Boys (RaMell Ross, Joslyn Barnes)",
      "Sing Sing": "Sing Sing (Clint Bentley, Greg Kwedar)"
    },
    "Best Original Screenplay": {
      "Anora": "Anora (Sean Baker)",
      "The Brutalist": "The Brutalist (Brady Corbet, Mona Fastvold)",
      "A Real Pain": "A Real Pain (Jesse Eisenberg)",
      "September 5": "September 5 (Moritz Binder, Tim Fehlbaum)",
      "The Substance": "The Substance (Coralie Fargeat)"
    },
    "Best Animated Short Film": {
      "Beautiful Men": "Beautiful Men (Nicolas Keppens, Brecht Van Elslande)",
      "In the Shadow of the Cypress": "In the Shadow of the Cypress (Shirin Sohani)",
      "Magic Candies": "Magic Candies (Daisuke Nishio, Takashi Washio)",
      "Wander to Wonder": "Wander to Wonder (Nina Gantz, Stienette Bosklopper)",
      "Yuck!": "Yuck! (Loïc Espuche, Juliette Marquet)"
    },
    "Best Picture": {
      "Anora": "Anora (Alex Coco, Samantha Quan, Sean Baker)",
      "The Brutalist": "The Brutalist (Nick Gordon, Brian Young, Andrew Morrison, Brady Corbet)",
      "A Complete Unknown": "A Complete Unknown (Fred Berger, James Mangold, Alex Heineman)",
      "Conclave": "Conclave (Tessa Ross, Juliette Howell, Michael A. Jackman)",
      "Dune: Part Two": "Dune: Part Two (Mary Parent, Cale Boyter, Tanya Lapointe, Denis Villeneuve)",
      "Emilia Pérez": "Emilia Pérez (Pascal Caucheteux, Jacques Audiard)",
      "I'm Still Here": "I'm Still Here (Maria Carlota Bruno, Rodrigo Teixeira)",
      "Nickel Boys": "Nickel Boys (Dede Gardner, Jeremy Kleiner, Joslyn Barnes)",
      "The Substance": "The Substance (Coralie Fargeat, Tim Bevan, Eric Fellner)",
      "Wicked": "Wicked (Marc Platt)"
    },
    "Best Animated Feature Film": {
      "Flow": "Flow (Gints Zilbalodis)",
      "Inside Out 2": "Inside Out 2 (Pete Docter, Kelsey Mann)",
      "Memoir of a Snail": "Memoir of a Snail (Adam Elliot)",
      "Wallace & Gromit: Vengeance Most Fowl": "Wallace & Gromit: Vengeance Most Fowl (Nick Park)",
      "The Wild Robot": "The Wild Robot (Chris Sanders)"
    },
    "Best Visual Effects": {
      "Alien: Romulus": "Alien: Romulus (Eric Barba, Nelson Sepulveda-Fauser, Daniel Macarin)",
      "Better Man": "Better Man (Luke Millar, David Clayton, Keith Herft)",
      "Dune: Part Two": "Dune: Part Two (Paul Lambert, Gerd Nefzer, Tristan Myles)",
      "Kingdom of the Planet of the Apes": "Kingdom of the Planet of the Apes (Dan Glass, Anders Langlands)",
      "Wicked": "Wicked (Dan Glass, Mike Chambers, Brian Connor)"
    },
    "Best Documentary Short Film": {
      "Death by Numbers": "Death by Numbers (Kim A. Snyder, Janique L. Robillard)",
      "I Am Ready, Warden": "I Am Ready, Warden (Smriti Mundhra, Maya Gnyp)",
      "Incident": "Incident (Bill Morrison, Jamie Kalven)",
      "Instruments of a Beating Heart": "Instruments of a Beating Heart (Ema Ryan Yamazaki)",
      "The Only Girl in the Orchestra": "The Only Girl in the Orchestra (Molly O'Brien)"
    },
    "Best Documentary Feature Film": {
      "Black Box Diaries": "Black Box Diaries (Shiori Ito, Eric Nyari)",
      "No Other Land": "No Other Land (Basel Adra, Rachel Szor, Yuval Abraham)",
      "Porcelain War": "Porcelain War (Brendan Bellomo, Slava Leontyev)",
      "Soundtrack to a Coup d'Etat": "Soundtrack to a Coup d'Etat (Johan Grimonprez)",
      "Sugarcane": "Sugarcane (Julian Brave NoiseCat, Emily Kassie)"
    },
    "Best Film Editing": {
      "Anora": "Anora (Sean Baker)",
      "The Brutalist": "The Brutalist (David Jancso)",
      "Conclave": "Conclave (Nick Emerson)",
      "Emilia Pérez": "Emilia Pérez (Juliette Welfling)",
      "Wicked": "Wicked (Myron Kerstein)"
    },
    "Best Live Action Short Film": {
      "A Lien": "A Lien (Sam Cutler-Kreutz, David Cutler-Kreutz)",
      "Anuja": "Anuja (Adam J. Graves, Suchitra Mattai)",
      "I'm Not a Robot": "I'm Not a Robot (Victoria Warmerdam)",
      "The Last Ranger": "The Last Ranger (Cindy Lee, Darwin Shaw)",
      "The Man Who Could Not Remain Silent": "The Man Who Could Not Remain Silent (Nebojša Slijepčević)"
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeEntries();
    
    UserData.loadWatchedMovies().then((watchedList) {
      if (mounted) {
        setState(() {
          _watchedMovies = watchedList;
          if (entries.isNotEmpty) {
            currentIndex = Random().nextInt(entries.length);
          }
        });
      }
    });

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

    UserData.loadRatings().then((loadedRatings) {
      if (mounted) {
        setState(() => _ratings = loadedRatings);
      }
    });
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
      // Reset the index when changing movies
      _lastFoundSongIndex = -1;
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
      // Reset the index when changing movies
      _lastFoundSongIndex = -1;
    });
  }

  Future<void> _saveRating(String movieId, double rating) async {
    await UserData.saveRating(movieId, rating);
    setState(() => _ratings[movieId] = rating);
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

  Future<void> _shareMovie(Map<String, dynamic> movieData, String imdbId) async {
    try {
      // Get poster image
      ui.Image? poster;
      if (movieData['image_url'] != null) {
        try {
          final response = await http.get(Uri.parse(movieData['image_url']));
          final bytes = response.bodyBytes;
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();
          poster = frame.image;
        } catch (e) {
          print('Error loading poster: $e');
        }
      }

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      // Adjust width based on platform
      final width = Platform.isAndroid ? 400.0 : 600.0;
      final size = Size(width, poster != null ? width * 1.3 : width);
      
      // Draw black background with amber border
      final bgPaint = Paint()..color = Colors.black;
      final borderPaint = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(Offset.zero & size, bgPaint);
      canvas.drawRect(Rect.fromLTWH(1, 1, size.width - 2, size.height - 2), borderPaint);

      // Draw header text
      final headerPainter = TextPainter(
        text: TextSpan(
          text: "The 97th Academy Awards\n",
          style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,  // Add this
      )..layout(maxWidth: size.width - 40);
      
      // Center header text horizontally
      final headerX = (size.width - headerPainter.width) / 2;
      headerPainter.paint(canvas, Offset(headerX, 20));

      double yOffset = headerPainter.height + 40;

      // Draw poster if available
      if (poster != null) {
        final posterRect = Rect.fromLTWH(
          (size.width - 200) / 2, // Center horizontally
          yOffset,
          200,
          300
        );
        canvas.drawImageRect(
          poster,
          Rect.fromLTWH(0, 0, poster.width.toDouble(), poster.height.toDouble()),
          posterRect,
          Paint(),
        );
        yOffset += 320; // Poster height + margin
      }

      // Draw movie info
      // Use app's title instead of IMDb title
      final movieTitle = entries[currentIndex]['movieTitle'];
      
      final textPainter = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${entries[currentIndex]['category']}\n",
              style: TextStyle(color: Colors.grey, fontSize: width * 0.027),
            ),
            TextSpan(
              text: "$movieTitle\n", // Removed extra \n
              style: TextStyle(color: Colors.white, fontSize: width * 0.033, fontWeight: FontWeight.bold),
            ),
            // Add nomination info if available, but extract only what's in parentheses
            if (nominationTitles[entries[currentIndex]['category']]?[movieTitle] != null)
              TextSpan(
                text: (nominationTitles[entries[currentIndex]['category']]![movieTitle] ?? '')
                    .replaceAll(RegExp(r'^.*?\('), '('), // Remove everything before the first parenthesis
                style: TextStyle(color: Colors.grey, fontSize: width * 0.025), // Changed from amber to grey
              ),
            // IMDb rating - en azul sin bold
            if (movieData["rating"] != null && movieData["rating"] != "N/A")
              TextSpan(
                text: "\nIMDb: ${movieData["rating"]}/10\n",
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: width * 0.025,
                ),
              ),
            // Personal rating - en amarillo normal (sin bold)
            if (_ratings[imdbId] != null)
              TextSpan(
                text: "My Rating: ${_ratings[imdbId]?.toStringAsFixed(1)}/10\n",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: width * 0.025,
                ),
              ),
            if (movieData['duration'] != null || movieData['genres'] != null)
              TextSpan(
                text: "\n${movieData['duration'] ?? ''} ${movieData['duration'] != null && movieData['genres'] != null ? '| ' : ''}${movieData['genres'] ?? ''}\n",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
          ],
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: size.width - 40);

      // Center text horizontally
      final textX = (size.width - textPainter.width) / 2;
      textPainter.paint(canvas, Offset(textX, yOffset));
      yOffset += textPainter.height + 20;

      // Draw synopsis
      if (movieData['plot'] != null) {
        final synopsisPainter = TextPainter(
          text: TextSpan(
            text: movieData['plot'],
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.justify,
        )..layout(maxWidth: size.width - 40);
        synopsisPainter.paint(canvas, Offset(20, yOffset));
      }

      // Generate and share image
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.width.toInt(), size.height.toInt());
      final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

      if (Platform.isAndroid) {
        final temp = await getTemporaryDirectory();
        final file = File('${temp.path}/oscars_share.png');
        await file.writeAsBytes(pngBytes!.buffer.asUint8List());
        await Share.shareXFiles([XFile(file.path)]);
      } else {
        // Desktop save dialog
        final String? savePath = await FilePicker.platform.saveFile(
          dialogTitle: 'Save image as',
          fileName: 'oscars_${movieData['title']?.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')}.png',
          type: FileType.custom,
          allowedExtensions: ['png'],
        );

        if (savePath != null) {
          final file = File(savePath);
          await file.writeAsBytes(pngBytes!.buffer.asUint8List());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Saved to: $savePath')),
          );
        }
      }
    } catch (e) {
      print('Error sharing: $e');
    }
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
                      _buildMovieDetails(cachedData, entry),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildNominationInfo(Map<String, dynamic> entry) {
    String? nominationTitle;
    
    if (entry['category'] == "Best Original Song" && entry['movieTitle'] == "Emilia Pérez") {
      final songList = categories["Best Original Song"]!;
      // Get the first occurrence index
      final firstIndex = songList.indexOf("Emilia Pérez");
      
      // Calculate if this is the first or second occurrence based on the current entry index
      final isFirstSong = entries.indexOf(entry) == entries.indexWhere(
        (e) => e['category'] == "Best Original Song" && e['movieTitle'] == "Emilia Pérez"
      );
      
      entry['songIndex'] = isFirstSong ? 0 : 1;

      nominationTitle = isFirstSong
          ? "Emilia Pérez - 'El Mal' (Clément Ducol, Camille, Jacques Audiard)"
          : "Emilia Pérez - 'Mi Camino' (Camille, Clément Ducol)";
    } else {
      nominationTitle = nominationTitles[entry['category']]?[entry['movieTitle']];
    }
    
    final bool isWinner = OscarWinners.isWinner(entry['category'], entry['movieTitle'], entry['songIndex']);
    
    return Column(
      children: [
        Text(
          isWinner ? "Winner" : "Nomination",
          style: TextStyle(
            color: isWinner ? Colors.amber : Colors.white,
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
        if (nominationTitle != null) 
          Text(
            nominationTitle,
            style: TextStyle(
              color: Colors.amber.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
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

  Widget _buildMovieDetails(Map<String, dynamic>? data, Map<String, dynamic> entry) {
    final isWatched = _watchedMovies.contains(entry['imdbId']);
    final bool isWinner = OscarWinners.isWinner(entry['category'], entry['movieTitle'], entry['songIndex']);
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,  // Cambiado de topCenter a bottomCenter
          children: [
            Container(
              width: 250,
              height: 375,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: data?["image_url"] != null
                ? CachedNetworkImage(
                    imageUrl: data!["image_url"],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                  )
                : const Center(child: Text("Image unavailable", style: TextStyle(color: Colors.white))),
            ),
            if (isWinner)
              Container(
                margin: const EdgeInsets.only(bottom: 10),  // Cambiado de top a bottom
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber, width: 1)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Oscar Winner 2025",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _cleanText(entry['movieTitle']), // Use entry's title instead of IMDb title
          style: TextStyle(
            color: isWinner ? Colors.amber : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          "⭐ ${data?["rating"] ?? "N/A"}/10",
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        if (data?["imdb_url"] != null)
          InkWell(
            onTap: () => launchUrl(Uri.parse(data!["imdb_url"])),
            child: const Text(
              "🔗 View on IMDb",
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        const SizedBox(height: 10),
        Text(
          "⏱️ ${data?["duration"] ?? "N/A"} | 🎭 ${data?["genres"] ?? "N/A"}",
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        _buildStarRating(entry['imdbId']),
        const SizedBox(height: 10),
        // Watched button moved here
        InkWell(
          onTap: () async {
            await UserData.toggleWatched(entry['imdbId']);
            setState(() {
              if (isWatched) {
                _watchedMovies.remove(entry['imdbId']);
              } else {
                _watchedMovies.add(entry['imdbId']);
              }
            });
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
        // Share button moved to the bottom
        InkWell(
          onTap: () => _shareMovie(data!, entry['imdbId']),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1
              )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.share,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Share",
                  style: TextStyle(
                    color: Colors.white70,
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
}