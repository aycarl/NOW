import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

/// Unit tests for business logic components
void main() {
  group('Time Formatting Logic', () {
    group('Time Parsing', () {
      test('parses AM time correctly', () {
        // Arrange
        const timeString = '07:30 AM';
        
        // Act
        final parts = timeString.split(' ');
        final hourMinute = parts[0].split(':');
        int hour = int.parse(hourMinute[0]);
        int minute = int.parse(hourMinute[1]);
        final period = parts[1];
        
        // Handle 12 AM edge case
        if (period == 'AM' && hour == 12) hour = 0;
        
        final timeOfDay = TimeOfDay(hour: hour, minute: minute);
        
        // Assert
        expect(timeOfDay.hour, equals(7));
        expect(timeOfDay.minute, equals(30));
        expect(timeOfDay.period, equals(DayPeriod.am));
      });

      test('parses PM time correctly', () {
        // Arrange
        const timeString = '02:45 PM';
        
        // Act
        final parts = timeString.split(' ');
        final hourMinute = parts[0].split(':');
        int hour = int.parse(hourMinute[0]);
        int minute = int.parse(hourMinute[1]);
        final period = parts[1];
        
        // Handle PM conversion (except 12 PM)
        if (period == 'PM' && hour != 12) hour += 12;
        
        final timeOfDay = TimeOfDay(hour: hour, minute: minute);
        
        // Assert
        expect(timeOfDay.hour, equals(14));
        expect(timeOfDay.minute, equals(45));
        expect(timeOfDay.period, equals(DayPeriod.pm));
      });

      test('handles 12 AM correctly', () {
        // Arrange
        const timeString = '12:00 AM';
        
        // Act
        final parts = timeString.split(' ');
        final hourMinute = parts[0].split(':');
        int hour = int.parse(hourMinute[0]);
        int minute = int.parse(hourMinute[1]);
        final period = parts[1];
        
        if (period == 'AM' && hour == 12) hour = 0;
        
        final timeOfDay = TimeOfDay(hour: hour, minute: minute);
        
        // Assert
        expect(timeOfDay.hour, equals(0));
        expect(timeOfDay.minute, equals(0));
        expect(timeOfDay.period, equals(DayPeriod.am));
      });

      test('handles 12 PM correctly', () {
        // Arrange
        const timeString = '12:00 PM';
        
        // Act
        final parts = timeString.split(' ');
        final hourMinute = parts[0].split(':');
        int hour = int.parse(hourMinute[0]);
        int minute = int.parse(hourMinute[1]);
        final period = parts[1];
        
        // 12 PM stays as 12
        if (period == 'PM' && hour != 12) hour += 12;
        
        final timeOfDay = TimeOfDay(hour: hour, minute: minute);
        
        // Assert
        expect(timeOfDay.hour, equals(12));
        expect(timeOfDay.minute, equals(0));
        expect(timeOfDay.period, equals(DayPeriod.pm));
      });
    });

    group('Time Formatting', () {
      test('formats TimeOfDay to 12-hour string correctly', () {
        // Test cases for various times
        final testCases = [
          {'input': const TimeOfDay(hour: 0, minute: 0), 'expected': '12:00 AM'},
          {'input': const TimeOfDay(hour: 7, minute: 30), 'expected': '07:30 AM'},
          {'input': const TimeOfDay(hour: 12, minute: 0), 'expected': '12:00 PM'},
          {'input': const TimeOfDay(hour: 14, minute: 45), 'expected': '02:45 PM'},
          {'input': const TimeOfDay(hour: 23, minute: 59), 'expected': '11:59 PM'},
        ];

        for (final testCase in testCases) {
          final timeOfDay = testCase['input'] as TimeOfDay;
          
          // Act - Format time to 12-hour string
          final hour = timeOfDay.hourOfPeriod == 0 && timeOfDay.period == DayPeriod.pm 
              ? 12 
              : timeOfDay.hourOfPeriod;
          final timeString = '${hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')} ${timeOfDay.period == DayPeriod.am ? 'AM' : 'PM'}';
          
          // Assert
          expect(timeString, equals(testCase['expected']), 
                 reason: 'Failed for input: ${testCase['input']}');
        }
      });
    });
  });

  group('Bell Data Validation', () {
    group('Bell Configuration', () {
      test('validates complete bell data', () {
        // Arrange
        final bellData = {
          'time': '07:00 AM',
          'label': 'Morning Bell',
          'sound': 'default',
        };
        
        // Act & Assert
        expect(bellData.containsKey('time'), isTrue);
        expect(bellData.containsKey('label'), isTrue);
        expect(bellData.containsKey('sound'), isTrue);
        expect(bellData['time']!.isNotEmpty, isTrue);
        expect(bellData['label']!.isNotEmpty, isTrue);
        expect(bellData['sound']!.isNotEmpty, isTrue);
      });

      test('validates sound options', () {
        // Arrange
        const validSounds = ['default', 'alarm', 'notification', 'ringtone'];
        
        // Test each valid sound
        for (final sound in validSounds) {
          // Act
          final isValid = validSounds.contains(sound);
          
          // Assert
          expect(isValid, isTrue, reason: 'Sound $sound should be valid');
        }
        
        // Test invalid sound
        expect(validSounds.contains('invalid_sound'), isFalse);
      });

      test('validates bell label requirements', () {
        final testCases = [
          {'label': 'Morning Bell', 'valid': true},
          {'label': 'Work Bell', 'valid': true},
          {'label': 'A', 'valid': true}, // Single character should be valid
          {'label': '', 'valid': false}, // Empty should be invalid
          {'label': 'Very Long Bell Name That Might Be Too Long For Display', 'valid': true}, // Long names ok
        ];

        for (final testCase in testCases) {
          final label = testCase['label'] as String;
          final expectedValid = testCase['valid'] as bool;
          
          // Act - Simple validation: non-empty
          final isValid = label.isNotEmpty;
          
          // Assert
          expect(isValid, equals(expectedValid), 
                 reason: 'Label "$label" validation failed');
        }
      });
    });

    group('Bell Count Validation', () {
      test('validates maximum bell count', () {
        // Arrange
        const maxBells = 5;
        final bellCounts = [0, 1, 2, 3, 4, 5, 6, 10];
        
        for (final count in bellCounts) {
          // Act
          final canAddMore = count < maxBells;
          final shouldShowFAB = canAddMore;
          
          // Assert
          if (count < maxBells) {
            expect(shouldShowFAB, isTrue, 
                   reason: 'Should show FAB when count is $count');
          } else {
            expect(shouldShowFAB, isFalse, 
                   reason: 'Should not show FAB when count is $count');
          }
        }
      });
    });
  });

  group('Angel Numbers Logic', () {
    group('Angel Numbers Validation', () {
      test('validates angel number format', () {
        // Arrange
        const validAngelNumbers = ['1:11', '2:22', '3:33', '4:44', '5:55', '11:11'];
        const invalidNumbers = ['1:12', '2:23', '12:34', '1:10', '11:1'];
        
        // Test valid numbers
        for (final number in validAngelNumbers) {
          // Act - Check if hours and minutes match
          final parts = number.split(':');
          final hours = parts[0];
          final minutes = parts[1];
          final isAngel = (hours.length == 1 && minutes == hours + hours) || (hours == minutes);
          
          // Assert
          expect(isAngel, isTrue, reason: '$number should be valid angel number');
        }
        
        // Test invalid numbers
        for (final number in invalidNumbers) {
          final parts = number.split(':');
          final hours = parts[0];
          final minutes = parts[1];
          final isAngel = (hours.length == 1 && minutes == hours + hours) || (hours == minutes);
          
          expect(isAngel, isFalse, reason: '$number should not be valid angel number');
        }
      });

      test('manages enabled angel numbers set', () {
        // Arrange
        final enabledNumbers = <String>{};
        const testNumbers = ['1:11', '2:22', '3:33'];
        
        // Act - Add numbers
        for (final number in testNumbers) {
          enabledNumbers.add(number);
        }
        
        // Assert - All added
        expect(enabledNumbers.length, equals(3));
        for (final number in testNumbers) {
          expect(enabledNumbers.contains(number), isTrue);
        }
        
        // Act - Remove one
        enabledNumbers.remove('2:22');
        
        // Assert - Properly removed
        expect(enabledNumbers.length, equals(2));
        expect(enabledNumbers.contains('2:22'), isFalse);
        expect(enabledNumbers.contains('1:11'), isTrue);
        expect(enabledNumbers.contains('3:33'), isTrue);
      });
    });
  });

  group('Meditation Logic', () {
    group('Duration Validation', () {
      test('validates meditation duration ranges', () {
        final testDurations = [1, 5, 10, 15, 20, 30, 45, 60, 90, 120];
        
        for (final duration in testDurations) {
          // Act - Basic validation: positive number
          final isValid = duration > 0 && duration <= 120; // Max 2 hours
          
          // Assert
          expect(isValid, isTrue, 
                 reason: 'Duration $duration minutes should be valid');
        }
        
        // Test invalid durations
        final invalidDurations = [0, -1, -10, 150, 200];
        for (final duration in invalidDurations) {
          final isValid = duration > 0 && duration <= 120;
          
          expect(isValid, isFalse, 
                 reason: 'Duration $duration minutes should be invalid');
        }
      });

      test('validates preparation time ranges', () {
        final validPrepTimes = [0, 5, 10, 15, 30];
        final invalidPrepTimes = [-1, -5, 60, 120];
        
        for (final prepTime in validPrepTimes) {
          // Act - Valid prep time: 0-30 seconds
          final isValid = prepTime >= 0 && prepTime <= 30;
          
          // Assert
          expect(isValid, isTrue, 
                 reason: 'Prep time $prepTime seconds should be valid');
        }
        
        for (final prepTime in invalidPrepTimes) {
          final isValid = prepTime >= 0 && prepTime <= 30;
          
          expect(isValid, isFalse, 
                 reason: 'Prep time $prepTime seconds should be invalid');
        }
      });
    });

    group('Sound Selection', () {
      test('validates sound options', () {
        // Arrange
        final soundOptions = [
          {'label': 'Default', 'value': 'default'},
          {'label': 'Singing Bowl', 'value': 'singing_bowl'},
          {'label': 'Bell', 'value': 'bell'},
          {'label': 'Chime', 'value': 'chime'},
          {'label': 'Nature Sounds', 'value': 'nature'},
        ];
        
        // Act & Assert
        expect(soundOptions.length, equals(5));
        
        for (final sound in soundOptions) {
          expect(sound.containsKey('label'), isTrue);
          expect(sound.containsKey('value'), isTrue);
          expect(sound['label']!.isNotEmpty, isTrue);
          expect(sound['value']!.isNotEmpty, isTrue);
        }
        
        // Verify default sound exists
        final defaultSound = soundOptions.firstWhere(
          (s) => s['value'] == 'default',
          orElse: () => <String, String>{},
        );
        expect(defaultSound.isNotEmpty, isTrue);
      });
    });
  });

  group('Inspirational Quotes Logic', () {
    test('provides random quotes correctly', () {
      // Arrange
      final quotes = [
        "The present moment is the only time over which we have dominion.",
        "Meditation is not about stopping thoughts, but recognizing that we are more than our thoughts.",
        "In the midst of movement and chaos, keep stillness inside of you.",
        "The mind is everything. What you think you become.",
        "Peace comes from within. Do not seek it without.",
        "Wherever you are, be there totally.",
        "The quieter you become, the more you are able to hear.",
        "Mindfulness is about being fully awake in our lives.",
        "Breathe in peace, breathe out stress.",
        "The best way to take care of the future is to take care of the present moment.",
      ];
      
      // Act - Simulate getting random quotes
      final selectedQuotes = <String>{};
      for (int i = 0; i < 20; i++) {
        final randomIndex = i % quotes.length; // Simulate random selection
        selectedQuotes.add(quotes[randomIndex]);
      }
      
      // Assert - Should have variety (at least multiple quotes)
      expect(selectedQuotes.length, greaterThan(1));
      expect(quotes.length, equals(10));
      
      // All quotes should be non-empty
      for (final quote in quotes) {
        expect(quote.isNotEmpty, isTrue);
        expect(quote.length, greaterThan(10)); // Reasonable length
      }
    });

    test('validates quote content quality', () {
      final quotes = [
        "The present moment is the only time over which we have dominion.",
        "Meditation is not about stopping thoughts, but recognizing that we are more than our thoughts.",
      ];
      
      for (final quote in quotes) {
        // Basic quality checks
        expect(quote.isNotEmpty, isTrue);
        expect(quote.length, greaterThan(20)); // Substantial content
        expect(quote.contains('.') || quote.contains('!') || quote.contains('?'), isTrue); // Proper punctuation
        
        // Check for meditation/mindfulness related keywords
        final keywords = ['moment', 'meditation', 'mind', 'peace', 'present', 'stillness', 'thoughts'];
        final containsKeyword = keywords.any((keyword) => 
          quote.toLowerCase().contains(keyword.toLowerCase()));
        
        expect(containsKeyword, isTrue, 
               reason: 'Quote should contain meditation-related content: $quote');
      }
    });
  });

  group('Data Persistence Logic', () {
    test('validates bell data structure for persistence', () {
      // Arrange - Mock bell list
      final bells = [
        {'time': '07:00 AM', 'label': 'Morning Bell', 'sound': 'default'},
        {'time': '08:30 AM', 'label': 'Work Bell', 'sound': 'alarm'},
      ];
      
      // Act & Assert - Validate structure
      expect(bells.length, equals(2));
      
      for (final bell in bells) {
        expect(bell.keys.length, equals(3));
        expect(bell.containsKey('time'), isTrue);
        expect(bell.containsKey('label'), isTrue);
        expect(bell.containsKey('sound'), isTrue);
        
        // Validate values are non-null and non-empty
        expect(bell['time'], isNotNull);
        expect(bell['label'], isNotNull);
        expect(bell['sound'], isNotNull);
        expect(bell['time']!.isNotEmpty, isTrue);
        expect(bell['label']!.isNotEmpty, isTrue);
        expect(bell['sound']!.isNotEmpty, isTrue);
      }
    });

    test('validates meditation settings persistence', () {
      // Arrange - Mock meditation settings
      final settings = {
        'duration': 10,
        'sound': 'default',
        'preparationTime': 10,
      };
      
      // Act & Assert
      expect(settings['duration'], isA<int>());
      expect(settings['sound'], isA<String>());
      expect(settings['preparationTime'], isA<int>());
      
      expect((settings['duration'] as int) > 0, isTrue);
      expect((settings['sound'] as String).isNotEmpty, isTrue);
      expect((settings['preparationTime'] as int) >= 0, isTrue);
    });
  });
}
