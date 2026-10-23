import 'package:flutter/material.dart';

/// Semantic color and surface tokens for the N:OW Tao UI/UX concept.
///
/// Embodies the balance of Yang (Washi Light — warm unbleached rice paper,
/// stone wash, and bamboo sage) and Yin (Obsidian Night — deep mineral
/// charcoal, moonlit silk, and warm temple amber).
class TaoPalette extends ThemeExtension<TaoPalette> {
  final bool isDark;
  final Color scaffoldCanvas;
  final Color stoneWashStart;
  final Color stoneWashEnd;
  final Color peekingCardSurface;
  final Color peekingCardBorder;
  final Color frostedSheetSurface;
  final Color capsuleSurface;
  final Color capsuleBorder;
  final Color hairlineDivider;
  final Color inkPrimary;
  final Color inkMuted;
  final Color accentPrimary;
  final Color accentOnPrimary;
  final Color accentGold;
  final List<Color> orbGradient;
  final Color orbGlow;

  const TaoPalette({
    required this.isDark,
    required this.scaffoldCanvas,
    required this.stoneWashStart,
    required this.stoneWashEnd,
    required this.peekingCardSurface,
    required this.peekingCardBorder,
    required this.frostedSheetSurface,
    required this.capsuleSurface,
    required this.capsuleBorder,
    required this.hairlineDivider,
    required this.inkPrimary,
    required this.inkMuted,
    required this.accentPrimary,
    required this.accentOnPrimary,
    required this.accentGold,
    required this.orbGradient,
    required this.orbGlow,
  });

  /// Yang — Washi Light (Misty morning stone & warm rice paper).
  static const TaoPalette light = TaoPalette(
    isDark: false,
    scaffoldCanvas: Color(0xFFEBE7DF),
    stoneWashStart: Color(0xFFDCD7CC),
    stoneWashEnd: Color(0xFFEFECE5),
    peekingCardSurface: Color(0xD9E4DFD5),
    peekingCardBorder: Color(0x88FFFFFF),
    frostedSheetSurface: Color(0xF2F5F2EB),
    capsuleSurface: Color(0x1F8C867A),
    capsuleBorder: Color(0x388C867A),
    hairlineDivider: Color(0x2E8C867A),
    inkPrimary: Color(0xFF3A3832),
    inkMuted: Color(0xFF7A756C),
    accentPrimary: Color(0xFF5C6658),
    accentOnPrimary: Color(0xFFFAF8F5),
    accentGold: Color(0xFFB59257),
    orbGradient: [
      Color(0xFFFFFFFF),
      Color(0xFFFBF3E4),
      Color(0xFFEFE2C9),
      Color(0xFFE5D4B7),
    ],
    orbGlow: Color(0xB3FFF4DA),
  );

  /// Yin — Obsidian Night (Deep mineral charcoal & warm temple amber).
  static const TaoPalette dark = TaoPalette(
    isDark: true,
    scaffoldCanvas: Color(0xFF111312),
    stoneWashStart: Color(0xFF1A1D1B),
    stoneWashEnd: Color(0xFF111312),
    peekingCardSurface: Color(0xE6181B19),
    peekingCardBorder: Color(0x2ED4AF73),
    frostedSheetSurface: Color(0xF5191C1A),
    capsuleSurface: Color(0x14FFFFFF),
    capsuleBorder: Color(0x38D4AF73),
    hairlineDivider: Color(0x24E5E0D5),
    inkPrimary: Color(0xFFE5E0D5),
    inkMuted: Color(0xFF8E8B82),
    accentPrimary: Color(0xFFD4AF73),
    accentOnPrimary: Color(0xFF141615),
    accentGold: Color(0xFFD9B26F),
    orbGradient: [
      Color(0xFF574833),
      Color(0xFF332B21),
      Color(0xFF1D1B17),
      Color(0xFF131413),
    ],
    orbGlow: Color(0x4DD9B26F),
  );

