import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import '../../credentials.dart';

const apiUrl =
    "https://api-inference.huggingface.co/models/runwayml/stable-diffusion-v1-5";

Task generateImage(String prompt) {
  final requestResult = makeRequest(prompt);
  return requestResult.map((data) {
    print(data.body);
    return data.bodyBytes;
  });
}

Task makeRequest(String prompt) {
  final headers = {"Authorization": "Bearer $token"};
  final body = {"inputs": prompt};

  return Task(() => http.post(Uri.parse(apiUrl), headers: headers, body: body));
}
