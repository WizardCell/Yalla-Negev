import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  final String label;
  final int? initialValue;
  final ValueSetter<int?> onSaved;

  const NumberField({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          initialValue: initialValue?.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label),
          onSaved: (value) => onSaved(int.tryParse(value!)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
