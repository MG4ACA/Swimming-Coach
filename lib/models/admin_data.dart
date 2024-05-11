class AdminData {
  String? token;
  String? email;
  String? selectLevel;

  String? dayOneTitle;
  String? dayOneWarmUp;
  String? dayOneDrills;
  String? dayOneMainSet;
  String? dayOneCoolDown;

  String? dayTwoTitle;
  String? dayTwoWarmUp;
  String? dayTwoDrills;
  String? dayTwoCoolDown;

  String? dayThreeTitle;
  String? dayThreeDryland;
  String? dayThreePool;
  String? dayThreeCoolDown;
  String? dayForeTitle;

  String? dayFiveTitle;
  String? dayFiveWarmUp;
  String? dayFiveCoolDown;

  String? daySixTitle;
  String? daySixWarmUp;
  String? daySixMainSet;
  String? daySixCoolDown;

  String? daySevenTitle;

  bool? activeStatus;

  AdminData({
    this.token,
    this.email,
    this.selectLevel,
    this.dayOneTitle,
    this.dayOneWarmUp,
    this.dayOneDrills,
    this.dayOneMainSet,
    this.dayOneCoolDown,
    this.dayTwoTitle,
    this.dayTwoWarmUp,
    this.dayTwoDrills,
    this.dayTwoCoolDown,
    this.dayThreeTitle,
    this.dayThreeDryland,
    this.dayThreePool,
    this.dayThreeCoolDown,
    this.dayForeTitle,
    this.dayFiveTitle,
    this.dayFiveWarmUp,
    this.dayFiveCoolDown,
    this.daySixTitle,
    this.daySixWarmUp,
    this.daySixMainSet,
    this.daySixCoolDown,
    this.daySevenTitle,
    this.activeStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "userEmail": email,
      "selectLevel": selectLevel,
      "dayOneTitle": dayOneTitle,
      "dayOneWarmUp": dayOneWarmUp,
      "dayOneDrills": dayOneDrills,
      "dayOneMainSet": dayOneMainSet,
      "dayOneCoolDown": dayOneCoolDown,
      "dayTwoTitle": dayTwoTitle,
      "dayTwoWarmUp": dayTwoWarmUp,
      "dayTwoDrills": dayTwoDrills,
      "dayTwoCoolDown": dayTwoCoolDown,
      "dayThreeTitle": dayThreeTitle,
      "dayThreeDryland": dayThreeDryland,
      "dayThreePool": dayThreePool,
      "dayThreeCoolDown": dayThreeCoolDown,
      "dayForeTitle": dayForeTitle,
      "dayFiveTitle": dayFiveTitle,
      "dayFiveWarmUp": dayFiveWarmUp,
      "dayFiveCoolDown": dayFiveCoolDown,
      "daySixTitle": daySixTitle,
      "daySixWarmUp": daySixWarmUp,
      "daySixMainSet": daySixMainSet,
      "daySixCoolDown": daySixCoolDown,
      "daySevenTitle": daySevenTitle,
      "activeStatus": activeStatus,
    };
  }

  factory AdminData.fromJson(Map<String, dynamic> fromJson) {
    return AdminData(
        token: fromJson["token"],
        email: fromJson["userEmail"],
        selectLevel: fromJson["selectLevel"],
        dayOneTitle: fromJson["dayOneTitle"],
        dayOneWarmUp: fromJson["dayOneWarmUp"],
        dayOneDrills: fromJson["dayOneDrills"],
        dayOneMainSet: fromJson["dayOneMainSet"],
        dayOneCoolDown: fromJson["dayOneCoolDown"],
        dayTwoTitle: fromJson["dayTwoTitle"],
        dayTwoWarmUp: fromJson["dayTwoWarmUp"],
        dayTwoDrills: fromJson["dayTwoDrills"],
        dayTwoCoolDown: fromJson["dayTwoCoolDown"],
        dayThreeTitle: fromJson["dayThreeTitle"],
        dayThreeDryland: fromJson["dayThreeDryland"],
        dayThreePool: fromJson["dayThreePool"],
        dayThreeCoolDown: fromJson["dayThreeCoolDown"],
        dayForeTitle: fromJson["dayForeTitle"],
        dayFiveTitle: fromJson["dayFiveTitle"],
        dayFiveWarmUp: fromJson["dayFiveWarmUp"],
        dayFiveCoolDown: fromJson["dayFiveCoolDown"],
        daySixTitle: fromJson["daySixTitle"],
        daySixWarmUp: fromJson["daySixWarmUp"],
        daySixMainSet: fromJson["daySixMainSet"],
        daySixCoolDown: fromJson["daySixCoolDown"],
        daySevenTitle: fromJson["daySevenTitle"],
        activeStatus: fromJson["activeStatus"]);
  }
}
