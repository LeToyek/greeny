import 'package:greenify/constants/disease_dataset.dart';
import 'package:greenify/constants/soil_dataset.dart';
import 'package:greenify/model/soill_model.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';

List<String> soils = [
  "Black Soil",
  "Cinder Soil",
  "Laterite Soil",
  "Peat Soil",
  "Yellow Soil",
];

class InputOutput {
  final Object input;
  final Object output;

  InputOutput(this.input, this.output);
}

class TFLiteSoilDetectionService {
  Interpreter? _interpreterInstance;

  Future<Interpreter> get _interpreter async =>
      _interpreterInstance ??= await Interpreter.fromAsset(
        'assets/soil-model.tflite',
        options: InterpreterOptions()..threads = 4,
      );

  Future<Soil> detectSoil(imglib.Image img) async {
    final imageInput = imglib.copyResize(
      img,
      width: 220,
      height: 220,
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

    return _getSoil(output);
  }

  Future<List<num>> _runInference(
    List<List<List<num>>> imageMatrix,
  ) async {
    final interpreter = await _interpreter;

    final input = [imageMatrix];
    final output = List.filled(1 * soils.length, 0.0).reshape(
      [1, soils.length],
    );
    print('input: ${input[0].length}');
    print('output: ${soils.length}');

    // Run inference
    interpreter.run(input, output);

    return output.first;
  }

  static Soil _getSoil(List<num>? scores) {
    int bestInd = 0;

    if (scores != null) {
      num maxScore = 0;

      for (int i = 0; i < scores.length; ++i) {
        if (maxScore < scores[i]) {
          maxScore = scores[i];
          bestInd = i;
        }
      }
    }

    print('Prediction Result: $bestInd');

    if (bestInd > diseaseDataset.length - 1) {
      bestInd = 0;
    }

    return soilsDataset[bestInd];
  }

  Future<void> dispose() async {
    (_interpreterInstance)?.close();
  }
}
