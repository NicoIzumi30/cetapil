<div class="w-full chart-bg p-6 rounded-lg">
    
        <div class="text-center text-xl text-white font-bold mb-6">AVG Survey Duration</div>
        <div class="filters flex justify-center flex-wrap w-full">
            <x-input.datepicker id="product-date-range" />
            <x-select.light>
                <x-slot:title>Filter Date</x-slot:title>
            </x-select.light>
        </div>

    <div class="chart-container">
        <div class="donut-container">
            <canvas id="productdonutChart"></canvas>
            <div class="center-number text-2xl font-bold text-white">00:00:00</div>
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

    const canvas = document.getElementById('productdonutChart');
    const ctx = canvas.getContext('2d');

    const dpr = 2;
    canvas.width = 160 * dpr;
    canvas.height = 160 * dpr;
    canvas.style.width = '100%';
    ctx.scale(dpr, dpr);

    const data = [{
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

    const centerX = 80;
    const centerY = 80;
    const radius = 60;
    const innerRadius = 45;
    const startAngle = -Math.PI / 2;
    const gapAngle = (Math.PI * 2) * 0.01;

    let currentAngle = startAngle;
    data.forEach((segment, index) => {
        const segmentAngle = (segment.value / 100) * (Math.PI * 2 - gapAngle * data.length);

        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + segmentAngle);
        ctx.arc(centerX, centerY, innerRadius, currentAngle + segmentAngle, currentAngle, true);
        ctx.closePath();

        ctx.fillStyle = segment.color;
        ctx.fill();

        currentAngle += segmentAngle + gapAngle;
    });
</script>


<script>
    $(document).ready(function() {
        $("#product-date-range").flatpickr({
            mode: "range"
        });
    })
</script>
