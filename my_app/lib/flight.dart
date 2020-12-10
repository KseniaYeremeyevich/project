class Flight {
	String _flightnumber;
	String _airport;
	String _scheduletime;
	String _expectedtime;
	String _actualtime;
	String _status;
	String _aircraft;
	String _flighttype;

	Flight(this._flightnumber,this._airport, this._scheduletime, this._expectedtime, this._actualtime, this._status, this._aircraft, this._flighttype);

	get flightnumber => this._flightnumber;
	get airport => this._airport;
	get scheduletime => this._scheduletime;
	get expectedtime => this._expectedtime;
	get actualtime => this._actualtime;
	get status => this._status;
	get aircraft => this._aircraft;
	get flighttype => this._flighttype;
}

class FlightWithName {
	String _flightnumber;
	String _airport;
	String _name;
	String _scheduletime;
	String _expectedtime;
	String _actualtime;
	String _status;
	String _aircraft;
	String _flighttype;

	FlightWithName(this._flightnumber,this._airport, this._name, this._scheduletime, this._expectedtime, this._actualtime, this._status, this._aircraft, this._flighttype);

	get flightnumber => this._flightnumber;
	get airport => this._airport;
	get name => this._name;
	get scheduletime => this._scheduletime;
	get expectedtime => this._expectedtime;
	get actualtime => this._actualtime;
	get status => this._status;
	get aircraft => this._aircraft;
	get flighttype => this._flighttype;
}
