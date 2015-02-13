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

    if (payoffMonths === 0 || isNaN(payoffMonths)) {
        this.setRetry(true);
    }
    else {
        this.setRetry(false);
    }
    /*Delete when we are sure we won't use
     else {
     //calc payoffMonths if payment was $25 more a month
     var lessPayoffMonths = (-1 * Math.log(1 - intRate * principal / (monthlyPayment - monthlyCharges + 25))) / (Math.log(1 + intRate));
     var lessTotalInterest = Math.ceil((lessPayoffMonths * (monthlyPayment - monthlyCharges + 25)) - principal);
     lessTotalInterest = totalInterest - lessTotalInterest;
     lessPayoffMonths = Math.ceil(lessPayoffMonths);

     if (lessPayoffMonths > 0) {
     this.setLessPayoffMonths(lessPayoffMonths);
     this.setLessTotalInterest(lessTotalInterest);
     }
     }
     */
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

    if(monthlyCharges >= monthlyPayment) {
        this.setRetry(true);
    }
    else {
        this.setRetry(false);
    }
    /*
     var lessPayoffMonths = payoffMonths - 2;
     var lessMonthlyPayment = (intRate * principal) / (1 - (Math.pow(1 + intRate, -lessPayoffMonths)));
     var lessTotalInterest = Math.round((lessPayoffMonths * lessMonthlyPayment) - principal);
     lessTotalInterest = totalInterest - lessTotalInterest;
     lessMonthlyPayment = Math.round(lessMonthlyPayment - monthlyCharges);

     if (lessPayoffMonths > 0) {
     this.setLessTotalInterest(lessTotalInterest);
     this.setLessMonthlyPayment(lessMonthlyPayment);
     }
     */
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





