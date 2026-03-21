import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/project.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  Future<List<Project>> getProjects() async {
    try {
      final response = await _client
          .from('projects')
          .select()
          .order('created_at', ascending: false);
      
      debugPrint('Supabase raw response: $response');
      return (response as List).map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Supabase error in getProjects: $e');
      rethrow;
    }
  }
}
