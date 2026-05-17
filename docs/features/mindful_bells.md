# Mindful moments (reminders)

Status: [PARTIALLY IMPLEMENTED]

- [x] Pick number & time(s) of reminder(s): 1, 2 or 3 (Current implementation allows custom max bells)
- [ ] Select frequency of reminders (daily, weekly)
  - [x] Create custom reminder
  - [x] Update reminder
  - [ ] Delete reminder

Edge Cases:
- User tries to set more than 3 reminders (or custom max bells) - show error message.
- User tries to set a reminder in the past - show error message.
- User tries to set a reminder without selecting a time - add button stays inactive.
- User tries to set duplicate reminders - show error message.

## User Flow
- **Step 1:** Swipe to the Mindful Bells screen.
- **Step 2:** Tap an empty time slot or the "+" icon.
- **Step 3:** Scroll to desired time and tap outside the picker to auto-save.
