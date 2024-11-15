@extends('layouts.main')

@section('banner-content')
    <div class="flex items-start justify-between mb-6 p-6">
		<div class="z-[30]">
			<h2 class="text-4xl text-white text-left font-[400]">Selamat Datang,</h2>
			<h1 class="text-5xl text-white my-6 text-left font-bold">Andromeda Phytagoras Silalahi</h1>
			<div class="px-5 py-2 bg-primary rounded-3xl text-center w-fit text-white font-[600] italic text-xl">
				Superadmin
			</div>
		</div>
		<div class="flex flex-col items-end z-50">
			<div class="bg-white flex items-center p-3 gap-5 rounded-md">
				<img class="w-10 h-auto" src="{{ asset('/assets/icons/material-symbols_date-range.svg') }}" alt="calendar">
				<div>
					<p class="text-lightGrey text-sm font-bold">Hari Ini</p>
					<p class="text-black text-sms font-bold">Senin, 10 November 2024</p>
				</div>
			</div>

		</div>
	</div>
@endsection

@section('dashboard-content')
    <main class="w-full">
		<div class="flex w-full gap-5 p-6">
			<x-pages.dashboard.total-card :title="'Total Report'" :total="7.432"/>
			<x-pages.dashboard.total-card :title="'Total Sales'" :total="7.432"/>
			<x-pages.dashboard.total-card :title="'Total Routing'" :total="7.432"/>
			<x-pages.dashboard.total-card :title="'Total Visibility'" :total="7.432"/>
		</div>
		<div class="p-6">
            <div class="bg-[#1a1a1a] rounded-xl shadow-md p-4">
                <div class="col-12" id="map">
                    {{-- Stock On-Hand Map --}}
                    <div id="maps-chart-stock" style="height: 600px"></div>
                    {{-- Visibility Map --}}
                    <div id="maps-chart-visibility" style="height: 600px"></div>
                    {{-- Map Controls --}}
                    <div id="mapsTextRight" class="mt-4">
                        <div class="filter">
                            <div id="frameHidden">
                                <div class="btn-group w-100 flex gap-2" role="group" aria-label="Map toggle">
                                    <input type="radio" class="hidden" name="frame" value="false" id="btnStock" checked>
                                    <label class="btn flex-1 py-2 px-4 rounded-md text-center cursor-pointer transition-all duration-200 bg-[#0288d1] text-white hover:bg-[#0277bd]" for="btnStock">
                                        Stock On-Hand
                                    </label>
                                    <input type="radio" class="hidden" name="frame" value="true" id="btnVisibility">
                                    <label class="btn flex-1 py-2 px-4 rounded-md text-center cursor-pointer transition-all duration-200 bg-[#333] text-white hover:bg-[#444]" for="btnVisibility">
                                        Visibility
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</main>
@endsection


@push('styles')
<style>
    /* Highcharts Custom Styles */
    .highcharts-background {
        fill: #1a1a1a;
    }
    .highcharts-credits {
        display: none;
    }
    .highcharts-title {
        fill: #ffffff;
    }
    .highcharts-subtitle {
        fill: #ffffff;
    }
    .highcharts-label text {
        fill: #ffffff;
    }
    .highcharts-axis-labels text {
        fill: #ffffff;
    }
    .highcharts-button-box {
        fill: #333333;
    }

    /* Map Container Styles */
    #maps-chart-stock, #maps-chart-visibility {
        min-height: 600px;
        width: 100%;
        position: relative;
    }

    /* Responsive Styles */
    @media (max-width: 768px) {
        #maps-chart-stock, #maps-chart-visibility {
            min-height: 400px;
        }
    }

    @media (min-width: 1024px) {
        #maps-chart-stock, #maps-chart-visibility {
            min-height: 600px;
        }
    }
</style>
@endpush

