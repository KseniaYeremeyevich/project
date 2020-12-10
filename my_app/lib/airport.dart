class Airport {
	String _iata;
	String _name;
	String _lang;

	Airport(this._iata, this._name, this._lang);

	get iata => this._iata;
	get name => this._name;
	get lang => this._lang;
}