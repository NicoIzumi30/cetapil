<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;

class ProductController extends Controller
{
    public function index()
    {
        // Create mock data array
        $mockData = collect([
            [
                'id' => 1,
                'name' => 'Gaming Laptop',
                'price' => 1299.99,
                'stock' => 50,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => -40
            ],
            [
                'id' => 2,
                'name' => 'Wireless Mouse',
                'price' => 49.99,
                'stock' => 100,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 40

            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
            [
                'id' => 3,
                'name' => 'Mechanical Keyboard',
                'price' => 159.99,
                'stock' => 30,
				'status' => 'Yes',
				'ket' => 'Ideal',
				'recommendation' => 20
            ],
            [
                'id' => 4,
                'name' => 'Gaming Monitor',
                'price' => 499.99,
                'stock' => 25,
				'status' => 'Yes',
				'ket' => 'Kurang',
				'recommendation' => 10
            ],
            [
                'id' => 5,
                'name' => 'Gaming Chair',
                'price' => 299.99,
                'stock' => 15,
				'status' => 'No',
				'ket' => 'Ideal',
				'recommendation' => -20
            ],
        ]);

        $perPage = 7; // Number of items per page
        $currentPage = request()->get('page', 1); // Get current page from URL, default to 1
        $offset = ($currentPage - 1) * $perPage; // Calculate offset

        // Slice the collection
        $items = new LengthAwarePaginator(
            $mockData->slice($offset, $perPage)->values(),
            $mockData->count(),
            $perPage,
            $currentPage,
            ['path' => request()->url()]
        );

        return view('pages.product.index', compact('items'));
    }
}