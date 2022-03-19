import 'package:flutter/material.dart';
import 'package:yodravet/src/model/sponsor.dart';

class PromoterWidget extends StatelessWidget {
  final Sponsor promoter;
  const PromoterWidget(this.promoter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 150,
        width: 150,
        child: Card(
          elevation: 4.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
              side: BorderSide(width: 2, color: Colors.green)),
          child: Center(
            child: Image.asset(promoter.logoPath,
              height: 110,
              width: 110,
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
      );
}
