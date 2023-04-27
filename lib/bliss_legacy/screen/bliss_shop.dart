import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oga_bliss/bliss_legacy/bliss_controller/shop_controller.dart';
import 'package:oga_bliss/bliss_legacy/bliss_widget/clipper_object.dart';
import 'package:oga_bliss/bliss_legacy/bliss_widget/shop_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BlissShop extends StatefulWidget {
  const BlissShop({Key? key}) : super(key: key);

  @override
  State<BlissShop> createState() => _BlissShopState();
}

class _BlissShopState extends State<BlissShop> {
  final shopController = ShopController().getXID;

  late ScrollController _controller;

  String? user_id;
  String? user_name;
  String? user_status;
  bool? admin_status;
  bool? isUserLogin;
  String? isbank_verify;

  initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId1 = prefs.getString('user_id');
    var userName1 = prefs.getString('user_name');
    var user_status1 = prefs.getString('user_status');
    var admin_status1 = prefs.getBool('admin_status');
    var isUserLogin1 = prefs.getBool('isUserLogin');
    var isbank_verify1 = prefs.getString('isbank_verify');

    if (mounted) {
      setState(() {
        user_id = userId1;
        user_name = userName1;
        user_status = user_status1;
        admin_status = admin_status1;
        isUserLogin = isUserLogin1;
        isbank_verify = isbank_verify1;
      });

      await shopController.getPlans(1, user_id);
    }
  }

  var current_page = 1;
  bool isLoading = false;
  bool widgetLoading = true;
  String? payableBalance;
  bool isJoin = false;
  int? disId;

  @override
  void initState() {
    initUserDetail();
    super.initState();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
        current_page++;
      });

      shopController.getPlansMore(current_page, user_id);

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  onTapClick() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 160.0, top: 20.0),
                    child: Text(
                      'Shop with Bliss Legacy',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                  ),
                  BlissClipperObject(
                    marginVal: 0,
                  ),
                  Obx(() => ListView.builder(
                        padding: const EdgeInsets.only(top: 0, bottom: 20),
                        shrinkWrap: true,
                        itemCount: shopController.plansList.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var data = shopController.plansList[index];
                          return shopWidget(
                            onTap: () async {
                              if (isbank_verify == 'yes') {
                                setState(() {
                                  //isJoin = true;
                                  disId = int.parse(data.disId!);
                                });

                                var planId = data.planId;
                                var planCode = data.planCode;

                                var link =
                                    'https://ogabliss.com/Subscription/join_sub/$user_id/$planId/$planCode';

                                Future.delayed(
                                  const Duration(seconds: 1),
                                  () async {
                                    setState(() {
                                      isJoin = false;
                                    });
                                    await _launchInBrowser(Uri.parse(link));
                                  },
                                );
                              } else {
                                Get.defaultDialog(
                                  title: 'Action Required',
                                  middleText: '',
                                  content: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 18.0, right: 18),
                                    child: Text(
                                      'Your Bank account it\'s not verify, please go to your profile to edit your bank details and click verify',
                                      style: TextStyle(),
                                    ),
                                  ),
                                  textCancel: 'Cancel',
                                  onCancel: () {},
                                  radius: 5,
                                );
                              }
                            },
                            planImg: '${data.planImage}',
                            planName: '${data.planName}',
                            planInterval: '${data.planInterval}',
                            planLimit: '${data.planLimit}',
                            planAmount: '${data.planAmount}',
                            isLoading: isJoin,
                            isSubscribe: data.isSubscribe!,
                          );
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => (shopController.plansList.isNotEmpty)
            ? Container()
            : InkWell(
                onTap: () {
                  setState(() {
                    shopController.isShoprocessing.value = 'null';
                    shopController.getPlans(1, user_id);
                    shopController.plansList.refresh();
                  });
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: Colors.blue.shade900,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
