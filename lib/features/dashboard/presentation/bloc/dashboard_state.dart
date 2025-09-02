part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}
final class DashboardLoading extends DashboardState {}
final class DashboardLoaded extends DashboardState {
  final Map<String,dynamic> busStops;
  const DashboardLoaded({required this.busStops});
  @override
  List<Object> get props => [busStops];
}
final class ErrorLoadingDashBoard extends DashboardState {
  final String message;
  const ErrorLoadingDashBoard({required this.message});
  @override
  List<Object> get props => [message];
}