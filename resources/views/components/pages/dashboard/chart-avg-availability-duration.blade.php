<div class="w-full chart-bg p-6 rounded-lg">

    <div class="text-center text-xl text-white font-bold mb-6">AVG Availability Duration</div>
    <div class="filters flex flex-wrap md:flex-nowrap justify-center">
        <x-input.datepicker id="availability-date-range" />
        <x-select.light id="availibility-filter-date">
            <x-slot:title>Filter Date</x-slot:title>
            @php
                $days = getAllDay();
            @endphp
            @foreach ($days as $key => $value)
                <option value="{{ $value }}">{{ $key }}</option>
            @endforeach
        </x-select.light>
    </div>


    <div class="chart-container">
        <div id="availability-chart-bar" class="hidden">
            <div class="donut-container">
                <canvas id="routingDonutChart"></canvas>
                <div class="center-number text-center">
                    <p id="avg-availability-duration" class="text-white text-2xl font-bold">00:00:00</p>
                    <span class="text-white text-sm font-bold text-center">hh:mm:ss</span>
                </div>
            </div>

            <div class="bar-chart">
                <div class="bar-label">MT</div>
                <div class="bar-row">
                    <div class="bar-wrapper">
                        <div class="bar" style="width: 78.58%" id="mt-availability-bar"></div>
                    </div>
                    <div class="bar-value">
                        <div class="percentage" id="mt-availability-time">0m 0s</div>
                    </div>
                </div>

                <div class="bar-label">GT</div>
                <div class="bar-row">
                    <div class="bar-wrapper">
                        <div class="bar" style="width: 54%" id="gt-availability-bar"></div>
                    </div>
                    <div class="bar-value">
                        <div class="percentage" id="gt-availability-time">0m 0s</div>
                    </div>
                </div>
            </div>
        </div>
        <div id="availability-loading" class="mt-24">
            <svg aria-hidden="true" class="w-12 h-12 text-gray-200 animate-spin fill-primary" viewBox="0 0 100 101"
                fill="none" xmlns="http://www.w3.org/2000/svg">
                <path
                    d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                    fill="#fff" />
                <path
                    d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                    fill="currentFill" />
            </svg>
        </div>
    </div>

</div>

<script>
    function InitializeAvailabilityChart(data) {
		$('#availability-chart-bar').removeClass("hidden")
		$('#availability-loading').addClass("hidden")
		 
        const routingCanvas = document.getElementById('routingDonutChart');
        const routingCtx = routingCanvas.getContext('2d');
        const routingDpr = 2;
        routingCanvas.width = 160 * routingDpr;
        routingCanvas.height = 160 * routingDpr;
        routingCanvas.style.width = '100%';
        routingCtx.scale(routingDpr, routingDpr);

        const routingData = [{
                value: data.mt_contribution,
                color: '#48CAE4'
            },
            {
                value: data.gt_contribution,
                color: '#0095ff'
            },
        ];
        $('#avg-availability-duration').text(data.avg_all);
        $('#mt-availability-bar').css('width', `${data.progres_mt}%`);
        $('#mt-availability-time').text(data.avg_mt);
        $('#gt-availability-bar').css('width', `${data.progres_gt}%`);
        $('#gt-availability-time').text(data.avg_gt);

        const routingCenterX = 80;
        const routingCenterY = 80;
        const routingRadius = 60;
        const routingInnerRadius = 45;
        const routingStartAngle = -Math.PI / 2;
        const routingGapAngle = (Math.PI * 2) * 0.01;

        let routingCurrentAngle = routingStartAngle;
        routingData.forEach((segment) => {
            const routingSegmentAngle = (segment.value / 100) * (Math.PI * 2 - routingGapAngle * routingData
                .length);

            routingCtx.beginPath();
            routingCtx.arc(routingCenterX, routingCenterY, routingRadius, routingCurrentAngle,
                routingCurrentAngle +
                routingSegmentAngle);
            routingCtx.arc(routingCenterX, routingCenterY, routingInnerRadius, routingCurrentAngle +
                routingSegmentAngle, routingCurrentAngle, true);
            routingCtx.closePath();

            routingCtx.fillStyle = segment.color;
            routingCtx.fill();

            routingCurrentAngle += routingSegmentAngle + routingGapAngle;
        });
    }
    $.ajax({
        url: '/get-avg-availability',
        type: 'GET',
        success: function(response) {
            const avgAvailability = JSON.parse(response);
            $('#avg-availability-duration').text(avgAvailability.time_avg);
            InitializeAvailabilityChart(avgAvailability);
        },
        error: function(xhr) {
            toast('error', xhr.responseJSON.message, 200);
        }
    });
</script>

<script>
    $(document).ready(function() {
        let selectedAvailibilityDateRange = ''
        let selectedAvailibilityVisitDay = 0

        function fetchAvailabilityData(dateRange, visitDay) {
			$('#availability-chart-bar').addClass("hidden")
			$('#availability-loading').removeClass("hidden")
            $.ajax({
                url: `/get-avg-availability?date=${dateRange}&visit-day=${visitDay}`,
                type: 'GET',
                success: function(response) {
                    const filteredAvgAvailability = JSON.parse(response);
                    $('#avg-availability-duration').text(filteredAvgAvailability.time_avg);
                    InitializeAvailabilityChart(filteredAvgAvailability);
                },
                error: function(xhr) {
                    toast('error', xhr.responseJSON.message, 200);
                }
            })
        }

        $('#availibility-filter-date').on('change', function(e) {
            selectedAvailibilityVisitDay = e.target.value
            fetchAvailabilityData(selectedAvailibilityDateRange, selectedAvailibilityVisitDay)
        })
        $("#availability-date-range").flatpickr({
            mode: "range",
            onClose: function(selectedDate, dateStr) {
                formattedSelectedDate = dateStr.replaceAll(" ", "+")
                selectedAvailibilityDateRange = formattedSelectedDate
                fetchAvailabilityData(selectedAvailibilityDateRange, selectedAvailibilityVisitDay)
            }
        })
    })
</script>
