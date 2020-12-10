//dbelavia.dart
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_app/airport.dart';
import 'package:my_app/airports.dart';
import 'package:my_app/flight.dart';
import 'package:my_app/flights.dart';
import 'package:my_app/datelist.dart';

class DBelavia {
  
  static final _databaseName = "belaviadb.db";
  static final _databaseVersion = 1;

  static final atable = 'airports';
  static final ftable = 'flights';
  
  static final columnId = '_id';

  static final columnIata = 'iata';
  static final columnName = 'name';
  static final columnLang = 'lang';

  static final columnFlightnumber = 'flightnumber';			
  static final columnAirport = 'airport';
  static final columnScheduletime = 'scheduletime';
  static final columnExpectedtime = 'expectedtime';
  static final columnActualtime = 'actualtime';
  static final columnStatus = 'status';
  static final columnAircraft = 'aircraft';
  static final columnFlighttype = 'flighttype';


  DBelavia._privateConstructor();
  static final DBelavia instance = DBelavia._privateConstructor();

  static Database _database;
  
  Future<Database> get database async {
    if (_database != null) return _database;
    
    _database = await _initDatabase();
    return _database;
  }
  
  //open the database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  //create the database tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $atable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnIata TEXT,
            $columnName TEXT,
            $columnLang TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $ftable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnFlightnumber TEXT,
            $columnAirport TEXT,
            $columnScheduletime TEXT,
            $columnExpectedtime TEXT,
            $columnActualtime TEXT,
            $columnStatus TEXT,
            $columnAircraft TEXT,
            $columnFlighttype TEXT
          )
          ''');
  }
  
  Future<int> insertAirport(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(atable, row);
  }

  Future<int> insertFlight(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(ftable, row);
  }


  Future<List<Airport>> getAirports(String lang) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(atable,
        columns: [columnIata, columnName, columnLang],
        where: '$columnLang = ?',
        whereArgs: [lang]);

    return List.generate(maps.length, (index) {
      return Airport(
        maps[index][columnIata],
        maps[index][columnName],
        maps[index][columnLang],
      );
    });
  }

  Future<List<FlightWithName>> getFlights(String flType, String dt, String lang) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery("select f.flightnumber, f.airport, a.name, f.scheduletime, f.expectedtime, f.actualtime, f.status, f.aircraft, f.flighttype from flights as f, airports as a where f.airport = a.iata and a.lang = ? and f.flighttype = ? and f.scheduletime like '$dt%'", [lang, flType]);

    return List.generate(maps.length, (i) {
      return FlightWithName(
        maps[i][columnFlightnumber],
        maps[i][columnAirport],
        maps[i][columnName],
        maps[i][columnScheduletime],
        maps[i][columnExpectedtime],
        maps[i][columnActualtime],
        maps[i][columnStatus],
        maps[i][columnAircraft],
        maps[i][columnFlighttype],
      );
    });
  }


  Future<int> cleanAirport() async {
    Database db = await instance.database;
    return await db.delete(atable);
  }

  Future<int> cleanFlight() async {
    Database db = await instance.database;
    return await db.delete(ftable);
  }
  
  Future<int> cleanDB() async {
    final rowsDeleted = await cleanAirport();
    //print('Airports deleted rows:  $rowsDeleted');
    final rowsDeletedF = await cleanFlight();
    //print('Flights deleted rows:  $rowsDeletedF');
    return rowsDeleted + rowsDeletedF;
  }
  
  Future<void> loadAirports(String lang) async {
    AirportList alist = new AirportList();
    List<Airport> al = await alist.fetchAirports(lang);
    al.forEach((element) {
      Map<String, dynamic> row = {
        columnIata : element.iata,
        columnName : element.name,
        columnLang : element.lang
      };
      final id = insertAirport(row);
    });
  }

  Future<void> loadFlights(String flightType, String dateFlights) async {
    FlightList flist = new FlightList();
    List<Flight> fla = await flist.fetchFlights(flightType, dateFlights);
    fla.forEach((element) {
      Map<String, dynamic> row = {
        columnFlightnumber  : element.flightnumber,
        columnAirport : element.airport,
        columnScheduletime : element.scheduletime,
        columnExpectedtime : element.expectedtime,
        columnActualtime : element.actualtime,
        columnStatus : element.status,
        columnAircraft : element.aircraft,
        columnFlighttype : flightType
      };
      final ida = insertFlight(row);
    });
  }

  
  Future<void> loadDB(DateList listDates) async {
    await loadAirports('ru');
    await loadAirports('en');
    listDates.strDateList.forEach((element) async {
      await loadFlights('Arrival', element);
      await loadFlights('Departure', element);
    });
  }
}
