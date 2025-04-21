import 'package:flutter/material.dart';

class SearchPage1 extends StatefulWidget {
  const SearchPage1({Key? key}) : super(key: key);

  @override
  State<SearchPage1> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage1> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [
    'Mountain View',
  ];
  
  List<SearchCategory> _popularCategories = [
    SearchCategory(name: 'Mountains', icon: Icons.terrain),
    SearchCategory(name: 'Beaches', icon: Icons.beach_access),
    SearchCategory(name: 'Camping', icon: Icons.nights_stay),
    SearchCategory(name: 'Hiking', icon: Icons.directions_walk),
    SearchCategory(name: 'Cities', icon: Icons.location_city),
    SearchCategory(name: 'Parks', icon: Icons.park),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildRecentSearches(),
            _buildPopularCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'Search',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search places, activities, etc...',
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: IconButton(
              icon: const Icon(Icons.mic, color: Colors.grey),
              onPressed: () {
                // Voice search functionality would go here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voice search coming soon!'),
                  ),
                );
              },
            ),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                if (!_recentSearches.contains(value)) {
                  _recentSearches.insert(0, value);
                  if (_recentSearches.length > 5) {
                    _recentSearches.removeLast();
                  }
                }
              });
              _searchController.clear();
            }
          },
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_recentSearches.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _recentSearches = [];
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _recentSearches.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No recent searches',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentSearches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.history,
                        color: Colors.grey,
                      ),
                      title: Text(_recentSearches[index]),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _recentSearches.removeAt(index);
                          });
                        },
                      ),
                      onTap: () {
                        // Handle tapping on a recent search
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Searching for ${_recentSearches[index]}...'),
                          ),
                        );
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildPopularCategories() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: _popularCategories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(_popularCategories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(SearchCategory category) {
    return InkWell(
      onTap: () {
        // Handle category tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Browsing ${category.name}...'),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category.icon,
              color: Colors.blue.shade700,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchCategory {
  final String name;
  final IconData icon;

  SearchCategory({required this.name, required this.icon});
}