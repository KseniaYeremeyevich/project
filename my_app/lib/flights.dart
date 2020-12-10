import 'dart:convert';
import 'package:my_app/flight.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class FlightList {
  Future<List<Flight>> fetchFlights(String flightType, String flightDate) async {
    final String soap = '''
		<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:web="http://webservices.belavia.by/">
		<soap:Header/>
		<soap:Body>
			<web:GetTimeTable>
				<!--Optional:-->
				<web:Airport>MSQ</web:Airport>
				<web:Type>$flightType</web:Type>
				<web:ViewDate>$flightDate</web:ViewDate>
			</web:GetTimeTable>
		</soap:Body>
		</soap:Envelope>
		''';

    http.Response response = await http.post(
      'http://api-tt.belavia.by/TimeTable/Service.asmx',
      headers: {
        'Content-Type': 'text/xml;charset=UTF-8',
        'SOAPAction': 'http://webservices.belavia.by/GetTimeTable',
      },
      body: soap,
    );

    var storeDocument = XmlDocument.parse(response.body);
    var elements = storeDocument.findAllElements('Flight');

    return elements.map((element){
      return Flight(element.getAttribute('FlightNumber'), element.getAttribute('Airport'), element.getAttribute('ScheduleTime'), element.getAttribute('ExpectedTime'), element.getAttribute('ActualTime'), element.getAttribute('Status'), element.getAttribute('Aircraft'), flightType);
    }).toList();
  }
}