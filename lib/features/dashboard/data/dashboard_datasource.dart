import 'dart:convert';

import 'package:flutter/services.dart';

class DashboardDatasource{
  Future<Map<String,dynamic>> fetchBusStops() async{

    final response =  await rootBundle.loadString('assets/mock/stops.json');
    final Map<String,dynamic> data = jsonDecode(response);

    return data;
  }
}