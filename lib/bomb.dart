import 'package:flutter/material.dart';

class Bomb extends StatelessWidget {
  const Bomb({
    super.key,
    required this.isOpened,
    required this.callback,
  });

  final bool isOpened;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            color: isOpened
                ? Colors.grey[900]
                : const Color.fromARGB(255, 255, 237, 42),
            child: isOpened
                ? const Icon(
                    Icons.brightness_high_outlined,
                    size: 32,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
