import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/model/house/house_w.dart';
import 'package:project_view/model/user/change_pwd_w.dart';
import 'package:project_view/model/user/user.dart';
import 'package:project_view/model/user/user_login.dart';
import 'package:project_view/model/user/user_register_w.dart';
import 'package:project_view/model/user/user_w.dart';
import 'package:project_view/pages/components/area_filter.dart';
import 'package:project_view/pages/components/select_imgs.dart';
import 'package:project_view/pages/components/select_popmenu.dart';

import '../../../model/house/house.dart';
import '../../../model/house/house_info.dart';
import '../../../model/user/user_extra_info.dart';
import '../../../model/user/user_login_w.dart';

class EditInfoController {
  EditInfoController();

  /// all info
  final TextEditingController _password = TextEditingController();
  TextEditingController get password => _password;
  final TextEditingController _secondPassword = TextEditingController();
  TextEditingController get secondPassword => _secondPassword;
  final ProvinceFilterController _province = ProvinceFilterController();
  String? initProvinceCode;
  final AreaFilterController _addrCode = AreaFilterController();
  String? initAddrCode;
  final TextEditingController _addr = TextEditingController();
  final TextEditingController _nickName = TextEditingController();
  TextEditingController get nickName => _nickName;
  final TextEditingController _phones = TextEditingController();
  TextEditingController get phones => _phones;
  final TextEditingController _emails = TextEditingController();
  TextEditingController get emails => _emails;
  final TextEditingController _verifyCode = TextEditingController();
  TextEditingController get verifyCode => _verifyCode;

  /// house info
  ProvinceFilterController get houseTerritory => _province;
  AreaFilterController get houseAddrCode => _addrCode;
  TextEditingController get houseAddr => _addr;
  final SelectController _houseTardType = SelectController(
    const [
      SelectData(label: "出租", data: HouseModel.rentHouse),
      SelectData(label: "出售", data: HouseModel.sellHouse),
    ],
  );
  SelectController get houseTardType => _houseTardType;
  final TextEditingController _housePrice = TextEditingController();
  TextEditingController get housePrice => _housePrice;
  final SelectController _buyPayType = SelectController(
    const [
      SelectData(label: "一次性付款", data: BuyHouseInfo.buyPayOnce),
      SelectData(label: "按揭", data: BuyHouseInfo.buyPayMortgage),
      SelectData(label: "分期", data: BuyHouseInfo.buyPayInstallment),
    ],
  );
  SelectController get buyPayType => _buyPayType;
  final TextEditingController _houseArea = TextEditingController();
  TextEditingController get houseArea => _houseArea;
  final SelectController _rentPayType = SelectController(
    const [
      SelectData(label: '月付', data: RentHouseInfo.rentPayMonth),
      SelectData(label: '季付', data: RentHouseInfo.rentPayQuarter),
      SelectData(label: '半年付', data: RentHouseInfo.rentPayHalfYear),
      SelectData(label: '年付', data: RentHouseInfo.rentPayYear),
    ],
  );
  SelectController get rentPayType => _rentPayType;
  final SelectController _rentType = SelectController(
    const [
      SelectData(label: '整租', data: RentHouseInfo.rentTypeWhole),
      SelectData(label: '合租', data: RentHouseInfo.rentTypeJoint),
    ],
  );
  SelectController get rentType => _rentType;
  final TextEditingController _decoration = TextEditingController();
  TextEditingController get decoration => _decoration;
  final SelectImgController _houseFile = SelectImgController();
  SelectImgController get houseFile => _houseFile;

  void clearHouseInfo() {
    _province.reset();
    _addrCode.reset();
    _addr.clear();
    _houseTardType.clear();
    _housePrice.clear();
    _buyPayType.clear();
    _houseArea.clear();
    _rentPayType.clear();
    _rentType.clear();
    _decoration.clear();
    _houseFile.clean();
  }

  HouseWriteModel get houseInfo {
    final BaseHouseInfo info;
    final houseTardeType = houseTardType.firstValue;
    if (houseTardeType == HouseModel.rentHouse) {
      info = RentHouseInfo(
        rentPayType: rentPayType.selectValue.join(''),
        rentType: rentType.firstValue,
        decoration: decoration.text,
      );
    } else {
      info = BuyHouseInfo(
        houseArea: double.parse(houseArea.text),
        buyPayType: buyPayType.selectValue.join(''),
        decoration: decoration.text,
      );
    }
    return HouseWriteModel(
        houseTardeType: houseTardeType,
        houseTerritory: houseTerritory.code,
        houseAddrCode: houseAddrCode.code,
        houseAddr: houseAddr.text,
        housePrice: double.parse(housePrice.text),
        houseFile: houseFile.imageUrl.join(','),
        houseInfo: info);
  }

  void setHouseInfo(HouseModel model) {
    clearHouseInfo();
    initProvinceCode = model.houseTerritory;
    initAddrCode = model.houseAddrCode;
    _addr.text = model.houseAddr;
    _houseTardType.setFromStr(model.houseTardeType);
    _housePrice.text = model.housePrice.toString();
    _houseFile.addImgs(model.houseFileList);
    if (model.houseTardeType == HouseModel.rentHouse) {
      final info = model.houseInfo as RentHouseInfo;
      _rentPayType.setFromStr(info.rentPayType);
      _rentType.setFromStr(info.rentType);
      _decoration.text = info.decoration;
    } else {
      final info = model.houseInfo as BuyHouseInfo;
      _houseArea.text = info.houseArea.toString();
      _buyPayType.setFromStr(info.buyPayType);
      _decoration.text = info.decoration;
    }
  }

