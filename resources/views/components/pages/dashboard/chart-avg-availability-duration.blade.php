<div class="w-full chart-bg p-6 rounded-lg">

    <div class="text-center text-xl text-white font-bold mb-6">AVG Availability Duration</div>
    <div class="filters flex flex-wrap md:flex-nowrap justify-center">
        <x-input.datepicker id="routing-date-range" />
        <x-select.light>
            <x-slot:title>Filter Date</x-slot:title>
        </x-select.light>
    </div>


    <div class="chart-container">
        <div class="donut-container">
            <canvas id="routingDonutChart"></canvas>
            <div id="avg-availability-duration" class="center-number text-white text-2xl font-bold">00:00:00</div>
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
    function InitializeAvailabilityChart(data) {
        const maximumAvgAvailabilityTime = Math.max(data.time_chain_pharmacy, data.time_minimarket, data.time_hfsgt, data.time_hsm);
        let maximumPercentage = maximumAvgAvailabilityTime * 100 / maximumAvgAvailabilityTime
		function getPercentageValue (value) {
			return value * 100 / maximumAvgAvailabilityTime;
		}
		const chainPharmacyTime = getPercentageValue(data.time_chain_pharmacy)  ;
        const minimarketTime = getPercentageValue(data.time_minimarket);
        const hstGtTime = getPercentageValue(data.time_hfsgt);
        const hsmTime = getPercentageValue(data.time_hsm);


		console.log(chainPharmacyTime, minimarketTime, hstGtTime, hsmTime);


        const routingData = [{
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
            },
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
            console.log(avgAvailability);
            $('#avg-availability-duration').text(avgAvailability.time_avg);
            InitializeAvailabilityChart(avgAvailability);
        },
        error: function(xhr) {
            toast('error', xhr.responseJSON.message, 200);
        }
    });


    const routingCanvas = document.getElementById('routingDonutChart');
    const routingCtx = routingCanvas.getContext('2d');

    const routingDpr = 2;
    routingCanvas.width = 160 * routingDpr;
    routingCanvas.height = 160 * routingDpr;
    routingCanvas.style.width = '100%';
    routingCtx.scale(routingDpr, routingDpr);
</script>
