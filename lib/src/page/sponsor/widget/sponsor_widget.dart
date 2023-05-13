import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/sponsor_event.dart';
import 'package:yodravet/src/bloc/sponsor_bloc.dart';
import 'package:yodravet/src/model/collaborator.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

class SponsorWidget extends StatelessWidget {
  final Collaborator sponsor;
  const SponsorWidget(this.sponsor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 140, 71, 153),
                blurRadius: 5.0,
                offset: Offset(0, 10),
                spreadRadius: 0.5,
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Card(
            elevation: 4.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
                side: BorderSide(width: 2, color: Colors.green)),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
              child: Image(
                image: _getImage(),
                width: 110,
                height: 110,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        onTap: () => BlocProvider.of<SponsorBloc>(context)
            .add(Navigate2SponsorWebsiteEvent(sponsor.id)),
      );

  ImageProvider<Object> _getImage() {
    if ( PlatformDiscover.isWeb() ) {
      return NetworkImage(sponsor.logoPath);
    } else {
      return CachedNetworkImageProvider(sponsor.logoPath);
    }
  }
}
