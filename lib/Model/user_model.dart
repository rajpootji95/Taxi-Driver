class UserModel {
  String? id;
  String? name;
  String? userName;
  String? password;
  String? phone;
  String? address;
  String? email;
  String? licenseNo;
  String? carTypeId;
  String? carType;
  String? carNo;
  String? gender;
  String? dob;
  String? bankChaque;
  String? walletAmount;
  String? activeId;
  String? userStatus;
  String? type;
  String? driverBalance;
  String? rating;
  String? latitude;
  String? longitude;
  String? timetype;
  String? prefferedLocation;
  String? deviceId;
  String? insuranceNo;
  String? isVerified;
  String? isActive;
  String? isBlock;
  String? drivingLicenceNo;
  String? panCard;
  String? aadharCard;
  String? vehicalImege;
  String? carModel;
  String? otp;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? userImage;
  String? drivingLicencePhoto;
  String? referralCode;
  String? friendsCode;
  String? onlineOfline;
  String? panCardStatus1;
  String? vehicalImegeStatus;
  String? aadharCardStatus;
  String? userImageStatus;
  String? panCardStatus;
  String? createdAt;
  String? profileStatus;
  String? dateOfBirth;
  String? incentiveStatus;
  String? incentiveDate;
  String? homeAddress;
  String? profileStatusRead;
  String? profileReadStatus;
  String? bounusEndDate;
  String? bounusAmount;
  String? joiningIncBounus;
  String? insurance;
  String? newDriver;
  String? userGcmCode;
  String? reject;
  String? carImage;
  String? status;

  UserModel(
      {this.id,
      this.name,
      this.userName,
      this.password,
      this.phone,
      this.address,
      this.email,
      this.licenseNo,
      this.carTypeId,
      this.carType,
      this.carNo,
      this.gender,
      this.dob,
      this.bankChaque,
      this.walletAmount,
      this.activeId,
      this.userStatus,
      this.type,
      this.driverBalance,
      this.rating,
      this.latitude,
      this.longitude,
      this.timetype,
      this.prefferedLocation,
      this.deviceId,
      this.insuranceNo,
      this.isVerified,
      this.isActive,
      this.isBlock,
      this.drivingLicenceNo,
      this.panCard,
      this.aadharCard,
      this.vehicalImege,
      this.carModel,
      this.otp,
      this.bankName,
      this.accountNumber,
      this.ifscCode,
      this.userImage,
      this.drivingLicencePhoto,
      this.referralCode,
      this.friendsCode,
      this.onlineOfline,
      this.panCardStatus1,
      this.vehicalImegeStatus,
      this.aadharCardStatus,
      this.userImageStatus,
      this.panCardStatus,
      this.createdAt,
      this.profileStatus,
      this.dateOfBirth,
      this.incentiveStatus,
      this.incentiveDate,
      this.homeAddress,
      this.profileStatusRead,
      this.profileReadStatus,
      this.bounusEndDate,
      this.bounusAmount,
      this.joiningIncBounus,
      this.insurance,
      this.newDriver,
      this.userGcmCode,
      this.reject,
      this.carImage,
      this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userName = json['user_name'];
    password = json['password'];
    phone = json['phone'];
    address = json['address'];
    email = json['email'];
    licenseNo = json['license_no'];
    carTypeId = json['car_type_id'];
    carType = json['car_type'];
    carNo = json['car_no'];
    gender = json['gender'];
    dob = json['dob'];
    bankChaque = json['bank_chaque'];
    walletAmount = json['wallet_amount'];
    activeId = json['active_id'];
    userStatus = json['user_status'];
    type = json['type'];
    driverBalance = json['driver_balance'].toString();
    rating = json['rating'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    timetype = json['timetype'];
    prefferedLocation = json['preffered_location'];
    deviceId = json['device_id'];
    insuranceNo = json['insurance_no'];
    isVerified = json['is_verified'];
    isActive = json['is_active'];
    isBlock = json['is_block'];
    drivingLicenceNo = json['driving_licence_no'];
    panCard = json['pan_card'];
    aadharCard = json['aadhar_card'];
    vehicalImege = json['vehical_imege'];
    carModel = json['car_model'];
    otp = json['otp'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    userImage = json['user_image'];
    drivingLicencePhoto = json['driving_licence_photo'];
    referralCode = json['referral_code'];
    friendsCode = json['friends_code'];
    onlineOfline = json['online_ofline'];
    panCardStatus1 = json['pan_card_status1'];
    vehicalImegeStatus = json['vehical_imege_status'];
    aadharCardStatus = json['aadhar_card_status'];
    userImageStatus = json['user_image_status'];
    panCardStatus = json['pan_card_status'];
    createdAt = json['created_at'];
    profileStatus = json['profile_status'];
    dateOfBirth = json['date_of_birth'];
    incentiveStatus = json['incentive_status'];
    incentiveDate = json['incentive_date'];
    homeAddress = json['home_address'];
    profileStatusRead = json['profile_status_read'];
    profileReadStatus = json['profile_read_status'];
    bounusEndDate = json['bounus_end_date'];
    bounusAmount = json['bounus_amount'];
    joiningIncBounus = json['joining_inc_bounus'];
    insurance = json['insurance'];
    newDriver = json['new_driver'];
    userGcmCode = json['user_gcm_code'];
    reject = json['reject'];
    carImage = json['car_image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_name'] = this.userName;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['email'] = this.email;
    data['license_no'] = this.licenseNo;
    data['car_type_id'] = this.carTypeId;
    data['car_type'] = this.carType;
    data['car_no'] = this.carNo;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['bank_chaque'] = this.bankChaque;
    data['wallet_amount'] = this.walletAmount;
    data['active_id'] = this.activeId;
    data['user_status'] = this.userStatus;
    data['type'] = this.type;
    data['driver_balance'] = this.driverBalance;
    data['rating'] = this.rating;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['timetype'] = this.timetype;
    data['preffered_location'] = this.prefferedLocation;
    data['device_id'] = this.deviceId;
    data['insurance_no'] = this.insuranceNo;
    data['is_verified'] = this.isVerified;
    data['is_active'] = this.isActive;
    data['is_block'] = this.isBlock;
    data['driving_licence_no'] = this.drivingLicenceNo;
    data['pan_card'] = this.panCard;
    data['aadhar_card'] = this.aadharCard;
    data['vehical_imege'] = this.vehicalImege;
    data['car_model'] = this.carModel;
    data['otp'] = this.otp;
    data['bank_name'] = this.bankName;
    data['account_number'] = this.accountNumber;
    data['ifsc_code'] = this.ifscCode;
    data['user_image'] = this.userImage;
    data['driving_licence_photo'] = this.drivingLicencePhoto;
    data['referral_code'] = this.referralCode;
    data['friends_code'] = this.friendsCode;
    data['online_ofline'] = this.onlineOfline;
    data['pan_card_status1'] = this.panCardStatus1;
    data['vehical_imege_status'] = this.vehicalImegeStatus;
    data['aadhar_card_status'] = this.aadharCardStatus;
    data['user_image_status'] = this.userImageStatus;
    data['pan_card_status'] = this.panCardStatus;
    data['created_at'] = this.createdAt;
    data['profile_status'] = this.profileStatus;
    data['date_of_birth'] = this.dateOfBirth;
    data['incentive_status'] = this.incentiveStatus;
    data['incentive_date'] = this.incentiveDate;
    data['home_address'] = this.homeAddress;
    data['profile_status_read'] = this.profileStatusRead;
    data['profile_read_status'] = this.profileReadStatus;
    data['bounus_end_date'] = this.bounusEndDate;
    data['bounus_amount'] = this.bounusAmount;
    data['joining_inc_bounus'] = this.joiningIncBounus;
    data['insurance'] = this.insurance;
    data['new_driver'] = this.newDriver;
    data['user_gcm_code'] = this.userGcmCode;
    data['reject'] = this.reject;
    data['car_image'] = this.carImage;
    data['status'] = this.status;
    return data;
  }
}
