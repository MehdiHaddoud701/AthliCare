import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/guidance_dummy_repo.dart';

class GuidanceCubit extends Cubit<Map<String, dynamic>> {
  final GuidanceRepository repo;

  GuidanceCubit()
    : repo = GuidanceRepository(),
      super({'data': <String, dynamic>{}, 'state': 'loading', 'message': ''});

  /// Load all guidance data (articles and vitamins)
  Future<void> load() async {
    // Emit loading state
    emit({
      ...state,
      'state': 'loading',
      'message': '',
      'data': <String, dynamic>{},
    });

    try {
      // Fetch data from repository
      final records = await repo.getAllGuidance();

      // Small delay for smooth UX
      await Future.delayed(const Duration(milliseconds: 300));

      print('✅ Guidance Data Loaded: ${records.toString()}');

      // Emit success state with data
      emit({
        ...state,
        'data': records,
        'state': 'done',
        'message': 'Data loaded successfully',
      });
    } catch (e) {
      print('❌ Error loading guidance data: $e');

      // Emit error state
      emit({
        ...state,
        'state': 'error',
        'message': e.toString(),
        'data': <String, dynamic>{},
      });
    }
  }

  /// Reload data (useful for pull-to-refresh)
  Future<void> reload() async {
    await load();
  }

  /// Get articles only
  List<Map<String, dynamic>> getArticles() {
    if (state['state'] == 'done' && state['data'] is Map) {
      final data = state['data'] as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['articles'] ?? []);
    }
    return [];
  }

  /// Get vitamins only
  List<Map<String, dynamic>> getVitamins() {
    if (state['state'] == 'done' && state['data'] is Map) {
      final data = state['data'] as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['vitamins'] ?? []);
    }
    return [];
  }
}
