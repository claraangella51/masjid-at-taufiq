import 'package:flutter/material.dart';

class HadithCard extends StatelessWidget {
  final String text;
  final String narrator;

  const HadithCard({required this.text, required this.narrator, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xfffdfcf7), Color(0xfff4f1e8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: const Border(
          left: BorderSide(color: Color(0xffE6B566), width: 5),
        ),
      ),

      child: Stack(
        children: [
          /// Quote Ornament
          Positioned(
            right: -10,
            top: -20,
            child: Icon(
              Icons.format_quote,
              size: 90,
              color: Colors.black.withOpacity(0.05),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Row(
                children: const [
                  Text(
                    "Hadis Hari Ini",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Hadith Text
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 14),

              /// Narrator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff0F6A71).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "- $narrator",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0F6A71),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
