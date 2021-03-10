class Weather {
  String conditionsDay;
  double tempMin;
  double tempMax;
  String conditionsNight;
  String iconCode;
  String date;

  Weather(
      {this.tempMax,
      this.tempMin,
      this.iconCode,
      this.conditionsDay,
      this.conditionsNight,
      this.date});

  factory Weather.fromJson(Map<String, dynamic> data) {
    return Weather(
      date: data['Date'].toString().substring(5,10),
      tempMax: data['Temperature']['Maximum']['Value'],
      tempMin: data['Temperature']['Minimum']['Value'],
      iconCode: data['Day']['Icon'].toString(),
      conditionsDay: data['Day']['IconPhrase'].toString(),
      conditionsNight: data['Night']['IconPhrase'].toString(),
    );
  }
}
