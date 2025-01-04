<div class="w-full chart-bg p-6 rounded-lg">
        <div class="text-center text-xl text-white font-bold mb-6">AVG Visibility Duration</div>
		<div class="filters flex-wrap md:flex-nowrap flex justify-center">
            <x-input.datepicker id="time-activity-date-range" />
            <x-select.light>
                <x-slot:title>Filter Date</x-slot:title>
            </x-select.light>
        </div>


    <div class="chart-container">
        <div class="donut-container">
            <canvas id="timeActivityDonutChart"></canvas>
            <div class="center-number text-white text-2xl font-bold">00:00:00</div>
        </div>

        <div class="legend">
            <div class="legend-item">
                <span>hh:mm:ss</span>
            </div>
        </div>

		<div class="bar-chart">
            <div class="bar-label">Chain Pharmacy</div>
            <div class="bar-row">
                <div class="bar-wrapper">
                    <div class="bar" style="width: 100%"></div>
                </div>
                <div class="bar-value">
                    <div class="percentage">54 m</div>
                </div>
            </div>

            <div class="bar-label">Minimarket</div>
            <div class="bar-row">
                <div class="bar-wrapper">
                    <div class="bar" style="width: 54%"></div>
                </div>
                <div class="bar-value">
                    <div class="percentage">15 m 22 s</div>
                </div>
            </div>

            <div class="bar-label">HFS/GT</div>
            <div class="bar-row">
                <div class="bar-wrapper">
                    <div class="bar" style="width: 54%"></div>
                </div>
                <div class="bar-value">
                    <div class="percentage">21 m 15 s</div>
                </div>
            </div>

            <div class="bar-label">HSM (Hyper Suparmarket)</div>
            <div class="bar-row">
                <div class="bar-wrapper">
                    <div class="bar" style="width: 54%"></div>
                </div>
                <div class="bar-value">
                    <div class="percentage">45 m 25 s</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const timeActivityCanvas = document.getElementById('timeActivityDonutChart');
    const timeActivityCtx = timeActivityCanvas.getContext('2d');

    const timeActivityDpr = 2;
    timeActivityCanvas.width = 160 * timeActivityDpr;
    timeActivityCanvas.height = 160 * timeActivityDpr;
    timeActivityCanvas.style.width = '100%';
    timeActivityCtx.scale(timeActivityDpr, timeActivityDpr);

    const timeActivityData = [{
            value: 45,
            color: '#48CAE4'
        }, 
        {
            value: 15,
            color: '#0095ff'
        }, 
        {
            value: 15,
            color: '#2D40AB'
        }, 
        {
            value: 25,
            color: '#145C81'
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

