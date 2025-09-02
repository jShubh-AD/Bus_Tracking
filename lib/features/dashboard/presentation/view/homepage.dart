import 'package:bus_tracking/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:bus_tracking/features/search/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  void initState () {
    super.initState();
    context.read<DashboardCubit>().fetchBusStops();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Track'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchPage()));
          }, icon: Icon(Icons.search)),
          SizedBox(width: 10,)
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<DashboardCubit, DashboardState>(builder: (context, state) {
           if(state is DashboardLoading || state is DashboardInitial){
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
           if(state is DashboardLoaded){

             final data = state.busStops;

             return ExpansionTile(
               title: Text('Tir TO Kutarr'),
               children: [
                 ListView.builder(
                     shrinkWrap: true,
                     itemCount: (data['tirTOkutarr'] as List).length,
                     itemBuilder: (context, index){
                       return ListTile(
                         title: Text(data['tirTOkutarr'][index].toString(),style: TextStyle(color: Colors.black),),
                         subtitle: Text("stop description"),
                         onTap: (){

                         },
                       );
                     }
                 )
               ],
             );
           }
           if(state is ErrorLoadingDashBoard){
             return Text(state.message);
           }
           else {
             return SizedBox.shrink();
           }
        })
      ),
    );
  }
}
