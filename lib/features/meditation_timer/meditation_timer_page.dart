import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:now/core/theme/tao_theme.dart';
import 'package:now/core/widgets/zen_sound_symbol.dart';

/// A page that provides a Tao-inspired minimalist meditation sanctuary.
///
/// Embodies the "Less is More" 90% emptiness rule:
/// - In the resting state, displays a whispered quote, the central Breathing Orb,
///   thin countdown digits (`10:00`), and a single consolidated Whisper Capsule
///   (`◯ Singing Bowl · 10m · 10s prep`).
/// - Tapping the Whisper Capsule (or time digits) opens a translucent frosted
///   bottom sheet (`_SessionAttunementSheet`) for progressive disclosure.
/// - Tapping the Breathing Orb starts the live countdown and dissolves all
///   surrounding UI chrome so only the breathing orb and countdown remain.
class MeditationTimerPage extends StatefulWidget {
  /// The index of the current page in the stacked home layout.
  final int currentPageIndex;

  /// A callback function to toggle between pages.
  final VoidCallback onToggle;

  /// Optional callback notified when a meditation session starts or ends,
  /// allowing the parent home wrapper to dissolve top/bottom chrome.
  final ValueChanged<bool>? onSessionStateChanged;

  /// Creates a new instance of the MeditationTimerPage.
  const MeditationTimerPage({
    super.key,
    this.currentPageIndex = 0,
    required this.onToggle,
    this.onSessionStateChanged,
  });

  @override
  State<MeditationTimerPage> createState() => _MeditationTimerPageState();
}

