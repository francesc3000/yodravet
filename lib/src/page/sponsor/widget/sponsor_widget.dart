import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/sponsor_event.dart';
import 'package:yodravet/src/bloc/sponsor_bloc.dart';
import 'package:yodravet/src/model/collaborator.dart';

class SponsorWidget extends StatelessWidget {
  final Collaborator sponsor;
  const SponsorWidget(this.sponsor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          height: 200,
          width: 200,
          child: Card(
            elevation: 4.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
                side: BorderSide(width: 2, color: Colors.green)),
            // child: SizedBox(
            //   height: 140,
            //   width: 140,
            //   child: CachedNetworkImageBuilder(
            //     url: sponsor.logoPath,
            //     builder: (image) => Image.asset("assets/images/avatar.png"),
            //   ),
            // ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
              child: Image(
                image: FirebaseImage(sponsor.logoPath),
                // fit: BoxFit.fitWidth,
                fit: BoxFit.scaleDown,
                height: 70,
                width: 70,
              ),
            ),
          ),
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
        ),
        onTap: () => BlocProvider.of<SponsorBloc>(context)
            .add(Navigate2WebsiteEvent(sponsor.id)),
      );
}
