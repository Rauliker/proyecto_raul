import 'package:bidhub/presentations/appbars/avatar_appbar.dart';
import 'package:bidhub/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:bidhub/presentations/bloc/subastas/subastas_event.dart';
import 'package:bidhub/presentations/bloc/subastas/subastas_state.dart';
import 'package:bidhub/presentations/bloc/users/users_bloc.dart';
import 'package:bidhub/presentations/bloc/users/users_event.dart';
import 'package:bidhub/presentations/widgets/drewers.dart';
import 'package:bidhub/presentations/widgets/filter_drawer.dart';
import 'package:bidhub/presentations/widgets/sort_drawer.dart';
import 'package:bidhub/presentations/widgets/subastas_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  double? _minPrice;
  double? _maxPrice;
  bool _isPriceSort = false;
  bool _isDateSort = false;
  bool subastasCheckbox = true;
  bool _isPriceSortAscending = true;
  bool _isDateSortAscending = true;
  int? precioMasAlto;
  int? precioMasBajo;

  bool _isFirstTimeSortedPrice = true;
  bool _isFirstTimeSortedDate = true;

  @override
  void initState() {
    super.initState();
    _loadSavedFilters();
    fetchUserData();
    fetchSubastas();
  }

  Future<void> _loadSavedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _minPrice = prefs.getDouble('minPrice');
      _maxPrice = prefs.getDouble('maxPrice');
    });
  }

  Future<void> _saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    if (_minPrice != null) await prefs.setDouble('minPrice', _minPrice!);
    if (_maxPrice != null) await prefs.setDouble('maxPrice', _maxPrice!);
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null && mounted) {
      context.read<UserBloc>().add(UserDataRequest(email: email));
    }
  }

  Future<void> fetchSubastas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email != null && mounted) {
      context.read<SubastasBloc>().add(FetchSubastasDeOtroUsuarioEvent(
          email, null, subastasCheckbox, null, null, null));
    }

    if (!mounted) return;
    context.read<SubastasBloc>().stream.listen((state) {
      if (state is SubastasLoadedState) {
        // final precios =
        // state.subastas.map((subasta) => subasta.pujaActual).toList();

        // if (precios.isNotEmpty) {
        //   setState(() {
        //     precioMasAlto = precios.reduce((a, b) => a > b ? a : b);
        //     precioMasBajo = precios.reduce((a, b) => a < b ? a : b);
        //   });
        // }
      }
      if (_maxPrice != null) {
        precioMasAlto = _maxPrice?.toInt();
      }
      if (_minPrice != null) {
        precioMasBajo = _minPrice?.toInt();
      }
    });
  }

  Future<void> _filterSubastas(
      String? query, bool? subastasCheckbox, int? min, int? max) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email == null) return;

    setState(() {
      _minPrice = min?.toDouble();
      _maxPrice = max?.toDouble();
    });

    await _saveFilters();
    if (!mounted) return;
    context.read<SubastasBloc>().add(FetchSubastasDeOtroUsuarioEvent(
        email, query, subastasCheckbox, min, max, null));
  }

  void _applySorting(bool isPriceSort, bool isAscending) {
    setState(() {
      _isPriceSort = isPriceSort;
      _isDateSort = !isPriceSort;
      if (isPriceSort) {
        _isPriceSortAscending = isAscending;
        _isFirstTimeSortedPrice = !_isFirstTimeSortedPrice;
      } else {
        _isDateSortAscending = isAscending;
        _isFirstTimeSortedDate = !_isFirstTimeSortedDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AvatarAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => _filterSubastas(query, subastasCheckbox,
                  _minPrice?.toInt(), _maxPrice?.toInt()),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.search,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: SubastasListWidget(
              isPriceSort: _isPriceSort,
              isPriceSortAscending: _isPriceSortAscending,
              isDateSort: _isDateSort,
              isDateSortAscending: _isDateSortAscending,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => showFiltersDrawer(context, _searchController,
                (min, max, checkbox) async {
              setState(() {
                _minPrice = min;
                _maxPrice = max;
                subastasCheckbox = checkbox;
              });
              await _saveFilters();
              _filterSubastas(_searchController.text, subastasCheckbox,
                  _minPrice?.toInt(), _maxPrice?.toInt());
            }, precioMasBajo, precioMasAlto, subastasCheckbox),
            child: const Icon(Icons.filter_list),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () =>
                showSortDrawer(context, (isPriceSort, isAscending) {
              _applySorting(isPriceSort, isAscending);
            }, _isFirstTimeSortedPrice, _isFirstTimeSortedDate),
            child: const Icon(Icons.sort),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () => context.go('/my_sub'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.my_Bid,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
