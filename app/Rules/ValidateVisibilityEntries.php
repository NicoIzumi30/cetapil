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

        // Validate PRIMARY entries for CORE and BABY categories
        foreach (['CORE', 'BABY'] as $category) {
            $primaryEntries = collect($value)->filter(function ($item) use ($category) {
                return $item['type'] === 'PRIMARY' && $item['category'] === $category;
            });

            if ($primaryEntries->count() !== 3) {
                $fail("Must have exactly 3 PRIMARY {$category} entries.");
                return;
            }

            $primaryPositions = $primaryEntries->pluck('position')->sort()->values()->toArray();
            $missingPrimaryPositions = array_diff([1, 2, 3], $primaryPositions);

            if (!empty($missingPrimaryPositions)) {
                $missing = implode(', ', $missingPrimaryPositions);
                $fail("PRIMARY {$category} is missing positions: {$missing}");
                return;
            }
        }

        // Validate SECONDARY entries for CORE and BABY categories
        foreach (['CORE', 'BABY'] as $category) {
            $secondaryEntries = collect($value)->filter(function ($item) use ($category) {
                return $item['type'] === 'SECONDARY' && $item['category'] === $category;
            });

            // if ($secondaryEntries->count() !== 2) {
            //     $fail("Must have exactly 2 SECONDARY {$category} entries.");
            //     return;
            // }

            $secondaryPositions = $secondaryEntries->pluck('position')->sort()->values()->toArray();
            $missingSecondaryPositions = array_diff([1, 2], $secondaryPositions);

            if (!empty($missingSecondaryPositions)) {
                $missing = implode(', ', $missingSecondaryPositions);
                $fail("SECONDARY {$category} is missing positions: {$missing}");
                return;
            }
        }

        // Validate COMPETITOR category (required 2 entries)
        $competitorEntries = collect($value)->filter(function ($item) {
            return $item['category'] === 'COMPETITOR';
        });

        $competitorCount = $competitorEntries->count();

        if ($competitorCount !== 2) {
            $fail("Must have exactly 2 COMPETITOR entries.");
            return;
        }

        $positions = $competitorEntries->pluck('position')->sort()->values()->toArray();
        $missingPositions = array_diff([1, 2], $positions);

        if (!empty($missingPositions)) {
            $fail("COMPETITOR entries must use positions 1 and 2.");
            return;
        }
    }
}
