import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'bank-details_interactor.dart';
import 'bank_details_ui.dart';

class BankDetailsPage extends StatefulWidget {
  // final VoidCallback onAddBankDone;

  BankDetailsPage();

  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage>
    implements BankDetailsInteractor {
  @override
  Widget build(BuildContext context) {
    return BankDetailsUI();
  }

  @override
  void addBank() {
    // widget.onAddBankDone();
  }

  @override
  void skip() {
    // widget.onAddBankDone();
  }
}
