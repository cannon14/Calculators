/* 
 * Payoff Calculator calculates either the number of months to pay off a principal, or the minimum payment to pay off
 * the principal in a desired number of months.
 *
 * @author David Cannon
 * @date Jan 2014
 */
function PayoffCalculator() {

    if (!(this instanceof PayoffCalculator)) {
        return new PayoffCalculator();
    }

    Calculator.call(this); // call super constructor.

    this.lessPayoffMonths = null;
    this.lessTotalInterest = null;
}

// inherit Calculator
PayoffCalculator.prototype = new Calculator();

// correct the constructor pointer because it points to Calculator
PayoffCalculator.prototype.constructor = PayoffCalculator;

/**
 * Set the reduced months to payoff.
 * @param lessPayoffMonths
 */
PayoffCalculator.prototype.setLessPayoffMonths = function (lessPayoffMonths) {
    this.lessPayoffMonths = lessPayoffMonths;
};

/**
 * Get the reduced months to payoff.
 * @returns {*}
 */
PayoffCalculator.prototype.getLessPayoffMonths = function () {
    return this.lessPayoffMonths;
};

/**
 * Set the reduced total interest
 * @param lessTotalInterest
 */
PayoffCalculator.prototype.setLessTotalInterest = function (lessTotalInterest) {
    this.lessTotalInterest = lessTotalInterest;
};

/**
 * Get the reduced total interest
 * @returns {*}
 */
PayoffCalculator.prototype.getLessTotalInterest = function () {
    return this.lessTotalInterest;
};

/**
 * Set the reduced montly payment
 * @param lessMonthlyPayment
 */
PayoffCalculator.prototype.setLessMonthlyPayment = function (lessMonthlyPayment) {
    this.lessMonthlyPayment = lessMonthlyPayment;
};

/**
 * Get the reduced monthly payment.
 * @returns {*}
 */
PayoffCalculator.prototype.getLessMonthlyPayment = function () {
    return this.lessMonthlyPayment;
};


/**
 * Calculate the number of months to payoff based on monthly payment.
 */
PayoffCalculator.prototype.doPayoffMonths = function () {

    var principal = this.getPrincipal();
    var apr = this.getApr();
    var monthlyPayment = this.getMonthlyPayment();
    var monthlyCharges = this.getMonthlyCharges();
    var payoffMonths = this.calculateMonthsToPayoff(apr, principal, monthlyPayment, monthlyCharges);
    var totalInterest = roundMoney(this.calculateTotalInterest(principal, monthlyPayment, monthlyCharges, apr, payoffMonths));
    var result = '';
    var lessResult = '';

    if (payoffMonths === 0 || isNaN(payoffMonths)) {
        result += "<p>Your Desired Monthly Payment is less than the interest you owe. With these values, you will never be able to pay off your balance.</p>";
        result += "<p>Please increase the Desired Monthly Payment and try again.</p>";
        this.setResult(result);
    }
    else {
        result += "<p>At your current rate of spending, it will take <strong>" + payoffMonths + "</strong> monthly payments of <strong>" + toCurrency(monthlyPayment) + "</strong> to pay off your credit card balance.</p>";
        result += "<p>If you were to pay off your debt immediately, you could avoid <strong>" + toCurrency(totalInterest) + "</strong> in interest costs.</p>";
        this.setResult(result);

        //calc payoffMonths if payment was $25 more a month
        var lessPayoffMonths = (-1 * Math.log(1 - toMpr(apr) * principal / (monthlyPayment - monthlyCharges + 25))) / (Math.log(1 + toMpr(apr)));
        var lessTotalInterest = Math.ceil((lessPayoffMonths * (monthlyPayment - monthlyCharges + 25)) - principal);
        lessTotalInterest = totalInterest - lessTotalInterest;
        lessPayoffMonths = Math.ceil(lessPayoffMonths);

        if (lessPayoffMonths > 0) {
            lessResult += "<p>You might consider paying more each month.  Reducing your monthly charges or increasing your payment by <strong>$ 25</strong> per month,";
            lessResult += " will reduce the months to repay to <strong>" + lessPayoffMonths + " months</strong> and will save you <strong>" + toCurrency(lessTotalInterest) + "</strong> in interest charges.";
            this.setResult2(lessResult);
        }
    }
};

/**
 * Calculate the monthly payment based off the number of months.
 */