  /// Resolves the active [TaoPalette] from the current [BuildContext].
  static TaoPalette of(BuildContext context) {
    final ext = Theme.of(context).extension<TaoPalette>();
    if (ext != null) return ext;
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  @override
  TaoPalette copyWith({
    bool? isDark,
    Color? scaffoldCanvas,
    Color? stoneWashStart,
    Color? stoneWashEnd,
    Color? peekingCardSurface,
    Color? peekingCardBorder,
    Color? frostedSheetSurface,
    Color? capsuleSurface,
    Color? capsuleBorder,
    Color? hairlineDivider,
    Color? inkPrimary,
    Color? inkMuted,
    Color? accentPrimary,
    Color? accentOnPrimary,
    Color? accentGold,
    List<Color>? orbGradient,
    Color? orbGlow,
  }) {
    return TaoPalette(
      isDark: isDark ?? this.isDark,
      scaffoldCanvas: scaffoldCanvas ?? this.scaffoldCanvas,
      stoneWashStart: stoneWashStart ?? this.stoneWashStart,
      stoneWashEnd: stoneWashEnd ?? this.stoneWashEnd,
      peekingCardSurface: peekingCardSurface ?? this.peekingCardSurface,
      peekingCardBorder: peekingCardBorder ?? this.peekingCardBorder,
      frostedSheetSurface: frostedSheetSurface ?? this.frostedSheetSurface,
      capsuleSurface: capsuleSurface ?? this.capsuleSurface,
      capsuleBorder: capsuleBorder ?? this.capsuleBorder,
      hairlineDivider: hairlineDivider ?? this.hairlineDivider,
      inkPrimary: inkPrimary ?? this.inkPrimary,
      inkMuted: inkMuted ?? this.inkMuted,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentOnPrimary: accentOnPrimary ?? this.accentOnPrimary,
      accentGold: accentGold ?? this.accentGold,
      orbGradient: orbGradient ?? this.orbGradient,
      orbGlow: orbGlow ?? this.orbGlow,
    );
  }

  @override
  TaoPalette lerp(ThemeExtension<TaoPalette>? other, double t) {
    if (other is! TaoPalette) return this;
    return TaoPalette(
      isDark: t < 0.5 ? isDark : other.isDark,
      scaffoldCanvas: Color.lerp(scaffoldCanvas, other.scaffoldCanvas, t)!,
      stoneWashStart: Color.lerp(stoneWashStart, other.stoneWashStart, t)!,
      stoneWashEnd: Color.lerp(stoneWashEnd, other.stoneWashEnd, t)!,
      peekingCardSurface:
          Color.lerp(peekingCardSurface, other.peekingCardSurface, t)!,
      peekingCardBorder:
          Color.lerp(peekingCardBorder, other.peekingCardBorder, t)!,
      frostedSheetSurface:
          Color.lerp(frostedSheetSurface, other.frostedSheetSurface, t)!,
      capsuleSurface: Color.lerp(capsuleSurface, other.capsuleSurface, t)!,
      capsuleBorder: Color.lerp(capsuleBorder, other.capsuleBorder, t)!,
      hairlineDivider: Color.lerp(hairlineDivider, other.hairlineDivider, t)!,
      inkPrimary: Color.lerp(inkPrimary, other.inkPrimary, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentOnPrimary: Color.lerp(accentOnPrimary, other.accentOnPrimary, t)!,
      accentGold: Color.lerp(accentGold, other.accentGold, t)!,
      orbGradient: [
        for (int i = 0; i < orbGradient.length; i++)
          Color.lerp(orbGradient[i], other.orbGradient[i], t)!,
      ],
      orbGlow: Color.lerp(orbGlow, other.orbGlow, t)!,
    );
  }
}

/// Builds the Material 3 ThemeData for Washi Light (Yang) and Obsidian Night (Yin).
class TaoTheme {
  static ThemeData light() {
    const p = TaoPalette.light;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: p.scaffoldCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: p.accentPrimary,
        brightness: Brightness.light,
        surface: p.scaffoldCanvas,
        onSurface: p.inkPrimary,
        primary: p.accentPrimary,
        onPrimary: p.accentOnPrimary,
      ),
    );
    return base.copyWith(
      extensions: const [TaoPalette.light],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF3A3832),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: p.capsuleSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: p.capsuleBorder),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: p.hairlineDivider,
        thickness: 1,
      ),
    );
  }

  static ThemeData dark() {
    const p = TaoPalette.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: p.scaffoldCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: p.accentPrimary,
        brightness: Brightness.dark,
        surface: p.scaffoldCanvas,
        onSurface: p.inkPrimary,
        primary: p.accentPrimary,
        onPrimary: p.accentOnPrimary,
      ),
    );
    return base.copyWith(
      extensions: const [TaoPalette.dark],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFE5E0D5),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: p.capsuleSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: p.capsuleBorder),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: p.hairlineDivider,
        thickness: 1,
      ),
    );
  }
}
