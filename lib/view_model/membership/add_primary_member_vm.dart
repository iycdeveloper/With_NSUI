import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/primary_member.dart';
import 'package:iyc/app/data/resources/db_provider/membership/primary_member_db.dart';

import '../../di_container.dart';

class AddPrimaryMemberVM extends ChangeNotifier {
  bool loadingPage = false;
  bool showAddMemberPage = false;

  List<PrimaryMember> primaryMemberList = [];

  // BatchMember? batchMember;

  PrimaryMemberDB primaryMemberDB = sl<PrimaryMemberDB>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController idCardController = TextEditingController();

  init(BatchMember batch) async {
    loadingPage = true;
    // print(batch.memberId);
    primaryMemberList = await primaryMemberDB.getData(batch.memberId!);
    // print(primaryMemberList[0].firstName);
    // print(primaryMemberList.length);
    loadingPage = false;
    notifyListeners();
  }

  onChangedShowMemberPage() {
    print("On changed page");
    showAddMemberPage = !showAddMemberPage;
    notifyListeners();
  }

  void validatePrimaryMemberFormAndAdd(
      BuildContext context, BatchMember batchMember) async {
    loadingPage = true;
    notifyListeners();
    if (firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('First name is required')));
    }
    if (lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Last name is required')));
    }
    if (mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Mobile number is required')));
    }
    if (!['9', '8', '7', '6'].contains(mobileController.text[0])) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Mobile number is not valid')));
    }
    if (idCardController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Id card detail is required')));
    }
    try {
      print(batchMember.batchId);
      int count = primaryMemberList.length + 1;
      var primaryMember = PrimaryMember(
        memberId: '${batchMember.memberId}0$count',
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobile: mobileController.text,
        idCardNumber: idCardController.text,
        refererId: batchMember.memberId,
        batchNumber: batchMember.batchId,
        aggrId: batchMember.aggrId,
        assemblyCode: batchMember.assemblyCode,
        districtCode: batchMember.districtCode,
        stateCode: batchMember.stateCode,
        boothCode: batchMember.boothCode,
      );
      // print(primaryMember.toJson(primaryMember));
      // print(primaryMember.batchNumber);
      primaryMemberList.add(primaryMember);
      loadingPage = false;
      firstNameController.clear();
      lastNameController.clear();
      mobileController.clear();
      idCardController.clear();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void submit(bool isUpdate) async {
    if(isUpdate){
      primaryMemberList.forEach((element) async {
        await primaryMemberDB.updateData(element);
      });
    }else{
      primaryMemberList.forEach((element) async {
        await primaryMemberDB.insertData(element);
      });
    }

  }

  // void populateIntoModel() {
  // primaryMemberList = List.generate(
  //   10,
  //   (index) => PrimaryMember.fromBatchMember(
  //     batchMember,
  //   ).copyWith(
  //       // firstName: firstNameControllerList[index].text,
  //       // lastName: lastNameControllerList[index].text,
  //       // mobile: mobileControllerList[index].text,
  //       // idCardNumber: idCardControllerList[index].text),
  // );
  // }
}

///Member_Object mObject = new Member_Object();
//                     mObject.setAGGR_ID(mCompletedRegisterObjectUser.getAGGR_ID());
//                     mObject.setSTATE_CODE(mCompletedRegisterObjectUser.getSTATE_CODE());
//                     mObject.setDISTRICT_CODE(mCompletedRegisterObjectUser.getDISTRICT_CODE());
//                     mObject.setASSEMBLY_CODE(mAMAssembly);
//                     mObject.setBOOTH_CODE(mAMBooth);
//                     mObject.setACTIVE_STATUS("0");
//                     mObject.setREFERRER_ID(mAMBarcode);
//                     mObject.setCREATED_BY(mAMBarcode);
//                     mObject.setCREATED_ON(String
//                             .valueOf(Calendar.getInstance(TimeZone.getTimeZone("GMT"))
//                                     .getTimeInMillis()));
//                     mObject.setBATCH_NO(mBatchNumber);
//                     int primaryindex = i+1;
//                     String mPMIndex = String.valueOf(primaryindex);
//                     mObject.setMEMBER_ID(mAMBarcode+mPMIndex);
//                     mObject.setDECLARATION("1");
//                     mObject.setID_TYPE("EI");
//                     mObject.setTMP_ID(String
//                             .valueOf(Calendar.getInstance(TimeZone.getTimeZone("GMT"))
//                                     .getTimeInMillis())+i);
//                     mPrimaryObjectsArray.add(mObject);
