import 'package:bloc/bloc.dart';
import 'package:bus_tracking/features/dashboard/data/dashboard_datasource.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  final useCase = DashboardDatasource();

  Future<void> fetchBusStops () async{
    try{
      emit(DashboardLoading());

      final busStops =  await useCase.fetchBusStops();
      emit(DashboardLoaded(busStops: busStops));

    }catch(e){
      emit(ErrorLoadingDashBoard(message: e.toString()));
    }
  }

}

