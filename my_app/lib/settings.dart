import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/preferences.dart';
import 'package:my_app/main.dart';

List<String> _languages = <String>['ru','en'];
List<String> _languageNames = <String>['РУССКИЙ','ENGLISH'];

class SettingsWindow extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (curLang == 'en') ? Text('Settings') : Text('Настройки'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _languages.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: _buildTitle(_languageNames[index]),
              trailing: IconButton(
                //icon: const Icon(Icons.check),
                //icon: const Icon(Icons.circle),
                //icon: Icon(Icons.radio_button_checked_outlined),
                icon: (_languages[index] == curLang) ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_unchecked),//Icon(Icons.radio_button_unchecked),
                onPressed: () async {
                  await SharedPreferencesHelper.setLanguageCode(_languages[index]);
                  curLang = await SharedPreferencesHelper.getLanguageCode();
                  setState((){});
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(String languageCode){
    return Text('$languageCode',
      style: TextStyle(
          //fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
          fontSize: 20.0),
    );

  }
}


/*
class SettingsWindow extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("НАСТРОЙКИ"),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.white,
        body: new Center(child: new Column(
            children: [
               Container(
                 padding: const EdgeInsets.symmetric(vertical: 10.0),
                 width: double.infinity,
                 child: Text(
                   "ЯЗЫКИ",
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 20.0,
                     fontWeight: FontWeight.bold,
                    // textAlign: TextAlign.center,
                   ),
                 ),
               ),
               Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  child: Text(
                    "Русский",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  child: Text(
                    "English",
                    style: TextStyle(
                      color: Colors.black,
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

 */

