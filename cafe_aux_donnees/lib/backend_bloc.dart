import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:cafe_aux_donnees/globals.dart' as globals;

class BackendBloc extends Cubit<String> {
  BackendBloc() : super('');

  Future<void> fetchData() async {
    String parseString = "http://localhost:5000/api/data";

    for (final i in globals.data) {
      parseString += '/$i';
    }
    final response = await http.get(Uri.parse(parseString));
    if (response.statusCode == 200) {
      emit(response.body);
    } else {
      emit('error');
    }
  }

  Future<void> postData() async {
    String parseString = "http://localhost:5000/api/postdata";

    for (final i in globals.data) {
      parseString += '/$i';
    }
    parseString += '/${globals.dailyRev}';

    final response = await http.post(Uri.parse(parseString),);

    if (response.statusCode == 200) {
      print("Data posted successfully");
    } else {
      print("There was an error posting the data: ${response.statusCode}");
    }
  }
}
