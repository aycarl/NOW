# Mindful Moments (Mindful Bells)

Status: [IMPLEMENTED]

- [x] Pick number & time(s) of reminder(s) up to configurable `maxBells` limit
- [x] Create custom reminder with time, intention label, and sound timbre
- [x] Update reminder or cycle its acoustic symbol (`ZenSoundSymbol`)
- [x] Delete / toggle reminder
- [x] Yin & Yang theme adaptation (Washi Light & Obsidian Night dark mode)

## UI/UX Architecture ("Less is More")
- **Collapsed Peeking Tab:** While the Meditation Timer is active on the Home screen, *Mindful Bells* rests at the bottom 8% of the screen as a frosted-glass tab displaying `MINDFUL BELLS`.
- **Hairline Sanctuary:** When expanded, scheduled moments are displayed as featherweight typographic rows separated by subtle hairlines rather than heavy boxed cards, accompanied by minimalist sacred geometry sound symbols (`◯`, `◎`, `💧`, `〰`).

## User Flow
- **Step 1:** Swipe up or tap the **Mindful Bells** peeking tab at the bottom of the Home screen.
- **Step 2:** Tap **+ Add Mindful Moment** (or the `+` action button) or tap an existing bell row to edit.
- **Step 3:** Select the desired time, intention label, and sound resonance, then tap **Save / Add**.
