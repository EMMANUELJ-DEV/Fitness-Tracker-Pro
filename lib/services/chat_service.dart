import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'your api key here',
  );

  Future<String> sendMessage(String message) async {
    try {
      // Create a fitness-focused prompt
      final prompt = '''
You are an AI Fitness Assistant, specialized in providing expert advice about:
- Workout routines
- Nutrition and diet plans
- Exercise techniques
- Health and wellness tips

User Query: $message

Please provide a helpful, accurate, and friendly response focused on fitness and health.
''';

      final content = [
        Content.text(prompt),
      ];
      
      final response = await model.generateContent(content);
      if (response.text == null || response.text!.isEmpty) {
        return 'I apologize, but I was unable to generate a response. Please try asking your question in a different way.';
      }
      return response.text!;
    } catch (e) {
      print('Error in chat service: $e');
      return 'I apologize, but I encountered an error. Please ensure you have a stable internet connection and try again.';
    }
  }
} 
