import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/sponsor_event.dart';
import 'package:yodravet/src/bloc/sponsor_bloc.dart';
import 'package:yodravet/src/bloc/state/sponsor_state.dart';
import 'package:yodravet/src/model/collaborator.dart';
import 'package:yodravet/src/page/sponsor/widget/promoter_widget.dart';
import 'package:yodravet/src/page/sponsor/widget/sponsor_widget.dart';

import '../../route/app_router_delegate.dart';
import 'sponsor_basic_page.dart';

class SponsorMobilePage extends SponsorBasicPage {
  const SponsorMobilePage(AppRouterDelegate routerDelegate, {Key? key})
      : super(routerDelegate, key: key);

  @override
  Widget body(BuildContext context) => BlocBuilder<SponsorBloc, SponsorState>(
        builder: (context, state) {
          List<Widget> _slivers = [];
          List<Collaborator> _sponsors = [];
          List<Collaborator> _promoters = [];
          bool _loading = false;

          if (state is SponsorInitState) {
            _loading = true;
            BlocProvider.of<SponsorBloc>(context).add(SponsorInitDataEvent());
          } else if (state is UploadSponsorFields) {
            _loading = false;
            _sponsors = state.sponsors;
            _promoters = state.promoters;
          }

          if (_loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          _slivers.clear();
          _slivers.add(
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 20)),
          );
          _slivers.add(_buildSponsorGrid(context, _sponsors));
          _slivers.add(
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 20)),
          );
          _slivers.add(_buildPromoterGrid(context, _promoters));

          return Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromRGBO(153, 148, 86, 1),
            alignment: Alignment.center,
            child: CustomScrollView(
              slivers: _slivers,
            ),
          );
        },
      );
}

Widget _buildSponsorGrid(BuildContext context, List<Collaborator> sponsors) =>
    SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
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
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => PromoterWidget(promoters[index]),
        childCount: promoters.length,
      ),
    );
