<div class="w-full chart-bg p-6 rounded-lg">
        <div class="text-center text-xl text-white font-bold mb-6">Time Activity</div>
		<div class="filters flex-wrap md:flex-nowrap flex justify-center">
            <x-input.datepicker id="time-activity-date-range" />
            <x-select.light>
                <x-slot:title>Filter Date</x-slot:title>
            </x-select.light>
        </div>


    <div class="chart-container">
        <div class="donut-container">
            <canvas id="timeActivityDonutChart"></canvas>
            <div class="center-number text-white text-4xl font-bold">28%</div>
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
    const timeActivityCanvas = document.getElementById('timeActivityDonutChart');
    const timeActivityCtx = timeActivityCanvas.getContext('2d');

    const timeActivityDpr = window.devicePixelRatio || 1;
    timeActivityCanvas.width = 160 * timeActivityDpr;
    timeActivityCanvas.height = 160 * timeActivityDpr;
    timeActivityCanvas.style.width = '100%';
    timeActivityCtx.scale(timeActivityDpr, timeActivityDpr);

    const timeActivityData = [{
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

    const timeActivityCenterX = 80;
    const timeActivityCenterY = 80;
    const timeActivityRadius = 60;
    const timeActivityInnerRadius = 45;
    const timeActivityStartAngle = -Math.PI / 2;
    const timeActivityGapAngle = (Math.PI * 2) * 0.01;

    let timeActivityCurrentAngle = timeActivityStartAngle;
    timeActivityData.forEach((segment) => {
        const timeActivitySegmentAngle = (segment.value / 100) * (Math.PI * 2 - timeActivityGapAngle *
            timeActivityData.length);

        timeActivityCtx.beginPath();
        timeActivityCtx.arc(timeActivityCenterX, timeActivityCenterY, timeActivityRadius,
            timeActivityCurrentAngle, timeActivityCurrentAngle + timeActivitySegmentAngle);
        timeActivityCtx.arc(timeActivityCenterX, timeActivityCenterY, timeActivityInnerRadius,
            timeActivityCurrentAngle + timeActivitySegmentAngle, timeActivityCurrentAngle, true);
        timeActivityCtx.closePath();

        timeActivityCtx.fillStyle = segment.color;
        timeActivityCtx.fill();

        timeActivityCurrentAngle += timeActivitySegmentAngle + timeActivityGapAngle;
    });
</script>

<script>
    $(document).ready(function() {
        $("#time-activity-date-range").flatpickr({
            mode: "range"
        });
    })
</script>

