class CatalogoItem {
  final String id, nombre;

  CatalogoItem({required this.id, required this.nombre});
}

class Catalogos {
  final List<CatalogoItem> operativas;
  final List<CatalogoItem> sedes;
  final List<CatalogoItem> areas;
  final List<CatalogoItem> puestos;

  Catalogos({
    required this.operativas,
    required this.sedes,
    required this.areas,
    required this.puestos,
  });

  factory Catalogos.fromJson(Map<String?, dynamic> json) {
    List<CatalogoItem> parseList(List<dynamic> lista, String? campo) {
      return lista
          .map((item) => CatalogoItem(id: item['id'], nombre: item[campo]))
          .toList();
    }

    return Catalogos(
      operativas: parseList(json['operativas'], 'operativa'),
      sedes: parseList(json['sedes'], 'sede'),
      areas: parseList(json['areas'], 'area'),
      puestos: parseList(json['puestos'], 'puesto'),
    );
  }

  Catalogos.empty()
  :operativas = [],
  sedes = [],
  areas = [],
  puestos = [];
}
