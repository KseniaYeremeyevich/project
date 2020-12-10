import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/airport.dart';
import 'package:my_app/settings.dart';
import 'package:my_app/arrivals.dart';
import 'package:my_app/departures.dart';
import 'package:my_app/dbelavia.dart';
import 'package:my_app/datelist.dart';
import 'package:my_app/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import  'package:logger/logger.dart';

final dbBelavia = DBelavia.instance;
DateList lDates;
String curLang;

var logger = Logger(
  filter: null, // Use the default LogFilter (-> only log in debug mode)
  printer: PrettyPrinter(methodCount: 0),//PrettyPrinter(), // Use the PrettyPrinter to format and print log
  output: null, // Use the default LogOutput (-> send everything to console)
);


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  lDates = new DateList(DateFormat("yyyy-MM-dd").format(DateTime.now()),
      <String>[
        DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 1))),
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
        DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1)))
      ]
  );
  logger.i('Read Preferences');
  curLang = await SharedPreferencesHelper.getLanguageCode();
  logger.i('Clean DB');
  final delItems = await dbBelavia.cleanDB();
  logger.i('deleted rows: $delItems');
  logger.i('Load data from web service to DB...');
  await dbBelavia.loadDB(lDates);
  logger.i('Data was loaded');

  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyBody(),
    ),
  );
}

class MyBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text(
            (curLang == 'en') ? 'Scoreboard by Belavia' : 'Табло рейсов Belavia',//'Scoreboard by Belavia',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          //centerTitle: true,
          backgroundColor: Colors.blue[900],

          actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Settings Icon',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingRoute()),
                  );
                },
              ), //IconButton
            ],

        ),
        body: new Center(child: new Column(
            children: [
              Container(
                width: double.infinity,
                //width: 150,
                child: Image.asset('images/Belavia.jpg'),
              ),
              Container(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  //onPressed: () {},
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArrivePage()),
                    );
                  },
                  color: Colors.blue[900],
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    (curLang == 'en') ? 'ARRIVAL' : 'ПРИЛЕТЫ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  //onPressed: () {},
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DeparturePage()),
                    );
                  },
                  color: Colors.blue[900],
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    (curLang == 'en') ? 'DEPARTURE' : 'ВЫЛЕТЫ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  //onPressed: () {},
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AirportPage()),
                    );
                  },
                  color: Colors.blue[900],
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    (curLang == 'en') ? 'AIRPORTS' : 'АЭРОПОРТЫ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ]
        ),
        ));
  }
}

class ArrivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ArrivalsData();
  }
}

class DeparturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DeparturesData();
  }
}

class AirportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (curLang == 'en') ? Text('Airports'): Text("Аэропорты"),
        backgroundColor: Colors.blue[900],

      ),
      body: FutureBuilder<List<Airport>>(
        future: dbBelavia.getAirports(curLang),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Airport item = snapshot.data[index];
                String airportName = '';
                if (item.name != null) airportName = item.name;
                return ListTile(
                  leading: Icon(Icons.airplanemode_on_rounded,color: Colors.indigo,),
                  title: Text(item.iata, style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),),
                subtitle: Text(airportName, style: TextStyle(color: Colors.indigo, fontSize: 16.0, fontWeight: FontWeight.bold),),
                  //subtitle: Text(airportName),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class SettingRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SettingsWindow();
  }
}


