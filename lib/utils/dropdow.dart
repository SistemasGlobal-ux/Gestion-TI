import 'package:application_sop/maps/general.dart';
import 'package:application_sop/maps/general_equipos.dart';
import 'package:flutter/material.dart';

class DropdownCatalogo extends StatelessWidget {
  final String label;
  final List<CatalogoItem> items;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const DropdownCatalogo({
    super.key,
    required this.label,
    required this.items,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedId,
      decoration: InputDecoration(labelText: label),
      items:
          items
              .map(
                (item) => DropdownMenuItem<int>(
                  value: int.parse(item.id),
                  child: Text(item.nombre),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }
}


class DropdownCatalogoE extends StatelessWidget {
  final String label;
  final List<CatalogosEquipo> items;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const DropdownCatalogoE({
    super.key,
    required this.label,
    required this.items,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedId,
      decoration: InputDecoration(labelText: label),
      items:
          items
              .map(
                (item) => DropdownMenuItem<int>(
                  value: int.parse(item.id),
                  child: Text(item.nombre),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }
}