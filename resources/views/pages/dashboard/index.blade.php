@extends('layouts.main')

@section('banner-content')

    <div class="flex items-start flex-col md:flex-row gap-6 justify-between mb-6 md:mb-0 p-6">
        <div class="z-[30]">
            <h2 class="text-4xl text-white text-left font-[400]">Selamat Datang,</h2>
            <h1 class="text-5xl text-white my-6 text-left font-bold">{{ auth()->user()->name }}</h1>
            <div class="px-5 py-2 bg-primary rounded-3xl text-center w-fit text-white font-[600] italic text-xl">
                {{ ucwords(auth()->user()->getRoleNames()->first()) }}
            </div>
        </div>
        <div class="flex flex-col items-end z-50">
            <div class="bg-white flex items-center p-3 gap-5 rounded-md">
                <img class="w-10 h-auto" src="{{ asset('/assets/icons/material-symbols_date-range.svg') }}" alt="calendar">
                <div>
                    <p class="text-lightGrey text-sm font-bold">Hari Ini</p>
                    <p class="text-black text-sms font-bold">{{formatTanggalIndonesia()}}</p>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('dashboard-content')

    <main class="w-full p-6">
        <div class="flex flex-col md:flex-row w-full gap-5 ">
            <x-pages.dashboard.total-card :title="'Total Report'" :total="7.432" :trendValue="56" :date="'03 November 2024'" />
            <x-pages.dashboard.total-card :title="'Total Sales'" :total="$user['total']" :date="$user['date']" />
            <x-pages.dashboard.total-card :title="'Total Routing'" :total="$routes['total']" :date="$routes['date']" />
            <x-pages.dashboard.total-card :title="'Total Visibility Activity'" :total="$visibility_activity['total']" :trendValue="-2" :date="$visibility_activity['date']" />
        </div>
        <div class="flex flex-wrap xl:flex-nowrap gap-6 w-full mt-6">
            <x-pages.dashboard.chart-routing />
            <x-pages.dashboard.chart-time-activity />
            <x-pages.dashboard.chart-product-knowledge />

        </div>
        <div class="bg-[#1a1a1a] rounded-xl shadow-md p-4 mt-6">
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
                                <label
                                    class="btn flex-1 py-2 px-4 rounded-md text-center cursor-pointer transition-all duration-200 bg-[#0288d1] text-white hover:bg-[#0277bd]"
                                    for="btnStock">
                                    Stock On-Hand
                                </label>
                                <input type="radio" class="hidden" name="frame" value="true" id="btnVisibility">
                                <label
                                    class="btn flex-1 py-2 px-4 rounded-md text-center cursor-pointer transition-all duration-200 bg-[#333] text-white hover:bg-[#444]"
                                    for="btnVisibility">
                                    Visibility
                                </label>
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

        .highcharts-title,
        .highcharts-subtitle,
        .highcharts-label text,
        .highcharts-axis-labels text {
            fill: #ffffff;
        }

        .highcharts-button-box {
            fill: #333333;
        }

        /* Map Container Styles */
        #maps-chart-stock,
        #maps-chart-visibility {
            min-height: 600px;
            width: 100%;
            position: relative;
        }

        /* Custom Marker Styles */
        .map-marker {
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .map-marker:hover {
            transform: scale(1.2);
        }

        .marker-label {
            pointer-events: none;
            text-shadow: 2px 2px 2px rgba(0, 0, 0, 0.5);
        }

        .custom-tooltip {
            background-color: rgba(0, 0, 0, 0.9);
            border-radius: 8px;
            padding: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        /* Responsive Styles */
        @media (max-width: 768px) {

            #maps-chart-stock,
            #maps-chart-visibility {
                min-height: 400px;
            }
        }

        #custom-map-tooltip {
            transition: opacity 0.2s ease;
            opacity: 1;
        }

        #custom-map-tooltip.hiding {
            opacity: 0;
        }

        /* Add if you want a fade effect when showing/hiding */
        @keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        #custom-map-tooltip {
            animation: fadeIn 0.2s ease;
        }
    </style>
@endpush

