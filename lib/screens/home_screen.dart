import 'package:flutter/material.dart';
import 'package:fullproject/database/database_helper.dart';
import 'package:fullproject/screens/add_edit_user.dart';
import 'package:fullproject/screens/user_detail.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    DatabaseHelper.instance.refreshUsers();
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
      body: StreamBuilder(
        stream: DatabaseHelper.instance.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Users"));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, i) => UserCard(
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
            ),
          );
        },
      ),
    );
  }
}
