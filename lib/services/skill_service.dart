import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/skill_model.dart';
import 'package:picpee_mobile/models/skill_of_vendor_model.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;
import 'package:picpee_mobile/providers/auth_provider.dart';

class SkillService {
  // Lấy danh sách top designers theo từng skill category
  Future<Map<String, dynamic>> getTopDesignersBySkillCategory() async {
    String? _token = AuthProvider().token;
    if (_token == null) {
      throw Exception("No token found");
    }
    print("Fetching top designers with token: $_token");
    final response = await http.post(
      Uri.parse(Url.getTopDesignBySkill),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];

      SkillModel HDRTopDesigner = SkillModel.fromJson(data[1]);
      SkillModel VHSTopDesigner = SkillModel.fromJson(data[4]);
      SkillModel PropertyTopDesigner = SkillModel.fromJson(data[18]);
      SkillModel CleaningTopDesigner = SkillModel.fromJson(data[10]);
      SkillModel DTDTopDesigner = SkillModel.fromJson(data[7]);
      SkillModel SingleTopDesigner = SkillModel.fromJson(data[0]);
      SkillModel FlamTopDesigner = SkillModel.fromJson(data[2]);
      SkillModel I360ETopDesigner = SkillModel.fromJson(data[3]);
      SkillModel RemoveTopDesigner = SkillModel.fromJson(data[5]);
      SkillModel I360TopDesigner = SkillModel.fromJson(data[6]);
      SkillModel TWTopDesigner = SkillModel.fromJson(data[8]);
      SkillModel RemoveItemTopDesigner = SkillModel.fromJson(data[9]);
      SkillModel ChangeSeasonTopDesigner = SkillModel.fromJson(data[11]);
      SkillModel WaterTopDesigner = SkillModel.fromJson(data[12]);
      SkillModel LawnTopDesigner = SkillModel.fromJson(data[13]);
      SkillModel RainTopDesigner = SkillModel.fromJson(data[15]);
      SkillModel Cus2DTopDesigner = SkillModel.fromJson(data[16]);
      SkillModel Cus3DTopDesigner = SkillModel.fromJson(data[17]);
      SkillModel WalkthroughTopDesigner = SkillModel.fromJson(data[18]);
      SkillModel ReelsTopDesigner = SkillModel.fromJson(data[19]);
      SkillModel SlideTopDesigner = SkillModel.fromJson(data[21]);
      SkillModel IndividualTopDesigner = SkillModel.fromJson(data[21]);
      SkillModel TeamTopDesigner = SkillModel.fromJson(data[22]);
      SkillModel AddPersonTopDesigner = SkillModel.fromJson(data[23]);
      SkillModel RemovePersonTopDesigner = SkillModel.fromJson(data[24]);
      SkillModel BackgroundReplacementTopDesigner = SkillModel.fromJson(
        data[25],
      );
      SkillModel CutOutChangeColorTopDesigner = SkillModel.fromJson(data[26]);
      SkillModel ChangeColorTopDesigner = SkillModel.fromJson(data[27]);
      return {
        "HDR": HDRTopDesigner,
        "VHS": VHSTopDesigner,
        "Property": PropertyTopDesigner,
        "Cleaning": CleaningTopDesigner,
        "DTD": DTDTopDesigner,
        "Single": SingleTopDesigner,
        "Flam": FlamTopDesigner,
        "I360E": I360ETopDesigner,
        "Remove": RemoveTopDesigner,
        "I360": I360TopDesigner,
        "TW": TWTopDesigner,
        "RemoveItem": RemoveItemTopDesigner,
        "ChangeSeason": ChangeSeasonTopDesigner,
        "Water": WaterTopDesigner,
        "Lawn": LawnTopDesigner,
        "Rain": RainTopDesigner,
        "Cus2D": Cus2DTopDesigner,
        "Cus3D": Cus3DTopDesigner,
        "Walkthrough": WalkthroughTopDesigner,
        "Reels": ReelsTopDesigner,
        "Slide": SlideTopDesigner,
        "Individual": IndividualTopDesigner,
        "Team": TeamTopDesigner,
        "AddPerson": AddPersonTopDesigner,
        "RemovePerson": RemovePersonTopDesigner,
        "BackgroundReplacement": BackgroundReplacementTopDesigner,
        "CutOutChangeColor": CutOutChangeColorTopDesigner,
        "ChangeColor": ChangeColorTopDesigner,
      };
    } else {
      throw Exception("Failed to load skills: ${response.body}");
    }
  }

  //Lấy danh sách skill của vendor
  Future<List<SkillOfVendorModel>> getSkillsOfVendor(int vendorId) async {
    String? _token = AuthProvider().token;
    if (_token == null) {
      throw Exception("No token found");
    }
    print("Fetching skills of vendor with token: $_token");
    final response = await http.get(
      Uri.parse("${Url.getAllSkillOfVendor}/$vendorId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data']['userSkills'] as List<dynamic>;
      return data.map((e) => SkillOfVendorModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load skills of vendor: ${response.body}");
    }
  }

  Future<SkillOfVendorModel> getSkillDetailOfVendor(
    int vendorId,
    int skillId,
  ) async {
    String? _token = AuthProvider().token;
    if (_token == null) {
      throw Exception("No token found");
    }
    print("Fetching skill detail of vendor with token: $_token");
    final response = await http.get(
      Uri.parse("${Url.getAllSkillOfVendor}/$vendorId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data']['userSkills'] as List<dynamic>;
      return data
          .map((e) => SkillOfVendorModel.fromJson(e))
          .firstWhere((element) => element.skillId == skillId);
    } else {
      throw Exception(
        "Failed to load skill detail of vendor: ${response.body}",
      );
    }
  }
}
