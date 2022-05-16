class Buyer implements Comparable {
  String id;
  double butterfly;
  DateTime date;
  double totalPurchase;
  String userId;
  String userFullname;
  String userPhoto;

  Buyer(
      {required this.id,
        required this.butterfly,
        required this.date,
        required this.totalPurchase,
        required this.userId,
        required this.userFullname,
        required this.userPhoto});

  @override
  int compareTo(other) {
    if (totalPurchase < other.totalPurchase) {
      return 1;
    }

    if (totalPurchase > other.totalPurchase) {
      return -1;
    }

    if (totalPurchase == other.totalPurchase) {
      if (butterfly < other.butterfly) {
        return 1;
      }

      if (butterfly > other.butterfly) {
        return -1;
      }

      return 0;
    }
    return 0;
  }
}
