import 'package:greenify/model/emblem_model.dart';

class EmblemService {
  Future<List<EmblemModel>> getEmblems() async {
    try {
      final res = await EmblemModel.ref.get();

      final emblems = res.docs.map((e) {
        final emblem = EmblemModel.fromQuery(e);
        emblem.must = e['must'];
        return emblem;
      }).toList();

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
