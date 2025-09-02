import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/share_prederence/share_preferences.dart';
import '../dashboard/presentation/bloc/dashboard_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<String> favorites = [];
  final TextEditingController _nameCtrl = TextEditingController();
  List<Map<String, dynamic>> _suggestions = [];
  List<Map<String, dynamic>> _allStops = [];

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().fetchBusStops();
    _nameCtrl.addListener(_onNameChanged);
    _getAllFavStops();
  }

  Future<void> _getAllFavStops() async {
    final favs = await SharePreference.getFavorites();
    setState(() {
      favorites = favs;
    });
  }

  void _onNameChanged() {
    final q = _nameCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _suggestions = [];
      } else {
        _suggestions = _allStops
            .where((name) => name['stopname'].toString().toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search Stop'),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {
            _allStops = [];

            // Merge all routes into one list
            for (var routeKey in [
              'tirTOkutarr',
              'tirtoktkarr',
              'tirTOkuttp',
              'ktklTotir',
              'tirToktkl',
            ]) {
              final stops = state.busStops[routeKey] as List<dynamic>;
              for (var stop in stops) {
                if (stop is String) {
                  _allStops.add({
                    'stopname': stop,
                    'latitude': 'N/A',
                    'longitude': 'N/A',
                    'stopTime': 'N/A',
                    'timedifference': 'N/A',
                  });
                } else if (stop is Map<String, dynamic>) {
                  _allStops.add({
                    'stopname': stop['stopname'] ?? 'Unknown',
                    'latitude': stop['latitude'] ?? 'N/A',
                    'longitude': stop['longitude'] ?? 'N/A',
                    'stopTime':
                    (stop['stopTime']?.toString().isEmpty ?? true)
                        ? 'N/A'
                        : stop['stopTime'],
                    'timedifference': stop['timedifference'] ?? 'N/A',
                  });
                }
              }
            }

            return _buildSearchUI();
            return _buildSearchUI();
          }

          if (state is ErrorLoadingDashBoard) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSearchUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: 'Search by stop…',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              filled: true,
              fillColor: const Color(0xFFF1F4FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (_nameCtrl.text.trim().isNotEmpty && _suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
               // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final stop = _suggestions[i];
                  return ListTile(
                    title: Text(
                      stop['stopname'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "Lat: ${stop['latitude']}, Lng: ${stop['longitude']}\n"
                          "Time: ${stop['stopTime']}  |  Diff: ${stop['timedifference']} mins",
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        favorites.contains(stop)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await SharePreference.toggleFavorite(stop["stopname"]);
                        await _getAllFavStops(); // reload favorites
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
