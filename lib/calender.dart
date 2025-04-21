import 'package:flutter/material.dart';
import 'login_page.dart'; // Import for the HomePage
import 'search.dart';
import 'map.dart';
import 'profile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MemoryCalendarApp());
}

class MemoryCalendarApp extends StatelessWidget {
  const MemoryCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const CalendarScreen(),
    );
  }
}

class Memory {
  final String id;
  final DateTime date;
  final String imageAsset; // For placeholder or asset images
  final File? imageFile;   // For captured/selected images
  final String note;

  Memory({
    required this.id,
    required this.date,
    this.imageAsset = 'placeholder',
    this.imageFile,
    this.note = '',
  });
}

// Simple date formatter to avoid intl dependency
class DateFormatter {
  static String formatMonthYear(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  static String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with SingleTickerProviderStateMixin {
  final Map<DateTime, List<Memory>> _memories = {};
  DateTime _selectedDate = DateTime.now();
  String _newNote = '';
  int _currentNavIndex = 3; // Calendar selected by default (index 3)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  File? _selectedImage; // To store the selected image

  @override
  void initState() {
    super.initState();
    _loadSampleMemories();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadSampleMemories() {
    final now = DateTime.now();

    final sampleMemories = [
      Memory(
        id: '1',
        date: DateTime(now.year, now.month, now.day - 2),
        imageAsset: 'placeholder',
        note: 'Wonderful day at the park with family.',
      ),
      Memory(
        id: '2',
        date: DateTime(now.year, now.month, now.day - 5),
        imageAsset: 'placeholder',
        note: 'Dinner with friends at that new Italian restaurant downtown.',
      ),
      Memory(
        id: '3',
        date: DateTime(now.year, now.month, now.day),
        imageAsset: 'placeholder',
        note: 'Today\'s morning walk by the lake was refreshing.',
      ),
    ];

    for (var memory in sampleMemories) {
      _addMemoryToMap(memory);
    }
  }

  void _addMemoryToMap(Memory memory) {
    final date = DateTime(
      memory.date.year,
      memory.date.month,
      memory.date.day,
    );

    if (_memories[date] == null) {
      _memories[date] = [];
    }
    _memories[date]!.add(memory);
  }

  // Improved image picking function that properly saves the image
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      try {
        // Get application documents directory for more permanent storage
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(pickedFile.path);
        final savedImagePath = '${appDir.path}/$fileName';
        
        // Copy the image to our app's directory
        final savedImage = await File(pickedFile.path).copy(savedImagePath);
        
        setState(() {
          _selectedImage = savedImage;
        });
        
        // Show a snackbar to confirm the image was selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image selected successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Show error if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _addMemory() {
    _selectedImage = null;
    _newNote = '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.add_photo_alternate, color: Colors.blue.shade700),
            const SizedBox(width: 10),
            const Text('Create New Memory', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${DateFormatter.formatDate(_selectedDate)}',
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),
                  
                  // Image preview with improved visual feedback
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _selectedImage == null ? Colors.grey.shade200 : null,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedImage == null ? Colors.grey.shade400 : Colors.blue.shade400,
                        width: 1,
                      ),
                    ),
                    child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Add an image',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                  
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          offset: const Offset(0, 2),)
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write your memory here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                        prefixIcon: const Icon(Icons.edit_note, color: Colors.blue),
                      ),
                      maxLines: 5,
                      onChanged: (value) {
                        _newNote = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await _pickImage(ImageSource.camera);
                          // Update the dialog state to show the selected image
                          setDialogState(() {});
                        },
                        color: Colors.blue.shade100,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        child: Icon(Icons.camera_alt, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 15),
                      MaterialButton(
                        onPressed: () async {
                          await _pickImage(ImageSource.gallery);
                          // Update the dialog state to show the selected image
                          setDialogState(() {});
                        },
                        color: Colors.green.shade100,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        child: Icon(Icons.photo_library, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Clear selected image when canceling
              _selectedImage = null;
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_newNote.isNotEmpty) {
                final memory = Memory(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: _selectedDate,
                  imageAsset: _selectedImage == null ? 'placeholder' : '',
                  imageFile: _selectedImage,
                  note: _newNote,
                );
                setState(() {
                  _addMemoryToMap(memory);
                  _animationController.reset();
                  _animationController.forward();
                });
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Memory saved successfully!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                // Show error if note is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please write a note for your memory'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
                return; // Don't dismiss dialog
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save Memory'),
          ),
        ],
      ),
    );
  }

  bool _hasMemoriesOnDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _memories[normalizedDate]?.isNotEmpty ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildEnhancedCalendar(),
            const Divider(height: 1),
            Expanded(
              child: _buildEnhancedMemoriesList(),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemory,
        tooltip: 'Add Memory',
        backgroundColor: Colors.blue.shade600,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
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
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.camera_alt_outlined, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedCalendar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      DateFormatter.formatMonthYear(_selectedDate),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month - 1,
                            _selectedDate.day,
                          );
                          _animationController.reset();
                          _animationController.forward();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month + 1,
                            _selectedDate.day,
                          );
                          _animationController.reset();
                          _animationController.forward();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCalendarDays(),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildCalendarDates(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDays() {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dayNames
          .map((day) => Container(
                width: 40,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarDates() {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    int firstWeekday = firstDayOfMonth.weekday - 1;
    final lastDay = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final weeksNeeded = ((lastDay + firstWeekday) / 7).ceil();

    return Column(
      children: List.generate(weeksNeeded, (weekIndex) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (dayIndex) {
              final day = weekIndex * 7 + dayIndex + 1 - firstWeekday;

              if (day < 1 || day > lastDay) {
                return const SizedBox(width: 40, height: 40);
              }

              final date = DateTime(_selectedDate.year, _selectedDate.month, day);
              final isToday = DateTime.now().year == date.year &&
                  DateTime.now().month == date.month &&
                  DateTime.now().day == date.day;
              final isSelected = _selectedDate.year == date.year &&
                  _selectedDate.month == date.month &&
                  _selectedDate.day == date.day;
              final hasMemory = _hasMemoriesOnDate(date);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                    _animationController.reset();
                    _animationController.forward();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade700,
                            ],
                          )
                        : isToday
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.shade200,
                                  Colors.blue.shade300,
                                ],
                              )
                            : null,
                    color: isSelected || isToday ? null : Colors.transparent,
                    boxShadow: isSelected || isToday
                        ? [
                            BoxShadow(
                              color: Colors.blue.shade200.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TextStyle(
                          color: isSelected || isToday
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: isSelected || isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (hasMemory)
                        Positioned(
                          bottom: 6,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected || isToday
                                  ? Colors.white
                                  : Colors.blue.shade600,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade100.withOpacity(0.5),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildEnhancedMemoriesList() {
    final selectedDateNormalized = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final memories = _memories[selectedDateNormalized] ?? [];

    if (memories.isEmpty) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade50,
                ),
                child: Icon(
                  Icons.photo_album_outlined,
                  size: 80,
                  color: Colors.blue.shade300,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No memories for ${DateFormatter.formatDate(_selectedDate)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addMemory,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Create a memory'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: memories.length,
        itemBuilder: (context, index) {
          final memory = memories[index];
          
          final List<Color> cardColors = [
            Colors.blue.shade50,
            Colors.green.shade50,
            Colors.amber.shade50,
            Colors.purple.shade50,
            Colors.teal.shade50,
          ];
          final List<Color> borderColors = [
            Colors.blue.shade200,
            Colors.green.shade200,
            Colors.amber.shade200,
            Colors.purple.shade200,
            Colors.teal.shade200,
          ];
          
          final colorIndex = index % cardColors.length;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: borderColors[colorIndex],
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: memory.imageFile != null
                            ? Image.file(
                                memory.imageFile!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Handle image loading errors gracefully
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          cardColors[colorIndex],
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Image not available',
                                            style: TextStyle(color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      cardColors[colorIndex],
                                      Colors.white,
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 70,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            DateFormatter.formatDate(memory.date),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColors[colorIndex].withOpacity(0.4),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          memory.note,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Edit memory functionality
                              _editMemory(memory);
                            },
                            icon: Icon(Icons.edit, color: Colors.blue.shade700),
                            tooltip: 'Edit memory',
                          ),
                          IconButton(
                            onPressed: () {
                              // Delete memory functionality
                              _deleteMemory(memory);
                            },
                            icon: Icon(Icons.delete, color: Colors.red.shade400),
                            tooltip: 'Delete memory',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Add edit memory functionality
  void _editMemory(Memory memory) {
    _selectedImage = memory.imageFile;
    _newNote = memory.note;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.edit, color: Colors.blue.shade700),
            const SizedBox(width: 10),
            const Text('Edit Memory', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${DateFormatter.formatDate(memory.date)}',
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),
                  
                  // Image preview with improved visual feedback
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _selectedImage == null ? Colors.grey.shade200 : null,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedImage == null ? Colors.grey.shade400 : Colors.blue.shade400,
                        width: 1,
                      ),
                    ),
                    child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Add an image',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                  
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          offset: const Offset(0, 2),)
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write your memory here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                        prefixIcon: const Icon(Icons.edit_note, color: Colors.blue),
                      ),
                      maxLines: 5,
                      controller: TextEditingController(text: _newNote),
                      onChanged: (value) {
                        _newNote = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await _pickImage(ImageSource.camera);
                          // Update the dialog state to show the selected image
                          setDialogState(() {});
                        },
                        color: Colors.blue.shade100,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        child: Icon(Icons.camera_alt, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 15),
                      MaterialButton(
                        onPressed: () async {
                          await _pickImage(ImageSource.gallery);
                          // Update the dialog state to show the selected image
                          setDialogState(() {});
                        },
                        color: Colors.green.shade100,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        child: Icon(Icons.photo_library, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_newNote.isNotEmpty) {
                // Update the memory with new data
                setState(() {
                  // Find the memory in the map and update it
                  final date = DateTime(memory.date.year, memory.date.month, memory.date.day);
                  if (_memories[date] != null) {
                    final index = _memories[date]!.indexWhere((m) => m.id == memory.id);
                    if (index != -1) {
                      _memories[date]![index] = Memory(
                        id: memory.id,
                        date: memory.date,
                        imageAsset: _selectedImage == null ? 'placeholder' : '',
                        imageFile: _selectedImage,
                        note: _newNote,
                      );
                    }
                  }
                  _animationController.reset();
                  _animationController.forward();
                });
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Memory updated successfully!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                // Show error if note is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please write a note for your memory'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
                return; // Don't dismiss dialog
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Update Memory'),
          ),
        ],
      ),
    );
  }

  // Add delete memory functionality
  void _deleteMemory(Memory memory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.delete, color: Colors.red.shade400),
            const SizedBox(width: 10),
            const Text('Delete Memory', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Are you sure you want to delete this memory?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Find the memory in the map and remove it
                final date = DateTime(memory.date.year, memory.date.month, memory.date.day);
                if (_memories[date] != null) {
                  _memories[date]!.removeWhere((m) => m.id == memory.id);
                  // If no memories left for this date, remove the date entry
                  if (_memories[date]!.isEmpty) {
                    _memories.remove(date);
                  }
                }
                _animationController.reset();
                _animationController.forward();
              });
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Memory deleted successfully!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
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
          _buildNavItem(Icons.home, index: 0, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          }),
          _buildNavItem(Icons.video_library, index: 1, onTap: () {
            _launchInstagramReels();
          }),
          _buildNavItem(Icons.map, index: 2, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MapPage()),
            );
          }),
          _buildNavItem(Icons.calendar_month, index: 3, onTap: () {
            // Already on calendar page
          }),
          _buildNavItem(Icons.person_outline, index: 4, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {
    required int index,
    required VoidCallback onTap,
  }) {
    bool isSelected = _currentNavIndex == index;
    
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

// Placeholder classes to complete imports
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Login Page - Placeholder'),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Search Page - Placeholder'),
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Map Page - Placeholder'),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Page - Placeholder'),
      ),
    );
  }
}
