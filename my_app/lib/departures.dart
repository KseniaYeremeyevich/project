import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_app/main.dart';
import 'package:my_app/flight.dart';

class DeparturesData extends StatefulWidget {
  @override
  DeparturesState createState() => DeparturesState();
}

class DeparturesState extends State<DeparturesData> with SingleTickerProviderStateMixin {
  TabController controller;
  DateFormat formatter;

  static final DateTime now = new DateTime.now();
  static final DateTime yesterday = new DateTime(now.year, now.month, now.day - 1);
  static final DateTime tomorrow = new DateTime(now.year, now.month, now.day + 1);
  //static final DateFormat formatter = DateFormat('dd.MM');

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();
    formatter = new DateFormat.MMMd(curLang);
    controller = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          child: Text(formatter.format(yesterday),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tab(
          child: Text(formatter.format(now),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Tab(
          child: Text(formatter.format(tomorrow),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      controller: controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      children: tabs,
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: (curLang == 'en') ? Text('Departure'): Text("Вылеты"),
            backgroundColor: Colors.blue[900],
            /*
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.autorenew),
                tooltip: 'Autorenew Icon',
                onPressed: () {},
              ), //IconButton
            ],

             */
            bottom: getTabBar()
        ),
        body: getTabBarView(<Widget>[PreviousDep(), CurrentDep(), NextDep()]));
  }
}


class PreviousDep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DepartureFlightList(lDates.strDateList[0]);
  }
}

class CurrentDep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DepartureFlightList(lDates.strDateList[1]);
  }
}

class NextDep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DepartureFlightList(lDates.strDateList[2]);
  }
}

class DepartureFlightList extends StatelessWidget {
  final String _dateFlight;

  DepartureFlightList(this._dateFlight);

  String getStatus(String sourceStatus) {
    String resultValue ;

    resultValue = sourceStatus;
    if (curLang == 'ru') {
      switch(sourceStatus) {
        case 'Arrived': { resultValue = 'Прибыл'; }
        break;

        case 'Canceled': { resultValue = 'Отменён'; }
        break;

        case 'Delayed': { resultValue = 'Задержан'; }
        break;

        case 'Departure': { resultValue = 'Вылетел'; }
        break;

        case 'Scheduled': { resultValue = 'Запланирован'; }
        break;
      }
    }
    return resultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<FlightWithName>>(
        future: dbBelavia.getFlights('Departure', _dateFlight, curLang),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                FlightWithName item = snapshot.data[index];
                String airportName = '';
                if (item.name != null) airportName = item.name;
                return ListTile(
                  leading: Text(item.scheduletime.substring(11, 16), style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),),
                  title: Text(airportName + '(' + item.airport + ')'),
                  subtitle: Text(item.flightnumber + ' / ' + item.aircraft, style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),),
                  trailing: Text(getStatus(item.status), style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),),
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