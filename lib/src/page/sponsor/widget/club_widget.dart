import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/sponsor_event.dart';
import 'package:yodravet/src/bloc/sponsor_bloc.dart';
import 'package:yodravet/src/model/collaborator.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

class ClubWidget extends StatelessWidget {
  final Collaborator club;
  const ClubWidget(this.club, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          height: 110,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Card(
            elevation: 4.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
                side: BorderSide(width: 2, color: Colors.green)),
            // child: SizedBox(
            //     height: 110,
            //     width: 110,
            // child: CachedNetworkImageBuilder(
            //   url: club.logoPath,
            //   builder: (image) => Image.asset("assets/images/avatar.webp"),
            // ),
            // ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
              child: Image(
                  //image: PCacheImage(club.logoPath, enableInMemory: true),
                  image: _getImage(),
                  width: 110,
                  height: 110,
                  fit: BoxFit.scaleDown,
              ),
              // child: ExtendedImage.network(
              //   club.logoPath,
              //   width: 110,
              //   height: 110,
              //   fit: BoxFit.scaleDown,
              //   cache: true,
              // ),
            ),
          ),
        ),
        onTap: () => BlocProvider.of<SponsorBloc>(context)
            .add(Navigate2ClubWebsiteEvent(club.id)),
      );
  ImageProvider<Object> _getImage() {
    if ( PlatformDiscover.isWeb() ) {
      return NetworkImage(club.logoPath);
    } else {
      return CachedNetworkImageProvider(club.logoPath);
    }
  }
}
