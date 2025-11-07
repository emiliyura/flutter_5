import 'package:flutter/material.dart';

class BookingStepIndicator extends StatelessWidget {
  final int currentStep;

  const BookingStepIndicator({
    super.key,
    required this.currentStep,
  });

  Widget _buildStepCircle(BuildContext context, int stepNumber, bool isActive) {
    final isCurrent = currentStep == stepNumber;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrent
            ? Theme.of(context).colorScheme.primary
            : (isActive ? Colors.green : Colors.grey.shade300),
      ),
      child: Center(
        child: isActive && !isCurrent
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : Text(
                '$stepNumber',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(context, 1, currentStep >= 1),
        Container(width: 40, height: 2, color: currentStep > 1 ? Colors.green : Colors.grey.shade300),
        _buildStepCircle(context, 2, currentStep >= 2),
        Container(width: 40, height: 2, color: currentStep > 2 ? Colors.green : Colors.grey.shade300),
        _buildStepCircle(context, 3, currentStep >= 3),
      ],
    );
  }
}

