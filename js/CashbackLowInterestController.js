var calculatorApp = angular.module('CalculatorApplication', []);

calculatorApp.directive('selectOnClick', function () {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            element.on('click', function () {
                this.select();
            });
        }
    };
});

calculatorApp.controller('CashbackLowInterestController', ['$scope', '$sce', function ($scope, $sce) {

    var calc = new CashbackLowInterestCalculator();

    $scope.principal = 3000.00;
    $scope.years = 3;
    $scope.charges = 350.00;
    $scope.payment = 450.00;

    $scope.cash_back_rate = 0.0;
    $scope.low_interest_rate = 0.0;

    $scope.cash_back_term = 12;
    $scope.low_interest_term = 12;

    $scope.cash_back_regular_rate = 12.0;
    $scope.low_interest_regular_rate = 9.0;

    $scope.cash_back_annual_fee = 25.00;
    $scope.low_interest_annual_fee = 0.00;

    $scope.cashback_percent_regular = 1.0;
    $scope.cashback_percent_specific = 3.0;
    $scope.cashback_specific_reward = 50.00;

    $scope.calculate = function () {

        //Retrieve the variables from the view...give them default values in case the user hits calculate.
        var principal = $scope.principal ? $scope.principal : 0.00;
        var years = $scope.years ? $scope.years : 0;
        var charges = $scope.charges ? $scope.charges : 0.00;
        var payment = $scope.payment ? $scope.payment : 0.00;
        var cash_back_rate = $scope.cash_back_rate ? $scope.cash_back_rate : 0.0;
        var low_interest_rate = $scope.low_interest_rate ? $scope.low_interest_rate : 0.0;
        var cash_back_term = $scope.cash_back_term ? $scope.cash_back_term : 0;
        var low_interest_term = $scope.low_interest_term ? $scope.low_interest_term : 0;
        var cash_back_regular_rate = $scope.cash_back_regular_rate ? $scope.cash_back_regular_rate : 0.0;
        var low_interest_regular_rate = $scope.low_interest_regular_rate ? $scope.low_interest_regular_rate : 0.0;
        var cash_back_annual_fee = $scope.cash_back_annual_fee ? $scope.cash_back_annual_fee : 0.00;
        var low_interest_annual_fee = $scope.low_interest_annual_fee ? $scope.low_interest_annual_fee : 0.00;
        var cashback_percent_regular = $scope.cashback_percent_regular ? $scope.cashback_percent_regular : 0.0;
        var cashback_percent_specific = $scope.cashback_percent_specific ? $scope.cashback_percent_specific : 0.0;
        var cashback_specific_reward = $scope.cashback_specific_reward ? $scope.cashback_specific_reward : 0.00;

        calc.setPrincipal(principal);
        calc.setYears(years);
        calc.setMonthlyCharges(charges);
        calc.setMonthlyPayment(payment);
        calc.setCardOneIntroApr(cash_back_rate);
        calc.setCardTwoIntroApr(low_interest_rate);
        calc.setCardOneIntroTerm(cash_back_term);
        calc.setCardTwoIntroTerm(low_interest_term);
        calc.setApr(cash_back_regular_rate);
        calc.setCardTwoApr(low_interest_regular_rate);
        calc.setAnnualFee(cash_back_annual_fee);
        calc.setCardTwoAnnualFee(low_interest_annual_fee);
        calc.setCashbackPercentRegular(cashback_percent_regular);
        calc.setCashbackPercentSpecific(cashback_percent_specific);
        calc.setQualifyingAmount(cashback_specific_reward);

        //Build the table, principal, and interest data for the charts and tables.
        calc.calculateDataPoints();

        $scope.result = $sce.trustAsHtml(calc.getResult());
        $scope.cbTotalInterest = toCurrency(calc.getTotalInterest());
        $scope.liTotalInterest = toCurrency(calc.getCardTwoTotalInterest());
        $scope.cbTotalFees = toCurrency(calc.getTotalFees());
        $scope.liTotalFees = toCurrency(calc.getCardTwoTotalFees());
        $scope.totalCashAward = toCurrency(calc.getTotalCashRewardEarned());
        $scope.cbNetCost = toCurrency(calc.getCardOneNetCost());
        $scope.liNetCost = toCurrency(calc.getCardTwoNetCost());
        $scope.numOfYears = calc.getYears();

        $scope.displayChart();
    };

    $scope.displayChart = function () {
        $('#high_chart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Cash Back vs. Low Interest Card? <br> Time Period: ' + calc.getYears() + ' years',
                style: {"font-size": "14px", "font-weight": "bold"}
            },
            xAxis: {
                categories: ['Interest & Fees', 'Cash Award Earned']
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Cash ($)'
                },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
                    }
                }
            },
            legend: {
                align: 'right',
                x: 0,
                verticalAlign: 'top',
                y: 50,
                floating: true,
                backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
                borderColor: '#CCC',
                borderWidth: 1,
                layout: 'vertical',
                shadow: false
            },
            tooltip: {
                formatter: function () {
                    return '<strong>' + this.x + '</strong> <br/>' +
                        this.series.name + ': $' + this.y
                }
            },
            plotOptions: {
                column: {
                    grouping: 'true',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'black'
                    }
                }
            },
            series: [{
                name: 'Cash Back Card',
                data: [(calc.getTotalInterest() + calc.getTotalFees()), calc.getTotalCashRewardEarned()]
            }, {
                name: "Low Interest Card",
                data: [(calc.getCardTwoTotalInterest() + calc.getCardTwoTotalFees()), 0]
            }]
        });
    }
}]);