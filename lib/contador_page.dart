
import 'package:flutter/material.dart';

class ContadorHomePage extends StatefulWidget {

  const ContadorHomePage({super.key, required this.title});

  final String title;
  
  @override
  State<StatefulWidget> createState() => _ContadorHomePageState();

}

class _ContadorHomePageState extends State<ContadorHomePage> {

  int _contador = 0;

  void _incrementCounter() {
    setState(() {
      _contador++;
    });
  }

  void _decrementCounter() {
    if(_contador == 0) {
      return;
    }

    setState(() {
      _contador--;
    });
  }

  void _resetCounter() {
    setState(() {
      _contador = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_contador',
              style: theme.textTheme.headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10.0,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Decrementar',
                  child: Icon(Icons.remove),
                ),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Incrementar',
                  child: Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: _resetCounter,
                  tooltip: 'Reiniciar',
                  child: Icon(Icons.refresh),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}