PayoffCalculator.prototype.doMonthlyPayment = function () {

    var principal = this.getPrincipal();
    var apr = this.getApr();
    var payoffMonths = this.getMonthsToPayoff();
    var monthlyCharges = this.getMonthlyCharges();
    var monthlyPayment = roundMoney(this.calculateMonthlyPayment(apr, principal, monthlyCharges, payoffMonths));
    var totalInterest = roundMoney(this.calculateTotalInterest(principal, monthlyPayment, monthlyCharges, apr, payoffMonths));
    var result = '';
    var lessResult = '';

    if(monthlyCharges >= monthlyPayment) {
        result += "<p>Your Desired Monthly Payment is less than the interest you owe. With these values, you will never be able to pay off your balance.</p>";
        result += "<p>Please increase the Desired Monthly Payment and try again.</p>";
        this.setResult(result);
        this.setRetry(true);
    }
    else {

        result = "<p>At your current rate of spending, it will take payments of <strong>" + toCurrency(monthlyPayment) + "</strong> per month to pay off your credit card balance in <strong>" + payoffMonths + "</strong> months.</p>";
        result += "<p>If you were to pay off your debt immediately, you could avoid <strong>" + toCurrency(totalInterest) + "</strong> in interest costs.</p>";

        //calc monthly payment if payoffMonths was 2 months less
        var lessPayoffMonths = payoffMonths - 2;
        var lessMonthlyPayment = (toMpr(apr) * principal) / (1 - (Math.pow(1 + toMpr(apr), -lessPayoffMonths)));
        var lessTotalInterest = Math.round((lessPayoffMonths * lessMonthlyPayment) - principal);
        lessTotalInterest = totalInterest - lessTotalInterest;
        lessMonthlyPayment = Math.round(lessMonthlyPayment + monthlyCharges);

        this.setResult(result);
        this.setRetry(false);

        if (lessPayoffMonths > 0) {
            lessResult += "Paying off your balance 2 months earlier will increase your monthly payment to <strong>" + toCurrency(lessMonthlyPayment) + "</strong>,";
            lessResult += " but it will save you <strong>" + toCurrency(lessTotalInterest) + "</strong> in interest charges in the long run.";
            this.setResult2(lessResult);
        }
    }
};

/**
 * Calculate the data needed for tables and charts.
 */
PayoffCalculator.prototype.calculateDataPoints = function () {

    var tableDataArray = [];
    var principalDataArray = [];
    var interestDataArray = [];
    var remainingPrincipal = this.getPrincipal();
    var interestPaid = 0;
    var principalPaid = 0;
    var cummilativeInterest = 0;
    var interestRate = toMpr(this.getApr());
    var monthsToPayoff = Math.ceil(this.getMonthsToPayoff());
    var totalPayment = 0.00;
    var monthlyPayment = this.getMonthlyPayment();
    var monthlyCharges = this.getMonthlyCharges();

    //============= build object array with each month in payoff for chart and graph ==============
    for (var i = 1; i <= monthsToPayoff; i++) {
        //Interest Paid for the nth month.
        interestPaid = remainingPrincipal * interestRate;
        //Get a cummulative amount of interest.
        cummilativeInterest += interestPaid;

        var finalPayment = remainingPrincipal + interestPaid + monthlyCharges;
        //If the remaining principal and interest is less than the monthly payment, calculate the last payment.
        if (finalPayment < monthlyPayment) {
            //Total Final Payment
            totalPayment = remainingPrincipal + interestPaid + monthlyCharges;
            //Principal paid will be the remaining principal.
            principalPaid = remainingPrincipal;
            //Principal will now be 0.
            remainingPrincipal = 0;
        } else {
            //Paid will be the monthly payment minus interest.
            principalPaid = monthlyPayment - interestPaid;
            //Subtract payment from remaining principal.
            remainingPrincipal -= principalPaid;
            remainingPrincipal += monthlyCharges;
            //Total paid for nth month...payment - charges - interest.
            totalPayment = monthlyPayment;
        }

        var owed = roundMoney(remainingPrincipal);
        var totalInterest = roundMoney(cummilativeInterest);

        var tableObject = {};
        tableObject.month = i;
        tableObject.payment = roundMoney(totalPayment);
        tableObject.principal = roundMoney(principalPaid);
        tableObject.interest = roundMoney(interestPaid);
        tableObject.owed = owed;
        tableObject.totalInterest = totalInterest;

        tableDataArray.push(tableObject);
        principalDataArray.push(owed);
        interestDataArray.push(totalInterest);
    }

    this.setTableData(tableDataArray);
    this.setPrincipalData(principalDataArray);
    this.setInterestData(interestDataArray);
};