@push('scripts')
{{-- Highcharts Libraries --}}
<script src="https://code.highcharts.com/maps/highmaps.js"></script>
<script src="https://code.highcharts.com/maps/modules/exporting.js"></script>
<script src="https://code.highcharts.com/maps/modules/offline-exporting.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>

<script>
    // Toggle functionality between maps
    document.addEventListener("DOMContentLoaded", function() {
        var stockOnHand = document.getElementById("maps-chart-stock");
        var visibility = document.getElementById("maps-chart-visibility");
        var stockLabel = document.querySelector('label[for="btnStock"]');
        var visibilityLabel = document.querySelector('label[for="btnVisibility"]');

        visibility.style.display = "none";

        var radioStock = document.getElementById("btnStock");
        var radioVisibility = document.getElementById("btnVisibility");

        radioStock.addEventListener("change", function() {
            if (radioStock.checked) {
                stockOnHand.style.display = "block";
                visibility.style.display = "none";
                stockLabel.classList.add('bg-[#0288d1]');
                stockLabel.classList.remove('bg-[#333]');
                visibilityLabel.classList.add('bg-[#333]');
                visibilityLabel.classList.remove('bg-[#0288d1]');
            }
        });

        radioVisibility.addEventListener("change", function() {
            if (radioVisibility.checked) {
                stockOnHand.style.display = "none";
                visibility.style.display = "block";
                visibilityLabel.classList.add('bg-[#0288d1]');
                visibilityLabel.classList.remove('bg-[#333]');
                stockLabel.classList.add('bg-[#333]');
                stockLabel.classList.remove('bg-[#0288d1]');
            }
        });
    });

    // Map initialization
    (async () => {
        const topology = await fetch(
            'https://code.highcharts.com/mapdata/countries/id/id-all.topo.json'
        ).then(response => response.json());

        // Common chart options
        const commonOptions = {
            chart: {
                map: topology,
                backgroundColor: '#1a1a1a',
                height: 600,
                style: {
                    fontFamily: 'Arial, sans-serif'
                }
            },
            title: {
                text: '',
                style: {
                    color: '#ffffff'
                }
            },
            mapNavigation: {
                enabled: true,
                buttonOptions: {
                    verticalAlign: 'bottom',
                    theme: {
                        fill: '#333',
                        'stroke-width': 1,
                        stroke: '#666',
                        r: 0,
                        states: {
                            hover: {
                                fill: '#444'
                            },
                            select: {
                                fill: '#444'
                            }
                        },
                        style: {
                            color: '#ffffff'
                        }
                    }
                }
            },
            colorAxis: {
                min: 0,
                minColor: '#E0EFF9',
                maxColor: '#0288d1',
                labels: {
                    style: {
                        color: '#ffffff'
                    }
                }
            },
            tooltip: {
                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                style: {
                    color: '#ffffff'
                },
                borderWidth: 0,
                borderRadius: 8,
                shadow: true,
                padding: 12
            }
        };

        // Stock On-Hand Map
        const dataStock = {!! json_encode($dataChartStock) !!};
        Highcharts.mapChart('maps-chart-stock', {
            ...commonOptions,
            series: [{
                data: dataStock,
                name: 'Stock On-Hand',
                states: {
                    hover: {
                        color: '#0288d1'
                    }
                },
                dataLabels: {
                    enabled: false
                },
                tooltip: {
                    pointFormat: '{point.name}: {point.value}'
                }
            }]
        });

        // Visibility Map
        const dataVisibility = {!! json_encode($dataChartVisibility) !!};
        Highcharts.mapChart('maps-chart-visibility', {
            ...commonOptions,
            series: [{
                data: dataVisibility,
                name: 'Visibility',
                states: {
                    hover: {
                        color: '#0288d1'
                    }
                },
                dataLabels: {
                    enabled: false
                },
                tooltip: {
                    pointFormat: '{point.name}: {point.value}%'
                }
            }]
        });
    })();
</script>
@endpush
