import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shifty/pages/home/search_page.dart';

import '../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required void Function() onLogout})
      : _onLogout = onLogout,
        super(key: key);

  final void Function() _onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: {
          0: const Text('Profile'),
          1: const Text('Search'),
          2: const Text('Payments'),
        }[_selectedPage],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              switch (_selectedPage) {
                case 1:
                  return const SearchPage();
                case 2:
                  return const Center(child: Text('Payments'));
                default:
                  return const Center(child: Text('Profile'));
              }
            }
            else if (snapshot.hasError) {
              return buildLoginError();
            }
            return const LinearProgressIndicator(minHeight: 15);
          },
          future: _loadUser(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments_outlined),
            label: 'Payments',
          )
        ],
        currentIndex: _selectedPage,
        onTap: (index) => setState(() => _selectedPage = index),
        showSelectedLabels: false,
      ),
    );
  }

  Widget buildLoginError() => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'There was an error loading your profile. Please login again.'),
                  ElevatedButton(
                    onPressed: widget._onLogout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );

  Future<void> _loadUser() async {
    if (User.instance != null) return;

    const storage = FlutterSecureStorage();
    if (!(await storage.containsKey(key: 'id'))) {
      throw Exception('No user found');
    }

    final fields = await storage.readAll();
    final email = fields['email']!;
    final id = fields['id']!;
    final password = fields['password']!;

    User.instance = await User.create(email, id, password);
  }
}
