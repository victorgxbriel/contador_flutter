import 'package:contador/app_logger.dart';
import 'package:contador/models/cofiguracao_agua.dart';
import 'package:flutter/material.dart';

class ConfiguracaoModal extends StatefulWidget {
  final List<ConfiguracaoAgua> listaConfiguracoes;
  final ConfiguracaoAgua configuracaoAtiva;

  const ConfiguracaoModal({
    super.key,
    required this.listaConfiguracoes,
    required this.configuracaoAtiva,
  });

  @override
  State<StatefulWidget> createState() => _ConfiguracaoModalState();

}

class _ConfiguracaoModalState extends State<ConfiguracaoModal> {
  final log = logger(ConfiguracaoModal);

  bool _isCreating = false;

  // para validação do form
  final _formKey = GlobalKey<FormState>();

  // controls para os campos, similar ao angular
  late TextEditingController _nomeController;
  late TextEditingController _metaController;
  late TextEditingController _copoController;
  late TextEditingController _incrementoController;
  late TextEditingController _decrementoController;

  UnidadeMedida _unidadeMetaSelect = UnidadeMedida.L;
  UnidadeMedida _unidadeCopoSelect = UnidadeMedida.mL;

  // dá pra colocar isso em um mixin passando todos os controllers? se tornaria facil para um form
  // talvez já exista um mixin de form TODO depois
  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _metaController = TextEditingController();
    _copoController = TextEditingController();
    _incrementoController = TextEditingController();
    _decrementoController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _metaController.dispose();
    _copoController.dispose();
    _incrementoController.dispose();
    _decrementoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    if(_isCreating) {
      return _buildFormulario(context, bottomPadding);
    } else {
      return _buildListaConfiguracoes(context, bottomPadding);
    }

  }

  Widget _buildListaConfiguracoes(BuildContext context, double bottomPadding) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecionar configuração',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16,),
          ListView.builder(
            itemCount: widget.listaConfiguracoes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final config = widget.listaConfiguracoes[index];
              final bool isAtiva = config.nome == widget.configuracaoAtiva.nome;

              return ListTile(
                title: Text(config.nome),
                subtitle: Text(
                  'Meta: ${config.metaDiaria} ${config.unidadeMeta.medida} / Copo: ${config.valorCopo} ${config.unidadeCopo.medida} / +${config.passoIncremento} / -${config.passoDecremento}'
                ),
                trailing: isAtiva ? Icon(Icons.check_circle, color: theme.colorScheme.primary,) : null,
                onTap: () {
                  Navigator.pop(context, config);
                },
              );
            }
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40)
            ),
            onPressed: () {
              setState(() {
                _isCreating = true;
              });
            }, 
            child: const Text('Criar nova configuração')
          ),
          SizedBox(height: bottomPadding,)
        ],
      ),
    );
  }

  Widget _buildFormulario(BuildContext context, double bottomPadding) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom, // empurra o form para cima do teclado
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView( // permite rolar se o teclado sobrepor
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Nova configuração',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 20.0,),
              
              // campo nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da configuração (ex: Garrafa 1L)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha este campo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0,),

              // campo  meta
              TextFormField(
                controller: _metaController,
                decoration: const InputDecoration(labelText: 'Meta diária'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || (int.tryParse(value) ?? 0) <= 0) {
                    return 'Valor invalido';
                  }
                  return null;
                },
              ),
              _buildSeletorUnidade(
                _unidadeMetaSelect,
                (novaUnidade) => setState(() => _unidadeMetaSelect = novaUnidade),
              ),
              const SizedBox(height: 16,),

              // campo copo
              TextFormField(
                controller: _copoController,
                decoration: const InputDecoration(labelText: 'Valor do copo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || (int.tryParse(value) ?? 0) <= 0) {
                    return 'Valor invalido';
                  }
                  return null;
                },
              ),
              _buildSeletorUnidade(
                _unidadeCopoSelect,
                (novaUnidade) => setState(() => _unidadeCopoSelect = novaUnidade),
              ),
              const SizedBox(height: 16.0,),

              // campo passo incremento
              TextFormField(
                controller: _incrementoController,
                decoration: const InputDecoration(labelText: 'Quantos copos adicionar?'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value == null || (int.tryParse(value) ?? 0) <= 0) {
                    return 'Valor invalidor';
                  }
                  return null;
                },
              ),

              // campo passo decremento
              TextFormField(
                controller: _decrementoController,
                decoration: const InputDecoration(labelText: 'Quantos copos diminuir?'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value == null || (int.tryParse(value) ?? 0) <= 0) {
                    log.w('Valor do campo Passo Decremento inválido');
                    return 'Valor invalidor';
                  }
                  return null;
                },
              ),

              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isCreating = false;
                      });
                    }, 
                    child: const Text('Cancelar'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _salvarConfiguracao, 
                    child: const Text('Salvar'),
                  ),
                ],
              ),
              SizedBox(height: bottomPadding,)
            ],
          ),
        )
      ),
    );
  }

  Widget _buildSeletorUnidade(
    UnidadeMedida unidade,
    Function(UnidadeMedida) onChanged,
  ) {
    return SegmentedButton<UnidadeMedida>(
      segments: [
        ButtonSegment(
          value: UnidadeMedida.mL, 
          label: Text(UnidadeMedida.mL.medida)
        ),
        ButtonSegment(
          value: UnidadeMedida.L,
          label: Text(UnidadeMedida.L.medida)
        ),
      ], 
      selected: {unidade},
      onSelectionChanged: (Set<UnidadeMedida> newSelected) {
        onChanged(newSelected.first);
      },
    );
  }

  void _salvarConfiguracao() {
    if(!_formKey.currentState!.validate()){
      return;
    }

    final String nome = _nomeController.text;
    final int metaValor = int.tryParse(_metaController.text) ?? 2000;
    final int valorCopo = int.tryParse(_copoController.text) ?? 200;
    final int passoIncremento = int.tryParse(_incrementoController.text) ?? 1;
    final int passoDecremento = int.tryParse(_decrementoController.text) ?? 1;

    final novaConfig = ConfiguracaoAgua(
      nome: nome, 
      metaDiaria: metaValor, 
      valorCopo: valorCopo, 
      passoIncremento: passoIncremento, 
      passoDecremento: passoDecremento,
      unidadeCopo: _unidadeCopoSelect,
      unidadeMeta: _unidadeMetaSelect
    );

    Navigator.pop(context, novaConfig); // esse pop do navigator é semelhante ao de kotlin
  }
  
}
