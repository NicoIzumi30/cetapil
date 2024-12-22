<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class ValidateVisibilityEntries implements ValidationRule
{
    /**
     * Run the validation rule.
     *
     * @param  \Closure(string, ?string=): \Illuminate\Translation\PotentiallyTranslatedString  $fail
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        // First validate that we have an array of items with required keys
        foreach ($value as $item) {
            if (!is_array($item) ||
                !isset($item['type']) ||
                !isset($item['category']) ||
                !isset($item['position'])) {
                $fail('Each visibility entry must have type, category, and position keys.');
                return;
            }
        }

        foreach (['CORE', 'BABY'] as $category) {
            $entries = collect($value)->filter(function ($item) use ($category) {
                return $item['type'] === 'PRIMARY' && $item['category'] === $category;
            });

            // Check count first
            if ($entries->count() !== 3) {
                $fail("Must have exactly 3 PRIMARY {$category} entries.");
                return;
            }

            // Get the positions and check for missing ones
            $positions = $entries->pluck('position')->sort()->values()->toArray();
            $missingPositions = array_diff([1, 2, 3], $positions);

            if (!empty($missingPositions)) {
                $missing = implode(', ', $missingPositions);
                $fail("PRIMARY {$category} is missing positions: {$missing}");
                return;
            }
        }
    }
}
