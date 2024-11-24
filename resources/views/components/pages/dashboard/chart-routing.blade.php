<div class="w-full chart-bg p-6 rounded-lg">

    <div class="text-center text-xl text-white font-bold mb-6">Routing</div>
    <div class="filters flex justify-center">
        <x-input.datepicker id="routing-date-range" />
        <x-select.light>
            <x-slot:title>Filter Date</x-slot:title>
        </x-select.light>
    </div>


    <div class="chart-container">
        <div class="donut-container">
            <canvas id="routingDonutChart"></canvas>
            <div class="center-number text-white text-4xl font-bold">74%</div>
        </div>

        <div class="legend">
            <div class="legend-item">
                <div class="legend-color" style="background: #48CAE4;"></div>
                <span>A</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: #0095ff;"></div>
                <span>B</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: #49b3ff;"></div>
                <span>C</span>
            </div>
        </div>

        <div class="bar-chart">
            <div class="bar-row">
                <div class="bar-label">GT</div>
                <div class="bar-wrapper">
                    <div class="bar" style="width: 100%"></div>
                </div>
                <div class="bar-value">
                    <div class="percentage">100%</div>
                    <div class="count">890</div>
                </div>
            </div>
            <div class="bar-row">
                <div class="bar-label">MT</div>
                <div class="bar-wrapper">
                    <div class="bar" style="width: 54%"></div>
                </div>
                <div class="bar-value">
                    <div class="percentage">54%</div>
                    <div class="count">578</div>
                </div>
            </div>
            <div class="bar-row">
                <div class="bar-label">MT</div>
                <div class="bar-wrapper">
                    <div class="bar" style="width: 65%"></div>
                </div>
                <div class="bar-value">
                    <div class="percentage">65%</div>
                    <div class="count">625</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const routingCanvas = document.getElementById('routingDonutChart');
    const routingCtx = routingCanvas.getContext('2d');

    const routingDpr = window.devicePixelRatio || 1;
    routingCanvas.width = 160 * routingDpr;
    routingCanvas.height = 160 * routingDpr;
    routingCanvas.style.width = '100%';
    routingCtx.scale(routingDpr, routingDpr);

    const routingData = [{
            value: 35,
            color: '#48CAE4'
        },
        {
            value: 35,
            color: '#0095ff'
        },
        {
            value: 30,
            color: '#49b3ff'
        }
    ];

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
        routingCtx.arc(routingCenterX, routingCenterY, routingRadius, routingCurrentAngle, routingCurrentAngle +
            routingSegmentAngle);
        routingCtx.arc(routingCenterX, routingCenterY, routingInnerRadius, routingCurrentAngle +
            routingSegmentAngle, routingCurrentAngle, true);
        routingCtx.closePath();

        routingCtx.fillStyle = segment.color;
        routingCtx.fill();

        routingCurrentAngle += routingSegmentAngle + routingGapAngle;
    });
</script>


<script>
    $(document).ready(function() {
        $("#routing-date-range").flatpickr({
            mode: "range"
        });
    })
</script>

