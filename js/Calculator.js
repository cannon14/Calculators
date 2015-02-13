/* 
 * Calculator object contains all common functionality for extending calculator instances.
 *
 * @author David Cannon
 * @date Jan 2014
 */

function Calculator() {

    if (!(this instanceof Calculator)) {
        return new Calculator();
    }

    this.principal = 0.00;
    this.apr = 0.0;
    this.monthlyCharges = 0.0;
    this.monthlyPayment = 0.0;
    this.monthsToPayoff = 0;
    this.interest = 0.00;
    this.totalFees = 0.00;
    this.annualFee = 0.00;
    this.result = null;
    this.retry = false;
    this.tableData = [];
    this.principalData = [];
    this.interestData = [];
}

/**
 * Set the principal.
 * @param principal
 */
Calculator.prototype.setPrincipal = function (principal) {
    this.principal = toFloat(principal);
};

/**
 * Get the principal
 * @returns {number}
 */
Calculator.prototype.getPrincipal = function () {
    return this.principal;
};

/**
 * Set the APR.
 * @param apr
 */
Calculator.prototype.setApr = function (apr) {
    this.apr = toFloat(apr);
};

/**
 * Get the APR
 * @returns {number}
 */
Calculator.prototype.getApr = function () {
    return this.apr;
};

/**
 * Set the total interest.
 * @param interest
 */
Calculator.prototype.setTotalInterest = function (interest) {
    this.interest = toFloat(interest);
};

/**
 * Get the total interest.
 * @returns {number}
 */
Calculator.prototype.getTotalInterest = function () {
    return this.interest;
};

/**
 * Set the annual fee.
 * @param fee
 */
Calculator.prototype.setAnnualFee = function (fee) {
    this.annualFee = toFloat(fee);
};

/**
 * Get the annual fee.
 * @returns {Function}
 */
Calculator.prototype.getAnnualFee = function () {
    return this.annualFee;
};

/**
 * Set the total fee.
 * @param fee
 */
Calculator.prototype.setTotalFees = function (fees) {
    this.totalFees = fees;
};

/**
 * Get the total Fee.
 * @returns {number}
 */
Calculator.prototype.getTotalFees = function () {
    return this.totalFees
};

/**
 * Set the result string.
 * @param result
 */
Calculator.prototype.setResult = function (result) {
    this.result = result;
};

/**
 * Get the result string
 * @returns {null|*}
 */
Calculator.prototype.getResult = function () {
    return this.result;
};

/**
 * Calculate, set, and return the total interest.
 * @param principal
 * @param monthlyPayment
 * @param monthlyCharges
 * @param apr
 * @param payoffMonths
 * @returns {number}
 */
Calculator.prototype.calculateTotalInterest = function (principal, monthlyPayment, monthlyCharges, apr, payoffMonths) {

    var rate = toMpr(apr);
    var interestPaid = 0;
    var cummilativeInterest = 0;

    for (var i = 1; i <= payoffMonths; i++) {
        //Interest Paid for the nth month.
        interestPaid = principal * rate;
        //Get a cummulative amount of interest.
        cummilativeInterest += interestPaid;
        principal -= (monthlyPayment - monthlyCharges) - interestPaid;
    }

    this.setTotalInterest(cummilativeInterest);
    //We set and return the interest to fore-go two method calls.
    return cummilativeInterest;
};

/**
 * Set the monthly charges.
 * @param charges
 */
Calculator.prototype.setMonthlyCharges = function (charges) {
    this.monthlyCharges = toFloat(charges);
};

/**
 * Get the monthly charges.
 * @returns {number}
 */
Calculator.prototype.getMonthlyCharges = function () {
    return this.monthlyCharges;
};

/**
 * Set the months to pay off.
 * @param months
 */
Calculator.prototype.setMonthsToPayoff = function (months) {
    this.monthsToPayoff = toFloat(months);
};

/**
 * Get the months to pay off.
 * @returns {number}
 */
Calculator.prototype.getMonthsToPayoff = function () {
    return this.monthsToPayoff;
};

/**
 * Calculate the number of months to pay off principal
 * @param apr
 * @param principal
 * @param monthlyPayment
 * @param monthlyCharges
 * @returns {number}
 */
Calculator.prototype.calculateMonthsToPayoff = function (apr, principal, monthlyPayment, monthlyCharges) {
    var rate = toMpr(apr);
    var interestPaid = 0;
    var cummilativeInterest = 0;
    var months = 0;
    while (principal > 0) {
        //Interest Paid for the nth month.
        interestPaid = principal * rate;
        //Get a cummulative amount of interest.
        cummilativeInterest += interestPaid;

        //Hold the current principal temporarily so we can check infinite loop condition below.
        var temp_principal = principal;

        //Subtract values from principal
        principal -= (monthlyPayment - monthlyCharges) - interestPaid;

        //If the above subtraction results in a principal increase, this card will never be paid off.  EXIT or suffer
        //an infinite loop.
        if (principal >= temp_principal) {
            this.setRetry(true);
            break;
        }

        //Increment months.
        months++;
    }

    this.setMonthsToPayoff(months);
    //We set and return the months to fore-go two method calls.
    return months;
};

/**
 * Set the monthly payment.
 * @param payment
 */
Calculator.prototype.setMonthlyPayment = function (payment) {
    this.monthlyPayment = toFloat(payment);
};

/**
 * Get the monthly payment.
 * @returns {Number|*}
 */
Calculator.prototype.getMonthlyPayment = function () {
    return this.monthlyPayment
};

/**
 * Calculate, set and return the monthly payment.
 * @param apr
 * @param principal
 * @param payoffMonths
 * @returns {number}
 */
Calculator.prototype.calculateMonthlyPayment = function (apr, principal, monthlyCharges, payoffMonths) {
    var rate = toMpr(apr);
    var charges = payoffMonths * monthlyCharges;
    var payment = (rate * (principal + charges)) / (1 - (Math.pow(1 + rate, -payoffMonths)));
    this.setMonthlyPayment(payment);

    return payment;
};

/**
 * Set retry.
 * @param retry
 */
Calculator.prototype.setRetry = function (retry) {
    this.retry = retry;
};

/**
 * Get retry
 * @returns {*}
 */
Calculator.prototype.getRetry = function () {
    return this.retry;
};

/**
 * Set the table data array.
 * @param data
 */
Calculator.prototype.setTableData = function (data) {
    this.tableData = data;
};

/**
 * Get the table data array
 * @returns {*}
 */
Calculator.prototype.getTableData = function () {
    return this.tableData;
};

/**
 * Set the principal data array.
 * @param data
 */
Calculator.prototype.setPrincipalData = function (data) {
    this.principalData = data;
};

/**
 * Get the principal data array
 * @returns {*}
 */
Calculator.prototype.getPrincipalData = function () {
    return this.principalData;
};

/**
 * Set the interest data array.
 * @param data
 */
Calculator.prototype.setInterestData = function (data) {
    this.interestData = data;
};

/**
 * Get the interest data array.
 * @returns {*}
 */
Calculator.prototype.getInterestData = function () {
    return this.interestData;
};




