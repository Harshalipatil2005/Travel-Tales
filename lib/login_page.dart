import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'db_helper.dart';
import 'package:flutter/services.dart';
import 'search.dart';
import 'map.dart';
import 'calender.dart';
import 'profile.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _selectedIndex = 0;
  int _currentNavIndex = 0;

  final List<String> _categories = [
    'All',
    'Top Destinations',
    'Favorite',
    'Saved',
    'Updates',  // Removed 'Nearest'
  ];

  // Updated destinations for Top Destinations section
  final List<Destination> _topDestinations = [
    Destination(
      imageUrl: 'https://www.pawnalakecamps.com/wp-content/uploads/2019/04/photo_6150133949872060136_y.jpg',
      name: 'Pawna Lake',
      likes: 8500,
      saves: 2100,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://tse4.mm.bing.net/th?id=OIP.stetvU5qsDW8pz0sdneV4QHaEo&pid=Api&P=0&h=180',
      name: 'Torna Fort',
      likes: 7800,
      saves: 1900,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://www.holidify.com/images/cmsuploads/compressed/shutterstock_1158772078_20190822134648.jpg',
      name: 'Tiger Point',
      likes: 7200,
      saves: 1800,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://oneday.travel/wp-content/uploads/one-day-pune-to-lavasa-tour-by-cab-header.jpg',
      name: 'Lavasa',
      likes: 6900,
      saves: 1700,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://imgmedia.lbb.in/media/2018/11/5bf6388ff329aa4cd2623057_1542862991571.jpg',
      name: 'Shivneri',
      likes: 6500,
      saves: 1600,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://www.gosahin.com/go/p/b/1517579553_Sinhagad-Fort1.jpg',
      name: 'Sinhagad',
      likes: 6300,
      saves: 1500,
      isLiked: false,
      isSaved: false,
    ),
  ];

  // Events for Updates section
  final List<Event> _events = [
    Event(
      imageUrl: 'https://www.yorkartgallery.org.uk/wp-content/uploads/sites/5/2019/06/CAG_New_Art_Installs_York_Museums-0029-scaled.jpg',
      name: 'Art Exhibition',
      date: 'Sept 23 - Oct 23',
    ),
    Event(
      imageUrl: 'https://i.ytimg.com/vi/3g9F56SZFhk/maxresdefault.jpg',
      name: 'Van Gogh 360',
      date: 'Sept 23 - Sept 30',
    ),
    Event(
      imageUrl: 'https://thisisauckland.com/wp-content/uploads/2020/08/Top-Fun-Flea-Markets-And-Antique-Shops-In-Auckland.jpeg',
      name: 'Flea Market',
      date: 'Oct 23 - Oct 28',
    ),
    Event(
      imageUrl: 'https://www.livenationentertainment.com/wp-content/uploads/2024/02/Static_FacebookPR_1200x630_DiljitDosanjh_2024_National.jpg',
      name: 'Dil-Luminati Tour',
      date: 'Nov 24',
    ),
    Event(
      imageUrl: 'https://media.insider.in/image/upload/c_crop,g_custom/v1708092891/gtppzavrdysybavrb1d1.png',
      name: 'The Under 25 Summit',
      date: 'Dec 15 - Dec 18',
    ),
  ];

  // Combined list for All section
  final List<Destination> _allDestinations = [
    Destination(
      imageUrl: 'https://www.pawnalakecamps.com/wp-content/uploads/2019/04/photo_6150133949872060136_y.jpg',
      name: 'Pawna Lake',
      likes: 8500,
      saves: 2100,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://tse4.mm.bing.net/th?id=OIP.stetvU5qsDW8pz0sdneV4QHaEo&pid=Api&P=0&h=180',
      name: 'Torna Fort',
      likes: 7800,
      saves: 1900,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://www.holidify.com/images/cmsuploads/compressed/shutterstock_1158772078_20190822134648.jpg',
      name: 'Tiger Point',
      likes: 7200,
      saves: 1800,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://oneday.travel/wp-content/uploads/one-day-pune-to-lavasa-tour-by-cab-header.jpg',
      name: 'Lavasa',
      likes: 6900,
      saves: 1700,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://imgmedia.lbb.in/media/2018/11/5bf6388ff329aa4cd2623057_1542862991571.jpg',
      name: 'Shivneri',
      likes: 6500,
      saves: 1600,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://www.gosahin.com/go/p/b/1517579553_Sinhagad-Fort1.jpg',
      name: 'Sinhagad',
      likes: 6300,
      saves: 1500,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://static2.tripoto.com/media/filter/nxl/img/585232/TripDocument/1526747211_5_parvati_temple_atop_of_the_hillock_in_the_scenic_view_6.jpg',
      name: 'Parvati Hill',
      likes: 6100,
      saves: 1400,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://www.fabhotels.com/blog/wp-content/uploads/2018/09/Lonavala.jpg',
      name: 'Lonavla',
      likes: 5900,
      saves: 1300,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://rishikeshdaytour.com/blog/wp-content/uploads/2024/07/Jejuri-Temple-Pune.jpg',
      name: 'Jejuri',
      likes: 5700,
      saves: 1200,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://www.oneindia.com/img/2016/08/khadakwasla-dam-05-1470394849.jpg',
      name: 'Khadakwasla Dam',
      likes: 5500,
      saves: 1100,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://pixahive.com/wp-content/uploads/2020/09/Arai-Hills-in-Pune-Forest-Trail-69580-pixahive-853x1024.jpg',
      name: 'Arai Hills',
      likes: 5300,
      saves: 1000,
      isLiked: false,
      isSaved: false,
    ),
    Destination(
      imageUrl: 'https://www.konkan.me/wp-content/uploads/2021/04/ramdara-temple-pune-loni-kalbhor.jpg',
      name: 'Ramdara Temple',
      likes: 5100,
      saves: 900,
      isLiked: false,
      isSaved: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryTabs(),
              if (_selectedIndex == 0) const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: WeatherWidget(),
              ),
              _buildDestinationsGridNonScrollable(),
              SizedBox(height: 80), // Add space for the bottom navigation bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.camera_alt_outlined, size: 22),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.red),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello Traveler!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    'Pune, Maharashtra',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Only language button now (Instagram Reels button removed)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.language, size: 22),
          ),
        ],
      ),
    );
  }

  // Method to launch Instagram Reels
  Future<void> _launchInstagramReels() async {
    // URL for Pune location or hashtag on Instagram
    const String puneTags = 'https://www.instagram.com/explore/tags/pune/';
    // If you prefer location-based URL:
    // const String puneLocation = 'https://www.instagram.com/explore/locations/213803427/pune-maharashtra-india/';
    
    final Uri url = Uri.parse(puneTags);
    
    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch Instagram. Make sure the app is installed.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage1()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Search place...',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _selectedIndex == index
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: _selectedIndex == index
                      ? Colors.black
                      : Colors.grey.shade600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinationsGridNonScrollable() {
    if (_selectedIndex == 4) { // Updates section
      return _buildEventsList();
    }
    
    List<Destination> displayedDestinations;
    
    if (_selectedIndex == 0) { // All section
      displayedDestinations = _allDestinations;
    } else if (_selectedIndex == 1) { // Top Destinations
      displayedDestinations = _topDestinations;
    } else if (_selectedIndex == 2) { // Favorite
      displayedDestinations = _allDestinations
          .where((destination) => destination.isLiked)
          .toList();
    } else if (_selectedIndex == 3) { // Saved
      displayedDestinations = _allDestinations
          .where((destination) => destination.isSaved)
          .toList();
    } else {
      displayedDestinations = _allDestinations;
    }

    if (displayedDestinations.isEmpty && _selectedIndex == 2) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No liked destinations yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Like some destinations to see them here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }
    
    if (displayedDestinations.isEmpty && _selectedIndex == 3) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No saved destinations yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save some destinations to see them here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: displayedDestinations.length,
        itemBuilder: (context, index) {
          final destination = displayedDestinations[index];
          return _buildDestinationCard(destination);
        },
      ),
    );
  }

  Widget _buildEventsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return _buildEventCard(event);
        },
      ),
    );
  }

  Widget _buildDestinationCard(Destination destination) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${destination.name}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              destination.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Text(
                destination.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (destination.isLiked) {
                              destination.likes--;
                              destination.isLiked = false;
                            } else {
                              destination.likes++;
                              destination.isLiked = true;
                            }
                          });
                        },
                        child: Icon(
                          destination.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: destination.isLiked ? Colors.red : Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(destination.likes),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (destination.isSaved) {
                              destination.saves--;
                              destination.isSaved = false;
                            } else {
                              destination.saves++;
                              destination.isSaved = true;
                            }
                          });
                        },
                        child: Icon(
                          destination.isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: destination.isSaved ? Colors.amber : Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(destination.saves),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              event.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                );
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.date,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      return '${countInK.toStringAsFixed(countInK.truncateToDouble() == countInK ? 0 : 1)}k';
    }
    return count.toString();
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      margin: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, index: 0),
          _buildNavItem(Icons.video_library, index: 1),  // Changed to video_library icon
          _buildNavItem(Icons.map, index: 2),
          _buildNavItem(Icons.calendar_month, index: 3),
          _buildNavItem(Icons.person_outline, index: 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {required int index}) {
    bool isSelected = _currentNavIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
        
        if (index == 1) {
          // Directly launch Instagram Reels
          _launchInstagramReels();
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapApp()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MemoryCalendarApp()),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (index != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getNavName(index)} feature coming soon!'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
  
  String _getNavName(int index) {
    switch (index) {
      case 0: return 'Home';
      case 1: return 'Reels';  // Changed from 'Search' to 'Reels'
      case 2: return 'Map';
      case 3: return 'Calendar';
      case 4: return 'Profile';
      default: return '';
    }
  }
}

