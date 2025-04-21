import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calender.dart';
import 'profile.dart';

class MapApp extends StatefulWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  State<MapApp> createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> with SingleTickerProviderStateMixin {
  String? selectedLocation;
  final List<double> _currentLocation = [18.488121, 73.895973];
  double _zoomLevel = 1.0;
  Offset _offset = Offset.zero;
  late TransformationController _transformationController;
  int _currentNavIndex = 2; // Map is at index 2

  // Define key destinations with approximate positions on our custom map
  final Map<String, List<double>> _destinations = {
    'Shivneri Fort': [0.25, 0.2],
    'Jejuri': [0.7, 0.65],
    'Sinhagad Fort': [0.5, 0.5],
    'Lavasa': [0.8, 0.3],
    'Khadakwasla Dam': [0.3, 0.7],
  };

  // Actual geographical coordinates for launching maps
  final Map<String, List<double>> _geoCoordinates = {
    'Shivneri Fort': [19.1924, 73.8548],
    'Jejuri': [18.2748, 74.1591],
    'Sinhagad Fort': [18.3664, 73.7548],
    'Lavasa': [18.4096, 73.5072],
    'Khadakwasla Dam': [18.4421, 73.7690],
  };

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _launchMapsUrl(String destinationName) async {
    final coords = _geoCoordinates[destinationName]!;
    final lat = coords[0];
    final lng = coords[1];
    
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      final fallbackUrl = Uri.parse('https://maps.google.com/?q=$lat,$lng');
      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch maps');
      }
    }
  }

  void _resetZoom() {
    setState(() {
      _transformationController.value = Matrix4.identity();
    });
  }

  void _centerOnCurrentLocation() {
    setState(() {
      _transformationController.value = Matrix4.identity();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Centered on current location')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 4.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    painter: MapPainter(),
                  ),
                  ..._buildDestinationMarkers(),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.5,
                    top: MediaQuery.of(context).size.height * 0.5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.5 - 15,
                    top: MediaQuery.of(context).size.height * 0.5 - 15,
                    child: _buildPulseAnimation(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 150,
            child: Column(
              children: [
                _buildZoomControl(Icons.add, () {
                  setState(() {
                    final currentScale = _transformationController.value.getMaxScaleOnAxis();
                    if (currentScale < 4.0) {
                      _transformationController.value = Matrix4.identity()
                        ..scale(currentScale + 0.5);
                    }
                  });
                }),
                const SizedBox(height: 8),
                _buildZoomControl(Icons.remove, () {
                  setState(() {
                    final currentScale = _transformationController.value.getMaxScaleOnAxis();
                    if (currentScale > 0.5) {
                      _transformationController.value = Matrix4.identity()
                        ..scale(currentScale - 0.5);
                    }
                  });
                }),
                const SizedBox(height: 8),
                _buildZoomControl(Icons.refresh, _resetZoom),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.arrow_back, size: 22),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.red),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello Harshali!',
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
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.language, size: 22),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (selectedLocation != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 20,
              right: 20,
              child: _buildLocationInfoCard(selectedLocation!),
            ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _destinations.keys.map((destination) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildLocationCard(
                      destination,
                      '$destination, Maharashtra',
                      () {
                        setState(() {
                          selectedLocation = destination;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: _centerOnCurrentLocation,
          child: const Icon(Icons.my_location, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPulseAnimation() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 30),
      duration: const Duration(seconds: 1),
      builder: (context, double value, child) {
        return Container(
          width: value,
          height: value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(1 - value / 30),
          ),
        );
      },
      onEnd: () {
        setState(() {});
      },
    );
  }
  
  Widget _buildZoomControl(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
  
  List<Widget> _buildDestinationMarkers() {
    List<Widget> markers = [];
    
    _destinations.forEach((name, position) {
      final isSelected = name == selectedLocation;
      
      markers.add(
        Positioned(
          left: MediaQuery.of(context).size.width * position[0],
          top: MediaQuery.of(context).size.height * position[1],
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedLocation = name;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.location_on,
                color: isSelected ? Colors.white : Colors.red,
                size: isSelected ? 36 : 30,
              ),
            ),
          ),
        ),
      );
      
      markers.add(
        Positioned(
          left: MediaQuery.of(context).size.width * position[0] - 40,
          top: MediaQuery.of(context).size.height * position[1] + 32,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    });
    
    return markers;
  }

  Widget _buildLocationInfoCard(String destination) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16/9,
              child: _getDestinationImage(destination),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getDestinationDescription(destination),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _launchMapsUrl(destination);
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text('Directions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedLocation = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDestinationImage(String destination) {
    Color bgColor;
    IconData icon;
    
    switch (destination) {
      case 'Shivneri Fort':
        bgColor = Colors.amber[700]!;
        icon = Icons.castle;
        break;
      case 'Jejuri':
        bgColor = Colors.orange[800]!;
        icon = Icons.temple_hindu;
        break;
      case 'Sinhagad Fort':
        bgColor = Colors.green[700]!;
        icon = Icons.landscape;
        break;
      case 'Lavasa':
        bgColor = Colors.blue[700]!;
        icon = Icons.location_city;
        break;
      case 'Khadakwasla Dam':
        bgColor = Colors.cyan[700]!;
        icon = Icons.water;
        break;
      default:
        bgColor = Colors.grey[700]!;
        icon = Icons.place;
    }
    
    return Container(
      color: bgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 8),
            Text(
              destination,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Tap for directions',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDestinationDescription(String destination) {
    switch (destination) {
      case 'Shivneri Fort':
        return 'Birthplace of Chhatrapati Shivaji Maharaj, this historic fort offers stunning views and significant cultural heritage. Located near Junnar in Pune district.';
      case 'Jejuri':
        return 'Famous for the Khandoba Temple, Jejuri is a religious site where devotees shower the deity with turmeric (bhandara) during festivals, creating a golden spectacle.';
      case 'Sinhagad Fort':
        return 'A historic fortress located southwest of Pune city. Its name means "Lion\'s Fort" and offers panoramic views of the surrounding landscape.';
      case 'Lavasa':
        return 'A planned city with Italian-style architecture, situated in the Western Ghats. Popular for its lakeside promenade and various recreational activities.';
      case 'Khadakwasla Dam':
        return 'A scenic dam and reservoir that supplies water to Pune. Popular weekend getaway with boating facilities and beautiful views of surrounding hills.';
      default:
        return 'A popular destination near Pune, Maharashtra.';
    }
  }

  Widget _buildLocationCard(String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 80,
                height: double.infinity,
                color: title == 'Shivneri Fort' 
                    ? Colors.amber[700]
                    : title == 'Jejuri'
                        ? Colors.orange[800]
                        : Colors.green[700],
                child: Center(
                  child: Icon(
                    title == 'Shivneri Fort'
                        ? Icons.castle
                        : title == 'Jejuri'
                            ? Icons.temple_hindu
                            : Icons.landscape,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.directions, size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 4),
                        Text(
                          'View details',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
      ),
    );
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
          _buildNavItem(Icons.home, index: 0, currentIndex: _currentNavIndex, onTap: () {
            Navigator.pop(context);
          }),
          _buildNavItem(Icons.video_library, index: 1, currentIndex: _currentNavIndex, onTap: () {
            _launchInstagramReels();
          }),
          _buildNavItem(Icons.map, index: 2, currentIndex: _currentNavIndex, onTap: () {
            // Already on map page
          }),
          _buildNavItem(Icons.calendar_month, index: 3, currentIndex: _currentNavIndex, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MemoryCalendarApp()),
            );
          }),
          _buildNavItem(Icons.person_outline, index: 4, currentIndex: _currentNavIndex, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    bool isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: onTap,
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

  Future<void> _launchInstagramReels() async {
    const String puneTags = 'https://www.instagram.com/explore/tags/pune/';
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
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
      
    final Paint waterPaint = Paint()
      ..color = const Color(0xFFBBDEFB)
      ..style = PaintingStyle.fill;
      
    final Paint parkPaint = Paint()
      ..color = const Color(0xFFA5D6A7)
      ..style = PaintingStyle.fill;
    
    Path waterPath = Path();
    waterPath.moveTo(size.width * 0.3, size.height * 0.2);
    waterPath.lineTo(size.width * 0.5, size.height * 0.1);
    waterPath.lineTo(size.width * 0.7, size.height * 0.2);
    waterPath.lineTo(size.width * 0.8, size.height * 0.4);
    waterPath.lineTo(size.width * 0.6, size.height * 0.5);
    waterPath.lineTo(size.width * 0.4, size.height * 0.4);
    waterPath.close();
    
    Path lakeCircle = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.7),
        width: size.width * 0.3,
        height: size.height * 0.2,
      ));
    
    canvas.drawPath(waterPath, waterPaint);
    canvas.drawPath(lakeCircle, waterPaint);
    
    Path parkPath1 = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.5),
        width: size.width * 0.15,
        height: size.height * 0.15,
      ));
    
    Path parkPath2 = Path();
    parkPath2.moveTo(size.width * 0.7, size.height * 0.8);
    parkPath2.lineTo(size.width * 0.8, size.height * 0.9);
    parkPath2.lineTo(size.width * 0.9, size.height * 0.8);
    parkPath2.lineTo(size.width * 0.8, size.height * 0.7);
    parkPath2.close();

    Path parkPath3 = Path();
    parkPath3.moveTo(size.width * 0.1, size.height * 0.85);
    parkPath3.lineTo(size.width * 0.3, size.height * 0.9);
    parkPath3.lineTo(size.width * 0.25, size.height * 0.97);
    parkPath3.lineTo(size.width * 0.05, size.height * 0.9);
    parkPath3.close();
    
    canvas.drawPath(parkPath1, parkPaint);
    canvas.drawPath(parkPath2, parkPaint);
    canvas.drawPath(parkPath3, parkPaint);
    
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.6),
      Offset(size.width, size.height * 0.6),
      roadPaint,
    );
    
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.15,
      roadPaint,
    );
    
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      roadPaint,
    );
    
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    textPainter.text = TextSpan(
      text: 'PUNE',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(size.width * 0.5 - textPainter.width / 2, size.height * 0.5 - textPainter.height / 2)
    );
    
    final cityStyle = TextStyle(
      color: Colors.black54,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    
    _drawText(canvas, 'Mumbai', size.width * 0.1, size.height * 0.15, cityStyle);
    _drawText(canvas, 'Nashik', size.width * 0.3, size.height * 0.15, cityStyle);
    _drawText(canvas, 'Aurangabad', size.width * 0.8, size.height * 0.1, cityStyle);
    _drawText(canvas, 'Satara', size.width * 0.6, size.height * 0.9, cityStyle);
    _drawText(canvas, 'Kolhapur', size.width * 0.2, size.height * 0.85, cityStyle);
  }
  
  void _drawText(Canvas canvas, String text, double x, double y, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}