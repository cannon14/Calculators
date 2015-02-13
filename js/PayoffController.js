var calculatorApp = angular.module('CalculatorApplication', []);

calculatorApp.controller('PayoffController', ['$scope', function ($scope) {

    var calc = new PayoffCalculator();

    $scope.calculate = function () {

        $scope.monthly = false;
        $scope.payoff = false;

        //Retrieve the variables from the view...give them default values in cause the user hits calculate.
        var principal = $scope.current_balance ? $scope.current_balance : 0.00;
        var apr = $scope.interest_rate ? $scope.interest_rate : 0.0;
        var monCharges = $scope.monthly_charges ? $scope.monthly_charges : 0.00;
        var monToPayoff = $scope.months_to_payoff ? $scope.months_to_payoff : 0;
        var monPayment = $scope.desired_monthly_payment ? $scope.desired_monthly_payment : 0.00;

        //Set the calculator properties that will be used in either of the below conditions.
        calc.setPrincipal(principal);
        calc.setApr(apr);
        calc.setMonthlyCharges(monCharges);

        //If there is a value in the "Desired Months to Payoff" field, run this condition.
        if (monToPayoff !== 0) {
            calc.setMonthsToPayoff(monToPayoff);
            calc.doMonthlyPayment();
            //$scope.lessMonthlyPayment = toCurrency(calc.getLessMonthlyPayment());
            //$scope.lessTotalInterest = toCurrency(calc.getLessTotalInterest());
            $scope.monthly = true;
        }
        //Else, run the "Desired Monthly Payment" logic.
        else {
            calc.setMonthlyPayment(monPayment);
            calc.doPayoffMonths();
            //$scope.lessPayoffMonths = calc.getLessPayoffMonths();
            //$scope.lessTotalInterest = toCurrency(calc.getLessTotalInterest());
            $scope.payoff = true;
        }

        $scope.payoffMonths = calc.getMonthsToPayoff();
        $scope.monthlyPayment = toCurrency(calc.getMonthlyPayment());
        $scope.totalInterest = toCurrency(calc.getTotalInterest());
        $scope.retry = calc.getRetry();
        //Build the table, principal, and interest data for the charts and tables.
        calc.calculateDataPoints();

        //Get the table data array.
        $scope.tableData = calc.getTableData();
        $scope.principalData = calc.getPrincipalData();
        $scope.interestData = calc.getInterestData();

        $scope.displayChart();
        $scope.showTabs = true;
    };

    $scope.displayChart = function () {
        $('#high_chart').highcharts({
            chart: {},
            title: {
                text: 'Interest Paid'
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