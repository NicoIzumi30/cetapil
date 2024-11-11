<div>
    <div id="canvas" class="w-full h-96"></div>
</div>

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var options = {
            chart: {
                type: 'line',
                height: 350,
                toolbar: {
                    show: true
                },
                zoom: {
                    enabled: true
                }
            },
            series: [{
                name: 'sales',
                data: 'sdasd'
            }],
            xaxis: {
                categories: 'sadasda'
            },
            stroke: {
                curve: 'smooth'
            },
            title: {
                text: 'baseng',
                align: 'left'
            },
            grid: {
                row: {
                    colors: ['#f3f3f3', 'transparent'],
                    opacity: 0.5
                },
            }
        };

        var chart = new ApexCharts(document.querySelector("#canvas"), options);
        chart.render();
    });
</script>
@endpush