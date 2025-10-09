import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/skill_model.dart';
import 'package:picpee_mobile/services/skill_service.dart';

class SkillProvider with ChangeNotifier {
  final SkillService _skillService = SkillService();
  bool _isLoading = false;
  SkillModel? HDRTopDesigner;
  SkillModel? VHSTopDesigner;
  SkillModel? PropertyTopDesigner;
  SkillModel? CleaningTopDesigner;
  SkillModel? DTDTopDesigner;
  SkillModel? SingleTopDesigner;
  SkillModel? FlamTopDesigner;
  SkillModel? I360ETopDesigner;
  SkillModel? RemoveTopDesigner;
  SkillModel? I360TopDesigner;
  SkillModel? TWTopDesigner;
  SkillModel? RemoveItemTopDesigner;
  SkillModel? ChangeSeasonTopDesigner;
  SkillModel? WaterTopDesigner;
  SkillModel? LawnTopDesigner;
  SkillModel? RainTopDesigner;
  SkillModel? Cus2DTopDesigner;
  SkillModel? Cus3DTopDesigner;
  SkillModel? WalkthroughTopDesigner;
  SkillModel? ReelsVideoEditTopDesigner;
  SkillModel? SlideTopDesigner;
  SkillModel? IndividualTopDesigner;
  SkillModel? TeamTopDesigner;
  SkillModel? AddPersonTopDesigner;
  SkillModel? RemovePersonTopDesigner;
  SkillModel? BackgroundReplacementTopDesigner;
  SkillModel? CutOutChangeColorTopDesigner;
  SkillModel? ChangeColorTopDesigner;
  List<SkillModel> haveTopDesigners = [];

  bool get isLoading => _isLoading;
  SkillModel? get hdrTopDesigner => HDRTopDesigner;
  SkillModel? get vhsTopDesigner => VHSTopDesigner;
  SkillModel? get propertyTopDesigner => PropertyTopDesigner;
  SkillModel? get cleaningTopDesigner => CleaningTopDesigner;
  SkillModel? get dtdTopDesigner => DTDTopDesigner;
  SkillModel? get singleTopDesigner => SingleTopDesigner;
  SkillModel? get flamTopDesigner => FlamTopDesigner;
  SkillModel? get i360ETopDesigner => I360ETopDesigner;
  SkillModel? get removeTopDesigner => RemoveTopDesigner;
  SkillModel? get i360TopDesigner => I360TopDesigner;
  SkillModel? get tWTopDesigner => TWTopDesigner;
  SkillModel? get removeItemTopDesigner => RemoveItemTopDesigner;
  SkillModel? get changeSeasonTopDesigner => ChangeSeasonTopDesigner;
  SkillModel? get waterTopDesigner => WaterTopDesigner;
  SkillModel? get lawnTopDesigner => LawnTopDesigner;
  SkillModel? get rainTopDesigner => RainTopDesigner;
  SkillModel? get cus2DTopDesigner => Cus2DTopDesigner;
  SkillModel? get cus3DTopDesigner => Cus3DTopDesigner;
  SkillModel? get walkthroughTopDesigner => WalkthroughTopDesigner;
  SkillModel? get reelsVideoEditTopDesigner => ReelsVideoEditTopDesigner;
  SkillModel? get slideTopDesigner => SlideTopDesigner;
  SkillModel? get individualTopDesigner => IndividualTopDesigner;
  SkillModel? get teamTopDesigner => TeamTopDesigner;
  SkillModel? get addPersonTopDesigner => AddPersonTopDesigner;
  SkillModel? get removePersonTopDesigner => RemovePersonTopDesigner;
  SkillModel? get backgroundReplacementTopDesigner =>
      BackgroundReplacementTopDesigner;
  SkillModel? get cutOutChangeColorTopDesigner => CutOutChangeColorTopDesigner;
  SkillModel? get changeColorTopDesigner => ChangeColorTopDesigner;
  List<SkillModel> get getHaveTopDesigners => haveTopDesigners;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setHaveTopDesigners() {
    haveTopDesigners = [
      if (HDRTopDesigner!.topDesigners.isNotEmpty) HDRTopDesigner!,
      if (VHSTopDesigner!.topDesigners.isNotEmpty) VHSTopDesigner!,
      if (PropertyTopDesigner!.topDesigners.isNotEmpty) PropertyTopDesigner!,
      if (CleaningTopDesigner!.topDesigners.isNotEmpty) CleaningTopDesigner!,
      if (DTDTopDesigner!.topDesigners.isNotEmpty) DTDTopDesigner!,
      if (SingleTopDesigner!.topDesigners.isNotEmpty) SingleTopDesigner!,
      if (FlamTopDesigner!.topDesigners.isNotEmpty) FlamTopDesigner!,
      if (I360ETopDesigner!.topDesigners.isNotEmpty) I360ETopDesigner!,
      if (RemoveTopDesigner!.topDesigners.isNotEmpty) RemoveTopDesigner!,
      if (I360TopDesigner!.topDesigners.isNotEmpty) I360TopDesigner!,
      if (TWTopDesigner!.topDesigners.isNotEmpty) TWTopDesigner!,
      if (RemoveItemTopDesigner!.topDesigners.isNotEmpty)
        RemoveItemTopDesigner!,
      if (ChangeSeasonTopDesigner!.topDesigners.isNotEmpty)
        ChangeSeasonTopDesigner!,
      if (WaterTopDesigner!.topDesigners.isNotEmpty) WaterTopDesigner!,
      if (LawnTopDesigner!.topDesigners.isNotEmpty) LawnTopDesigner!,
      if (RainTopDesigner!.topDesigners.isNotEmpty) RainTopDesigner!,
      if (Cus2DTopDesigner!.topDesigners.isNotEmpty) Cus2DTopDesigner!,
      if (Cus3DTopDesigner!.topDesigners.isNotEmpty) Cus3DTopDesigner!,
      if (WalkthroughTopDesigner!.topDesigners.isNotEmpty)
        WalkthroughTopDesigner!,
      if (ReelsVideoEditTopDesigner!.topDesigners.isNotEmpty)
        ReelsVideoEditTopDesigner!,
      if (SlideTopDesigner!.topDesigners.isNotEmpty) SlideTopDesigner!,
      if (IndividualTopDesigner!.topDesigners.isNotEmpty)
        IndividualTopDesigner!,
      if (TeamTopDesigner!.topDesigners.isNotEmpty) TeamTopDesigner!,
      if (AddPersonTopDesigner!.topDesigners.isNotEmpty) AddPersonTopDesigner!,
      if (RemovePersonTopDesigner!.topDesigners.isNotEmpty)
        RemovePersonTopDesigner!,
      if (BackgroundReplacementTopDesigner!.topDesigners.isNotEmpty)
        BackgroundReplacementTopDesigner!,
      if (CutOutChangeColorTopDesigner!.topDesigners.isNotEmpty)
        CutOutChangeColorTopDesigner!,
      if (ChangeColorTopDesigner!.topDesigners.isNotEmpty)
        ChangeColorTopDesigner!,
    ];
    notifyListeners();
  }

