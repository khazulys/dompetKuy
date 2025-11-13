import 'dart:math';

enum AvatarHairStyle { none, short, wave, bun, buzz }

enum AvatarEyeStyle { round, happy, wink }

enum AvatarMouthStyle { smile, grin, surprised }

class AvatarConfig {
  static const backgroundPalette = [
    '#F8B195',
    '#F67280',
    '#C06C84',
    '#6C5B7B',
    '#355C7D',
    '#E0FF4F',
    '#6BE3C5',
    '#AEC6FF',
  ];

  static const facePalette = [
    '#F7D6C5',
    '#E7BFAA',
    '#D1997B',
    '#AD8066',
    '#7A4F37',
  ];

  static const hairPalette = [
    '#2C2A3A',
    '#5B4636',
    '#A47C48',
    '#CC9957',
    '#E2B964',
    '#C52F57',
    '#1A8FE3',
  ];

  final String backgroundColor;
  final String faceColor;
  final String hairColor;
  final AvatarHairStyle hairStyle;
  final AvatarEyeStyle eyeStyle;
  final AvatarMouthStyle mouthStyle;

  const AvatarConfig({
    required this.backgroundColor,
    required this.faceColor,
    required this.hairColor,
    required this.hairStyle,
    required this.eyeStyle,
    required this.mouthStyle,
  });

  AvatarConfig copyWith({
    String? backgroundColor,
    String? faceColor,
    String? hairColor,
    AvatarHairStyle? hairStyle,
    AvatarEyeStyle? eyeStyle,
    AvatarMouthStyle? mouthStyle,
  }) {
    return AvatarConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      faceColor: faceColor ?? this.faceColor,
      hairColor: hairColor ?? this.hairColor,
      hairStyle: hairStyle ?? this.hairStyle,
      eyeStyle: eyeStyle ?? this.eyeStyle,
      mouthStyle: mouthStyle ?? this.mouthStyle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'faceColor': faceColor,
      'hairColor': hairColor,
      'hairStyle': hairStyle.name,
      'eyeStyle': eyeStyle.name,
      'mouthStyle': mouthStyle.name,
    };
  }

  factory AvatarConfig.fromJson(Map<String, dynamic> json) {
    return AvatarConfig(
      backgroundColor:
          json['backgroundColor'] as String? ?? backgroundPalette.first,
      faceColor: json['faceColor'] as String? ?? facePalette.first,
      hairColor: json['hairColor'] as String? ?? hairPalette.first,
      hairStyle: AvatarHairStyle.values.firstWhere(
        (style) => style.name == json['hairStyle'],
        orElse: () => AvatarHairStyle.short,
      ),
      eyeStyle: AvatarEyeStyle.values.firstWhere(
        (style) => style.name == json['eyeStyle'],
        orElse: () => AvatarEyeStyle.round,
      ),
      mouthStyle: AvatarMouthStyle.values.firstWhere(
        (style) => style.name == json['mouthStyle'],
        orElse: () => AvatarMouthStyle.smile,
      ),
    );
  }

  static AvatarConfig random([Random? seed]) {
    final random = seed ?? Random();
    String pick(List<String> palette) =>
        palette[random.nextInt(palette.length)];

    return AvatarConfig(
      backgroundColor: pick(backgroundPalette),
      faceColor: pick(facePalette),
      hairColor: pick(hairPalette),
      hairStyle:
          AvatarHairStyle.values[random.nextInt(AvatarHairStyle.values.length)],
      eyeStyle:
          AvatarEyeStyle.values[random.nextInt(AvatarEyeStyle.values.length)],
      mouthStyle: AvatarMouthStyle
          .values[random.nextInt(AvatarMouthStyle.values.length)],
    );
  }

  static AvatarConfig defaults() {
    return AvatarConfig(
      backgroundColor: backgroundPalette.first,
      faceColor: facePalette.first,
      hairColor: hairPalette.first,
      hairStyle: AvatarHairStyle.short,
      eyeStyle: AvatarEyeStyle.round,
      mouthStyle: AvatarMouthStyle.smile,
    );
  }
}
