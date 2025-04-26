import 'package:flutter/material.dart';
import 'vendas_page.dart';
import 'compras_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomePage({super.key, required this.onThemeToggle});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controle Financeiro'),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: widget.onThemeToggle,
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [Tab(text: 'Vendas'), Tab(text: 'Compras')],
          ),
        ),
        body: const TabBarView(children: [VendasPage(), ComprasPage()]),
      ),
    );
  }
}
