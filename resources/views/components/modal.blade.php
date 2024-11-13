<div id="{{ $id ?? 'modal' }}" class="fixed inset-0 z-50 hidden overflow-y-auto">
    <div class="flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
        {{-- Background overlay --}}
        <div class="fixed inset-0 transition-opacity bg-gray-500 bg-opacity-75 modal-overlay"></div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        {{-- Modal panel --}}
        <div
            class="inline-block w-full max-w-[800px] my-8 overflow-hidden text-left align-middle transition-all transform bg-white rounded-lg shadow-xl">
            {{-- Header --}}
            <div class="flex items-center justify-between p-6 bg-white  mb-4">
                <h3 class="text-xl font-bold text-black">
                    {{ $title }}
                </h3>
                <div>    
                    {{ $modalAction ?? "" }}
                </div>
            </div>

            {{-- Content --}}
            <div class="mt-2 p-6">
                {{ $slot }}
            </div>

            {{-- Footer --}}
            @if (isset($footer))
                <div class="mt-4 space-x-2 text-right py-8 px-6 border-t-2 ">
                    {{ $footer }}
                </div>
            @endif
        </div>
    </div>
</div>

{{-- Modal JavaScript --}}
@once
    <script>
        function openModal(modalId) {
            const modal = document.getElementById(modalId);
            modal.classList.remove('hidden');
            document.body.style.overflow = 'hidden';

            // Close on escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    closeModal(modalId);
                }
            });

            // Close on overlay click
            modal.querySelector('.modal-overlay').addEventListener('click', function() {
                closeModal(modalId);
            });
        }

        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            modal.classList.add('hidden');
            document.body.style.overflow = 'auto';
        }
    </script>
@endonce
