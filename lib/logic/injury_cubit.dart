import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/injury_repo.dart';
import '../data/models/injury_model.dart';
import '../data/models/injuries_info.dart';
import '../data/state/injury_state.dart';

class InjuryCubit extends Cubit<InjuryState> {
  final InjuryRepository _repository;
  int? _currentUserId;

  InjuryCubit(this._repository) : super(InjuryInitial());

  // ==================== GETTERS ====================

  /// Get current user ID
  int? get currentUserId => _currentUserId;

  /// Get active injuries from current state
  List<InjuryModel> get activeInjuries {
    final currentState = state;
    if (currentState is InjuriesLoaded) {
      return currentState.activeInjuries;
    }
    return [];
  }

  /// Get history injuries from current state
  List<InjuryModel> get historyInjuries {
    final currentState = state;
    if (currentState is InjuriesLoaded) {
      return currentState.historyInjuries;
    }
    return [];
  }

  /// Check if there's an active injury
  bool get hasActiveInjury => activeInjuries.isNotEmpty;

  // ==================== LOAD DATA ====================

  /// Load all injuries for a user
  Future<void> loadInjuries(int userId) async {
    _currentUserId = userId;
    emit(InjuryLoading());

    try {
      final activeInjuries = await _repository.getActiveInjuries(userId);
      final historyInjuries = await _repository.getInjuryHistory(userId);

      print('✅ Loaded ${activeInjuries.length} active injuries');
      print('✅ Loaded ${historyInjuries.length} history injuries');

      emit(
        InjuriesLoaded(
          activeInjuries: activeInjuries,
          historyInjuries: historyInjuries,
        ),
      );
    } catch (e) {
      print('❌ Error loading injuries: $e');
      emit(InjuryError('Failed to load injuries: $e'));
    }
  }

  /// Refresh injuries (silent reload)
  Future<void> refreshInjuries() async {
    if (_currentUserId != null) {
      try {
        final activeInjuries = await _repository.getActiveInjuries(
          _currentUserId!,
        );
        final historyInjuries = await _repository.getInjuryHistory(
          _currentUserId!,
        );

        emit(
          InjuriesLoaded(
            activeInjuries: activeInjuries,
            historyInjuries: historyInjuries,
          ),
        );
      } catch (e) {
        print('❌ Error refreshing injuries: $e');
      }
    }
  }

  // ==================== CREATE ====================

  /// Log a new injury
  Future<void> logInjury(InjuryModel injury) async {
    final previousState = state;
    emit(InjuryLoading());

    try {
      final injuryId = await _repository.insertInjury(injury);

      if (injuryId == -1) {
        emit(previousState); // Restore previous state
        emit(const InjuryError('Failed to log injury'));
        return;
      }

      print('✅ Injury logged with ID: $injuryId');

      // Show success message
      emit(const InjuryActionSuccess('Injury logged successfully!'));

      // Reload injuries to get updated data
      if (_currentUserId != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        await loadInjuries(_currentUserId!);
      }
    } catch (e) {
      print('❌ Error logging injury: $e');
      emit(previousState);
      emit(InjuryError('Failed to log injury: $e'));
    }
  }

  // ==================== UPDATE ====================

  /// Update injury details
  Future<void> updateInjury(InjuryModel injury) async {
    try {
      final result = await _repository.updateInjury(injury);

      if (result == 0) {
        emit(const InjuryError('Failed to update injury'));
        return;
      }

      print('✅ Injury updated');

      // Update state with modified injury
      final currentState = state;
      if (currentState is InjuriesLoaded) {
        final updatedActive = currentState.activeInjuries.map((i) {
          return i.injuryId == injury.injuryId ? injury : i;
        }).toList();

        final updatedHistory = currentState.historyInjuries.map((i) {
          return i.injuryId == injury.injuryId ? injury : i;
        }).toList();

        emit(
          currentState.copyWith(
            activeInjuries: updatedActive,
            historyInjuries: updatedHistory,
          ),
        );
      }
    } catch (e) {
      print('❌ Error updating injury: $e');
      emit(InjuryError('Failed to update injury: $e'));
    }
  }

  /// Update pain level for an injury
  Future<void> updatePainLevel(int injuryId, double painLevel) async {
    try {
      await _repository.updatePainLevel(injuryId, painLevel);

      // Update the current state without full reload
      final currentState = state;
      if (currentState is InjuriesLoaded) {
        final updatedActive = currentState.activeInjuries.map((injury) {
          if (injury.injuryId == injuryId) {
            return injury.copyWith(currentPainLevel: painLevel);
          }
          return injury;
        }).toList();

        emit(currentState.copyWith(activeInjuries: updatedActive));
      }

      print('✅ Pain level updated to $painLevel for injury $injuryId');
    } catch (e) {
      print('❌ Failed to update pain level: $e');
    }
  }

