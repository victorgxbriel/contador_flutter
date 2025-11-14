

import 'package:contador/app_logger.dart';
import 'package:contador/models/cofiguracao_agua.dart';
import 'package:contador/screens/widgets/configuracao_modal.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomePage extends StatefulWidget {

  final String title;
  
  // isso aqui é o construtor
  const HomePage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  final log = logger(_HomePageState);
  final detailLog = detailLogger(_HomePageState);

  int _contagemAtual = 0;

  ConfiguracaoAgua _configuracaoAtiva = ConfiguracaoAgua.defaultValues();

  final List<ConfiguracaoAgua> _listaConfiguracoes = [
    ConfiguracaoAgua.defaultValues(),
  ];

  @override
  void initState() {
    super.initState();
    detailLog.d("initState");
    detailLog.d("Configuração inicial: ${_configuracaoAtiva.nome}");
  }

  @override
  void dispose() {
    detailLog.d("dispose");
    super.dispose();
  }

  void _incrementCounter() {
    log.i("Incremento solicitado");
    setState(() {
      final novaContagem = _contagemAtual + (_configuracaoAtiva.passoIncremento * _configuracaoAtiva.copoEmMl);
      detailLog.d("Contagem: $_contagemAtual - > $novaContagem");

      _contagemAtual = novaContagem;
    });
  }

  void _decrementCounter() {
    log.i("Decremento solicitado");
    setState(() {
      final novaContagem = _contagemAtual - (_configuracaoAtiva.passoDecremento * _configuracaoAtiva.copoEmMl);

      if(novaContagem >= 0) {
        detailLog.d("Contagem: $_contagemAtual -> $novaContagem");
        _contagemAtual = novaContagem;
      } else {
        detailLog.w("Tentativa de decrementar abaixo de zero. Travado em 0.");
        _contagemAtual = 0;
      }
    });
  }

  void _resetCounter() {
    log.i("Reset solicitado");
    setState(() {
      _contagemAtual = 0;
    });
  }

  void _abrirModalConfiguracoes() async {
    log.i("Abrindo modal de configurações");
    try {

      final resultado = await showModalBottomSheet<ConfiguracaoAgua>(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return ConfiguracaoModal(listaConfiguracoes: _listaConfiguracoes, configuracaoAtiva: _configuracaoAtiva);
        }
      );

      if(resultado != null) {
        log.i("Nova configuração recebida: ${resultado.nome}");
        setState(() {
          _configuracaoAtiva = resultado;

          if(!_listaConfiguracoes.any((cfg) => cfg.nome == resultado.nome)) {
            log.i("Salvando nova configuração na lista.");
            _listaConfiguracoes.add(resultado);
            detailLog.d("Total de configurações: ${_listaConfiguracoes.length}");
          }
        });
      } else {
        detailLog.d("Modal fechado sem seleção (resultado == null)");
      }

    } catch (e, s) {
      detailLog.e(
        "Erro fatal ao abrir ou processar modal de configurações",
        error: e,
        stackTrace: s
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Isso aqui é un InheretedWidget(o que você pode usar para passar os estados)
    final double progresso = _configuracaoAtiva.metaDiaria > 0 ? _contagemAtual / _configuracaoAtiva.metaEmMl : 0.0;
    final int coposTomados = (_configuracaoAtiva.copoEmMl > 0) 
                            ? _contagemAtual ~/ _configuracaoAtiva.copoEmMl 
                            : 0;
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
            Center (
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _configuracaoAtiva.nome,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.secondary
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5.0,
                        children: [
                          Icon(
                            Symbols.target,
                            color: Colors.orange,
                          ),
                          Text(
                            'Meta: ${_configuracaoAtiva.metaDiaria} ${_configuracaoAtiva.unidadeMeta.medida}'
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5.0,
                        children: [
                          Icon(
                            Symbols.glass_cup,
                            color: Colors.blueAccent,
                          ),
                          Text(
                            'Copo: ${_configuracaoAtiva.valorCopo} ${_configuracaoAtiva.unidadeCopo.medida}'
                          )
                        ],
                      )
                    ],
                  )
                ],
              )
            ),
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
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10.0,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Decrementar',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2.0,
                    children: [
                      Text('${_configuracaoAtiva.passoDecremento}'),
                      const Icon(
                        Symbols.water_loss,
                        fill: 0.5,
                        color: Colors.redAccent,
                      )
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Incrementar',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2.0,
                    children: [
                      Text('${_configuracaoAtiva.passoIncremento}'),
                      const Icon(
                        Symbols.water_full,
                        fill: 1.0,
                        color: Colors.blueAccent,),
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: _resetCounter,
                  tooltip: 'Reiniciar',
                  child: Icon(Icons.refresh),
                ),
              ]
            ),
            // --- INÍCIO DA ADIÇÃO (VERSÃO ESTILIZADA) ---
            const SizedBox(height: 24,), // Espaçamento

            // Usamos um Padding para dar um respiro nas laterais
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                decoration: BoxDecoration(
                  // Usamos uma cor do tema, que se adapta ao light/dark mode
                  color: theme.colorScheme.primaryContainer.withOpacity(0.5), 
                  borderRadius: BorderRadius.circular(16.0), // Bordas arredondadas
                ),
                child: Column(
                  children: [
                    // Texto principal (Ex: "Você bebeu")
                    if (coposTomados == 0)
                      Text(
                        'Hora de se hidratar!',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      Text(
                        'Você bebeu',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    
                    const SizedBox(height: 8),

                    // O NÚMERO (Destaque total)
                    Text(
                      '$coposTomados', 
                      style: theme.textTheme.displayLarge?.copyWith( // Estilo bem grande
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary, // Cor de destaque principal
                      ),
                    ),
                    
                    // O Subtexto (Ex: "copos hoje")
                    Text(
                      coposTomados == 1 ? 'copo hoje' : 'copos hoje',
                      style: theme.textTheme.titleMedium?.copyWith( // Estilo menor
                        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}