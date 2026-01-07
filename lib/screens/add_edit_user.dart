import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/database_helper.dart';
import '../data/state_city_data.dart';
import '../models/users.dart';
import '../models/state_city.dart';
import '../streams/user_form_stream.dart';

class EditUserScreen extends StatefulWidget {
  final Users? user;

  const EditUserScreen({super.key, this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final dob = TextEditingController();

  late UserFormStream _formStream;

  @override
  void initState() {
    super.initState();
    _formStream = UserFormStream();

    if (widget.user != null) {
      firstName.text = widget.user!.firstName;
      lastName.text = widget.user!.lastName;
      phone.text = widget.user!.phone;
      password.text = widget.user!.password;
      dob.text = widget.user!.dob;

      if (widget.user!.profilePic != null) {
        _formStream.updateImage(File(widget.user!.profilePic!));
      }

      _formStream.updateGender(widget.user!.gender);
      if (widget.user!.selectedState != null) {
        _formStream.updateState(widget.user!.selectedState!);
      }
      if (widget.user!.selectedCity != null) {
        _formStream.updateCity(widget.user!.selectedCity!);
      }
      _formStream.updateAgree(true);
      _formStream.updatePassword(password.text);
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _formStream.updateImage(File(picked.path));
    }
  }

  @override
  void dispose() {
    _formStream.dispose();
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    password.dispose();
    dob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? "Add User" : "Edit User"),
      ),
      body: StreamBuilder<UserFormState>(
        stream: _formStream.stream,
        initialData: _formStream.currentState, // ✅ fixed getter
        builder: (context, snapshot) {
          final state = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage:
                      state.image != null ? FileImage(state.image!) : null,
                      child: state.image == null
                          ? const Icon(Icons.camera_alt, size: 30)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: firstName,
                    decoration: const InputDecoration(labelText: "First Name"),
                    validator: (v) =>
                    v == null || v.length < 3 ? "Min 3 chars" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastName,
                    decoration: const InputDecoration(labelText: "Last Name"),
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                    validator: (v) =>
                    v == null || v.length != 10 ? "10 digits required" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    onChanged: _formStream.updatePassword,
                    validator: (_) => state.passwordRules.containsValue(false)
                        ? "Password rules not met"
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.passwordRules.entries.map((e) {
                      return Row(
                        children: [
                          Icon(
                            e.value ? Icons.check : Icons.close,
                            color: e.value ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(e.key),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: dob,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "DOB"),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );
                      if (d != null) {
                        dob.text = "${d.day}/${d.month}/${d.year}";
                      }
                    },
                    validator: (v) =>
                    v == null || v.isEmpty ? "Select DOB" : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: state.gender,
                    hint: const Text("Select Gender"),
                    items: ['Male', 'Female', 'Other']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) _formStream.updateGender(v);
                    },
                    validator: (v) => v == null ? "Select gender" : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<StateModel>(
                    value: state.state,
                    hint: const Text("Select State"),
                    items: states
                        .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.name),
                    ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) _formStream.updateState(v);
                    },
                    validator: (v) => v == null ? "Select state" : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<CityModel>(
                    value: state.city,
                    hint: const Text("Select City"),
                    items: (state.state?.cities ?? [])
                        .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.name),
                    ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) _formStream.updateCity(v);
                    },
                    validator: (v) => v == null ? "Select city" : null,
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text("Agree & Accept"),
                    value: state.agree,
                    onChanged: (v) {
                      if (v != null) _formStream.updateAgree(v);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate() || !state.agree) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Complete all fields"),
                          ),
                        );
                        return;
                      }

                      final user = Users(
                        id: widget.user?.id,
                        firstName: firstName.text.trim(),
                        lastName: lastName.text.trim(),
                        phone: phone.text.trim(),
                        password: password.text.trim(),
                        gender: state.gender!,
                        dob: dob.text,
                        profilePic: state.image?.path,
                        selectedState: state.state,
                        selectedCity: state.city,
                      );

                      if (widget.user == null) {
                        await DatabaseHelper.instance.insertUser(user);
                      } else {
                        await DatabaseHelper.instance.updateUser(user);
                      }

                      Navigator.pop(context);
                    },
                    child: const Text("SAVE"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
