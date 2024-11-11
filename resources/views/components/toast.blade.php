@props(['title', 'subTitle'])

<div class="toast-container position-fixed top-0 end-0 p-3">
    <div id="liveToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-body d-flex align-items-start flex-column bg-primary p-0">
            <div class="p-3 me-5">
                <div class="position-absolute bottom-0 end-0 me-4 mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" width="105" height="105" viewBox="0 0 105 105" fill="none">
                        <path d="M44.1126 73.0881L23.8636 52.8391L30.6133 46.0894L44.1126 59.5887L71.1112 32.5901L77.8609 39.3398L44.1126 73.0881Z" fill="white" fill-opacity="0.1"/>
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M0 52.5C0 23.5051 23.5051 0 52.5 0C81.495 0 105 23.5051 105 52.5C105 81.495 81.495 105 52.5 105C23.5051 105 0 81.495 0 52.5ZM52.5 95.4546C28.7769 95.4546 9.54545 76.2231 9.54545 52.5C9.54545 28.7769 28.7769 9.54545 52.5 9.54545C76.2231 9.54545 95.4546 28.7769 95.4546 52.5C95.4546 76.2231 76.2231 95.4546 52.5 95.4546Z" fill="white" fill-opacity="0.1"/>
                    </svg>
                </div>

                <h5>{{ $title }}</h5>
                <p>
                    {{ $subTitle }}
                </p>
            </div>
            <div class="card">
                <div class="card-body">
                </div>
            </div>
        </div>
    </div>
</div>
