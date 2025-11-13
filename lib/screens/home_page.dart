

import 'package:contador/models/cofiguracao_agua.dart';
import 'package:contador/screens/widgets/configuracao_modal.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final String title;
  
  // isso aqui é o construtor
  const HomePage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  int _contagemAtual = 0;

  ConfiguracaoAgua _configuracaoAtiva = ConfiguracaoAgua.defaultValues();

  final List<ConfiguracaoAgua> _listaConfiguracoes = [
    ConfiguracaoAgua.defaultValues(),
  ];

  void _incrementCounter() {
    setState(() {
      final novaContagem = _contagemAtual + (_configuracaoAtiva.passoIncremento * _configuracaoAtiva.copoEmMl);

      _contagemAtual = novaContagem;
    });
  }

  void _decrementCounter() {
    setState(() {
      final novaContagem = _contagemAtual - (_configuracaoAtiva.passoDecremento * _configuracaoAtiva.copoEmMl);

      if(novaContagem >= 0) {
        _contagemAtual = novaContagem;
      } else {
        _contagemAtual = 0;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _contagemAtual = 0;
    });
  }

  void _abrirModalConfiguracoes() async {
    final resultado = await showModalBottomSheet<ConfiguracaoAgua>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return ConfiguracaoModal(listaConfiguracoes: _listaConfiguracoes, configuracaoAtiva: _configuracaoAtiva);
      }
    );

    if(resultado != null) {
      setState(() {
        _configuracaoAtiva = resultado;

        if(!_listaConfiguracoes.any((cfg) => cfg.nome == resultado.nome)) {
          _listaConfiguracoes.add(resultado);
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Isso aqui é un InheretedWidget(o que você pode usar para passar os estados)
    final double progresso = _configuracaoAtiva.metaDiaria > 0 ? _contagemAtual / _configuracaoAtiva.metaEmMl : 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _abrirModalConfiguracoes, icon: const Icon(Icons.settings), tooltip: 'Configurações',)
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: LinearProgressIndicator(
                value: progresso,
                minHeight: 12,
                borderRadius: BorderRadius.circular(6),
                backgroundColor: theme.colorScheme.primaryContainer,
              ),
            ),
            Text(
              '$_contagemAtual ${_configuracaoAtiva.unidadeCopo.medida}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              'Meta: ${_configuracaoAtiva.metaDiaria} ${_configuracaoAtiva.unidadeMeta.medida}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 30,),
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
              ]
            )
          ],
        ),
      ),
    );
  }
}