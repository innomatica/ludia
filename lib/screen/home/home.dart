import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/ludia.dart';
import '../../model/ludia_item.dart';
import '../../shared/constants.dart';
import '../about/about.dart';
import 'itemgrid.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  // Scaffold Menu Buttons
  //
  Widget _buildAboutButton() {
    return IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AboutPage()));
        },
        icon: const Icon(Icons.info_outline_rounded));
  }

  Widget _buildGridButton() {
    final logic = context.read<LudiaLogic>();
    return IconButton(
        onPressed: () {
          logic.changeGridColumns();
        },
        icon: const Icon(Icons.grid_view_rounded));
  }

  //
  // Scaffold Body
  //
  Widget _buildBody() {
    return const ItemGridView();
  }

  //
  // Scaffold Floating Action Button
  //
  Widget? _buildFab() {
    final ludia = context.read<LudiaLogic>();
    return FloatingActionButton(
      onPressed: () {
        ludia.insertItem(LudiaItem.fromDefault());
      },
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          _buildGridButton(),
          _buildAboutButton(),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
