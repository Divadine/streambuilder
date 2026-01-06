import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fullproject/models/users.dart';

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
          backgroundImage: user.profilePic != null
              ? FileImage(File(user.profilePic!))
              : null,
          child: user.profilePic == null
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(
            '${user.gender} • ${user.selectedState?.name}, ${user.selectedCity?.name}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onEdit,
      ),
    );
  }
}
