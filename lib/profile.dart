import 'package:flutter/material.dart';
import 'login_page.dart';
import 'search.dart';
import 'calender.dart';
import 'map.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 4;
  bool _showSettings = false;
  final List<String> _travelBadges = [
    'Globetrotter',
    'Adventure Seeker',
    'Food Explorer',
    'Photography Pro',
    'Local Expert'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[50],
              ),
            ),
          ),
          
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[50],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header matching login page style
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MyApp()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.arrow_back, size: 22),
                          ),
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showSettings = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.more_vert, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Profile Content
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue.shade100,
                                  width: 3,
                                ),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://images.fineartamerica.com/images-medium-large-5/5-mona-lisa-leonardo-da-vinci.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Harshali Patil',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '@travelwithharshali',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('128', 'Trips'),
                            _buildStatItem('24', 'Countries'),
                            _buildStatItem('1.2K', 'Followers'),
                            _buildStatItem('356', 'Following'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Travel Badges Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Travel Badges',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _travelBadges.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _getBadgeColor(index),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getBadgeIcon(index),
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _travelBadges[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Recent Memories Section with Indian Cities
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Memories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: 8, // For 8 cities
                          itemBuilder: (context, index) {
                            return _buildMemoryItem(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Settings Panel
          if (_showSettings)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Settings Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, size: 20),
                              onPressed: () {
                                setState(() {
                                  _showSettings = false;
                                });
                              },
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Settings Content
                      Expanded(
                        child: ListView(
                          children: [
                            _buildSettingsOption(
                              Icons.person_outline,
                              'Edit Profile',
                              Colors.blue,
                            ),
                            _buildSettingsOption(
                              Icons.notifications_none,
                              'Notifications',
                              Colors.orange,
                            ),
                            _buildSettingsOption(
                              Icons.lock_outline,
                              'Privacy',
                              Colors.purple,
                            ),
                            _buildSettingsOption(
                              Icons.help_outline,
                              'Help Center',
                              Colors.green,
                            ),
                            _buildSettingsOption(
                              Icons.info_outline,
                              'About',
                              Colors.red,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 32),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[50],
                                  foregroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: () {},
                                child: const Text('Log Out'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      
      // Bottom Navigation Bar matching login page style
      bottomNavigationBar: Container(
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
            _buildNavItem(Icons.home_outlined, 'Home', 0),
            _buildNavItem(Icons.search, 'Explore', 1),
            _buildNavItem(Icons.map, 'Map', 2),
            _buildNavItem(Icons.calendar_month, 'Calendar', 3),
            _buildNavItem(Icons.person, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryItem(int index) {
    // List of city images with direct image URLs
    final List<Map<String, String>> cityData = [
      {
        'name': 'Jaipur, Rajasthan',
        'image': 'https://www.tourism.rajasthan.gov.in/content/dam/rajasthan-tourism/english/city/explore/113.jpg',
      },
      {
        'name': 'Mumbai, Maharashtra',
        'image': 'https://www.fabhotels.com/blog/wp-content/uploads/2018/09/Gateway-of-India-1.jpg',
      },
      {
        'name': 'Pune, Maharashtra',
        'image': 'https://www.holidify.com/images/bgImages/PUNE.jpg',
      },
      {
        'name': 'Jodhpur, Rajasthan',
        'image': 'https://www.tourism.rajasthan.gov.in/content/dam/rajasthan-tourism/english/city/explore/123.jpg',
      },
      {
        'name': 'Delhi, India',
        'image': 'https://www.holidify.com/images/bgImages/DELHI.jpg',
      },
      {
        'name': 'Kochi, Kerala',
        'image': 'https://static.toiimg.com/photo/81695811.cms',
      },
      {
        'name': 'Varanasi, Uttar Pradesh',
        'image': 'https://www.holidify.com/images/bgImages/VARANASI.jpg',
      },
      {
        'name': 'Udaipur, Rajasthan',
        'image': 'https://www.tourism.rajasthan.gov.in/content/dam/rajasthan-tourism/english/city/explore/121.jpg',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(cityData[index]['image']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cityData[index]['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, 
                        color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${(index + 1) * 23}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.comment_outlined, 
                        color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${(index + 1) * 5}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(IconData icon, String title, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
        
       if (index == 1) { // Search index
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage1()),
          );
        } else if (index == 2) { // Map index
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapApp()),
          );
        } else if (index == 3) { // Calendar index
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MemoryCalendarApp()),
          );
        } else if (index == 4) { // Profile index
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.black : Colors.grey,
            size: isSelected ? 26 : 24,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBadgeColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];
    return colors[index % colors.length];
  }

  IconData _getBadgeIcon(int index) {
    List<IconData> icons = [
      Icons.public,
      Icons.landscape,
      Icons.restaurant,
      Icons.camera_alt,
      Icons.people,
    ];
    return icons[index % icons.length];
  }
}