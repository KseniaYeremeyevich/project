class DateList {
	String _selectedDate;
	List<String> _strDateList = <String>[];

	DateList(this._selectedDate, this._strDateList);

	get selectedDate => this._selectedDate;
	get strDateList => this._strDateList;

	void setSelectedDate(String newValue) {
		this._selectedDate = newValue;
	}
}