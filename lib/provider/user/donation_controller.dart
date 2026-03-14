class DonationController {
  int total = 0;

  void addDonation(int nominal) {
    total += nominal;
  }

  void reset() {
    total = 0;
  }
}
