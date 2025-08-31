import 'package:flutter/material.dart';

class HeaderHalfImage extends StatelessWidget {
  final String assetPath;
  final double heightFactor; // default 0.5
  final String? title;

  const HeaderHalfImage({
    super.key,
    required this.assetPath,
    this.heightFactor = 0.5,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * heightFactor;
    return SizedBox(
      height: h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            child: Image.asset(assetPath, fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              color: Colors.black.withOpacity(0.25),
            ),
          ),
          if (title != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 32, // atur manual, misalnya 28–32 px
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ],
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
