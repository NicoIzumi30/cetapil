<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;

class ProductController extends Controller
{
    public function index(Request $request)
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

		$perPage = $request->input('per_page', 50);
        
        // Validate the per_page parameter to ensure it's one of the allowed values
        $validPerPage = in_array($perPage, [10, 20, 30, 40, 50]) ? $perPage : 10;
        
        $currentPage = request()->get('page', 1); // Get current page from URL, default to 1
        $offset = ($currentPage - 1) * $validPerPage; // Calculate offset

        // Create paginator instance with dynamic per_page value
        $items = new LengthAwarePaginator(
            $mockData->slice($offset, $validPerPage)->values(),
            $mockData->count(),
            $validPerPage,
            $currentPage,
            ['path' => request()->url()]
        );

        // Append the per_page parameter to pagination links
        $items->appends(['per_page' => $validPerPage]);

        return view('pages.product.index', compact('items'));
    }
}