// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, avoid_print, use_build_context_synchronously, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String currentUsername = ''; // To track the admin username
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<List<User>> fetchUsers(String collectionName) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    final List<QueryDocumentSnapshot> documents = snapshot.docs;
    return documents.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return User(
        id: doc.id,
        username: data['username']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
      );
    }).toList();
  }

  void login(String username) {
    // Simulating a login functionality
    setState(() {
      currentUsername = username;
    });
  }

  Future<void> addUser(String username, String email) async {
    // Simulating adding a user functionality
    final DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .add({'username': username, 'email': email});
    final String userId = docRef.id;
    print('User added with ID: $userId');
  }

  Future<void> addAdvisor(String username, String email) async {
    // Simulating adding an advisor functionality
    final DocumentReference docRef = await FirebaseFirestore.instance
        .collection('advisors')
        .add({'username': username, 'email': email});
    final String userId = docRef.id;
    print('Advisor added with ID: $userId');
  }

  Future<void> removeUser(String userId) async {
    // Simulating removing a user functionality
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  Future<void> removeAdvisor(String advisorId) async {
    // Simulating removing an advisor functionality
    await FirebaseFirestore.instance.collection('advisors').doc(advisorId).delete();
  }

  void logout() {
    // Simulating a logout functionality
    setState(() {
      currentUsername = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUsername.isEmpty) {
      // Show login screen
      return Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Login',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => login(usernameController.text),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      );
    } else {
      // Show admin dashboard
      return Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $currentUsername',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'User Management',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Add User'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await addUser(
                              usernameController.text,
                              emailController.text,
                            );
                            Navigator.pop(context);
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Add User'),
              ),
              SizedBox(height: 8),
              FutureBuilder<List<User>>(
                future: fetchUsers('users'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Text('No users found');
                  }
                  final users = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user.username),
                        subtitle: Text(user.email),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeUser(user.id),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => logout(),
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class User {
  final String id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });
}
