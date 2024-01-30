import 'package:app_tournament/config/app_information.dart';
import 'package:app_tournament/config/hive_open_ad.dart';
import 'package:app_tournament/services/auth.dart';
import 'package:app_tournament/services/firestore.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/settings/wallet/profile_update.dart';
import 'package:app_tournament/settings/wallet/transactions.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/container.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool loading = true;
  late Razorpay _razorpay;
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _withdrawWallet = TextEditingController();
  final TextEditingController _goodName = TextEditingController();

  bool _loadingAnimation = false;
  int? _radioValue = 1;
  Future loadingAnimation() async {
    setState(() {
      _loadingAnimation = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _loadingAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    final DarkModeProvider darkModeProvider =
        Provider.of<DarkModeProvider>(context);
    final user = AuthService().user;
    return SingleChildScrollView(
      child: Column(
        children: [
          DesignContainer(
            color: darkModeProvider.isDarkTheme
                ? DesignColor.blackFront
                : const Color(0xffffffff),
            margin: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DesignContainer.rounded(
                      allPadding: 0,
                      margin: const EdgeInsets.only(right: 8),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                          height: 64,
                          imageUrl: user!.isAnonymous
                              ? AppInformation().userProfile
                              : userData.profile,
                          fit: BoxFit.cover),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DesignText.bold1(
                          user.isAnonymous ? "Welcome to -" : userData.name,
                          fontWeight: 700,
                          color: darkModeProvider.isDarkTheme
                              ? Colors.white
                              : null,
                        ),
                        const SizedBox(height: 4),
                        DesignText.caption(
                          user.isAnonymous
                              ? AppInformation().appMainTitle
                              : userData.email,
                          xMuted: true,
                          fontWeight: 600,
                          color: darkModeProvider.isDarkTheme
                              ? Colors.white
                              : null,
                        ),
                        const SizedBox(height: 4),
                        DesignText.caption(
                          'Your Coins ' '${userData.coins}',
                          color: Colors.red,
                          fontWeight: 700,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          DesignContainer(
            color: darkModeProvider.isDarkTheme
                ? DesignColor.blackFront
                : const Color(0xffffffff),
            margin: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DesignButtons.icon(
                      icon: const Icon(Ionicons.wallet_outline),
                      textLabel: 'Withdraw',
                      colorText:
                          darkModeProvider.isDarkTheme ? Colors.white : null,
                      onPressed: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(6))),
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: ListView(
                                      children: [
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: _amount,
                                          decoration: const InputDecoration(
                                            labelText: 'Withdraw Amount',
                                            filled: true,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                            contentPadding: EdgeInsets.all(8),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.0),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        ListTile(
                                          title: DesignText.bold2(
                                            "Google Pay",
                                            color: darkModeProvider.isDarkTheme
                                                ? Colors.white
                                                : null,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          dense: true,
                                          leading: Radio(
                                            value: 1,
                                            activeColor: DesignColor.blueSmart,
                                            groupValue: _radioValue,
                                            onChanged: (int? value) {
                                              setState(() {
                                                _radioValue = value;
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: DesignText.bold1(
                                            "Paytm",
                                            color: darkModeProvider.isDarkTheme
                                                ? Colors.white
                                                : null,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          dense: true,
                                          leading: Radio(
                                            value: 2,
                                            activeColor: DesignColor.blueSmart,
                                            groupValue: _radioValue,
                                            onChanged: (int? value) {
                                              setState(() {
                                                _radioValue = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: _withdrawWallet,
                                          decoration: InputDecoration(
                                            labelText: _radioValue == 1
                                                ? 'Pay Number/UPI'
                                                : 'Paytm Number',
                                            filled: true,
                                            fillColor: userData.isDark
                                                ? DesignColor.blackFront
                                                : null,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.0),
                                            ),
                                          ),
                                          keyboardType: TextInputType.text,
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: _goodName,
                                          decoration: InputDecoration(
                                            labelText: 'Your Good Name',
                                            filled: true,
                                            fillColor: userData.isDark
                                                ? DesignColor.blackFront
                                                : null,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.0),
                                            ),
                                          ),
                                          keyboardType: TextInputType.text,
                                        ),
                                        const SizedBox(height: 20),
                                        DesignButtons.icon(
                                          icon: const Icon(
                                              Ionicons.wallet_outline),
                                          textLabel: 'Withdraw ',
                                          colorText:
                                              darkModeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : null,
                                          onPressed: () {
                                            if (_withdrawWallet.text.isEmpty ||
                                                _goodName.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: _withdrawWallet
                                                          .text.isEmpty
                                                      ? _radioValue == 1
                                                          ? 'Enter Pay Number/UPI'
                                                          : 'Enter Paytm Number'
                                                      : 'Please enter your good name',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                            } else {
                                              if (_amount.text.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg: "Add coins first",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              } else {
                                                if (!int.parse(_amount.text)
                                                    .isNegative) {
                                                  int.parse(_amount.text) <=
                                                              userData.coins &&
                                                          int.parse(_amount.text) !=
                                                              0
                                                      ? FirestoreService()
                                                          .updateWallet(
                                                              -int.parse(_amount.text)
                                                                  .abs(),
                                                              'Withdraw',
                                                              DateTime.now()
                                                                  .toString(),
                                                              _goodName.text,
                                                              _radioValue == 1
                                                                  ? 'Pay Number/UPI'
                                                                  : 'Paytm Number',
                                                              _withdrawWallet
                                                                  .text,
                                                              false)
                                                          .whenComplete(() => Fluttertoast.showToast(
                                                              msg: "SUCCESS",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT))
                                                          .whenComplete(() =>
                                                              Navigator.pop(
                                                                  context))
                                                      : Fluttertoast.showToast(
                                                          msg: "Coins Low",
                                                          toastLength:
                                                              Toast.LENGTH_SHORT);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Coins must be in Positive",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT);
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: DesignButtons.icon(
                      icon: const Icon(Ionicons.wallet_outline),
                      textLabel: 'ADD Money',
                      colorText:
                          darkModeProvider.isDarkTheme ? Colors.white : null,
                      onPressed: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(6))),
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: SizedBox(
                                  height: 170,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: ListView(
                                      children: [
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: _amount,
                                          decoration: const InputDecoration(
                                            labelText: 'Add Amount',
                                            filled: true,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                            contentPadding: EdgeInsets.all(16),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.0),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        const SizedBox(height: 20),
                                        DesignButtons.icon(
                                          icon: const Icon(
                                              Ionicons.wallet_outline),
                                          textLabel: 'ADD Money',
                                          onPressed: openCheckout,
                                          colorText:
                                              darkModeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : null,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          DesignContainer(
            color: darkModeProvider.isDarkTheme
                ? DesignColor.blackFront
                : const Color(0xffffffff),
            margin: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DesignText.bold1(
                  "Options",
                  fontWeight: 800,
                  color: darkModeProvider.isDarkTheme ? Colors.white : null,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) =>
                            const ProfileUpdate(),
                      ),
                    );
                  },
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    visualDensity: VisualDensity.compact,
                    title: Row(
                      children: [
                        const Icon(Ionicons.person_circle_outline, size: 18),
                        const SizedBox(width: 4),
                        DesignText.bold2(
                          "Profile Update",
                          letterSpacing: 0,
                          color: darkModeProvider.isDarkTheme
                              ? Colors.white
                              : null,
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: darkModeProvider.isDarkTheme ? Colors.white : null,
                    ),
                  ),
                ),
                SwitchListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  inactiveTrackColor: Colors.blueAccent.withAlpha(100),
                  activeTrackColor: Colors.blueAccent.withAlpha(150),
                  activeColor: Colors.blue,
                  title: Row(
                    children: [
                      const Icon(Ionicons.notifications_outline, size: 18),
                      const SizedBox(width: 4),
                      DesignText.bold2(
                        "Notifications",
                        letterSpacing: 0,
                        color:
                            darkModeProvider.isDarkTheme ? Colors.white : null,
                      ),
                    ],
                  ),
                  onChanged: (value) async {
                    await notificationActive(value);
                    setState(() {
                      notification = value;
                      debugPrint('topic hive toggle value-> $value');
                    });
                    // await Future.delayed(const Duration(seconds: 1));
                    notificationToggle();
                    loadingAnimation();
                  },
                  value: notification,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => const Transactions(),
                      ),
                    );
                  },
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    visualDensity: VisualDensity.compact,
                    title: Row(
                      children: [
                        const Icon(Ionicons.wallet_outline, size: 18),
                        const SizedBox(width: 4),
                        DesignText.bold2(
                          "Transactions",
                          letterSpacing: 0,
                          color: darkModeProvider.isDarkTheme
                              ? Colors.white
                              : null,
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: darkModeProvider.isDarkTheme ? Colors.white : null,
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                  title: Row(
                    children: [
                      const Icon(Ionicons.refresh_outline, size: 18),
                      const SizedBox(width: 4),
                      DesignText.bold2(
                        "More Coming Soon..",
                        color:
                            darkModeProvider.isDarkTheme ? Colors.white : null,
                        letterSpacing: 0,
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: darkModeProvider.isDarkTheme ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 4),
                DesignButtons.icon(
                  icon: const Icon(Ionicons.trail_sign_outline),
                  textLabel: 'Signout ',
                  colorText: darkModeProvider.isDarkTheme ? Colors.white : null,
                  onPressed: () async {
                    await AuthService().signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                ),
              ],
            ),
          ),
          if (_loadingAnimation)
            Lottie.asset(
              'assets/notification_bell.json',
              fit: BoxFit.fill,
            )
          else
            Container(),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_48WgUhjgo1IkOT',
      'amount': 100 * int.parse(_amount.text).abs(),
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    FirestoreService()
        .updateWallet(
            int.parse(_amount.text),
            'Transaction ID: ' + response.paymentId.toString(),
            DateTime.now().toString(),
            '',
            '',
            '',
            true)
        .whenComplete(() => Fluttertoast.showToast(
            msg: "SUCCESS: " + response.paymentId.toString(),
            toastLength: Toast.LENGTH_SHORT))
        .whenComplete(() => Navigator.pop(context));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // updateWallet
    // FirestoreService().updateWallet(11, 'anai', 123345);
    FirestoreService()
        .updateWallet(0, response.message.toString(), DateTime.now().toString(),
            '', '', '', true)
        .whenComplete(() => Fluttertoast.showToast(
            msg: "Faild: " + response.message.toString(),
            toastLength: Toast.LENGTH_SHORT))
        .whenComplete(() => Navigator.pop(context));
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
    // await Future.delayed(const Duration(seconds: 2));
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return const ProfileScreen();
    // }));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    FirestoreService()
        .updateWallet(
            0,
            'ExternalWalletResponse' + response.walletName.toString(),
            DateTime.now().toString(),
            '',
            '',
            '',
            true)
        .whenComplete(() => Fluttertoast.showToast(
            msg: "ExternalWalletResponse: " + response.walletName.toString(),
            toastLength: Toast.LENGTH_SHORT))
        .whenComplete(() => Navigator.pop(context));
  }
}
