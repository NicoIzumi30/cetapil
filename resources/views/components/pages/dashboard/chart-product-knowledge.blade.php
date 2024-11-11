<div class="col-4">
    <div class="card">
        <div class="card-body">
            <div class="row d-flex justify-content-evenly">
                <div class="col-10 my-2">
                    <div class="datepicker">
                        <button class="btn btn-primary w-100 text-nowrap overflow-x-auto" id="triggerDateRangeProduct">
                            {{ !empty($dateRangeProduct) ? $dateRangeProduct : "Date Range" }}
                        </button>
                        <div class="input-group">
                            <input id="dateRangeProduct" wire:model.blur="dateRangeProduct" class="form-control visually-hidden" value="" type="text" />
                        </div>
                    </div>
                </div>
                <div class="col-10 my-2" wire:ignore>
                    <select id="area_product" name="area_product" wire:model.change="area_product" class="form-select text-nowrap overflow-x-auto">
                        <option value="" data-placeholder="true">
                            Area
                        </option>
                        @foreach ($areas as $option)
                            <option value="{{ $option['id'] }}">
                                {{ $option['name'] }}
                            </option>
                        @endforeach
                    </select>
                </div>
                <div class="col-10 my-2" wire:ignore>
                    <select id="user_product" name="user_product" wire:model.change="user_product" class="form-select text-nowrap overflow-x-auto">
                        <option value="" data-placeholder="true">
                            Sales
                        </option>
                        @foreach ($sales as $option)
                            <option value="{{ $option['id'] }}">
                                {{ $option['name'] }}
                            </option>
                        @endforeach
                    </select>
                </div>
            </div>
            <div class="d-flex justify-content-center" wire:ignore>
                <div id="product_knowledge" style="width: 60%; height: 300px;"></div>
            </div>

            <div class="detail mt-3">
                <div class="title text-center">
                    <h5 class="text-info">Product Knowledge</h5>
                </div>

                <div class="row align-items-center">
                    <div class="col-2 pe-0 me-0">
                        <span class="fw-bold">GT</span>
                    </div>
                    <div class="col ms-0 ps-0">
                        <div class="progress my-3" role="progressbar" aria-label="Basic example" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">
                            <div class="progress-bar bg-info" style="width: {{ $productKnowledge['gt_percentage'] ?? 0 }}%">
                                {{ $productKnowledge['gt_percentage'] ?? 0 }}%
                            </div>
                        </div>
                    </div>
                    <div class="col-2">
                        {{ $productKnowledge['total_gt'] ?? 0 }}
                    </div>
                </div>
                <div class="row align-items-center mb-5">
                    <div class="col-2 pe-0 me-0">
                        <span class="fw-bold">MT</span>
                    </div>
                    <div class="col ms-0 ps-0">
                        <div class="progress" role="progressbar" aria-label="Basic example" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100">
                            <div class="progress-bar bg-info" style="width: {{ $productKnowledge['mt_percentage'] ?? 0 }}%">
                                {{ $productKnowledge['mt_percentage'] ?? 0 }}%
                            </div>
                        </div>
                    </div>
                    <div class="col-2">
                        {{ $productKnowledge['total_mt'] ?? 0 }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@push('addon-script')
    <script>
		
        let rootProduct = am5.Root.new("product_knowledge");

        rootProduct.setThemes([
            am5themes_Animated.new(rootProduct)
        ]);

        let chartProduct = rootProduct.container.children.push(
            am5percent.PieChart.new(rootProduct, {
                radius: am5.percent(90),
            })
        );

        // Create series
        let seriesProduct = chartProduct.series.push(
            am5percent.PieSeries.new(rootProduct, {
                name: "Series",
                valueField: "percentage",
                categoryField: "percent",
                alignLabels: false,
            })
        );

        seriesProduct.slices.template.setAll({
            fill: am5.color("#D0EDFF")
        });

        seriesProduct.data.setAll([{
            percent: "{{ $productKnowledge['total_data'] ?? 0 }}",
            percentage: 100,
        }]);

        seriesProduct.labels.template.setAll({
            fontSize: 24,
            text: "{{ $productKnowledge['total_data'] ?? 0 }}",
            inside: true,
            radius: am5.p100, // Set to 100% of the radius
            centerX: am5.p100, // Set to 100% of the radius
            centerY: am5.p100, // Set to 100% of the radius
            textAlign: "center",
            fontWeight: "bold",
            fill: am5.color('#3C3C3C')
        });

        series.ticks.template.set("visible", false);

        let seriesProduct2 = chartProduct.series.push(
            am5percent.PieSeries.new(rootProduct, {
                name: "Series",
                valueField: "value",
                categoryField: "key",
            })
        );

        seriesProduct2.get("colors").set("colors", [
            am5.color('#39B5FF'),
            am5.color('#008CE0'),
        ]);

        seriesProduct2.data.setAll([{
            key: "Target Views",
            value: {{ $productKnowledge['target_views'] ?? 0 }},
        }, {
            key: "Total Views",
            value: {{ $productKnowledge['total_views'] ?? 0 }},
        }]);

        // Configuring slices
        seriesProduct2.slices.template.setAll({
            stroke: am5.color(0xffffff),
            strokeWidth: 4,
        })

        // Disabling labels and ticks
        seriesProduct2.labels.template.set("visible", false);
        seriesProduct2.ticks.template.set("visible", false);
    </script>
@endpush


<script type="module">
    var showing = false;
    var dateRangeProduct = $("#dateRangeProduct");

    $('#triggerDateRangeProduct').on('click', function() {
        console.log(showing);
        if (!showing) {
            dateRangeProduct.click();
        }
    });

    dateRangeProduct.daterangepicker({
        opens: 'bottom',
        locale: {
            format: 'YYYY-MM-DD',
        },
    }, function(start, end) {
        @this.set('dateRangeProduct', start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD'));
    });

    dateRangeProduct.on('show.daterangepicker', function (e) {
        showing = true;
    });

    dateRangeProduct.on('hide.daterangepicker', function (e) {
        showing = false;
    });

    Livewire.on("event-data-product", ({ data }) => {
        console.log(data)
        let target_views = 0;
        if ("target_views" in data) {
            target_views = data.target_views;
        }

        let total_views = 0;
        if ("total_views" in data) {
            total_views = data.total_views;
        }

        seriesProduct2.data.setAll([{
            key: "Target Views",
            value: target_views,
        }, {
            key: "Total Views",
            value: total_views,
        }]);

        let total_data = 0;
        if("total_data" in data) {
            total_data = data.total_data;
        }

        seriesProduct.data.setAll([{
            percent: total_data,
            percentage: 100,
        }]);

        seriesProduct.labels.template.setAll({
            fontSize: 24,
            text: `${total_data}`,
            inside: true,
            radius: am5.p100, // Set to 100% of the radius
            centerX: am5.p100, // Set to 100% of the radius
            centerY: am5.p100, // Set to 100% of the radius
            textAlign: "center",
            fontWeight: "bold",
            fill: am5.color('#3C3C3C')
        });
    })
</script>
