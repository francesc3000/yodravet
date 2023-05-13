import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/sponsor_event.dart';
import 'package:yodravet/src/bloc/sponsor_bloc.dart';
import 'package:yodravet/src/bloc/state/sponsor_state.dart';
import 'package:yodravet/src/model/collaborator.dart';
import 'package:yodravet/src/page/sponsor/widget/club_widget.dart';
import 'package:yodravet/src/page/sponsor/widget/promoter_widget.dart';
import 'package:yodravet/src/page/sponsor/widget/sponsor_widget.dart';

import '../../route/app_router_delegate.dart';
import 'sponsor_basic_page.dart';

class SponsorDesktopPage extends SponsorBasicPage {
  const SponsorDesktopPage(AppRouterDelegate routerDelegate, {Key? key})
      : super(routerDelegate, key: key);

  @override
  Widget body(BuildContext context) => BlocBuilder<SponsorBloc, SponsorState>(
        builder: (context, state) {
          List<Widget> slivers = [];
          List<Collaborator> sponsors = [];
          List<Collaborator> promoters = [];
          List<Collaborator> clubs = [];
          bool loading = false;

          if (state is SponsorInitState) {
            loading = true;
            BlocProvider.of<SponsorBloc>(context).add(SponsorInitDataEvent());
          } else if (state is UploadSponsorFields) {
            loading = false;
            sponsors = state.sponsors;
            promoters = state.promoters;
            clubs = state.clubs;
          }

          if (loading) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30.0),
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: const CircularProgressIndicator(),
            );
          }

          slivers.clear();
          slivers.add(
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 20)),
          );
          slivers.add(_buildSponsorGrid(context, sponsors));
          slivers.add(
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 20)),
          );
          slivers.add(_buildPromoterGrid(context, promoters));
          slivers.add(
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 20)),
          );
          slivers.add(_buildClubGrid(context, clubs));
          slivers.add(
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 20)),
          );

          return Container(
            padding: const EdgeInsets.only(left: 140.0, right: 8.0),
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromRGBO(153, 148, 86, 1),
            alignment: Alignment.center,
            child: CustomScrollView(
              slivers: slivers,
            ),
          );
        },
      );
}

Widget _buildSponsorGrid(BuildContext context, List<Collaborator> sponsors) =>
    SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        // childAspectRatio: 2.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => SponsorWidget(sponsors[index]),
        childCount: sponsors.length,
      ),
    );

Widget _buildPromoterGrid(BuildContext context, List<Collaborator> promoters) =>
    SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => PromoterWidget(promoters[index]),
        childCount: promoters.length,
      ),
    );

Widget _buildClubGrid(BuildContext context, List<Collaborator> clubs) =>
    SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) => ClubWidget(clubs[index]),
        childCount: clubs.length,
      ),
    );