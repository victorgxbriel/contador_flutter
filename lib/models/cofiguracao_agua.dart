
enum UnidadeMedida { 
  mL, 
  L;

  String get medida {
    switch(this) {
      case UnidadeMedida.mL:
        return 'mL';
      case UnidadeMedida.L:
        return 'L';
    }
  }
}

class ConfiguracaoAgua {
  final String nome;
  final int metaDiaria;
  final int valorCopo;

  // quantos copos eu incremento ou decremento? 
  final int passoIncremento;
  final int passoDecremento;

  final UnidadeMedida unidadeMeta;
  final UnidadeMedida unidadeCopo;

  // constructor
  ConfiguracaoAgua({
    required this.nome,
    required this.metaDiaria,
    required this.valorCopo,
    required this.passoIncremento,
    required this.passoDecremento,
    this.unidadeMeta = UnidadeMedida.L, // valor default
    this.unidadeCopo = UnidadeMedida.mL
  });

  // default
  factory ConfiguracaoAgua.defaultValues() {
    return ConfiguracaoAgua(
      nome: 'Padrão', 
      metaDiaria: 2, 
      valorCopo: 200, 
      passoIncremento: 1, 
      passoDecremento: 1, 
      unidadeMeta: UnidadeMedida.L, 
      unidadeCopo: UnidadeMedida.mL);
  }

  int get metaEmMl {
    return unidadeMeta == UnidadeMedida.L ? metaDiaria * 1000 : metaDiaria;
  }

  int get copoEmMl {
    return unidadeCopo == UnidadeMedida.L ? valorCopo * 1000 : valorCopo;
  }

}