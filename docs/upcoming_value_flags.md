# Upcoming Value Flags (2026-02-08)

Event: UFC Fight Night: Bautista vs. Oliveira  
Model: `ufc_ml.rolling_lr`  
Odds format: decimal  
Rule: `edge = model_prob - implied_prob`, value_flag if `edge >= 0.05`  
Fighter A = left side in the source list
Source query: `sql/64_sample_upcoming_value_flags.sql`

## Value flags

| Fight | Value side | Model prob | Implied prob | Edge |
| --- | --- | --- | --- | --- |
| Priscila Cachoeira vs Klaudia Sygula | A | 0.776 | 0.455 | +0.322 |
| Amir Albazi vs Kyoji Horiguchi | A | 0.460 | 0.270 | +0.189 |
| Jean Matsumoto vs Farid Basharat | A | 0.480 | 0.317 | +0.163 |
| Said Nurmagomedov vs Javid Basharat | A | 0.662 | 0.500 | +0.162 |
| Bruna Brasil vs Ketlen Souza | A | 0.603 | 0.444 | +0.158 |
| Michal Oleksiejczuk vs Marc-Andre Barriault | B | 0.446 | 0.294 | +0.151 |
| Wang Cong vs Eduarda Moura | B | 0.437 | 0.278 | +0.159 |
| Jailton Almeida vs Rizvan Kuniev | B | 0.656 | 0.455 | +0.201 |
| Muin Gafurov vs Jakub Wiklacz | B | 0.981 | 0.476 | +0.505 |

## No value flag
- Mario Bautista vs Vinicius Oliveira

## Notes
- Jakub Wiklacz has no historical UFC data in the dataset, so his features are mostly imputed. This makes the prediction high-uncertainty.
- This is a learning project, not betting advice or a production model.

## Caveats
- Model probabilities are not calibrated yet, so edges can be overestimated.
- Implied probabilities are computed from odds without vig removal.
