import 'package:flutter/material.dart';
import 'package:frontend/Services/api_Services.dart';
import 'package:frontend/Services/auth_Service.dart';
import 'package:frontend/Screens/banquet_form_screen.dart';
import 'package:frontend/Screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  late Future<Map<String, dynamic>?> _userFuture;
  late Future<List<dynamic>> _categoriesFuture;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _userFuture = _authService.getUser();
    _categoriesFuture = _apiService.getCategories();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  void _logout() {
    _authService.logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildHeader(isLoading: true);
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return _buildHeader(name: 'Guest', hasError: true);
              }
              final user = snapshot.data!;
              return _buildHeader(name: user['name'] ?? 'No Name');
            },
          ),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildHeader({bool isLoading = false, String? name, bool hasError = false}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      name ?? 'Error',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
              PopupMenuButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    isLoading || name == null ? '' : name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onSelected: (value) {
                  if (value == 'logout') {
                    _logout();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPlanCard(),
          const SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildPlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Free plan',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('You have 3 bids left.',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Bid left: 3',
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            _buildCategoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    const initialCategories = [
      {
        "name": "BANQUETS & VENUES",
        "image":
            "https://images.unsplash.com/photo-1523580494863-6f3031224c94?q=80&w=2070&auto=format&fit=crop"
      },
      {
        "name": "Travel & Stay",
        "image":
            "https://images.unsplash.com/photo-1439130490301-25e322d88054?q=80&w=1932&auto=format&fit=crop"
      },
      {
        "name": "Corporate Events",
        "image":
            "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?q=80&w=2070&auto=format&fit=crop"
      },
      {
        "name": "Music & Entertainment",
        "image":
            "https://images.unsplash.com/photo-1511379938547-c1f69419868d?q=80&w=2070&auto=format&fit=crop"
      }
    ];

    return FutureBuilder<List<dynamic>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        List<dynamic> categories;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          categories = initialCategories;
        } else {
          categories = snapshot.data!;
        }

        final filteredCategories = categories
            .where((category) =>
                category['name']
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery))
            .toList();

        if (filteredCategories.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            var category = filteredCategories[index];
            return _buildCategoryCard(
              category['name'],
              category['image'],
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BanquetFormScreen()),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
