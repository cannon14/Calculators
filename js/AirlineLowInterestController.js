var calculatorApp = angular.module('CalculatorApplication', []);

calculatorApp.controller('AirlineLowInterestController', ['$scope', '$sce', function ($scope, $sce) {

    var calc = new AirlineLowInterestCalculator();

    $scope.calculate = function () {

        //Retrieve the variables from the view...give them default values in case the user hits calculate.
        var principal = $scope.principal ? $scope.principal : 5000.00;
        var years = $scope.years ? $scope.years : 3;
        var charges = $scope.charges ? $scope.charges : 350.00;
        var payment = $scope.payment ? $scope.payment : 450.00;
        var airline_intro_rate = $scope.airline_intro_rate ? $scope.airline_intro_rate : 4.0;
        var low_interest_intro_rate = $scope.low_interest_intro_rate ? $scope.low_interest_intro_rate : 2.0;
        var airline_intro_term = $scope.airline_intro_term ? $scope.airline_intro_term : 12;
        var low_interest_intro_term = $scope.low_interest_intro_term ? $scope.low_interest_intro_term : 12;
        var airline_regular_rate = $scope.airline_regular_rate ? $scope.airline_regular_rate : 10.0;
        var low_interest_regular_rate = $scope.low_interest_regular_rate ? $scope.low_interest_regular_rate : 9.0;
        var airline_intro_annual_fee = $scope.airline_intro_annual_fee ? $scope.airline_intro_annual_fee : 0.00;
        var low_interest_intro_annual_fee = $scope.low_interest_intro_annual_fee ? $scope.low_interest_intro_annual_fee : 0.00;
        var airline_regular_annual_fee = $scope.airline_regular_annual_fee ? $scope.airline_regular_annual_fee : 50.0;
        var low_interest_regular_annual_fee = $scope.low_interest_regular_annual_fee ? $scope.low_interest_regular_annual_fee : 25.0;
        var miles_per_dollar = $scope.miles_per_dollar ? $scope.miles_per_dollar : 2;
        var miles_to_apply = $scope.miles_to_apply ? $scope.miles_to_apply : 10000.00;
        var max_yearly_miles = $scope.max_yearly_miles ? $scope.max_yearly_miles : 60000.00;
        var miles_for_free_ticket = $scope.miles_for_free_ticket ? $scope.miles_for_free_ticket : 25000;
        var cost_of_ticket = $scope.cost_of_ticket ? $scope.cost_of_ticket : 300;

        calc.setPrincipal(principal);
        calc.setYears(years);
        calc.setMonthlyCharges(charges);
        calc.setMonthlyPayment(payment);
        calc.setCardOneIntroApr(airline_intro_rate);
        calc.setCardTwoIntroApr(low_interest_intro_rate);
        calc.setCardOneIntroTerm(airline_intro_term);
        calc.setCardTwoIntroTerm(low_interest_intro_term);
        calc.setApr(airline_regular_rate);
        calc.setCardTwoApr(low_interest_regular_rate);
        calc.setCardOneIntroAnnualFee(airline_intro_annual_fee);
        calc.setCardTwoIntroAnnualFee(low_interest_intro_annual_fee);
        calc.setAnnualFee(airline_regular_annual_fee);
        calc.setCardTwoAnnualFee(low_interest_regular_annual_fee);
        calc.setMilesPerDollar(miles_per_dollar);
        calc.setMilesToApply(miles_to_apply);
        calc.setMaxYearlyMiles(max_yearly_miles);
        calc.setMilesToFreeTicket(miles_for_free_ticket);
        calc.setCostOfTicket(cost_of_ticket);

        //Build the table, principal, and interest data for the charts and tables.
        calc.calculateDataPoints();

        $scope.result = $sce.trustAsHtml(calc.getResult());
        $scope.totalMilesEarned = calc.getTotalMilesEarned();
        $scope.totalTicketsEarned = calc.getTotalTicketsEarned();
        $scope.totalValueOfTickets = toCurrency(calc.getTotalValueOfTickets());
        $scope.cardOneTotalInterestAndFees = toCurrency(calc.getCardOneTotalInterestAndFees());
        $scope.cardTwoTotalInterestAndFees = toCurrency(calc.getCardTwoTotalInterestAndFees());
        $scope.numOfYears = calc.getYears();

        $scope.displayChart();
        $scope.showTabs = true;
    };

    $scope.displayChart = function () {
        $('#high_chart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Airlines vs. Low Interest Card? <br> Time Period: ' + calc.getYears() + ' years',
                style: {"font-size": "14px", "font-weight": "bold"}
            },
            xAxis: {
                categories: ['Interest & Fees', 'Remaining Balance', 'Value of Tickets']
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
                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
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
                    return '<strong>Month:</strong> ' + this.x + '<br/>' +
                        this.series.name + ': $' + this.y
                }
            },
            plotOptions: {
                column: {
                    grouping: 'true',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                        style: {
                            textShadow: '0 0 3px black'
                        }
                    }
                }
            },
            series: [{
                name: 'Airlines',
                data: [calc.getCardOneTotalInterestAndFees(), calc.getCardOneRemainingBalance(), calc.getTotalValueOfTickets()]
            }, {
                name: "Low Interest",
                data: [calc.getCardTwoTotalInterestAndFees(), calc.getCardTwoRemainingBalance(), 0]
            }]
        });
    }
}]);