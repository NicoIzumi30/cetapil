<?php

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

if (!function_exists('saveFile')) {
    function saveFile(UploadedFile $file, $folderPath, $defaultPath = 'images')
    {
        $fileName = $file->getClientOriginalName();
        $filenameWithoutExtension = pathinfo($fileName, PATHINFO_FILENAME);
        $newFileName = Str::slug($filenameWithoutExtension, '_') . '_' . time() . '.' . $file->getClientOriginalExtension();
        $destinationPath = '/' . $defaultPath . '/' . $folderPath;

        // Move file directly instead of using file_get_contents
        Storage::disk('public')->putFileAs(
            $destinationPath,
            $file,
            $newFileName
        );

        return [
            'filename' => $fileName,
            'path' => "$destinationPath/$newFileName"
        ];
    }
}

if (!function_exists('removeFile')) {
    function removeFile($path)
    {
        if ($path !== null && Storage::disk('public')->exists($path)) {
            Storage::disk('public')->delete($path);
        }
    }
}

if (!function_exists('removeFolder')) {
    function removeFolder($directory)
    {
        if (Storage::disk('public')->exists($directory)) {
            Storage::disk('public')->deleteDirectory($directory);
        }
    }
}

if (!function_exists('uploadImageByUrl')) {
    function uploadImageByUrl($url, $path)
    {
        try {
            $response = Http::get($url);
            $image = $response->body();

            // Create image resource from string
            $sourceImage = imagecreatefromstring($image);

            if (!$sourceImage) {
                throw new Exception("Failed to create image from URL");
            }

            // Get original dimensions
            $width = imagesx($sourceImage);
            $height = imagesy($sourceImage);

            // Calculate new dimensions (max width 800px)
            $newWidth = 800;
            $newHeight = floor($height * ($newWidth / $width));

            // Create new image with new dimensions
            $newImage = imagecreatetruecolor($newWidth, $newHeight);

            // Resize image
            imagecopyresampled(
                $newImage,
                $sourceImage,
                0,
                0,
                0,
                0,
                $newWidth,
                $newHeight,
                $width,
                $height
            );

            // Start output buffering
            ob_start();
            imagejpeg($newImage, null, 90);
            $imageData = ob_get_clean();

            // Clean up
            imagedestroy($sourceImage);
            imagedestroy($newImage);

            $imageName = time() . '_' . Str::random(10) . '.jpg';
            Storage::disk('public')->put($path . '/' . $imageName, $imageData);

            return $imageName;
        } catch (Exception $e) {
            // Log error or handle it appropriately
            return null;
        }
    }
}

if (!function_exists('updateFileKnowledge')) {
    function updateFileKnowledge(UploadedFile $file, $folderPath, $fileName)
    {
        $path = "/{$folderPath}/{$fileName}";
        if ($path !== null && Storage::disk('public')->exists($path)) {
            Storage::disk('public')->delete($path);
        }

        Storage::disk('public')->put($path, file_get_contents($file));

        return [
            'filename' => $fileName,
            'path' => "$path",
        ];
    }
}
