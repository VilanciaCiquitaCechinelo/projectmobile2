import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _usersRef;

  @override
  void initState() {
    super.initState();
    _usersRef = _firestore.collection('users'); // Collection users di Firestore
  }

  // Fungsi logout admin
  void _logout() async {
    await _auth.signOut();
    Navigator.pop(context); // Kembali ke halaman login
  }

  // Fungsi untuk menambah user
  void _addUser() {
    // Menampilkan dialog untuk menambahkan user
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController emailController = TextEditingController();
        TextEditingController passwordController = TextEditingController();
        return AlertDialog(
          title: Text('Tambah User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Menambahkan user baru
                  await _firestore.collection('users').add({
                    'email': emailController.text,
                    'password': passwordController.text,
                    'created_at': Timestamp.now(),
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('User berhasil ditambahkan!'),
                  ));
                } catch (e) {
                  print('Error: $e');
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus user
  void _deleteUser(String userId) {
    // Menghapus user berdasarkan ID
    _firestore.collection('users').doc(userId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('User berhasil dihapus!'),
    ));
  }

  // Fungsi untuk menampilkan data pengguna
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final users = snapshot.data!.docs;

        if (users.isEmpty) {
          return Center(child: Text('Tidak ada pengguna.'));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final userId = user.id;
            final email = user['email'];

            return ListTile(
              title: Text(email),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteUser(userId),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addUser,
              child: const Text('Tambah User'),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildUserList()),
          ],
        ),
      ),
    );
  }
}
