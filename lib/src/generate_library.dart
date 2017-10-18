import 'package:ebisu/ebisu_dart_meta.dart';
import 'package:ebisu/ebisu.dart';
import 'package:ebisu_ang/ebisu_ang.dart';
import 'package:ebisu_pod/ebisu_pod.dart' as pod;

Installation generateAngular(pod.PodPackage pkg) {
  var portfolioAccount =
      pkg.podObjects.firstWhere((o) => o.name == 'portfolio_account');

  var appComponent = component('${pkg.id.snake}_application')
    ..directives = [
      new Directive('router_link'),
    ];

  var components = [
    generateDetailComponent(portfolioAccount),
    generateListComponent(portfolioAccount),
  ];

  var routeConfig = new StringBuffer()..writeln('@RouteConfig(const [');

  for (var component in components) {
    // ex. foo_detail_cmp => 'detail', foo_list_cmp => 'list'
    // technically a code smell, but...
    var stub = component.id.snake
        .replaceFirst(portfolioAccount.id.snake, '')
        .split('_')[1];
        var routeName = stub.substring(0, 1).toUpperCase() + stub.substring(1);

    if (stub == 'detail') stub += '/:id';

    routeConfig
      ..writeln('  const Route(')
      ..writeln('    name: "$routeName",')
      ..writeln('    path: "/$stub",')
      ..writeln('    component: ${component.id.capCamel},')
      ..writeln('  )');
  }

  routeConfig.writeln('])');

  appComponent.controller.annotations
      .add(new Annotation(routeConfig.toString()));

  appComponent.library.classes.add(generateClass(portfolioAccount));

  return installation(pkg.id.snake)
    ..appComponent = appComponent
    ..components = components;
}

Component generateDetailComponent(pod.PodObject obj) {
  var cmp = component('${obj.name}_detail_component');

  cmp.controller
    ..members = [
      member('model')
        ..type = obj.id.capCamel
        ..init = 'new ${obj.id.capCamel}()'
    ];

  var buf = new StringBuffer()
    ..writeln('<h1>${obj.id.capCamel} Detail</h1>')
    ..writeln('<table>');

  for (var field in obj.fields) {
    buf
      ..writeln('  <tr>')
      ..writeln('    <td>${field.id.capCamel}</td>')
      ..writeln('    <td>{{model.${field.id.camel}}}</td>')
      ..writeln('  </tr>');
  }

  buf.writeln('</table>');

  cmp.template = new _Template(buf.toString());

  return cmp;
}

Component generateListComponent(pod.PodObject obj) {
  var cmp = component('${obj.name}_list_component')
    ..directives = [
      new Directive('router_link'),
    ];

  cmp.controller
    ..members = [
      member('models')
        ..type = 'List<${obj.id.capCamel}>'
        ..init = '[]',
    ];

  var buf = new StringBuffer()
    ..writeln('<h1>${obj.id.capCamel}s ({{ models.length }})</h1>')
    ..writeln('<table>')
    ..writeln('  <thead>')
    ..writeln('    <tr>');

  for (var field in obj.fields) {
    buf.writeln('      <th>${field.id.capCamel}</th>');
  }

  buf
    ..writeln('    </tr>')
    ..writeln('  </thead>')
    ..writeln('  <tbody>')
    ..writeln(
        '    <tr *ngFor="let model of models;" [routerLink]="[\'/${obj.id.capCamel}/Detail\', { id: model.id }]">');

  for (var field in obj.fields) {
    buf.writeln('      <td>{{model.${field.id.camel}}}</td>');
  }

  buf..writeln('   </tr>')..writeln('  </tbody>')..writeln('</table>');

  cmp.template = new _Template(buf.toString());

  return cmp;
}

class _Template extends Template {
  @override
  final String content;

  _Template(this.content);

  @override
  taggedHtml(tag) => content;
}

Library _generateAngularLibrary(pod.PodPackage package) {
  var lib = library(package.name);

  // Generate all enums
  lib.enums = package.podEnums.map((pod.PodEnum e) {
    return enum_(e.name)
      ..doc = e.doc
      ..values = e.values.map((v) => v.id.camel);
  }).toList();

  // Generate all classes
  lib.classes = package.podObjects.map((pod.PodObject o) {
    return class_(o.name)
      ..doc = o.doc
      ..members = o.fields.map((f) {
        return member(f.name)
          ..doc = f.doc
          ..type = generateType(f.podType);
      }).toList();
  }).toList();

  // Generate list component
  lib.classes.add(
    class_('PortfolioAccountListComponent')..annotations = ['@Component()'],
  );

  // Generate detail component

  return lib;
}

final RegExp _map =
    new RegExp(r'MapOf([A-Za-z][A-Za-z0-9_]*)To([A-Za-z][A-Za-z0-9_]*)');

Class generateClass(pod.PodObject obj) {
  return class_(obj.id.snake)
    ..members = obj.fields.map(generateMember).toList();
}

Member generateMember(pod.PodField field) {
  return member(field.id.snake)
    ..type = generateType(field.podType)
    ..init = field.defaultValue?.toString();
}

String generateType(pod.PodType t) {
  if (t.isArray) {
    return generateTypeName(t.typeName.replaceFirst('array_of_', ''));
  }

  if (_map.hasMatch(t.typeName)) {
    var m = _map.firstMatch(t.typeName);
    var k = generateTypeName(m[1]), v = generateTypeName(m[2]);
    return 'Map<$k, $v>';
  }

  return generateTypeName(t.typeName);
}

String generateTypeName(String typeName) {
  switch (typeName) {
    case 'Double':
      return 'double';
    case 'Date':
      return 'DateTime';
    case 'Str':
      return 'String';
    default:
      return id(typeName).capCamel;
  }
}
