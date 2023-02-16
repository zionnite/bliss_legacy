import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oga_bliss/util/common.dart';

import '../model/users_model.dart';
import '../services/api_services.dart';

class UsersController extends GetxController {
  UsersController get getXID => Get.find<UsersController>();

  var page_num = 1;
  var isUserFetchProcessing = 'null'.obs;
  var isAgentFetchProcessing = 'null'.obs;
  var isMoreDataAvailable = true.obs;
  var isUserFetching = false.obs;
  var usersList = <UsersModel>[].obs;
  var disUsersList = <UsersModel>[].obs;
  var landLordList = <UsersModel>[].obs;

  // String? user_id;
  // bool? admin_status;
  // String? user_status;

  @override
  void onInit() async {
    super.onInit();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // user_id = prefs.getString('user_id');
    // admin_status = prefs.getBool('admin_status');
    // user_status = prefs.getString('user_status');
    // await getUsers(page_num);
    // await getLandlord(page_num);
  }

  getUsers(pageNum) async {
    var seeker = await ApiServices.getUsers(pageNum);
    if (seeker != null) {
      isUserFetchProcessing.value = 'yes';
      usersList.value = seeker.cast<UsersModel>();
    } else {
      isUserFetchProcessing.value = 'no';
    }
  }

  getUsersMore(pageNum) async {
    var seeker = await ApiServices.getUsers(pageNum);
    if (seeker != null) {
      usersList.addAll(seeker.cast<UsersModel>());
    } else {}
  }

  getLandlord(pageNum) async {
    var seeker = await ApiServices.getLandlords(pageNum);
    if (seeker != null) {
      isAgentFetchProcessing.value = 'yes';
      landLordList.value = seeker.cast<UsersModel>();
    } else {
      isAgentFetchProcessing.value = 'no';
    }
  }

  getLandLordsMore(pageNum) async {
    var seeker = await ApiServices.getLandlords(pageNum);
    if (seeker != null) {
      landLordList.addAll(seeker.cast<UsersModel>());
    } else {}
  }

  Future<String> toggleBan({
    required String userId,
  }) async {
    String? msg;
    String status = await ApiServices.toggleBan(UserId: userId);
    if (status == 'ban') {
      msg = 'User Added to Ban List';
      showSnackBar(
          title: 'User Management', msg: msg, backgroundColor: Colors.blue);
      return 'ban';
    } else if (status == 'unban') {
      msg = 'User Removed from Ban List';
      showSnackBar(
          title: 'User Management', msg: msg, backgroundColor: Colors.blue);
      return 'unban';
    } else {
      msg = 'Database Busy, Could not perform operation, Pls Try Again Later!';
      showSnackBar(
          title: 'User Management', msg: msg, backgroundColor: Colors.blue);
      return 'false';
    }
  }

  Future<bool> deleteUser({
    required String userId,
  }) async {
    String? msg;
    bool status = await ApiServices.deleteUser(UserId: userId);
    if (status) {
      msg = 'User Removed from Database';
      showSnackBar(
          title: 'User Management', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = 'Database Busy, Could not perform operation, Pls Try Again Later!';
      showSnackBar(
          title: 'User Management', msg: msg, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future<bool> sendEmail({
    required String disUserId,
    required String fullName,
    required String email,
    required String subject,
    required String message,
  }) async {
    String? msg;
    bool status = await ApiServices.sendEmail(
        disUserId: disUserId,
        fullName: fullName,
        email: email,
        subject: subject,
        message: message);
    if (status) {
      msg = 'Email Sent...';
      showSnackBar(
          title: 'User Management', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = 'Email having trouble delivering';
      showSnackBar(
          title: 'User Management', msg: msg, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future<bool> signUp({
    required String userName,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String usersType,
  }) async {
    String? msg;
    String status = await ApiServices.signUp(
      userName: userName,
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      userType: usersType,
    );
    if (status == 'true') {
      msg = 'Account Creation was successful...';
      showSnackBar(
          title: 'Account Creation', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = '';
      showSnackBar(
          title: 'Account Creation', msg: status, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    String? msg;
    String status = await ApiServices.login(
      email: email,
      password: password,
    );
    if (status == 'true') {
      msg = 'Login Successful...';
      showSnackBar(title: 'Success', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = '';
      showSnackBar(title: 'Oops', msg: status, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
  }) async {
    String? msg;
    String status = await ApiServices.resetPassword(
      email: email,
    );
    if (status == 'true') {
      msg =
          'An Email has been Sent to the provided email for further instruction!...';
      showSnackBar(
          title: 'Congratulation', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = '';
      showSnackBar(title: 'Oops', msg: status, backgroundColor: Colors.blue);
      return false;
    }
  }

  getDisUser(var userId) async {
    disUsersList.clear();
    isUserFetching(true);
    var seeker = await ApiServices.getDisUser(userId);
    if (seeker != null) {
      isUserFetching(false);
      disUsersList.value = seeker.cast<UsersModel>();
    } else {
      isUserFetching(false);
    }
  }

  Future<bool> updateUserBio({
    required String fullName,
    required String email,
    required String phone,
    required String age,
    required String address,
    required String sex,
    required String my_id,
  }) async {
    String? msg;
    String status = await ApiServices.updateUserBio(
      fullName: fullName,
      email: email,
      phone: phone,
      age: age,
      address: address,
      sex: sex,
      my_id: my_id,
    );
    if (status == 'true') {
      msg = 'Update Successful...';
      showSnackBar(title: 'Success', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = 'Could not update Profile';
      showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future<bool> updateUserBank({
    required String accountName,
    required String accountNum,
    required String bankName,
    required String my_id,
  }) async {
    String? msg;
    String status = await ApiServices.updateUserBank(
      accountName: accountName,
      accountNum: accountNum,
      bankName: bankName,
      my_id: my_id,
    );
    if (status == 'true') {
      msg = 'Update Successful...';
      showSnackBar(title: 'Success', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else {
      msg = 'Could not update Profile';
      showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.blue);
      return false;
    }
  }

  uploadImage(var userId, File imageName) async {
    var status =
        await ApiServices.uploadUserImage(userId: userId, image: imageName);

    String? msg;

    if (status != false) {
      msg = 'Image Uploaded';
      showSnackBar(title: 'Product', msg: msg, backgroundColor: Colors.blue);

      return status;
    } else {
      msg = 'Database Busy, Could not perform operation, Pls Try Again Later!';
      showSnackBar(title: 'Product', msg: msg, backgroundColor: Colors.blue);
      return false;
    }
  }

  Future<bool> verifyBank({
    required String accountNum,
    required String bankCode,
    required String my_id,
  }) async {
    String? msg;
    String status = await ApiServices.verifyBank(
      accountNum: accountNum,
      bankCode: bankCode,
      my_id: my_id,
    );
    if (status == 'true') {
      msg = 'Verify Successful...';

      showSnackBar(title: 'Success', msg: msg, backgroundColor: Colors.blue);
      return true;
    } else if (status == 'fail') {
      msg = 'Verify Successful, but could not update your profile';
      showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.blue);
      return false;
    } else {
      msg =
          'Could not verify bank account detail, pls try updating your bank details and come try again';
      showSnackBar(title: 'Oops', msg: msg, backgroundColor: Colors.blue);
      return false;
    }
  }
}
