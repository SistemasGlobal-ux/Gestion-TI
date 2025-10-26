
class CatalogosEquipo{
final String id, nombre;
CatalogosEquipo({required this.id, required this.nombre});
}

class CatalogosE {
  final List<CatalogosEquipo> tipos;
  final List<CatalogosEquipo> marcas;
  final List<CatalogosEquipo> modelos;
  final List<CatalogosEquipo> procesadores;
  final List<CatalogosEquipo> generaciones;
  final List<CatalogosEquipo> discos;
  final List<CatalogosEquipo> rams;
  final List<CatalogosEquipo> sistemasOperativos;

  CatalogosE({
    required this.tipos,
    required this.marcas,
    required this.modelos,
    required this.procesadores,
    required this.generaciones,
    required this.discos,
    required this.rams,
    required this.sistemasOperativos,
  });

  factory CatalogosE.fromJson(Map<String?, dynamic> json){
    List<CatalogosEquipo> parseList(List<dynamic> lista, String? campo) {
      return lista
          .map((item) => CatalogosEquipo(id: item['id'], nombre: item[campo]))
          .toList();
    }
    return CatalogosE(
    tipos: parseList(json["tipos"], "tipo"), 
    marcas: parseList(json["marcas"], "marca"),
    modelos: parseList(json["modelos"], "modelo"),
    procesadores: parseList(json["procesadores"], "procesador"),
    generaciones: parseList(json["generaciones"], "generacion"),
    discos: parseList(json["discos"], "disco"),
    rams: parseList(json["rams"], "ram"),
    sistemasOperativos: parseList(json["sistemas_operativos"], "so"),
    );
  }

   CatalogosE.empty()
   :tipos = [],
   marcas = [],
   modelos = [],
   procesadores = [],
   generaciones = [],
   discos = [],
   rams = [],
   sistemasOperativos = [];

}