class Destination {
  final String imageUrl;
  final String name;
  int likes;
  int saves;
  bool isLiked;
  bool isSaved;

  Destination({
    required this.imageUrl,
    required this.name,
    required this.likes,
    required this.saves,
    required this.isLiked,
    required this.isSaved,
  });
}
class Event {
  final String imageUrl;
  final String name;
  final String date;

  Event({
    required this.imageUrl,
    required this.name,
    required this.date,
  });
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Weather? _weather;
  final WeatherFactory _weatherFactory = WeatherFactory('99cd17ead708315e89e03a2d6deaa5de');
  Position? _currentPosition;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  Future<void> _initializeWeather() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Location services are disabled. Please enable them.';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permission denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permissions are permanently denied';
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 30),
      );

      Weather weather = await _weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weather = weather;
        _currentPosition = position;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _error = 'Failed to load weather data: $e';
        _isLoading = false;
      });
      debugPrint('Error getting weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        height: 100,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
            TextButton(
              onPressed: _initializeWeather,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_weather == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No weather data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFFA78A7F), // Matte clay/terracotta brown
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 6,
        spreadRadius: 1,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _weather?.areaName ?? 'Unknown Location',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE, d MMM').format(_weather!.date!),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${_weather!.temperature!.celsius?.round()}°C',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _getWeatherIcon(_weather!.weatherMain ?? 'Clear'),
                    size: 32,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Condition: ${
              _weather!.weatherDescription}',
            style: const TextStyle(
              fontSize: 14, 
              color: Colors.white,
            ),
          ),
          Text(
            'Humidity: ${_weather!.humidity}%',
            style: const TextStyle(
              fontSize: 14, 
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear': return Icons.wb_sunny;
      case 'clouds': return Icons.cloud;
      case 'rain': return Icons.water_drop;
      case 'drizzle': return Icons.grain;
      case 'thunderstorm': return Icons.flash_on;
      case 'snow': return Icons.ac_unit;
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog': return Icons.cloud_queue;
      case 'tornado': return Icons.tornado;
      case 'windy': return Icons.air;
      default: return Icons.wb_sunny;
    }
  }
}