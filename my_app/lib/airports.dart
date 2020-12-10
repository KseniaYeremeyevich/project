import 'dart:convert';
import 'package:my_app/airport.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;


class AirportList {

  Future<List<Airport>> fetchAirports(String lang) async {

    final String soap = '''
		<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:web="http://webservices.belavia.by/">
		<soap:Header/>
		<soap:Body>
			<web:GetAirportsList>
				<!--Optional:-->
				<web:Language>$lang</web:Language>
			</web:GetAirportsList>
		</soap:Body>
		</soap:Envelope>
		''';

    http.Response response = await http.post(
      'http://api-tt.belavia.by/TimeTable/Service.asmx',
      headers: {
        'Content-Type': 'text/xml;charset=UTF-8',
        'SOAPAction' : 'http://webservices.belavia.by/GetAirportsList',
      },
      body: soap,
    );

    var storeDocument = XmlDocument.parse(response.body);
    var elements = storeDocument.findAllElements('Airport');

    return elements.map((element){
      return Airport(element.getAttribute('IATA'), element.getAttribute('Name'), lang);
    }).toList();
  }
}