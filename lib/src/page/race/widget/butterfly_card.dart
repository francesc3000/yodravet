import 'package:flutter/material.dart';
import 'package:yodravet/src/model/buyer.dart';

class ButterflyCard extends StatelessWidget {
  final Buyer buyer;
  final int poleCounter;
  const ButterflyCard(this.buyer, this.poleCounter, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget userPhoto = buyer.userPhoto.isEmpty
        ? Image.asset(
            'assets/images/avatar.webp',
            height: 75,
          )
        : Image.network(
            buyer.userPhoto,
            loadingBuilder: (context, child, imageEvent) => Image.asset(
              'assets/images/avatar.webp',
              height: 75,
            ),
          );

    // return Card(
    //   color: const Color.fromRGBO(89, 63, 153, 1),
    //   child: ListTile(
    //     minVerticalPadding: 100,
    //     leading: ClipRRect(
    //         borderRadius: BorderRadius.circular(100),
    //         child: Container(color: Colors.white, child: userPhoto)),
    //     title: Text(buyer.userFullname),
    //     subtitle: Text('${buyer.totalPurchase}' ' €'),
    //     trailing: Stack(
    //       children: [
    //         Positioned(
    //           child: Image.asset(
    //             "assets/images/butterflies.webp",
    //           ),
    //         ),
    //         Positioned(
    //           child: Text(
    //             '${buyer.butterfly.toInt()}',
    //             style: const TextStyle(fontSize: 14),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Card(
      color: const Color.fromRGBO(89, 63, 153, 1),
      child: Stack(children: [
        Positioned(
          top: 10,
          left: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(color: Colors.white, child: userPhoto),
          ),
        ),
        Positioned(
          top: 10,
          left: 100,
          width: MediaQuery.of(context).size.width - 100 - 100,
          child: Text(
            buyer.userFullname,
            style: const TextStyle(fontSize: 25),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Stack(
            children: [
              Positioned(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Image.asset(
                    "assets/images/cantimplora.png",
                    scale: 3,
                    //height: 145,
                  ),
                ),
              ),
              Positioned(
                top: 90,
                left: 35,
                child: Text(
                  '${buyer.butterfly.toInt()}',
                  style: const TextStyle(fontSize: 19),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: poleCounter > 3 ? false : true,
          child: Positioned(
            top: 60.0,
            left: 60.0,
            width: 35,
            child:
                Image.asset('assets/images/medallas/medalla$poleCounter.png'),
          ),
        ),
      ]),
    );
  }
}
