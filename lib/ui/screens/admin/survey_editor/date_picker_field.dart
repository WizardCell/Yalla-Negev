import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueSetter<DateTime> onDateSelected;

  const DatePickerField({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ListTile(
          title: Text(selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : 'Select date'),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
