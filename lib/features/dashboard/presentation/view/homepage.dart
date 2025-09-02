import 'package:bus_tracking/core/share_prederence/share_preferences.dart';
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
  List<String> favorites = [];


  @override
  void initState() {
    super.initState();
    _getAllFavStops();
    context.read<DashboardCubit>().fetchBusStops();
  }

  Future<void> _getAllFavStops() async {
    final favs = await SharePreference.getFavorites();
    setState(() {
      favorites = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Track'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading || state is DashboardInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            if (state is DashboardLoaded) {
              final data = state.busStops;

              return Column(
                children: [
                  _buildRouteTile("Tir to Kutarr", data['tirTOkutarr']),
                  _buildRouteTile("Tir to Ktkarr", data['tirtoktkarr']),
                  _buildRouteTile("Tir to Kuttp", data['tirTOkuttp']),
                  _buildRouteTile("Ktkl to Tir", data['ktklTotir']),
                  _buildRouteTile("Tir to Ktkl", data['tirToktkl']),
                ],
              );
            }

            if (state is ErrorLoadingDashBoard) {
              return Text(state.message);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildRouteTile(String title, List<dynamic> stops) {
    return ExpansionTile(
      title: Text(title),
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: stops.length,
          itemBuilder: (context, index) {
            final stop = stops[index];

            // Normalize both string-only and map stops
            final normalized = stop is String
                ? {
              'stopname': stop,
              'latitude': 'N/A',
              'longitude': 'N/A',
              'stopTime': 'N/A',
              'timedifference': 'N/A',
            }
                : {
              'stopname': stop['stopname'] ?? 'Unknown',
              'latitude': stop['latitude'] ?? 'N/A',
              'longitude': stop['longitude'] ?? 'N/A',
              'stopTime': (stop['stopTime']?.toString().isEmpty ?? true)
                  ? 'N/A'
                  : stop['stopTime'].toString(),
              'timedifference': stop['timedifference'] ?? 'N/A',
            };

            final stopName = normalized['stopname'].toString();

            return ListTile(
              title: Text(
                stopName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "Lat: ${normalized['latitude']}, Lng: ${normalized['longitude']}\n"
                    "Time: ${normalized['stopTime']}  |  Diff: ${normalized['timedifference']} mins",
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(
                  favorites.contains(stopName)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await SharePreference.toggleFavorite(stopName);
                  await _getAllFavStops(); // reload favorites
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
