
// import 'package:agri_app/crop_prediction_screen.dart';

// import 'package:agri_app/crop_price_prediction_screen.dart';
// import 'package:agri_app/crop_disease_prediction_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'login_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomeContent(),
    
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FarmConnect',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Booked'),
          BottomNavigationBarItem(icon: Icon(Icons.connect_without_contact), label: 'Connect'),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Prajwal"),
            accountEmail: const Text("prajwal.2242046@viit.ac.in"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/farmer.png'),
            ),
            decoration: const BoxDecoration(color: Colors.green),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage()));
            },
          ),
          ListTile(
                leading: const Icon(Icons.description_outlined, color: Colors.green),
                title: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => TermsPage()),
                  // );
                },
              ),
          ListTile(
                leading: const Icon(Icons.description_outlined, color: Colors.green),
                title: Text(
                  'Help & Support',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HelpSupportPage()),
                  // );
                },
              ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),

        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWelcomeHeader(),
          _buildCarousel(),
          _buildFeatureCards(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: const Center(
        child: Text(
          'Welcome to FarmConnect',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
      ),
      items: [1, 2, 3].map((i) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.green[100 * i],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Event $i',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // children: [
        //   _buildFeatureCard(context, Icons.water_drop, 'Crop Yield Prediction', const CropPredictionScreen()),
        //   _buildFeatureCard(context, Icons.currency_exchange, 'Market Trends', const CropPricePredictionScreen()),
        //   // _buildFeatureCard(context, Icons.health_and_safety, 'Disease Detection', const CropDiseasePredictionScreen()),
        // ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String label, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.green),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
        ),
      ),
    );
  }
}
