import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'transition_delegate.dart';

abstract class AppRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final TransitionDelegate transitionDelegate;

  final _pages = <Page>[];

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  AppRouterDelegate({this.transitionDelegate = const MyTransitionDelegate()});

  MaterialPage createPage(RouteSettings routeSettings);

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        pages: List.of(_pages),
        onPopPage: _onPopPage,
        transitionDelegate: transitionDelegate,
      );

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;

    popRoute();

    return true;
  }

  @override
  Future<bool> popRoute() async {
    if (_pages.length > 1) {
      _pages.removeLast();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return Future.value(true);
    }
    bool? response = await _confirmAppExit();
    return response == null ? Future.value(true) : Future.value(response);
  }

  Future<bool?> _confirmAppExit() => showDialog<bool>(
        context: navigatorKey!.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('¿Estas seguro que quieres abandonar la app?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context, true),
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      );

  //Cuando el usuario introduce a mano una dirección URL
  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) async {
    List<Page> pages = configuration.map(createPage).toList();
    _setPath(pages);

    return Future.value(null);
  }

  void _setPath(List<Page> pages) {
    _pages.clear();
    _pages.addAll(pages);
    if (_pages.isNotEmpty && _pages.first.name != '/') {
      _pages.insert(0, createPage(const RouteSettings(name: '/')));
    }
    notifyListeners();
  }

  void pushPage({required String name, dynamic arguments}) {
    MaterialPage page =
        createPage(RouteSettings(name: name, arguments: arguments));
    if (_pages.firstWhereOrNull((pageInPages) => pageInPages.key == page.key) ==
        null) {
      _pages.add(page);
    }

    notifyListeners();
  }

  void pushPageAndRemoveUntil({required String name, dynamic arguments}) {
    if (_pages.length > 1) {
      _pages.removeLast();
    }
    pushPage(name: name, arguments: arguments);
  }

  void parseRoute(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath([const RouteSettings(name: '/')]);
    } else {
      setNewRoutePath(uri.pathSegments
          .map((pathSegment) => RouteSettings(
                name: '/$pathSegment',
                arguments: pathSegment == uri.pathSegments.last
                    ? uri.queryParameters
                    : null,
              ))
          .toList());
    }
  }
}