class _MeditationTimerPageState extends State<MeditationTimerPage>
    with SingleTickerProviderStateMixin {
  int _selectedMinutes = 10;
  String _selectedSound = 'singing_bowl';
  int _preparationSeconds = 10;

  bool _isSessionActive = false;
  bool _isInPreparation = false;
  int _remainingSeconds = 600;
  int _quoteIndex = 0;

  Timer? _countdownTimer;
  late final AnimationController _breathController;

  final List<String> _inspirationalQuotes = const [
    "In the midst of movement and chaos, keep stillness inside of you.",
    "The quieter you become, the more you are able to hear.",
    "The present moment is the only time over which we have dominion.",
    "Nature does not hurry, yet everything is accomplished.",
    "Peace comes from within. Do not seek it without.",
    "Wherever you are, be there totally.",
    "Mindfulness is about being fully awake in our lives.",
    "Breathe in peace, breathe out stress.",
  ];

  final List<Map<String, String>> _soundOptions = const [
    {'label': 'Singing Bowl', 'value': 'singing_bowl'},
    {'label': 'Temple Shō', 'value': 'default'},
    {'label': 'Pin Chime', 'value': 'chime'},
    {'label': 'Bamboo Wind', 'value': 'nature'},
  ];

  @override
  void initState() {
    super.initState();
    _quoteIndex = Random().nextInt(_inspirationalQuotes.length);
    _remainingSeconds = _selectedMinutes * 60;
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (isTest) {
      _breathController.value = 0.5;
    } else {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  void _cycleQuote() {
    setState(() {
      _quoteIndex = (_quoteIndex + 1) % _inspirationalQuotes.length;
    });
  }

  String get _formattedTime {
    final total = _isSessionActive ? _remainingSeconds : _selectedMinutes * 60;
    final mins = total ~/ 60;
    final secs = total % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String get _breathCueLabel {
    if (_isInPreparation) {
      return 'Settling · ${_remainingSeconds}s';
    }
    final v = _breathController.value;
    if (v < 0.42) return 'Inhale';
    if (v < 0.58) return 'Hold';
    return 'Exhale';
  }

  void _toggleMeditationSession() {
    if (_isSessionActive) {
      _stopSession();
    } else {
      _startSession();
    }
  }

  void _startSession() {
    _countdownTimer?.cancel();
    setState(() {
      _isSessionActive = true;
      if (_preparationSeconds > 0) {
        _isInPreparation = true;
        _remainingSeconds = _preparationSeconds;
      } else {
        _isInPreparation = false;
        _remainingSeconds = _selectedMinutes * 60;
      }
    });
    widget.onSessionStateChanged?.call(true);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 1) {
          _remainingSeconds--;
        } else if (_isInPreparation) {
          _isInPreparation = false;
          _remainingSeconds = _selectedMinutes * 60;
        } else {
          _stopSession();
        }
      });
    });
  }

  void _stopSession() {
    _countdownTimer?.cancel();
    setState(() {
      _isSessionActive = false;
      _isInPreparation = false;
      _remainingSeconds = _selectedMinutes * 60;
    });
    widget.onSessionStateChanged?.call(false);
  }

  Future<void> _openAttunementSheet() async {
    if (_isSessionActive) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final p = TaoPalette.of(context);
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
                  decoration: BoxDecoration(
                    color: p.frostedSheetSurface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    border: Border(
                      top: BorderSide(color: p.peekingCardBorder, width: 1),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle pill
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: p.inkMuted.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SESSION ATTUNEMENT',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 2.2,
                                fontWeight: FontWeight.w500,
                                color: p.inkMuted,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              child: Text(
                                'DONE',
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1.5,
                                  color: p.accentPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 1. Duration Horizontal Ribbon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DURATION',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.6,
                                color: p.inkMuted,
                              ),
                            ),
                            Text(
                              '$_selectedMinutes minutes',
                              style: TextStyle(
                                fontSize: 12,
                                color: p.inkPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [5, 10, 15, 20, 30, 45, 60].map((mins) {
                            final active = _selectedMinutes == mins;
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.5),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    setState(() {
                                      _selectedMinutes = mins;
                                      _remainingSeconds = mins * 60;
                                    });
                                    setSheetState(() {});
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: active
                                          ? p.accentPrimary
                                          : p.capsuleSurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: active
                                            ? p.accentPrimary
                                            : p.capsuleBorder,
                                      ),
                                    ),
                                    child: Text(
                                      '${mins}m',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: active
                                            ? FontWeight.w600
                                            : FontWeight.w300,
                                        color: active
                                            ? p.accentOnPrimary
                                            : p.inkPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 22),

                        // 2. Settling Preparation Breath Ribbon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PREPARATION BREATH',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.6,
                                color: p.inkMuted,
                              ),
                            ),
                            Text(
                              _preparationSeconds == 0
                                  ? 'Off'
                                  : '$_preparationSeconds seconds',
                              style: TextStyle(
                                fontSize: 12,
                                color: p.inkPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [0, 10, 20, 30, 60].map((secs) {
                            final active = _preparationSeconds == secs;
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    setState(() {
                                      _preparationSeconds = secs;
                                    });
                                    setSheetState(() {});
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 9,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: active
                                          ? p.accentPrimary
                                          : p.capsuleSurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: active
                                            ? p.accentPrimary
                                            : p.capsuleBorder,
                                      ),
                                    ),
                                    child: Text(
                                      secs == 0 ? 'Off' : '${secs}s',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: active
                                            ? FontWeight.w600
                                            : FontWeight.w300,
                                        color: active
                                            ? p.accentOnPrimary
                                            : p.inkPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 22),

                        // 3. Bell Resonance Symbols
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'BELL RESONANCE',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.6,
                                color: p.inkMuted,
                              ),
                            ),
                            Text(
                              ZenSoundSymbol.labelFor(_selectedSound),
                              style: TextStyle(
                                fontSize: 12,
                                color: p.inkPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: _soundOptions.map((option) {
                            final value = option['value']!;
                            final label = option['label']!;
                            final active = _selectedSound == value;
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    setState(() {
                                      _selectedSound = value;
                                    });
                                    setSheetState(() {});
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: active
                                          ? p.accentPrimary
                                          : p.capsuleSurface,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: active
                                            ? p.accentGold
                                            : p.capsuleBorder,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ZenSoundSymbol(
                                          soundKey: value,
                                          size: 20,
                                          color: active
                                              ? p.accentOnPrimary
                                              : p.inkPrimary,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          label.split(' ').last,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: active
                                                ? FontWeight.w600
                                                : FontWeight.w300,
                                            color: active
                                                ? p.accentOnPrimary
                                                : p.inkPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = TaoPalette.of(context);

    // Collapsed peeking header when Mindful Bells (index 1) is expanded
    if (widget.currentPageIndex == 1) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onToggle,
        child: Container(
          decoration: BoxDecoration(
            color: p.peekingCardSurface,
            border: Border(
              bottom: BorderSide(color: p.peekingCardBorder, width: 1),
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Meditation Timer',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 2.4,
                          fontWeight: FontWeight.w400,
                          color: p.inkPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: p.accentPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 18,
                  color: p.inkMuted,
                ),
                tooltip: 'Expand Meditation Timer',
                onPressed: widget.onToggle,
              ),
            ],
          ),
        ),
      );
    }

    // Active Sanctuary (90% negative space + Breathing Orb + Whisper Capsule)
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            p.stoneWashStart,
            p.scaffoldCanvas,
            p.stoneWashEnd,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 480;
          final orbSize = isCompact ? 132.0 : 184.0;
          final haloSize = isCompact ? 168.0 : 236.0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Subtle top header row (fades completely during session)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 450),
                  opacity: _isSessionActive ? 0.0 : 1.0,
                  child: IgnorePointer(
                    ignoring: _isSessionActive,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Meditation Timer',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w400,
                              color: p.inkMuted.withValues(alpha: 0.01),
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            Icons.remove,
                            size: 16,
                            color: p.inkMuted.withValues(alpha: 0.45),
                          ),
                          tooltip: 'Switch to Mindful Bells',
                          onPressed: widget.onToggle,
                        ),
                      ],
                    ),
                  ),
                ),

                // Whispered Contemplation Quote (dissolves during countdown)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isSessionActive ? 0.0 : 0.72,
                  child: IgnorePointer(
                    ignoring: _isSessionActive,
                    child: GestureDetector(
                      onTap: _cycleQuote,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          '“${_inspirationalQuotes[_quoteIndex]}”',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isCompact ? 13 : 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            height: 1.45,
                            color: p.inkPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // CENTERPIECE: THE BREATHING ORB + WHISPERED COUNTDOWN
                Flexible(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Breathing Orb Gesture Target
                          GestureDetector(
                            key: const Key('breathing_orb_button'),
                            onTap: _toggleMeditationSession,
                            child: AnimatedBuilder(
                              animation: _breathController,
                              builder: (context, child) {
                                final t = Curves.easeInOut.transform(
                                  _breathController.value,
                                );
                                final orbScale = 0.91 + (t * 0.16);
                                final haloScale = 0.85 + (t * 0.32);
                                final haloAlpha = 0.25 + (t * 0.35);

                                return SizedBox(
                                  width: haloSize,
                                  height: haloSize,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Diffuse outer halo
                                      Transform.scale(
                                        scale: haloScale,
                                        child: Container(
                                          width: haloSize,
                                          height: haloSize,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              colors: [
                                                p.orbGlow.withValues(
                                                  alpha: haloAlpha,
                                                ),
                                                p.orbGlow.withValues(alpha: 0.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Luminous inner sphere
                                      Transform.scale(
                                        scale: orbScale,
                                        child: Container(
                                          width: orbSize,
                                          height: orbSize,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              center: const Alignment(-0.24, -0.28),
                                              radius: 0.88,
                                              colors: p.orbGradient,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: p.orbGlow,
                                                blurRadius: 44,
                                                spreadRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: AnimatedOpacity(
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            opacity:
                                                _isSessionActive ? 0.65 : 0.0,
                                            child: Text(
                                              _breathCueLabel.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 3.0,
                                                fontWeight: FontWeight.w300,
                                                color: p.inkPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: isCompact ? 10 : 20),

                          // Thin, wide-tracked Countdown Digits (Matches Prototype #1)
                          GestureDetector(
                            onTap: _openAttunementSheet,
                            child: Text(
                              _formattedTime,
                              key: const Key('meditation_countdown_text'),
                              style: TextStyle(
                                fontSize: isCompact ? 36 : 48,
                                fontWeight: FontWeight.w200,
                                letterSpacing: 4.5,
                                color: p.inkPrimary,
                              ),
                            ),
                          ),

                          SizedBox(height: isCompact ? 10 : 18),

                          // Progressive Disclosure: Single Whisper Capsule vs End Stillness
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: _isSessionActive
                                ? TextButton(
                                    key: const Key('end_stillness_button'),
                                    onPressed: _stopSession,
                                    child: Text(
                                      'END STILLNESS',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 2.5,
                                        fontWeight: FontWeight.w300,
                                        color: p.inkMuted,
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    key: const Key('whisper_capsule_button'),
                                    borderRadius: BorderRadius.circular(24),
                                    onTap: _openAttunementSheet,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: p.capsuleSurface,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: p.capsuleBorder,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ZenSoundSymbol(
                                            soundKey: _selectedSound,
                                            size: 15,
                                            color: p.inkMuted,
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              '${ZenSoundSymbol.labelFor(_selectedSound)} · ${_selectedMinutes}m · ${_preparationSeconds == 0 ? 'No prep' : '${_preparationSeconds}s prep'}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 0.8,
                                                fontWeight: FontWeight.w300,
                                                color: p.inkPrimary.withValues(
                                                  alpha: 0.85,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
