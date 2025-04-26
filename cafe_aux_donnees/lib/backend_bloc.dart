import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class BackendBloc extends Cubit<String> {
  BackendBloc() : super('');

  Future<void> fetchData() async {
    List data = [210, 9.86, 7, 10, 456, 673];
    String parseString = "http://localhost:5000/api/data";

    for (final i in data) {
      parseString += '/$i';
    }
    final response = await http.get(Uri.parse(parseString));
    if (response.statusCode == 200) {
      emit(response.body);
    } else {
      emit('Failed to fetch data');
    }
  }
}