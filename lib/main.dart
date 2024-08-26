import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Clima',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _description = '';
  String _iconUrl = '';

  final String _apiKey = '3b5c36ae115cbd5321b6bda45d040732'; 

  Future<void> _fetchWeather() async {
    final city = _cityController.text;
    final url = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _temperature = '${data['main']['temp']} °C';
        _description = data['weather'][0]['description'];
        _iconUrl = 'http://openweathermap.org/img/wn/${data['weather'][0]['icon']}.png';
      });
    } else {
      setState(() {
        _temperature = 'Error';
        _description = '';
        _iconUrl = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('El Clima'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ciudad:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa la ciudad',
              ),
            ),
            SizedBox(height: 16.0),
            
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text('Refrescar'),
            ),
            SizedBox(height: 16.0),

            if (_iconUrl.isNotEmpty)
              Row(
                children: [
                  Image.network(_iconUrl, width: 50, height: 50),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temperatura: $_temperature',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Descripción: $_description',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
