import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/sponsor_event.dart';
import 'package:yodravet/src/bloc/sponsor_bloc.dart';
import 'package:yodravet/src/model/collaborator.dart';

class ClubWidget extends StatelessWidget {
  final Collaborator club;
  const ClubWidget(this.club, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: Container(
          height: 110,
          width: 110,
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
            //   builder: (image) => Image.asset("assets/images/avatar.png"),
            // ),
            // ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
              child: Image(
                image: FirebaseImage(club.logoPath),
                // fit: BoxFit.fitWidth,
                height: 110,
                width: 110,
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
    onTap: () => BlocProvider.of<SponsorBloc>(context)
        .add(Navigate2ClubWebsiteEvent(club.id)),
  );
}
