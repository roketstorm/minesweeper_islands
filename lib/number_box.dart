import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  const NumberBox({
    super.key,
    required this.child,
    required this.isOpened,
    required this.callback,
  });

  final int child;
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
                ? Colors.grey[50]
                : const Color.fromARGB(255, 255, 237, 42),
            child: Center(
              child: Text(
                isOpened ? (child == 0 ? '' : child.toString()) : '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: child == 1
                      ? Colors.blue
                      : (child == 2 ? Colors.green : Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
