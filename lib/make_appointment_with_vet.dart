import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MakeAppointmentWithVetPage extends StatefulWidget {
  final String vetId;

  MakeAppointmentWithVetPage({required this.vetId});

  @override
  _MakeAppointmentWithVetPageState createState() => _MakeAppointmentWithVetPageState();
}

class _MakeAppointmentWithVetPageState extends State<MakeAppointmentWithVetPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isAvailable = true;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _confirmAppointment() async {
    final vetDoc = await FirebaseFirestore.instance.collection('vets').doc(widget.vetId).get();
    final openingTime = TimeOfDay(
      hour: vetDoc['openingTime']['hour'],
      minute: vetDoc['openingTime']['minute'],
    );
    final closingTime = TimeOfDay(
      hour: vetDoc['closingTime']['hour'],
      minute: vetDoc['closingTime']['minute'],
    );

    if (selectedTime != null && selectedDate != null) {
      final selectedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      if (selectedTime!.hour < openingTime.hour || selectedTime!.hour > closingTime.hour) {
        setState(() {
          isAvailable = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Not Available"),
            content: const Text("The selected time is outside of the vet's available hours."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        await FirebaseFirestore.instance.collection('appointments').add({
          'vetId': widget.vetId,
          'date': selectedDateTime,
          'time': selectedTime!.format(context),
          // Add other necessary fields as needed
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Appointment Confirmed"),
            content: const Text("Your appointment has been confirmed."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make Appointment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _selectDate,
              child: Text(selectedDate == null ? "Select Date" : selectedDate!.toLocal().toString().split(' ')[0]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text(selectedTime == null ? "Select Time" : selectedTime!.format(context)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _confirmAppointment,
              child: const Text("Confirm Appointment"),
            ),
          ],
        ),
      ),
    );
  }
}
