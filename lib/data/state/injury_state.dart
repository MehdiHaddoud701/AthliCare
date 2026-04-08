import 'package:equatable/equatable.dart';
import '../models/injury_model.dart';

abstract class InjuryState extends Equatable {
  const InjuryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class InjuryInitial extends InjuryState {}

/// Loading state
class InjuryLoading extends InjuryState {}

/// Loaded state with injuries
class InjuriesLoaded extends InjuryState {
  final List<InjuryModel> activeInjuries;
  final List<InjuryModel> historyInjuries;

  const InjuriesLoaded({
    required this.activeInjuries,
    required this.historyInjuries,
  });

  @override
  List<Object?> get props => [activeInjuries, historyInjuries];

  InjuriesLoaded copyWith({
    List<InjuryModel>? activeInjuries,
    List<InjuryModel>? historyInjuries,
  }) {
    return InjuriesLoaded(
      activeInjuries: activeInjuries ?? this.activeInjuries,
      historyInjuries: historyInjuries ?? this.historyInjuries,
    );
  }
}

/// Success state for actions
class InjuryActionSuccess extends InjuryState {
  final String message;

  const InjuryActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state
class InjuryError extends InjuryState {
  final String message;

  const InjuryError(this.message);

  @override
  List<Object?> get props => [message];
}
