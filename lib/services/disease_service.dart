import 'package:greenify/constants/disease_dataset.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';

// enum Expression {
//   unknown,
//   anger,
//   disgust,
//   fear,
//   happiness,
//   neutral,
//   sadness,
//   surprise,
// }

List<String> diseases = [
  "apple apple scab",
  "apple black rot",
  "apple cedar apple rust",
  "apple healthy",
  "blueberry healthy",
  "cherry including sour powdery mildew",
  "cherry including sour healthy",
  "corn maize cercospora leaf spot gray leaf spot",
  "corn maize common rust ",
  "corn maize northern leaf blight",
  "corn maize healthy",
  "grape black rot",
  "grape esca black measles ",
  "grape leaf blight isariopsis leaf spot ",
  "grape healthy",
  "orange haunglongbing citrus greening ",
  "peach bacterial spot",
  "peach healthy",
  "pepper bell bacterial spot",
  "pepper bell healthy",
  "potato early blight",
  "potato late blight",
  "potato healthy",
  "raspberry healthy",
  "soybean healthy",
  "squash powdery mildew",
  "strawberry leaf scorch",
  "strawberry healthy",
  "tomato bacterial spot",
  "tomato early blight",
  "tomato late blight",
  "tomato leaf mold",
  "tomato septoria leaf spot",
  "tomato spider mites two spotted spider mite",
  "tomato target spot",
  "tomato tomato yellow leaf curl virus",
  "tomato tomato mosaic virus",
  "tomato healthy",
];

List<String> penyakit = [
  "Penyakit busuk apel",
  "Penyakit busuk hitam apel",
  "Karat apel cedar",
  "Apel sehat",
  "Blueberry sehat",
  "Kutu tepung pada ceri termasuk ceri asam",
  "Ceri asam sehat",
  "Bercak daun Cercospora dan bercak abu-abu pada jagung jagung",
  "Karat umum pada jagung jagung",
  "Hawar daun utara pada jagung jagung",
  "Jagung sehat",
  "Busuk hitam pada anggur",
  "Esca hitam pada anggur",
  "Bercak daun Isariopsis pada anggur",
  "Anggur sehat",
  "Kebun jeruk citrus greening",
  "Bercak bakteri pada persik",
  "Persik sehat",
  "Bercak bakteri pada paprika bell",
  "Paprika bell sehat",
  "Hawar daun awal pada kentang",
  "Hawar daun terlambat pada kentang",
  "Kentang sehat",
  "Raspberry sehat",
  "Kedelai sehat",
  "Kutu tepung pada labu",
  "Strawberry layu daun",
  "Strawberry sehat",
  "Bercak bakteri pada tomat",
  "Hawar daun awal pada tomat",
  "Hawar daun terlambat pada tomat",
  "Jamur pada daun tomat",
  "Bercak daun Septoria pada tomat",
  "Tungau laba-laba dua bintik pada tomat",
  "Bercak target pada tomat",
  "Kutil kuning daun pada tomat",
  "Virus mosaic tomat pada tomat",
  "Tomat sehat"
];

class InputOutput {
  final Object input;
  final Object output;

  InputOutput(this.input, this.output);
}

class TFLiteDiseaseDetectionService {
  Interpreter? _interpreterInstance;

  // static List<String> emotions = [
  //   "",
  //   "Anger",
  //   "Disgust",
  //   "Fear",
  //   "Happiness",
  //   "Neutral",
  //   "Sadness",
  //   "Surprise"
  // ];

  Future<Interpreter> get _interpreter async =>
      _interpreterInstance ??= await Interpreter.fromAsset(
        'assets/model.tflite',
        options: InterpreterOptions()..threads = 4,
      );

  Future<Map<String, dynamic>> detectDisease(imglib.Image img) async {
    final imageInput = imglib.copyResize(
      img,
      // width: 64,
      // height: 64,
      width: 224,
      height: 224,
    );

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r / 255, pixel.g / 255, pixel.b / 255];
        },
      ),
    );

    final output = await _runInference(imageMatrix);

    return _getDisease(output);
  }

  Future<List<num>> _runInference(
    List<List<List<num>>> imageMatrix,
  ) async {
    final interpreter = await _interpreter;

    final input = [imageMatrix];
    final output = List.filled(1 * diseases.length, 0.0).reshape(
      [1, diseases.length],
    );
    print('input: ${input[0].length}');
    print('output: ${diseases.length}');

    // Run inference
    interpreter.run(input, output);

    return output.first;
  }

  static Map<String, dynamic> _getDisease(List<num>? diagnoseScores) {
    int bestInd = 0;

    if (diagnoseScores != null) {
      num maxScore = 0;

      for (int i = 0; i < diagnoseScores.length; ++i) {
        if (maxScore < diagnoseScores[i]) {
          maxScore = diagnoseScores[i];
          bestInd = i;
        }
      }
    }

    print('Prediction Result: $bestInd');

    if (bestInd > diseaseDataset.length - 1) {
      bestInd = 0;
    }

    return diseaseDataset[bestInd];
  }

  Future<void> dispose() async {
    (_interpreterInstance)?.close();
  }
}
