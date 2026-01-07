import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_edit_user.dart';
import '../models/users.dart';
import 'user_detail.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    DatabaseHelper.instance.showUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditUserScreen()),
          );
        },
      ),
      body: StreamBuilder<List<Users>>(
        stream: DatabaseHelper.instance.userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Users Available"));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, i) {
              return UserCard(
                user: users[i],
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditUserScreen(user: users[i]),
                    ),
                  );
                },
                onDelete: () =>
                    DatabaseHelper.instance.deleteUser(users[i].id!),
              );
            },
          );
        },
      ),
    );
  }
}
