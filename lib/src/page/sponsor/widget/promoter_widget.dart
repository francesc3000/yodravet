import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/sponsor_event.dart';
import 'package:yodravet/src/bloc/sponsor_bloc.dart';
import 'package:yodravet/src/model/collaborator.dart';

class PromoterWidget extends StatelessWidget {
  final Collaborator promoter;
  const PromoterWidget(this.promoter, {Key? key}) : super(key: key);

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
            //   url: promoter.logoPath,
            //   builder: (image) => Image.asset("assets/images/avatar.png"),
            // ),
            // ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
              child: ExtendedImage.network(
                promoter.logoPath,
                width: 110,
                height: 110,
                fit: BoxFit.scaleDown,
                cache: true,
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
    onTap: () => BlocProvider.of<SponsorBloc>(context)
        .add(Navigate2PromoterWebsiteEvent(promoter.id)),
  );
}
