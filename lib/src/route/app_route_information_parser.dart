import 'package:flutter/cupertino.dart';

class AppRouteInformationParser extends
RouteInformationParser<List<RouteSettings>> {
  const AppRouteInformationParser() : super();

  String restoreArguments(RouteSettings routeSettings) {
    if (routeSettings.name != '/product') return '';
    return '?signature=${(routeSettings.arguments
    as Map)['signature'].toString()}';
  }

  //Nos ayuda a una URL en una location dentro de la app
  @override
  Future<List<RouteSettings>> parseRouteInformation(
      RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) {
      return Future.value([const RouteSettings(name: '/')]);
    }
    final routeSettings = uri.pathSegments
        .map((pathSegment) => RouteSettings(
      name: '/$pathSegment',
      arguments: pathSegment == uri.pathSegments.last
          ? uri.queryParameters
          : null,
    ))
        .toList();
    return Future.value(routeSettings);
  }

  //Nos ayuda a convertir una location de la app en una URL
  @override
  RouteInformation restoreRouteInformation(List<RouteSettings>
  configuration) {
    final location = configuration.last.name;
    final arguments = restoreArguments(configuration.last);
    return RouteInformation(location: '$location$arguments');
  }
}