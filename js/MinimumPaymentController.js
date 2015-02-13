var calculatorApp = angular.module('CalculatorApplication', []);

calculatorApp.controller('MinimumPaymentController', ['$scope', function ($scope) {

    var calc = new MinimumPaymentCalculator();

    $scope.calculate = function () {

        //Retrieve the variables from the view...give them default values in cause the user hits calculate.
        var principal = $scope.current_balance ? $scope.current_balance : 0.00;
        var apr = $scope.interest_rate ? $scope.interest_rate : 0.0;
        var minPercPay = $scope.percentage_of_balance ? $scope.percentage_of_balance : 0.0;
        var minAmtPay = $scope.minimum_dollar_amount ? $scope.minimum_dollar_amount : 0.00;

        calc.setPrincipal(principal);
        calc.setApr(apr);
        calc.setMinimumPercentageToPay(minPercPay);
        calc.setMinimumDollarAmountToPay(minAmtPay);
        //Build the table, principal, and interest data for the charts and tables.
        calc.calculateDataPoints();

        $scope.principal = toCurrency(calc.getPrincipal());
        $scope.apr = toPercentage(calc.getApr());
        $scope.interest = toCurrency(calc.getTotalInterest());
        $scope.months = calc.getMonthsToPayoff();
        $scope.minimum = toCurrency(calc.calculateMinimumPayment());

        //Get the table data array.
        $scope.tableData = calc.getTableData();
        $scope.principalData = calc.getPrincipalData();
        $scope.interestData = calc.getInterestData();

        $scope.displayChart();
        $scope.showTabs = true;
    }

    $scope.displayChart = function () {
        $('#high_chart').highcharts({
            chart: {},
            title: {
                text: 'Interest Paid',
                x: -20 //center

            },
            plotOptions: {
                line: {
                    dataLabels: {
                        enabled: false
                    }
                }
            },
            xAxis: {
                title: {
                    text: '<strong>Months</strong>',
                    X: -20
                }
            },
            yAxis: {
                title: {
                    text: '<strong>Total Principal and Interest ($)</strong>'
                }
            },
            tooltip: {
                formatter: function () {
                    return '<strong>Month:</strong> ' + (this.x + 1) +
                        '<br/><strong>' + this.series.name + ':</strong> $' + this.y;
                }
            },
            series: [{
                name: 'Balance',
                data: $scope.principalData
            }, {
                name: 'Interest',
                data: $scope.interestData
            }]
        });
    }
}]);