@push('scripts')
    {{-- Highcharts Libraries --}}
    <script src="https://code.highcharts.com/maps/highmaps.js"></script>
    <script src="https://code.highcharts.com/maps/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/maps/modules/offline-exporting.js"></script>

    <script>
        // Data definitions
        const dataStock = {!!$stock!!}
        

        const dataVisibility = {!!$count!!}

        // Marker Data
        const markerData = {
            'id-pa': {
                markers: [{
                    lat: -2.5916,
                    long: 140.6690,
                    name: 'Jayapura',
                    details: {
                        stock: 1650,
                        lastUpdate: '2024-11-15',
                        address: 'Jl. Sam Ratulangi No.15',
                        contact: '+62 967 533111'
                    }
                }, {
                    lat: -3.3685,
                    long: 135.4954,
                    name: 'Nabire',
                    details: {
                        stock: 890,
                        lastUpdate: '2024-11-15',
                        address: 'Jl. Merdeka No.28',
                        contact: '+62 984 221234'
                    }
                }]
            },
            'id-ib': {
                markers: [{
                    lat: -0.8615,
                    long: 134.0620,
                    name: 'Manokwari',
                    details: {
                        stock: 1200,
                        lastUpdate: '2024-11-15',
                        address: 'Jl. Trikora No.32',
                        contact: '+62 986 211555'
                    }
                }, {
                    lat: -0.7833,
                    long: 131.2500,
                    name: 'Sorong',
                    details: {
                        stock: 980,
                        lastUpdate: '2024-11-15',
                        address: 'Jl. Ahmad Yani No.17',
                        contact: '+62 951 321888'
                    }
                }]
            },
            'id-go': {
                markers: [{
                    lat: 0.5412,
                    long: 123.0595,
                    name: 'Gorontalo City',
                    details: {
                        stock: 1250,
                        lastUpdate: '2024-11-15',
                        address: 'Jl. Jaksa Agung Suprapto No.10',
                        contact: '+62 435 821777'
                    }
                }]
            },
            'id-se': {
                markers: [{
                    lat: -5.1477,
                    long: 119.4327,
                    name: 'Makassar',
                    details: {
                        stock: 2300,
                        lastUpdate: '2024-11-15',
                        address: 'Jl. Perintis Kemerdekaan No.15',
                        contact: '+62 411 584777'
                    }
                }, {
                    lat: -3.9789,
                    long: 119.7594,
                    name: 'Palopo',
                    details: {
                        stock: 1100,
                        lastUpdate: '2024-11-15',
                        address: 'Jl. Andi Djemma No.8',
                        contact: '+62 471 326555'
                    }
                }]
            }
        };

        // Map Toggle Setup
        function setupMapToggle() {
            const stockMap = document.getElementById("maps-chart-stock");
            const visibilityMap = document.getElementById("maps-chart-visibility");
            visibilityMap.style.display = "none";

            document.getElementById("btnStock").addEventListener("change", function() {
                if (this.checked) {
                    stockMap.style.display = "block";
                    visibilityMap.style.display = "none";
                    document.querySelector('label[for="btnStock"]').classList.add('bg-[#0288d1]');
                    document.querySelector('label[for="btnStock"]').classList.remove('bg-[#333]');
                    document.querySelector('label[for="btnVisibility"]').classList.add('bg-[#333]');
                    document.querySelector('label[for="btnVisibility"]').classList.remove('bg-[#0288d1]');
                }
            });

            document.getElementById("btnVisibility").addEventListener("change", function() {
                if (this.checked) {
                    stockMap.style.display = "none";
                    visibilityMap.style.display = "block";
                    document.querySelector('label[for="btnVisibility"]').classList.add('bg-[#0288d1]');
                    document.querySelector('label[for="btnVisibility"]').classList.remove('bg-[#333]');
                    document.querySelector('label[for="btnStock"]').classList.add('bg-[#333]');
                    document.querySelector('label[for="btnStock"]').classList.remove('bg-[#0288d1]');
                }
            });
        }

        // Function to add markers with fixed tooltip functionality
        function addMarkers(chart, regionCode) {
            if (chart.markerGroup) {
                chart.markerGroup.destroy();
            }

            // Create custom tooltip container if it doesn't exist
            let tooltipContainer = document.getElementById('custom-map-tooltip');
            if (!tooltipContainer) {
                tooltipContainer = document.createElement('div');
                tooltipContainer.id = 'custom-map-tooltip';
                tooltipContainer.style.cssText = `
            position: absolute;
            display: none;
            background: rgba(0, 0, 0, 0.9);
            color: #fff;
            padding: 12px;
            border-radius: 8px;
            font-size: 13px;
            z-index: 99999;
            pointer-events: none;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            max-width: 300px;
            min-width: 200px;
        `;
                document.body.appendChild(tooltipContainer);
            }

            chart.markerGroup = chart.renderer.g('markers')
                .attr({
                    'zIndex': 9999
                })
                .add();

            if (markerData[regionCode]) {
                markerData[regionCode].markers.forEach(marker => {
                    const point = chart.mapView.lonLatToPixels({
                        lon: marker.long,
                        lat: marker.lat
                    });

                    if (point) {
                        // Add visible marker circle
                        const markerElement = chart.renderer.circle(
                                point.x,
                                point.y,
                                6
                            )
                            .attr({
                                'fill': '#FF4136',
                                'stroke': '#FFFFFF',
                                'stroke-width': 2,
                                'zIndex': 10000
                            })
                            .css({
                                'cursor': 'pointer'
                            })
                            .add(chart.markerGroup);

                        // Add marker label
                        const labelElement = chart.renderer.text(
                                marker.name,
                                point.x + 10,
                                point.y + 4
                            )
                            .attr({
                                'zIndex': 10000
                            })
                            .css({
                                'fontSize': '12px',
                                'fontWeight': 'bold',
                                'fill': '#FFFFFF',
                                'textOutline': '2px #000000'
                            })
                            .add(chart.markerGroup);

                        function positionTooltip() {
                            const chartRect = chart.container.getBoundingClientRect();
                            const tooltipRect = tooltipContainer.getBoundingClientRect();
                            const viewportWidth = window.innerWidth;
                            const viewportHeight = window.innerHeight;

                            // Default position (right of marker)
                            let xPosition = chartRect.left + point.x + 15;
                            let yPosition = chartRect.top + point.y - (tooltipRect.height / 2);

                            // Check right edge
                            if (xPosition + tooltipRect.width > viewportWidth - 10) {
                                // Place tooltip to the left of the marker
                                xPosition = chartRect.left + point.x - tooltipRect.width - 15;
                            }

                            // Check bottom edge
                            if (yPosition + tooltipRect.height > viewportHeight - 10) {
                                yPosition = viewportHeight - tooltipRect.height - 10;
                            }

                            // Check top edge
                            if (yPosition < 10) {
                                yPosition = 10;
                            }

                            // Check left edge
                            if (xPosition < 10) {
                                xPosition = 10;
                            }

                            tooltipContainer.style.left = `${xPosition}px`;
                            tooltipContainer.style.top = `${yPosition}px`;
                        }

                        markerElement
                            .on('mouseenter', function(e) {
                                // Animate marker
                                this.animate({
                                    r: 8,
                                    fill: '#FF725C'
                                }, {
                                    duration: 200
                                });

                                // Update tooltip content
                                tooltipContainer.innerHTML = `
                            <div class="custom-tooltip">
                                <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px; color: #FF725C;">
                                    ${marker.name}
                                </h3>
                                <div style="margin-bottom: 8px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 8px;">
                                    <div style="margin-bottom: 4px;">
                                        <strong style="color: #FF725C;">Stock:</strong>
                                        <span style="float: right;">${marker.details.stock.toLocaleString()}</span>
                                    </div>
                                    <div style="margin-bottom: 4px;">
                                        <strong style="color: #FF725C;">Last Update:</strong>
                                        <span style="float: right;">${marker.details.lastUpdate}</span>
                                    </div>
                                </div>
                                <div style="margin-bottom: 4px;">
                                    <strong style="color: #FF725C;">Address:</strong><br>
                                    ${marker.details.address}
                                </div>
                                <div style="margin-top: 8px;">
                                    <strong style="color: #FF725C;">Contact:</strong><br>
                                    ${marker.details.contact}
                                </div>
                            </div>
                        `;

                                // Show tooltip
                                tooltipContainer.style.display = 'block';

                                // Position tooltip after content is set
                                setTimeout(positionTooltip, 0);
                            })
                            .on('mouseleave', function() {
                                // Animate marker back
                                this.animate({
                                    r: 6,
                                    fill: '#FF4136'
                                }, {
                                    duration: 200
                                });

                                // Hide tooltip
                                tooltipContainer.style.display = 'none';
                            });

                        // Update tooltip position on chart pan/zoom
                        chart.container.addEventListener('mousemove', () => {
                            if (tooltipContainer.style.display === 'block') {
                                positionTooltip();
                            }
                        });

                        // Handle window resize
                        window.addEventListener('resize', () => {
                            if (tooltipContainer.style.display === 'block') {
                                positionTooltip();
                            }
                        });
                    }
                });
            }
        }

        // Function to create map
        function createMap(containerId, data, title) {
            const chart = Highcharts.mapChart(containerId, {
                chart: {
                    map: topology,
                    backgroundColor: '#1a1a1a',
                    height: 600,
                    events: {
                        destroy: function() {
                            // Clean up custom tooltip when chart is destroyed
                            const tooltip = document.getElementById('custom-map-tooltip');
                            if (tooltip) {
                                tooltip.remove();
                            }
                        }
                    }
                },
                title: {
                    text: ''
                },
                mapView: {
                    projection: {
                        name: 'WebMercator'
                    },
                    center: [118, -2],
                    zoom: 5
                },
                mapNavigation: {
                    enabled: true,
                    buttonOptions: {
                        verticalAlign: 'bottom',
                        theme: {
                            fill: '#333',
                            'stroke-width': 1,
                            stroke: '#666',
                            style: {
                                color: '#ffffff'
                            }
                        }
                    }
                },
                colorAxis: {
                    min: 0,
                    minColor: '#E0EFF9',
                    maxColor: '#0288d1'
                },
                tooltip: {
                    enabled: false // Disable default tooltip
                },
                series: [{
                    data: data,
                    name: title,
                    states: {
                        hover: {
                            color: '#0288d1'
                        },
                        select: {
                            color: '#02579B'
                        }
                    },
                    dataLabels: {
                        enabled: false
                    },
                    events: {
                        click: function(e) {
                            if (e.point) {
                                const regionCode = e.point.properties['hc-key'];
                                console.log('Clicked region:', regionCode);

                                // Deselect previous
                                if (this.chart.selectedPoint && this.chart.selectedPoint !== e.point) {
                                    this.chart.selectedPoint.select(false);
                                }

                                // Select current
                                e.point.select(true);
                                this.chart.selectedPoint = e.point;

                                // Add markers
                                addMarkers(this.chart, regionCode);
                            }
                        }
                    }
                }]
            });

            chart.container.addEventListener('mousemove', () => {
                const tooltip = document.getElementById('custom-map-tooltip');
                if (tooltip && tooltip.style.display === 'block') {
                    // Trigger mouseenter on active marker to update position
                    const activeMarker = chart.markerGroup?.element.querySelector('circle[fill="#FF725C"]');
                    if (activeMarker) {
                        activeMarker.dispatchEvent(new MouseEvent('mouseenter'));
                    }
                }
            });

            return chart;
        }

        // Initialize maps
        // Main initialization
        (async () => {
            try {
                // Load topology first
                const topology = await fetch('https://code.highcharts.com/mapdata/countries/id/id-all.topo.json')
                    .then(response => response.json());

                // Function to create map with topology
                function createMap(containerId, data, title) {
                    return Highcharts.mapChart(containerId, {
                        chart: {
                            map: topology, // Now topology is available here
                            backgroundColor: '#1a1a1a',
                            height: 600,
                            events: {
                                load: function() {
                                    this.markerGroup = this.renderer.g('markers').add();
                                },
                                redraw: function() {
                                    if (this.selectedPoint) {
                                        const regionCode = this.selectedPoint.properties['hc-key'];
                                        addMarkers(this, regionCode);
                                    }
                                }
                            }
                        },
                        // ... rest of your chart options remain the same
                        title: {
                            text: ''
                        },
                        mapView: {
                            projection: {
                                name: 'WebMercator'
                            },
                            center: [118, -2],
                            zoom: 5
                        },
                        mapNavigation: {
                            enabled: true,
                            buttonOptions: {
                                verticalAlign: 'bottom',
                                theme: {
                                    fill: '#333',
                                    'stroke-width': 1,
                                    stroke: '#666',
                                    style: {
                                        color: '#ffffff'
                                    }
                                }
                            }
                        },
                        colorAxis: {
                            min: 0,
                            minColor: '#E0EFF9',
                            maxColor: '#0288d1'
                        },
                        tooltip: {
                            enabled: true,
                            animation: false,
                            backgroundColor: 'rgba(0, 0, 0, 0.9)',
                            borderWidth: 0,
                            borderRadius: 8,
                            shadow: true,
                            padding: 12,
                            hideDelay: 100,
                            followPointer: false,
                            outside: true,
                            formatter: function() {
                                if (this.point.marker) {
                                    const details = this.point.details;
                                    return `
                                <div class="custom-tooltip">
                                    <h3 style="font-size: 16px; font-weight: bold; margin-bottom: 8px; color: #FF725C;">
                                        ${this.point.name}
                                    </h3>
                                    <div style="margin-bottom: 8px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 8px;">
                                        <div style="margin-bottom: 4px;">
                                            <strong style="color: #FF725C;">Stock:</strong>
                                            <span style="float: right;">${details.stock.toLocaleString()}</span>
                                        </div>
                                        <div style="margin-bottom: 4px;">
                                            <strong style="color: #FF725C;">Last Update:</strong>
                                            <span style="float: right;">${details.lastUpdate}</span>
                                        </div>
                                    </div>
                                    <div style="margin-bottom: 4px;">
                                        <strong style="color: #FF725C;">Address:</strong><br>
                                        ${details.address}
                                    </div>
                                    <div style="margin-top: 8px;">
                                        <strong style="color: #FF725C;">Contact:</strong><br>
                                        ${details.contact}
                                    </div>
                                </div>
                            `;
                                }
                                return `${this.point.name}: ${this.point.value}`;
                            },
                            useHTML: true,
                            style: {
                                color: '#ffffff',
                                fontSize: '13px'
                            }
                        },
                        series: [{
                            data: data,
                            name: title,
                            states: {
                                hover: {
                                    color: '#0288d1'
                                },
                                select: {
                                    color: '#02579B'
                                }
                            },
                            dataLabels: {
                                enabled: false
                            },
                            events: {
                                click: function(e) {
                                    if (e.point) {
                                        const regionCode = e.point.properties['hc-key'];
                                        console.log('Clicked region:', regionCode);

                                        // Deselect previous
                                        if (this.chart.selectedPoint && this.chart
                                            .selectedPoint !== e.point) {
                                            this.chart.selectedPoint.select(false);
                                        }

                                        // Select current
                                        e.point.select(true);
                                        this.chart.selectedPoint = e.point;

                                        // Add markers
                                        addMarkers(this.chart, regionCode);
                                    }
                                }
                            }
                        }]
                    });
                }

                // Setup map toggle
                setupMapToggle();

                // Create both maps after topology is loaded
                const stockChart = createMap('maps-chart-stock', dataStock, 'Stock On-Hand');
                const visibilityChart = createMap('maps-chart-visibility', dataVisibility, 'Visibility');

                // Handle window resize
                window.addEventListener('resize', () => {
                    requestAnimationFrame(() => {
                        stockChart.reflow();
                        visibilityChart.reflow();
                    });
                });

                // Handle clicking outside map
                document.addEventListener('click', function(e) {
                    if (!e.target.closest('.highcharts-container')) {
                        [stockChart, visibilityChart].forEach(chart => {
                            if (chart.markerGroup) {
                                chart.markerGroup.destroy();
                                chart.markerGroup = chart.renderer.g('markers').add();
                            }
                            if (chart.selectedPoint) {
                                chart.selectedPoint.select(false);
                                chart.selectedPoint = null;
                            }
                        });
                    }
                });

            } catch (error) {
                console.error('Error initializing maps:', error);
            }
        })();
    </script>
@endpush
