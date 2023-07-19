import 'package:greenify/model/emblem_model.dart';

class EmblemService {
  Future<List<EmblemModel>> getEmblems() async {
    try {
      final res = await EmblemModel.ref.get();
      List<EmblemModel> emblems = [];
      res.docs.map((e) => emblems.add(EmblemModel.fromQuery(e)));

      return emblems;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<EmblemModel> getEmblemByID(String id) async {
    try {
      final res = await EmblemModel.ref.doc(id).get();
      return EmblemModel.fromQuery(res);
    } catch (e) {
      throw Exception(e);
    }
  }
}
