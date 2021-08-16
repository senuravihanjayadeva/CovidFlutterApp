import 'dart:convert';

import 'package:covid_tracker/models/CovidModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocalCovidPanel extends StatefulWidget {
  const LocalCovidPanel({Key key}) : super(key: key);

  @override
  _LocalCovidPanelState createState() => _LocalCovidPanelState();
}

class _LocalCovidPanelState extends State<LocalCovidPanel> {
  Future<CovidModel> covidDetails;

  @override
  void initState() {
    super.initState();
    covidDetails = fetchCovidDetails();
  }

  Future<CovidModel> fetchCovidDetails() async {
    final responseData = await http.get(
        Uri.parse('https://www.hpb.health.gov.lk/api/get-current-statistical'));

    if (responseData.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CovidModel.fromJson(jsonDecode(responseData.body)['data']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Covid Details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2),
        children: [
          FutureBuilder<CovidModel>(
            future: covidDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StatusPanel(
                  title: 'CONFIREMED',
                  panelColor: Colors.red.shade100,
                  textColor: Colors.red,
                  count: snapshot.data.localCases,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          FutureBuilder<CovidModel>(
            future: covidDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StatusPanel(
                  title: 'ACTIVE',
                  panelColor: Colors.blue.shade100,
                  textColor: Colors.blue,
                  count: snapshot.data.localActiveCases,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          FutureBuilder<CovidModel>(
            future: covidDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StatusPanel(
                  title: 'RECOVERED',
                  panelColor: Colors.green.shade100,
                  textColor: Colors.green,
                  count: snapshot.data.localRecovered,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          FutureBuilder<CovidModel>(
            future: covidDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StatusPanel(
                  title: 'DEATHS',
                  panelColor: Colors.grey.shade100,
                  textColor: Colors.grey,
                  count: snapshot.data.localDeaths,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}

class StatusPanel extends StatelessWidget {
  final Color panelColor;
  final Color textColor;
  final String title;
  final int count;

  const StatusPanel(
      {Key key, this.panelColor, this.textColor, this.title, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(5),
      color: panelColor,
      height: 80,
      width: width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          Text(count.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: textColor))
        ],
      ),
    );
  }
}
