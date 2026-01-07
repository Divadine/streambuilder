import 'dart:io';
import 'package:flutter/material.dart';
import '../models/users.dart';

class UserCard extends StatelessWidget {
  final Users user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage:
          user.profilePic != null ? FileImage(File(user.profilePic!)) : null,
          child: user.profilePic == null
              ? const Icon(Icons.person, size: 30)
              : null,
        ),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(
            '${user.gender} • ${user.selectedState?.name ?? "-"}, ${user.selectedCity?.name ?? "-"}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Delete User"),
                content: const Text("Are you sure you want to delete this user?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      onDelete();
                      Navigator.pop(context);
                    },
                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
        onTap: onEdit,
      ),
    );
  }
}
