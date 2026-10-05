import 'package:flutter/material.dart';

import '../../../models/meeting.dart';

class MeetingLobbyScreen extends StatefulWidget {
  final Meeting meeting;

  const MeetingLobbyScreen({super.key, required this.meeting});

  @override
  State<MeetingLobbyScreen> createState() => _MeetingLobbyScreenState();
}

class _MeetingLobbyScreenState extends State<MeetingLobbyScreen> {
  bool isMicOn = true;
  bool isCameraOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text(
          'Meeting Lobby',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202538),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Text(
                widget.meeting.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF202538),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Check your camera and microphone before joining.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF73798C), fontSize: 14),
              ),

              const SizedBox(height: 28),

              // Camera Preview
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF202538),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: isCameraOn
                        ? const Icon(
                            Icons.person,
                            size: 90,
                            color: Colors.white54,
                          )
                        : const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.videocam_off,
                                size: 55,
                                color: Colors.white54,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Camera is off',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _controlButton(
                    icon: isMicOn ? Icons.mic : Icons.mic_off,
                    label: isMicOn ? 'Mic' : 'Muted',
                    onTap: () {
                      setState(() {
                        isMicOn = !isMicOn;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  _controlButton(
                    icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
                    label: isCameraOn ? 'Camera' : 'Camera Off',
                    onTap: () {
                      setState(() {
                        isCameraOn = !isCameraOn;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Join Meeting
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Meeting connection will be added with WebRTC.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D5FEF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Join Meeting',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE1E3EB)),
            ),
            child: Icon(icon, color: const Color(0xFF202538)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF73798C)),
        ),
      ],
    );
  }
}
