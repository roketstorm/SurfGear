import 'dart:convert';

import 'package:flutter/services.dart';

enum ModuleStatus { surf, alpha, beta, release }

class Module {
  final String name;
  final String link;
  final ModuleStatus status;
  final String description;

  Module({
    this.name,
    this.link,
    this.status,
    this.description,
  });
}

Future<List<Module>> get modules async {
  final json = await rootBundle.loadString('libraries_config.json');
  final jsonList = jsonDecode(json) as List;

  return jsonList.map<Module>(_mapJsonToModel).toList();
}

Module _mapJsonToModel(json) {
  return Module(
    name: json['name'],
    link: json['link'],
    description: json['description'],
    status: _mapStatus(json['status']),
  );
}

ModuleStatus _mapStatus(String status) {
  switch (status) {
    case 'alpha':
      return ModuleStatus.alpha;
    case 'beta':
      return ModuleStatus.beta;
    case 'release':
      return ModuleStatus.release;
    default:
      return ModuleStatus.surf;
  }
}
