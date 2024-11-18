import 'dart:io';
import 'package:image/image.dart' as img;

class ImageProcessor {
  final String inputPath;
  final String outputPath;

  ImageProcessor({
    required this.inputPath,
    required this.outputPath,
  });

  // Função para processar as imagens de forma serial
  Future<void> convertImages() async {
    final inputDir = Directory(inputPath);
    final outputDir = Directory(outputPath);

    if (!inputDir.existsSync()) {
      print('O diretório de entrada não existe!');
      return;
    }

    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    final files = inputDir.listSync().where((e) => e.path.endsWith('.png')).toList();

    // Processa cada imagem de forma serial
    for (var file in files) {
      await _processImage(file);  // Processa a imagem
    }
  }

  // Função que processa uma imagem de forma serial
  Future<void> _processImage(FileSystemEntity fileSystemEntity) async {
    final file = File(fileSystemEntity.path);  // Converte FileSystemEntity para File

    // Lê os bytes da imagem
    final imageBytes = await file.readAsBytes();
    final image = img.decodeImage(imageBytes)!;

    // Processamento da imagem em escala de cinza (pixel a pixel)
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        // Acessando os valores RGB usando operações bit a bit
        final r = (pixel >> 24) & 0xFF;  // Extrai o valor vermelho
        final g = (pixel >> 16) & 0xFF;  // Extrai o valor verde
        final b = (pixel >> 8) & 0xFF;   // Extrai o valor azul

        // Calcula o valor de cinza com base na fórmula fornecida
        final gray = (r * 0.298 + g * 0.587 + b * 0.114).round();

        // Cria o pixel em escala de cinza
        final grayPixel = (255 << 24) | (gray << 16) | (gray << 8) | gray;

        // Define o novo valor do pixel
        image.setPixel(x, y, grayPixel);
      }
    }

    // Salva a imagem convertida
    final outputFile = File('$outputPath/converted_${file.uri.pathSegments.last}');
    await outputFile.writeAsBytes(img.encodePng(image));

    print('Imagem convertida: ${outputFile.path}');
  }
}

void main() async {
  final processor = ImageProcessor(
    inputPath: 'assets/images',  // Caminho de entrada com as imagens
    outputPath: 'assets/converted_images',  // Caminho de saída para as imagens convertidas
  );

  await processor.convertImages();  // Converte as imagens
}