  /// Update days rested for an injury
  Future<void> updateDaysRested(int injuryId, int daysRested) async {
    try {
      await _repository.updateDaysRested(injuryId, daysRested);

      // Update the current state without full reload
      final currentState = state;
      if (currentState is InjuriesLoaded) {
        final updatedActive = currentState.activeInjuries.map((injury) {
          if (injury.injuryId == injuryId) {
            return injury.copyWith(daysRested: daysRested);
          }
          return injury;
        }).toList();

        emit(currentState.copyWith(activeInjuries: updatedActive));
      }

      print('✅ Days rested updated to $daysRested for injury $injuryId');
    } catch (e) {
      print('❌ Failed to update days rested: $e');
    }
  }

  /// Update notes for an injury
  Future<void> updateNotes(int injuryId, String? notes) async {
    try {
      final currentState = state;
      if (currentState is InjuriesLoaded) {
        final injury = currentState.activeInjuries.firstWhere(
          (i) => i.injuryId == injuryId,
        );

        final updatedInjury = injury.copyWith(notes: notes);
        await updateInjury(updatedInjury);
      }
    } catch (e) {
      print('❌ Failed to update notes: $e');
    }
  }

  // ==================== DELETE ====================

  /// Delete an injury
  Future<void> deleteInjury(int injuryId) async {
    final previousState = state;
    emit(InjuryLoading());

    try {
      final result = await _repository.deleteInjury(injuryId);

      if (result == 0) {
        emit(previousState);
        emit(const InjuryError('Failed to delete injury'));
        return;
      }

      print('✅ Injury deleted with ID: $injuryId');

      emit(const InjuryActionSuccess('Injury deleted successfully'));

      // Reload injuries
      if (_currentUserId != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        await loadInjuries(_currentUserId!);
      }
    } catch (e) {
      print('❌ Error deleting injury: $e');
      emit(previousState);
      emit(InjuryError('Failed to delete injury: $e'));
    }
  }

  // ==================== MARK AS RECOVERED ====================

  /// Mark an injury as recovered
  Future<void> markAsRecovered(int injuryId) async {
    final previousState = state;
    emit(InjuryLoading());

    try {
      final result = await _repository.markAsRecovered(injuryId);

      if (result == 0) {
        emit(previousState);
        emit(const InjuryError('Failed to mark as recovered'));
        return;
      }

      print('✅ Injury marked as recovered: $injuryId');

      emit(const InjuryActionSuccess('Injury marked as recovered! 🎉'));

      // Reload injuries
      if (_currentUserId != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        await loadInjuries(_currentUserId!);
      }
    } catch (e) {
      print('❌ Error marking as recovered: $e');
      emit(previousState);
      emit(InjuryError('Failed to mark as recovered: $e'));
    }
  }

  // ==================== HELPERS ====================

  /// Get injury info for a specific injury type
  InjuryInfo? getInjuryInfo(String injuryType) {
    return InjuryInfoDatabase.getInfo(injuryType);
  }

  /// Get list of available injury types
  List<String> getInjuryTypes() {
    return InjuryInfoDatabase.injuryTypes;
  }

  /// Get statistics
  Future<Map<String, int>> getStatistics(int userId) async {
    try {
      final activeCount = await _repository.getActiveInjuryCount(userId);
      final totalRecoveryDays = await _repository.getTotalRecoveryDays(userId);

      return {
        'activeCount': activeCount,
        'totalRecoveryDays': totalRecoveryDays,
      };
    } catch (e) {
      print('❌ Error getting statistics: $e');
      return {'activeCount': 0, 'totalRecoveryDays': 0};
    }
  }

  /// Get current injury (first active injury if exists)
  InjuryModel? getCurrentInjury() {
    final active = activeInjuries;
    return active.isNotEmpty ? active.first : null;
  }

  /// Clear error/success states and return to loaded state
  void clearActionState() {
    if (_currentUserId != null && state is! InjuriesLoaded) {
      refreshInjuries();
    }
  }

  // ==================== VALIDATION ====================

  /// Validate injury data before logging
  String? validateInjury({
    required String? injuryType,
    required String? severity,
    required DateTime? injuryDate,
  }) {
    if (injuryType == null || injuryType.isEmpty) {
      return 'Please select an injury type';
    }
    if (severity == null || severity.isEmpty) {
      return 'Please select severity level';
    }
    if (injuryDate == null) {
      return 'Please select the injury date';
    }
    if (injuryDate.isAfter(DateTime.now())) {
      return 'Injury date cannot be in the future';
    }
    return null; // Valid
  }

  // ==================== CLEANUP ====================

  @override
  Future<void> close() {
    print('🔴 InjuryCubit closed');
    return super.close();
  }
}
