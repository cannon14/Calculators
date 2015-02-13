/**
 *
 * This calculator extends the functionality of the Calculator class to allow calculations of the minimum payment
 * or payoff months required for a given principal and interest rate.
 *
 * @returns {MinimumPaymentCalculator}
 * @constructor
 */

function MinimumPaymentCalculator() {

    if (!(this instanceof MinimumPaymentCalculator)) {
        return new MinimumPaymentCalculator();
    }

    Calculator.call(this);

    this.percentage = 0.0;
    this.minimum = 0.00;
}

// inherit Calculator
MinimumPaymentCalculator.prototype = new Calculator();

// correct the constructor pointer because it points to Calculator
MinimumPaymentCalculator.prototype.constructor = MinimumPaymentCalculator;

/**
 * Set minimum monthly payment based on a percentage of principal
 * @param percentage
 */
MinimumPaymentCalculator.prototype.setMinimumPercentageToPay = function (percentage) {
    this.percentage = toFloat(percentage);
};

/**
 * Get minimum percentage to pay.
 * @returns {*}
 */
MinimumPaymentCalculator.prototype.getMinimumPercentageToPay = function () {
    return this.percentage;
};

/**
 * Set the minimum monthly dollar amount to pay on principal
 * @param minimum
 */
MinimumPaymentCalculator.prototype.setMinimumDollarAmountToPay = function (minimum) {
    this.minimum = toFloat(minimum);
};

/**
 * Get the minimum monthly dollar amount.
 * @returns {*}
 */
MinimumPaymentCalculator.prototype.getMinimumDollarAmountToPay = function () {
    return this.minimum;
};

/**
 * Calculate the minimum monthly payment.
 * @returns {number}
 */
MinimumPaymentCalculator.prototype.calculateMinimumPayment = function () {
    var minimum = 0.00;
    var percentAmount = toDecimal(this.getMinimumPercentageToPay()) * this.getPrincipal();

    if (percentAmount > this.getMinimumDollarAmountToPay()) {
        minimum = percentAmount;
    }
    else {
        minimum = this.getMinimumDollarAmountToPay();
    }

    return minimum;
};

/**
 * Calculate the number of months to pay off principal.
 */
MinimumPaymentCalculator.prototype.calculateDataPoints = function () {

    var tableDataArray = [];
    var principalDataArray = [];
    var interestDataArray = [];
    var apr = this.getApr();
    var intRate = toMpr(apr);
    var principal = this.getPrincipal();
    var interest = 0;
    var principalPaid = 0;
    var cummilativeInterest = 0;
    var calculatedPayment = 0;
    var payment = 0;
    var payoffMonths = 0;

    while (principal > 0) {
        //Increment the number of payoff months.
        payoffMonths++;
        //calculate Interest.
        interest = (principal * intRate);
        //Convert interest to a float.
        interest = toFloat(interest.toFixed(2));
        //Track the cummulative interest.
        cummilativeInterest += interest;
        //Calculate the total payment.
        calculatedPayment = principal * (this.getMinimumPercentageToPay() / 100);
        //Get whichever payment is larger...calculated or the minimum required.
        payment = Math.max(calculatedPayment, this.getMinimumDollarAmountToPay());

        //If payment is less than the principal and interest.
        if ((interest + principal) > payment) {
            //Subtract the payment, minus interest, for total amount of principal paid..
            principalPaid = payment - interest;
            //Subtract the the amount from the principal.
            principal -= principalPaid;
        }
        //Else, this is the final payment.
        else {
            //Principal paid is the principal.
            principalPaid = principal;
            //Payment will be principal plus interest.
            payment = principal + interest;
            //Remaining principal will be 0.
            principal = 0;
        }

        //This data will be used in multiple arrays.
        var owed = roundMoney(principal);
        var totalInterest = roundMoney(cummilativeInterest);

        //Assign specific data points to the table array.
        tableDataArray.push({
            month: payoffMonths,
            payment: roundMoney(payment),
            totalInterest: totalInterest,
            interest: roundMoney(interest),
            principal: roundMoney(principalPaid),
            owed: owed
        });

        //Assign specific data points for the principal and interest arrays.
        principalDataArray.push(owed);
        interestDataArray.push(totalInterest);
    }
    //Set the number of months to pay off principal that we have calculated.
    this.setMonthsToPayoff(payoffMonths);
    //Set the total interest that we have calculated.
    this.setTotalInterest(cummilativeInterest);
    //Set the array containing all of our data for the table in the view.
    this.setTableData(tableDataArray);
    //Set the array containing all of our principal data for the chart in the view.
    this.setPrincipalData(principalDataArray);
    //Set the array containing all of our interest data for the chart in the view.
    this.setInterestData(interestDataArray);

};