  Future<bool> fetchTopDesignersBySkill() async {
    print("Fetching top designers by skill...");
    setLoading(true);
    try {
      final result = await _skillService.getTopDesignersBySkillCategory();
      HDRTopDesigner = result["HDR"];
      print("HDR Top Designer: ${HDRTopDesigner?.topDesigners.length}");
      VHSTopDesigner = result["VHS"];
      PropertyTopDesigner = result["Property"];
      CleaningTopDesigner = result["Cleaning"];
      DTDTopDesigner = result["DTD"];
      SingleTopDesigner = result["Single"];
      FlamTopDesigner = result["Flam"];
      I360ETopDesigner = result["I360E"];
      RemoveTopDesigner = result["Remove"];
      I360TopDesigner = result["I360"];
      TWTopDesigner = result["TW"];
      RemoveItemTopDesigner = result["RemoveItem"];
      ChangeSeasonTopDesigner = result["ChangeSeason"];
      WaterTopDesigner = result["Water"];
      LawnTopDesigner = result["Lawn"];
      RainTopDesigner = result["Rain"];
      Cus2DTopDesigner = result["Cus2D"];
      Cus3DTopDesigner = result["Cus3D"];
      WalkthroughTopDesigner = result["Walkthrough"];
      ReelsVideoEditTopDesigner = result["Reels"];
      SlideTopDesigner = result["Slide"];
      IndividualTopDesigner = result["Individual"];
      TeamTopDesigner = result["Team"];
      AddPersonTopDesigner = result["AddPerson"];
      RemovePersonTopDesigner = result["RemovePerson"];
      BackgroundReplacementTopDesigner = result["BackgroundReplacement"];
      CutOutChangeColorTopDesigner = result["CutOutChangeColor"];
      ChangeColorTopDesigner = result["ChangeColor"];
      setHaveTopDesigners();
      print("Have Top Designers Count: ${haveTopDesigners.length}");
      return true;
    } catch (e) {
      print("Error fetching top designers: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }
}
