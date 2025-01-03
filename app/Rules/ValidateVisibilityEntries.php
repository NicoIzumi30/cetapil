<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Support\Facades\Log;

class ValidateVisibilityEntries implements ValidationRule
{
    /**
     * Run the validation rule.
     *
     * @param  \Closure(string, ?string=): \Illuminate\Translation\PotentiallyTranslatedString  $fail
     */
    // In ValidateVisibilityEntries.php
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        // First validate basic requirements
        foreach ($value as $item) {
            if (
                !is_array($item) ||
                !isset($item['type']) ||
                !isset($item['category']) ||
                !isset($item['position'])
            ) {
                $fail('Each visibility entry must have type, category, and position keys.');
                return;
            }
        }

        // Validate CORE and BABY categories as before
        foreach (['CORE', 'BABY'] as $category) {
            $entries = collect($value)->filter(function ($item) use ($category) {
                return $item['type'] === 'PRIMARY' && $item['category'] === $category;
            });

            if ($entries->count() !== 3) {
                $fail("Must have exactly 3 PRIMARY {$category} entries.");
                return;
            }

            $positions = $entries->pluck('position')->sort()->values()->toArray();
            $missingPositions = array_diff([1, 2, 3], $positions);

            if (!empty($missingPositions)) {
                $missing = implode(', ', $missingPositions);
                $fail("PRIMARY {$category} is missing positions: {$missing}");
                return;
            }
        }

        // Validate COMPETITOR category
        $competitorEntries = collect($value)->filter(function ($item) {
            return $item['category'] === 'COMPETITOR';
        });

        $competitorCount = $competitorEntries->count();

        if ($competitorCount > 0) {
            // Check maximum entries
            if ($competitorCount > 2) {
                $fail("Cannot have more than 2 COMPETITOR entries.");
                return;
            }

            $positions = $competitorEntries->pluck('position')->sort()->values()->toArray();

            // Debug log the positions
            Log::info('Competitor positions:', [
                'count' => $competitorCount,
                'positions' => $positions,
                'raw_entries' => $competitorEntries->toArray()
            ]);

            if ($competitorCount === 1) {
                if (!in_array(1, $positions)) {
                    $fail("Single COMPETITOR entry must use position 1.");
                    return;
                }
            }

            if ($competitorCount === 2) {
                // More lenient check - just ensure we have positions 1 and 2
                $requiredPositions = [1, 2];
                $missingPositions = array_diff($requiredPositions, $positions);

                if (!empty($missingPositions)) {
                    $fail("Two COMPETITOR entries must include positions 1 and 2.");
                    return;
                }
            }
        }
    }
}
