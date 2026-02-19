# Leakage Checklist (UFC)

## Rule of thumb
Only use information that is known **before** the fight starts.

## Do NOT use (leakage)
- Outcome fields: winner, winner_id, method, finish_round, match_time_sec
- Any in-fight stats from fight_details (all r_* and b_* strike/takedown/control stats)
- Anything derived from the current fight (e.g., sig strikes, takedowns, control time)

## Use (safe, pre-fight)
- Event date (event_date)
- Division / weight class (division)
- Title fight flag (title_fight)
- Scheduled rounds (total_rounds)
- Fighter attributes known before fight:
  - age (from dob + event_date)
  - height, reach, stance
  - missing-value flags for the above

## Notes
Fighter career totals (wins/losses etc.) can be leakage unless they are computed **as of the fight date**. We will add rolling/temporal features later.