import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _nameCtrl = TextEditingController();
  List<String> _suggestions = [];
  Map<String,dynamic> _allStops = {};

  @override
  void initState() {
    super.initState();

   // context.read<DashboardCubit>().fetchBusStops();

    _nameCtrl.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    final q = _nameCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _suggestions = [];
      } else {
        _suggestions = _allStops.keys
            .where((name) => name.toLowerCase().contains(q))
            .toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
   // final isExactMatch = _allStops.contains(typed);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search Stop'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              if (_nameCtrl.text.trim().isNotEmpty && (_suggestions.isNotEmpty /*|| !isExactMatch*/))
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _suggestions.isNotEmpty
                  // 1) matching suggestions
                      ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final name = _suggestions[i];
                      return ListTile(
                        title: Text( name),
                        onTap: () {
                          setState(() {
                            _nameCtrl.text  = name;
                           // context.read<DashboardCubit>().fetchCityFromPreferences();
                            Navigator.pop(context);
                          });
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  )
                  // 2) no matches & not an exact match
                      : ListTile(
                      title: Text(
                        'No Stops Found for: ${_nameCtrl.text}',
                      ),
                      onTap: () {
                        setState(() {_suggestions.clear();
                        });
                      }
                  ),
                ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
