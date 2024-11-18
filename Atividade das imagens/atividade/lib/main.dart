import 'package:atividade/imagemGerador.dart';

void main() {
  // Configurações para gerar imagens
  final generator = ImageGenerator(
    outputPath: 'assets/images',
    width: 500,
    height: 500,
    numImages: 1000,
  );

  // Gera as imagens
  generator.generateImages();
}
