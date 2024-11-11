<button type="button" {{ $attributes->merge(['class' => 'py-2 primary-bg hover:bg-primary rounded-lg text-lightBlue border px-4 mt-2 me-2 font-bold text-lg text-center']) }}>
    {{ $slot }}
</button>

<style> 
	.primary-bg {
		background: linear-gradient(135deg, #53A2D2 0%, #0077BD 100%);
	}
</style>
