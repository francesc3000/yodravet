import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/donor_bloc.dart';
import 'package:yodravet/src/bloc/event/donor_event.dart';
import 'package:yodravet/src/bloc/state/donor_state.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/team.dart';
import 'package:yodravet/src/widget/sliver_appbar_delegate.dart';

import '../../route/app_router_delegate.dart';
import 'donor_basic_page.dart';

class DonorMobilePage extends DonorBasicPage {
  const DonorMobilePage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    List<Activity>? activities = [];
    List<Team>? teams;
    String? _currentTeamId;
    List<Widget> slivers = [];
    DateTime? beforeDate;
    DateTime? afterDate;
    bool _loading = false;

    return BlocBuilder<DonorBloc, DonorState>(
      builder: (BuildContext context, state) {
        if (state is DonorInitState) {
          BlocProvider.of<DonorBloc>(context).add(LoadInitialDataEvent());
          _loading = true;
        } else if (state is UploadDonorFieldsState) {
          activities = state.activities;
          teams = state.teams;
          _currentTeamId = state.currentTeamId;
          beforeDate = state.beforeDate;
          afterDate = state.afterDate;
          _loading = false;
        } else if (state is DonorStateError) {
          //TODO: Mostrar errores en Pages
          // CustomSnackBar
        }

        if (_loading) {
          return Container(
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: const Center(child: CircularProgressIndicator()));
        }

        slivers.clear();
        slivers =
            _buildSlivers(context, activities != null, beforeDate, afterDate);
        slivers.addAll(_buildSliverActivities(context, activities));
        slivers.addAll(_buildTeams(context, _currentTeamId, teams));

        return Container(
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: CustomScrollView(
            slivers: slivers,
          ),
        );
      },
    );
  }

  List<Widget> _buildSlivers(BuildContext context, bool isStravaLogin,
      DateTime? beforeDate, DateTime? afterDate) {
    List<Widget> slivers = [];

    if (isStravaLogin) {
      // slivers.add(
      //   SliverPersistentHeader(
      //     delegate: _SliverAppBarDelegate(
      //       minHeight: 30,
      //       maxHeight: 30,
      //       child: Container(
      //         padding: EdgeInsets.all(40.0),
      //         alignment: Alignment.center,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Text('Puedes donar tus km a través de tu cuenta Strava'),
      //             // ElevatedButton(
      //             //   style: ButtonStyle(
      //             //     shape: MaterialStateProperty.all(
      //             //       RoundedRectangleBorder(
      //             //           borderRadius: BorderRadius.circular(30.0)),
      //             //     ),
      //             //     backgroundColor: MaterialStateProperty.all(Colors.orange),
      //             //   ),
      //             //   child: ListTile(
      //             //     leading: Icon(FontAwesomeIcons.strava),
      //             //     title: Text('Strava'),
      //             //   ),
      //             //   onPressed: () {
      //             //     Navigator.pop(context);
      //             //     BlocProvider.of<AuthBloc>(context)
      //             //         .add(StravaLogInEvent());
      //             //   },
      //             // ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // );

      //Título actividades
      slivers.add(SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          minHeight: 50,
          maxHeight: 50,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: _buildActivitiesTitle(context, beforeDate!, afterDate)),
        ),
      ));
    }
    return slivers;
  }

  List<Widget> _buildTeams(
      BuildContext context, String? currentTeamId, List<Team>? teams) {
    List<Widget> slivers = [];

    if (teams != null) {
      //Gestión de equipos
      slivers.add(SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          // childAspectRatio: 2.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            Team team = teams[index];
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  opacity: 0.5,
                  image: NetworkImage(team.photo),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(team.fullname),
                  Visibility(
                    visible: currentTeamId == null || currentTeamId != team.id,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed:
                          currentTeamId == null || currentTeamId != team.id
                              ? () => BlocProvider.of<DonorBloc>(context)
                                  .add(JoinTeamEvent(team.id))
                              : null,
                      child: Text(AppLocalizations.of(context)!.joinTeam),
                    ),
                  ),
                  Visibility(
                    visible: currentTeamId == team.id,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed:
                      currentTeamId == team.id
                          ? () => BlocProvider.of<DonorBloc>(context)
                          .add(DisJoinTeamEvent(team.id))
                          : null,
                      child: Text(AppLocalizations.of(context)!.disJoinTeam),
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: teams.length,
        ),
      ));
    }
    return slivers;
  }

  Widget _buildActivitiesTitle(
      BuildContext context, DateTime beforeDate, DateTime? afterDate) {
    Widget result;
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 00, 01, 00);

    if (now.isBefore(beforeDate) && now.isAfter(afterDate!)) {
      result = Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.donerTitle),
              Row(
                children: [
                  Text('${afterDate.day}/${afterDate.month}/${afterDate.year}'),
                  Text(AppLocalizations.of(context)!.donerMiddleTitle),
                  Text(
                      '${beforeDate.day}/${beforeDate.month}/${beforeDate.year}'),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      if (afterDate!.isAfter(now)) {
        result = Text(
            '${AppLocalizations.of(context)!.beforeRange} ${afterDate.day}/${afterDate.month}/${afterDate.year}');
      } else {
        result = Text(AppLocalizations.of(context)!.rangeOut);
      }
    }

    return result;
  }

  List<Widget> _buildSliverActivities(
      BuildContext context, List<Activity>? activities) {
    List<Widget> slivers = [];

    if (activities!.isEmpty) {
      slivers.add(
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context)!.noStravaActivities),
              )),
            ),
          ]),
        ),
      );
    } else {
      slivers.add(
        SliverPersistentHeader(
          pinned: false,
          delegate: SliverAppBarDelegate(
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) =>
                      _buildActivity(context, activities[index])),
            ),
          ),
        ),
      );
    }

    return slivers;
  }

  Widget _buildActivity(BuildContext context, Activity activity) {
    double distance = activity.distance! / 1000;
    IconData iconData;
    switch (activity.type) {
      case ActivityType.ride:
        iconData = FontAwesomeIcons.bicycle;
        break;
      case ActivityType.walk:
        iconData = FontAwesomeIcons.personWalking;
        break;
      default:
        iconData = FontAwesomeIcons.personRunning;
    }
    return Card(
      child: ListTile(
        leading: Icon(iconData),
        title: Text('${distance.toStringAsFixed(1)} Km'),
        subtitle: Text(
            '${activity.startDate!.day}/${activity.startDate!.month}/${activity.startDate!.year} ${activity.startDate!.hour}:${activity.startDate!.minute}'),
        trailing: _activityTrailing(context, activity),
      ),
    );
  }

  Widget _activityTrailing(BuildContext context, Activity activity) {
    Widget result;
    // ActivityStatus status = activity.status;

    // switch (status) {
    //   case ActivityStatus.waiting:
    //     result = const CircularProgressIndicator();
    //     break;
    //   case ActivityStatus.nodonate:
    result = ElevatedButton(
      child: Text(AppLocalizations.of(context)!.doner),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor)),
      onPressed: () {
        BlocProvider.of<DonorBloc>(context)
            .add(DonateKmEvent(activity.stravaId));
      },
    );
    //     break;
    //   case ActivityStatus.manual:
    //     result = ElevatedButton(
    //         child: Text(AppLocalizations.of(context)!.manualKm),
    //         style: ButtonStyle(
    //             backgroundColor: MaterialStateProperty.all(Colors.red)),
    //         onPressed: null);
    //     break;
    //   default:
    //     // result = ElevatedButton(
    //     //     child: Text(AppLocalizations.of(context)!.donerKm),
    //     //     style: ButtonStyle(
    //     //         backgroundColor: MaterialStateProperty.all(Colors.green)),
    //     //     onPressed: null);
    //     result = IconButton(
    //         icon: const Icon(FontAwesomeIcons.shareNodes),
    //         color: Colors.green,
    //         onPressed: () {
    //           double km = activity.distance! / 1000;
    //           String message = AppLocalizations.of(context)!.shareText(km);
    //           BlocProvider.of<DonorBloc>(context)
    //               .add(ShareActivityEvent(message));
    //         });
    // }

    return result;
  }
}
