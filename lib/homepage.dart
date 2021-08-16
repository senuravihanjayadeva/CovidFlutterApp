import 'dart:convert';

import 'package:covid_tracker/datasource.dart';
import 'package:covid_tracker/models/CovidModel.dart';
import 'package:covid_tracker/panels/localCovidPanel.dart';
import 'package:covid_tracker/panels/worldwidepanel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<CovidModel> futureCovidModel;

  Future<CovidModel> fetchCovidModel() async {
    final response = await http.get(
        Uri.parse('https://www.hpb.health.gov.lk/api/get-current-statistical'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CovidModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCovidModel = fetchCovidModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Covid-19 Tracker'),
        ),
        body: Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              color: Colors.orange[100],
              child: Text(
                DataSource.developedBy,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Worldwide',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )),
            WorldWidePanel(),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Local Cases',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )),
            LocalCovidPanel()
          ],
        ));
  }
}
