import 'package:flutter/material.dart';

class MyTransitionDelegate extends TransitionDelegate {
  const MyTransitionDelegate() : super();

  @override
  Iterable<RouteTransitionRecord> resolve({
    required List<RouteTransitionRecord> newPageRouteHistory,
    required Map<RouteTransitionRecord?, RouteTransitionRecord>
        locationToExitingPageRoute,
    required Map<RouteTransitionRecord?, List<RouteTransitionRecord>>
        pageRouteToPagelessRoutes,
  }) {
    final List<RouteTransitionRecord> results = <RouteTransitionRecord>[];
    // add this declaration
    final bool showAnimation = locationToExitingPageRoute.isEmpty ||
        newPageRouteHistory.last.route.settings.name !=
            locationToExitingPageRoute.values.last.route.settings.name;

    // This method will handle the exiting route and its corresponding pageless
    // route at this location. It will also recursively check if there is any
    // other exiting routes above it and handle them accordingly.
    void handleExitingRoute(RouteTransitionRecord? location, bool isLast) {
      final RouteTransitionRecord? exitingPageRoute =
          locationToExitingPageRoute[location];
      if (exitingPageRoute == null) return;
      if (exitingPageRoute.isWaitingForExitingDecision) {
        final bool hasPageLessRoute =
            pageRouteToPagelessRoutes.containsKey(exitingPageRoute);
        final bool isLastExitingPageRoute =
            isLast && !locationToExitingPageRoute.containsKey(exitingPageRoute);
        if (isLastExitingPageRoute && !hasPageLessRoute && showAnimation) {
          exitingPageRoute.markForPop(exitingPageRoute.route.currentResult);
        } else {
          exitingPageRoute
              .markForComplete(exitingPageRoute.route.currentResult);
        }
        if (hasPageLessRoute) {
          final List<RouteTransitionRecord>? pageLessRoutes =
              pageRouteToPagelessRoutes[exitingPageRoute];
          for (final RouteTransitionRecord pageLessRoute in pageLessRoutes!) {
            // It is possible that a pageless route that belongs to an exiting
            // page-based route does not require exiting decision. This can
            // happen if the page list is updated right after a Navigator.pop.
            if (pageLessRoute.isWaitingForExitingDecision) {
              if (isLastExitingPageRoute &&
                  pageLessRoute == pageLessRoutes.last) {
                pageLessRoute.markForPop(pageLessRoute.route.currentResult);
              } else {
                pageLessRoute
                    .markForComplete(pageLessRoute.route.currentResult);
              }
            }
          }
        }
      }
      results.add(exitingPageRoute);
      //It's possible there is another exiting route above this exitingPageRoute
      handleExitingRoute(exitingPageRoute, isLast);
    }

    // Handles exiting route in the beginning of list.
    handleExitingRoute(null, newPageRouteHistory.isEmpty);
    for (final RouteTransitionRecord pageRoute in newPageRouteHistory) {
      final bool isLastIteration = newPageRouteHistory.last == pageRoute;
      if (pageRoute.isWaitingForEnteringDecision) {
        if (!locationToExitingPageRoute.containsKey(pageRoute) &&
            isLastIteration &&
            showAnimation) {
          pageRoute.markForPush();
        } else {
          pageRoute.markForAdd();
        }
      }
      results.add(pageRoute);
      handleExitingRoute(pageRoute, isLastIteration);
    }
    return results;
  }
}
