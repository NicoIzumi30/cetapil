<div class="w-full chart-bg p-6 rounded-lg">
    
        <div class="text-center text-xl text-white font-bold mb-6">Product Knowledge</div>
        <div class="filters flex justify-center flex-wrap  w-full">
            <x-input.datepicker id="product-date-range" />
            <x-select.light>
                <x-slot:title>Filter Outlet</x-slot:title>
            </x-select.light>
            <x-select.light>
                <x-slot:title>Filter Date</x-slot:title>
            </x-select.light>
        </div>

    <div class="chart-container">
        <div class="donut-container">
            <canvas id="productdonutChart"></canvas>
            <div class="center-number text-4xl font-bold text-white">1040</div>
        </div>

        <div class="legend">
            <div class="legend-item">
                <div class="legend-color" style="background: #8fe1ff;"></div>
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
					<div class="percentage">100%</div>
                    <div class="count">578</div>
                </div>
            </div>
            <div class="bar-row">
                <div class="bar-label">MT</div>
                <div class="bar-wrapper">
                    <div class="bar" style="width: 65%"></div>
                </div>
                <div class="bar-value relative">
					<div class="percentage ">65%</div>
                    <div class="count">625</div>
                </div>
            </div>
        </div>
    </div>
</div>


<script>
    const canvas = document.getElementById('productdonutChart');
    const ctx = canvas.getContext('2d');

    const dpr = window.devicePixelRatio || 1;
    canvas.width = 160 * dpr;
    canvas.height = 160 * dpr;
    canvas.style.width = '100%';
    ctx.scale(dpr, dpr);

    const data = [{
            value: 35,
            color: '#48CAE4'
        }, // Light blue
        {
            value: 35,
            color: '#0095ff'
        }, // Dark blue
        {
            value: 30,
            color: '#49b3ff'
        } // Medium blue
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
