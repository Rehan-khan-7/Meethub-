import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../widgets/deskverse_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final String workspaceId;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.workspaceId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController jobController;
  late final TextEditingController phoneController;
  late final TextEditingController locationController;

  String selectedGender = 'Male';

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    jobController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    jobController.dispose();
    phoneController.dispose();
    locationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.user.name.isNotEmpty
        ? widget.user.name[0].toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      // Simple Profile header
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF202538),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202538),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          children: [
            // Profile avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFFEAF1FF),
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2879D8),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.user.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202538),
              ),
            ),

            const SizedBox(height: 22),

            // Form card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E3EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Full Name'),
                  _buildTextField(
                    controller: nameController,
                    hint: 'Full Name',
                  ),

                  const SizedBox(height: 16),

                  _buildLabel('Email Address'),
                  _buildTextField(
                    controller: emailController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // Job Title + Gender
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Job Title'),
                            _buildTextField(
                              controller: jobController,
                              hint: 'Job',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Gender'),
                            _buildGenderDropdown(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Phone + Work Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Phone Number'),
                            _buildTextField(
                              controller: phoneController,
                              hint: 'Number',
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Work Location'),
                            _buildTextField(
                              controller: locationController,
                              hint: 'Work Location',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF202538),
                              side: const BorderSide(color: Color(0xFFD9DDE7)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2879D8),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Same bottom navigation as other screens
      bottomNavigationBar: DeskVerseBottomNav(
        currentIndex: 4,
        user: widget.user,
        workspaceId: widget.workspaceId,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF202538),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: Color(0xFF202538)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF858B9D)),
          filled: true,
          fillColor: const Color(0xFFF0EFFA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD8D5EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD8D5EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2879D8)),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return SizedBox(
      height: 48,
      child: DropdownButtonFormField<String>(
        initialValue: selectedGender,
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF73798C)),
        style: const TextStyle(fontSize: 13, color: Color(0xFF202538)),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF0EFFA),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD8D5EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD8D5EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2879D8)),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedGender = value;
            });
          }
        },
      ),
    );
  }

  void _saveChanges() {
    final updatedUser = User(
      id: widget.user.id,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      role: widget.user.role,
    );

    Navigator.pop(context, updatedUser);
  }
}
