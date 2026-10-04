import 'package:flutter/material.dart';

import '../../home/screens/home_screen.dart';
import '../../../services/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Auth service
  final AuthService authService = AuthService();

  // UI states
  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Login function
  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await authService.login(email, password);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed. Please check your credentials."),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // HEADER
              // --------------------------------------------------

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    // Logo
                    Transform.rotate(
                      angle: 0.785398,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F5FF3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      "DeskVerse",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B2B48),
                      ),
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------
              // ILLUSTRATION CARD
              // --------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  padding: const EdgeInsets.only(left: 18, top: 18, bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7EEFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "YOUR VIRTUAL HQ",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2458F5),
                                letterSpacing: 0.4,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "A little closer.\nA lot together.",
                              style: TextStyle(
                                fontSize: 21,
                                height: 1.05,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B2B48),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Illustration
                      SizedBox(
                        width: 140,
                        height: 125,
                        child: Image.asset(
                          "assets/office.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // WELCOME TEXT
              // --------------------------------------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B2B48),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  "Log in and pick up where your team left off.",
                  style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // EMAIL LABEL
              // --------------------------------------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  "Work email",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF26364F),
                  ),
                ),
              ),

              const SizedBox(height: 7),

              // --------------------------------------------------
              // EMAIL FIELD
              // --------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    hintText: "Enter your email",

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDCE3EF)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDCE3EF)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2F5FF3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // PASSWORD LABEL
              // --------------------------------------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF26364F),
                  ),
                ),
              ),

              const SizedBox(height: 7),

              // --------------------------------------------------
              // PASSWORD FIELD
              // --------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: TextField(
                  controller: passwordController,

                  obscureText: obscurePassword,

                  decoration: InputDecoration(
                    hintText: "Enter your password",

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },

                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,

                        color: const Color(0xFF718096),
                        size: 21,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDCE3EF)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDCE3EF)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2F5FF3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // --------------------------------------------------
              // FORGOT PASSWORD
              // --------------------------------------------------
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 22),
                  child: TextButton(
                    onPressed: () {
                      // Forgot password later
                    },

                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),

                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2458F5),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // --------------------------------------------------
              // LOGIN BUTTON
              // --------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SizedBox(
                  width: double.infinity,
                  height: 51,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleLogin,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F5FF3),
                      disabledBackgroundColor: const Color(0xFF9DB4F7),

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // --------------------------------------------------
              // DIVIDER + COMPANY ACCOUNT
              // --------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFDCE3EF))),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "or use your company account",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blueGrey.shade400,
                        ),
                      ),
                    ),

                    const Expanded(child: Divider(color: Color(0xFFDCE3EF))),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // SSO BUTTON
              // --------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: OutlinedButton(
                    onPressed: () {
                      // SSO later
                    },

                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,

                      side: const BorderSide(color: Color(0xFFDCE3EF)),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.business_outlined,
                          size: 20,
                          color: Color(0xFF718096),
                        ),

                        SizedBox(width: 9),

                        Text(
                          "Continue with SSO",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF26364F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // SIGNUP
              // --------------------------------------------------
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "New to DeskVerse? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF718096),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2458F5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
