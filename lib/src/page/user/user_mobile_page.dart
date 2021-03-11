import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/user_event.dart';
import 'package:yodravet/src/bloc/state/user_state.dart';
import 'package:yodravet/src/bloc/user_bloc.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/routes/route_name.dart';
import 'package:yodravet/src/widget/sliver_appbar_delegate.dart';

import 'user_basic_page.dart';

class UserMobilePage extends UserBasicPage {
  UserMobilePage(String title) : super(title);

  @override
  Widget body(BuildContext context) {
    List<Activity> activities = [];
    List<Widget> slivers = [];
    String fullname = '';
    String photoUrl = '';
    DateTime beforeDate;
    DateTime afterDate;
    bool _loading = false;
    bool isStravaLogin = false;
    bool lockStravaLogin = false;
    int _filterDonorTab = 0;
    List<ActivityPurchase> donors = [];

    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, state) {
        if (state is UserInitState) {
          BlocProvider.of<UserBloc>(context).add(LoadInitialDataEvent());
          _loading = true;
        } else if (state is UserLogInState) {
          // BlocProvider.of<UserBloc>(context).add(GetStravaActivitiesEvent());
        } else if (state is UserLogOutState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/' + RouteName.homePage, (route) => false);
          });
        } else if (state is UploadUserFieldsState) {
          isStravaLogin = state.isStravaLogin;
          lockStravaLogin = state.lockStravaLogin;
          fullname = state.fullname;
          photoUrl = state.photo;
          activities = state.activities;
          beforeDate = state.beforeDate;
          afterDate = state.afterDate;
          _filterDonorTab = state.filterDonorTab;
          donors = state.donors;
          _loading = false;
        }

        if (_loading) {
          return Center(child: CircularProgressIndicator());
        }

        slivers.clear();
        slivers = _buildSlivers(context, isStravaLogin, lockStravaLogin,
            fullname, photoUrl, beforeDate, afterDate);
        slivers
            .addAll(_buildSliverActivities(context, isStravaLogin, activities));
        slivers.add(_buildDonorsList(context, _filterDonorTab, donors));

        return CustomScrollView(
          slivers: slivers,
        );
      },
    );
  }

  List<Widget> _buildSlivers(
      BuildContext context,
      bool isStravaLogin,
      bool lockStravaLogin,
      String fullname,
      String photoUrl,
      DateTime beforeDate,
      DateTime afterDate) {
    List<Widget> slivers = [];
    Color primaryColor = Theme.of(context).primaryColor;

    //Botón cerrar sesión
    slivers.add(SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 40,
        maxHeight: 40,
        child: Container(
          color: Color.fromRGBO(153, 148, 86, 60 ),
          child: ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: photoUrl.isEmpty
                    ? Image.asset('assets/defaultAvatar.png')
                    : Image.network(photoUrl)),
            title: Text(fullname),
            trailing: ElevatedButton(
              child: Text('Cerrar Sesión'),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(primaryColor)),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
              },
            ),
          ),
        ),
      ),
    ));

    //Switch Strava login
    slivers.add(
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          minHeight: 40,
          maxHeight: 50,
          child: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Text('Conectar con Strava'),
                Icon(FontAwesomeIcons.strava, color: Colors.orange),
                Spacer(),
                Switch(
                    activeColor: Colors.green,
                    inactiveThumbColor:
                        lockStravaLogin ? Colors.grey : Colors.red,
                    value: isStravaLogin,
                    onChanged: lockStravaLogin
                        ? null
                        : (_) {
                            BlocProvider.of<UserBloc>(context)
                                .add(ConnectWithStravaEvent());
                          }),
              ],
            ),
          ),
        ),
      ),
    );

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
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: _buildActivitiesTitle(context, beforeDate, afterDate)),
        ),
      ));
    }
    return slivers;
  }

  Widget _buildActivitiesTitle(
      BuildContext context, DateTime beforeDate, DateTime afterDate) {
    Widget result;
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 00, 01, 00);

    if (now.isBefore(beforeDate) && now.isAfter(afterDate)) {
      result = Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dona tus kilómetros entre el'),
              Row(
                children: [
                  Text('${afterDate.day}' +
                      '/' +
                      '${afterDate.month}' +
                      '/' +
                      '${afterDate.year}'),
                  Text(' y el '),
                  Text('${beforeDate.day}' +
                      '/' +
                      '${beforeDate.month}' +
                      '/' +
                      '${beforeDate.year}'),
                ],
              ),
            ],
          ),
          Spacer(),
          IconButton(
              icon: Icon(FontAwesomeIcons.syncAlt),
              onPressed: () {
                BlocProvider.of<UserBloc>(context)
                    .add(GetStravaActivitiesEvent());
              }),
        ],
      );
    } else {
      result = Text('Podrás donar tus Km en la siguiente edición');
    }

    return result;
  }

  List<Widget> _buildSliverActivities(
      BuildContext context, bool isStravaLogin, List<Activity> activities) {
    List<Widget> slivers = [];

    if (isStravaLogin) {
      if (activities.length == 0) {
        slivers.add(
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Text('No se han encontrado actividades en Strava'),
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
                padding: EdgeInsets.all(8.0),
                color: Color.fromRGBO(153, 148, 86, 60 ),
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                  return _buildActivity(context, activities[index]);
                }),
              ),
            ),
          ),
        );
      }
    }

    return slivers;
  }

  Widget _buildActivity(BuildContext context, Activity activity) {
    double distance = activity.distance / 1000;
    IconData iconData;
    switch (activity.type) {
      case ActivityType.ride:
        iconData = FontAwesomeIcons.bicycle;
        break;
      case ActivityType.walk:
        iconData = FontAwesomeIcons.walking;
        break;
      default:
        iconData = FontAwesomeIcons.running;
    }
    return Card(
      child: ListTile(
        leading: Icon(iconData),
        title: Text('${distance.toString()}' + 'Km'),
        subtitle: Text('${activity.startDate.day}' +
            '/' +
            '${activity.startDate.month}' +
            '/' +
            '${activity.startDate.year}' +
            ' ' +
            '${activity.startDate.hour}' +
            ':' +
            '${activity.startDate.minute}'),
        trailing: _activityTrailing(context, activity),
      ),
    );
  }

  Widget _activityTrailing(BuildContext context, Activity activity) {
    Widget result;
    ActivityStatus status = activity.status;

    switch (status) {
      case ActivityStatus.waiting:
        result = CircularProgressIndicator();
        break;
      case ActivityStatus.nodonate:
        result = ElevatedButton(
          child: Text('Donar'),
          style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
          onPressed: () {
            BlocProvider.of<UserBloc>(context)
                .add(DonateKmEvent(activity.stravaId));
          },
        );
        break;
      case ActivityStatus.manual:
        result = ElevatedButton(
            child: Text('Km manuales'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: null);
        break;
      default:
        result = ElevatedButton(
            child: Text('Km Donados'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: null);
    }

    return result;
  }

  Widget _buildDonorsList(BuildContext context, int filterDonorTab, List<ActivityPurchase> donors) {
    return SliverList(
      delegate: SliverChildListDelegate(_buildDonors(context, filterDonorTab, donors)),
    );
  }

  List<Widget> _buildDonors(
      BuildContext context, int filterDonorTab, List<ActivityPurchase> donors) {
    List<Widget> slivers = [];
    int poleCounter = 1;

      slivers.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ranking Km Donados'),
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: filterDonorTab == 0 ? Theme.of(context).primaryColor : Colors.black,
                  icon: Icon(FontAwesomeIcons.star), onPressed: () { 
                    BlocProvider.of<UserBloc>(context).add(ChangeUserPodiumTabEvent(0));
                   },
                ),
                IconButton(
                  color: filterDonorTab == 1 ? Colors.blue : Colors.black,
                  icon: Icon(FontAwesomeIcons.walking), onPressed: () { 
                    BlocProvider.of<UserBloc>(context).add(ChangeUserPodiumTabEvent(1));
                   },
                ),
                IconButton(
                  color: filterDonorTab == 2 ? Colors.blue : Colors.black,
                  icon: Icon(FontAwesomeIcons.running), onPressed: () { 
                    BlocProvider.of<UserBloc>(context).add(ChangeUserPodiumTabEvent(2));
                   },
                ),
                IconButton(
                  color: filterDonorTab == 3 ? Colors.blue : Colors.black,
                  icon: Icon(FontAwesomeIcons.bicycle), onPressed: () { 
                    BlocProvider.of<UserBloc>(context).add(ChangeUserPodiumTabEvent(3));
                   },
                ),
            ]),
          ],
        ),
      ));

    for (ActivityPurchase donor in donors) {
      double distance = donor.distance / 1000;
      Widget userPhoto = donor.userPhoto.isEmpty
          ? Image.asset('assets/defaultAvatar.png')
          : Image.network(donor.userPhoto);
      IconData iconData;
      switch (donor.type) {
        case ActivityType.ride:
          iconData = FontAwesomeIcons.bicycle;
          break;
        case ActivityType.walk:
          iconData = FontAwesomeIcons.walking;
          break;
        default:
          iconData = FontAwesomeIcons.running;
      }

      if(filterDonorTab==0) {iconData = FontAwesomeIcons.star;}

      slivers.add(
        Stack(
          children: [
            Positioned(
              child: Card(
                child: Stack(
                  children: [
                    ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: userPhoto),
                      title: Text('${donor.userFullname}'),
                      subtitle: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(iconData)),
                      trailing: Text(
                        '${distance.toString()}' + 'Km',
                        style: TextStyle(fontSize: 19),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: poleCounter > 3 ? false : true,
              child: Positioned(
                left: 55.0,
                top: 23.0,
                width: 35,
                child: Image.asset(
                    'assets/medallas/medalla' + '$poleCounter' + '.png'),
              ),
            ),
          ],
        ),
      );

      poleCounter++;
    }

    return slivers;
  }
}
