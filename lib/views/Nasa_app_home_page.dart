import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class NasaAppScreen extends StatefulWidget {
  @override
  _NasaAppScreenState createState() => _NasaAppScreenState();
}

class _NasaAppScreenState extends State<NasaAppScreen> {
  String _imageUrl = '';
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool _isLoading = false;

  Future<void> _fetchApodImage() async {
    setState(() {
      _isLoading = true;
    });

    final String apiKey = '18QBwoiRpbFgeYBSl3PxFHi2aoJjrt7lIindJfng';
    final String baseUrl = 'https://api.nasa.gov/planetary/apod';

    final url = '$baseUrl?date=$_selectedDate&api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _imageUrl = data['url'];
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 6, 16),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchApodImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selected Date: $_selectedDate',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchApodImage,
              child: Text('Show Image'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _imageUrl.isNotEmpty
                    ? Expanded(
                        child: Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text('No image available'),
          ],
        ),
      ),
    );
  }
}
