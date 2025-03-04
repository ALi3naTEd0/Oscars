class OscarWinners {
  // Map containing the official winners for the 97th Academy Awards
  static final Map<String, String> winners = {
    // Best Picture
    "Best Picture": "Anora",
    
    // Acting Categories
    "Best Actor": "The Brutalist", // Adrien Brody
    "Best Actress": "Anora", // Mikey Madison
    "Best Supporting Actor": "A Real Pain", // Kieran Culkin
    "Best Supporting Actress": "Emilia Pérez", // Zoe Saldaña
    
    // Directing and Writing
    "Best Director": "Anora", // Sean Baker
    "Best Original Screenplay": "Anora", // Sean Baker
    "Best Adapted Screenplay": "Conclave", // Peter Straughan
    
    // Other Major Categories
    "Best International Feature Film": "I'm Still Here", // Brazil
    "Best Animated Feature Film": "Flow", // Gints Zilbalodis
    "Best Documentary Feature Film": "No Other Land", // Basel Adra, Rachel Szor, Yuval Abraham
    "Best Visual Effects": "Dune: Part Two", // Paul Lambert, Gerd Nefzer, Tristan Myles
    
    // Technical Categories
    "Best Cinematography": "The Brutalist", // Lol Crawley
    "Best Film Editing": "Anora", // Sean Baker
    "Best Sound": "Dune: Part Two", // Gareth John, Richard King
    "Best Production Design": "Wicked", // Nathan Crowley, Lee Sandales
    "Best Costume Design": "Wicked", // Paul Tazewell
    "Best Makeup and Hairstyling": "The Substance", // Pierre-Olivier Persin, Stéphanie Guillon
    "Best Original Score": "The Brutalist", // Daniel Blumberg
    "Best Original Song": "Emilia Pérez", // "El Mal" by Clément Ducol, Camille, Jacques Audiard
    
    // Short Films
    "Best Animated Short Film": "In the Shadow of the Cypress", // Shirin Sohani
    "Best Live Action Short Film": "I'm Not a Robot", // Victoria Warmerdam
    "Best Documentary Short Film": "The Only Girl in the Orchestra", // Molly O'Brien
  };

  // Check if a movie is a winner in a specific category
  static bool isWinner(String category, String movieTitle) {
    return winners[category] == movieTitle;
  }
}
