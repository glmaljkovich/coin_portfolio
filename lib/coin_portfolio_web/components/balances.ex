defmodule BalancesComponent do
  use Phoenix.LiveComponent
  import CoinPortfolio.Utils.TransactionUtils
  import Phoenix.HTML

  def render(assigns) do
    ~L"""
    <div class="ui p-0 segment mb-1">
      <div id="balance"></div>
      <script id="balancescript">
      function initChart() {
        var dates = JSON.parse('<%= raw balance_history_to_chart_data(@balance_history) %>')
        var formatter = new Intl.NumberFormat('en-US', {
          style: 'currency',
          currency: "<%= @current_user.main_currency %>",
          currencyDisplay: 'narrowSymbol',
          minimumFractionDigits: 0
        });

        var options = {
          series: [{
            name: 'Balance',
            data: dates
          }],
          chart: {
            type: 'area',
            stacked: false,
            height: 350,
            zoom: {
              type: 'x',
              enabled: true,
              autoScaleYaxis: true
            },
            toolbar: {
              autoSelected: 'zoom'
            }
          },
          dataLabels: {
            enabled: false
          },
          markers: {
            size: 0,
          },
          fill: {
            type: 'gradient',
            gradient: {
              shadeIntensity: 1,
              inverseColors: false,
              opacityFrom: 0.5,
              opacityTo: 0,
              stops: [0, 90, 100]
            },
          },
          yaxis: {
            labels: {
              formatter: function (val) {
                return formatter.format(val);
              },
            },
            title: {
              text: 'Holdings (<%= @current_user.main_currency %>)'
            }
          },
          xaxis: {
            type: 'datetime',
            title: {
              text: 'Time'
            },
          },
          tooltip: {
            shared: false,
            y: {
              formatter: function (val) {
                return "<%= @current_user.main_currency %> " + formatter.format(val)
              }
            }
          }
        };
        var chart = new ApexCharts(document.querySelector("#balance"), options);
        chart.render();
      }
      $('body').on('DOMSubtreeModified', '#balancescript', () => {
        initChart();
      });
      </script>
    </div>
    """
  end
end