  /// user info
  final SelectController _sex = SelectController(
    const [
      SelectData(label: '男', data: UserExtraInfoModel.sexMan),
      SelectData(label: '女', data: UserExtraInfoModel.sexWoman),
      SelectData(label: '保密', data: UserExtraInfoModel.sexUnknown),
    ],
  );
  TextEditingController get addr => _addr;
  SelectController get sex => _sex;
  ProvinceFilterController get province => _province;
  AreaFilterController get addrCode => _addrCode;
  final TextEditingController _birthday = TextEditingController();
  TextEditingController get birthday => _birthday;
  final TextEditingController _signature = TextEditingController();
  TextEditingController get signature => _signature;
  final TextEditingController _favorite = TextEditingController();
  TextEditingController get favorite => _favorite;

  void clearUserInfo() {
    _nickName.clear();
    _sex.clear();
    _phones.clear();
    _emails.clear();
    _province.reset();
    _addrCode.reset();
    _addr.clear();
    _birthday.clear();
    _signature.clear();
    _favorite.clear();
  }

  UserWriteModle get userInfo => UserWriteModle(
        nickname: nickName.text,
        emails: emails.text,
        phones: phones.text,
        addrCode: addrCode.code,
        addr: _addr.text,
        avatar: null,
        extraInfo: UserExtraInfoModel(
          sex: _sex.firstValue,
          birthday: _birthday.text,
          signature: _signature.text,
          favorite: _favorite.text,
        ),
      );

  void setUserInfo(UserLoginModel? model) {
    if (model == null) return;
    clearUserInfo();
    _nickName.text = model.nickName;
    _phones.text = model.phones ?? '';
    _emails.text = model.emails ?? '';
    initAddrCode = model.addrCode;
    _addr.text = model.addr ?? '';
    _sex.setFromStr(model.extraInfo.sex);
    _birthday.text = model.extraInfo.birthday ?? '';
    _signature.text = model.extraInfo.signature ?? '';
    _favorite.text = model.extraInfo.favorite ?? '';
  }

  UserLoginModel? copyUser(UserLoginModel? model) {
    return model?.copyWith(
      nickName: nickName.text,
      phones: phones.text,
      emails: emails.text,
      addrCode: addrCode.code,
      addr: _addr.text,
      sex: _sex.firstValue,
      birthday: _birthday.text,
      signature: _signature.text,
      favorite: _favorite.text,
    );
  }

  /// LOGIN ADN REGISTER
  final TextEditingController _userName = TextEditingController();
  TextEditingController get userName => _userName;

  void cleanLogin() {
    _userName.clear();
    _password.clear();
    _verifyCode.clear();
  }

  UserLoginWriteModel loginInfo(String codeToken) => UserLoginWriteModel(
        userName: userName.text,
        password: password.text,
        code: verifyCode.text,
        codeToken: codeToken,
      );

  void cleanRegister() {
    _userName.clear();
    _password.clear();
    _secondPassword.clear();
    _nickName.clear();
    _phones.clear();
    _emails.clear();
    _verifyCode.clear();
  }

  UserRegisterWriteModel registerInfo(String codeToken) =>
      UserRegisterWriteModel(
        userName: userName.text,
        password: password.text,
        secondPassword: secondPassword.text,
        nickName: nickName.text,
        phones: phones.text,
        emails: emails.text,
        codeToken: codeToken,
        code: verifyCode.text,
      );

  /// change password
  final TextEditingController _oldPassword = TextEditingController();
  TextEditingController get oldPassword => _oldPassword;
  void clearPwd() {
    _oldPassword.clear();
    _password.clear();
    _secondPassword.clear();
    _verifyCode.clear();
  }

  ChangePwdWriteModel pwdInfo(String codeToken) => ChangePwdWriteModel(
        oldPassword: oldPassword.text,
        password: password.text,
        secondPassword: secondPassword.text,
        code: verifyCode.text,
        codeToken: codeToken,
      );

  final TextEditingController _message = TextEditingController();
  TextEditingController get message => _message;
  ScrollController scrollController = ScrollController();
  void clearMessage() {
    _message.clear();
  }

  void scrollToLastItem() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // users manage
  final RxList<UserModel> _users = RxList<UserModel>([]);
  List<UserModel> get users => _users;
  set users(List<UserModel> users) => _users.value = users;
  void setOfIndex(int index, UserModel model) => _users[index] = model;
  final RxBool _isExpanded = false.obs;
  bool get isExpanded => _isExpanded.value;
  set isExpanded(bool value) => _isExpanded.value = value;
  final RxInt _pageNum = 0.obs;
  int get pageNum => _pageNum.value;
  int pageSize = 15;
  final SelectController _permission = SelectController(
    const [
      SelectData(label: '管理员', data: UserModel.permissionAdmin),
      SelectData(label: '可登录', data: UserModel.permissionLogin),
      SelectData(label: '可发布', data: UserModel.permissionPublish),
    ],
  );
  SelectController get permission => _permission;
  final TextEditingController _search = TextEditingController();
  TextEditingController get search => _search;

  void clearUsersFilter() {
    _search.clear();
    _province.reset();
    _addrCode.reset();
    _permission.clear();
  }
}
