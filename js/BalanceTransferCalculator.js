/* 
 * Payoff Calculator calculates either the number of months to pay off a principal, or the minimum payment to pay off
 * the principal in a desired number of months.
 *
 * @author David Cannon
 * @date Jan 2014
 */
function BalanceTransferCalculator() {

    if (!(this instanceof BalanceTransferCalculator)) {
        return new BalanceTransferCalculator();
    }

    Calculator.call(this); // call super constructor.

    this.introApr = 0.0;
    this.introTerm = 0;
    this.regularApr = 0.0;
    this.annualFee = 0.00;
    this.percentOfBalanceFee = 0.0;
    this.maximumBalanceFee = 0.00;
    this.totalTransferFees = 0.00;
    this.totalCurrentFees = 0.00;
    this.totalIntroInterest = 0.00;
    this.totalRegularInterest = 0.00;
    this.totalIntroSavings = 0.00;
    this.totalRegularSavings = 0.00;
    this.doIt = true;
    this.cards = [];
}

// inherit Calculator
BalanceTransferCalculator.prototype = new Calculator();

// correct the constructor pointer because it points to Calculator
BalanceTransferCalculator.prototype.constructor = BalanceTransferCalculator;

/**
 * Set the intro interest rate.
 * @param apr
 */
BalanceTransferCalculator.prototype.setIntroApr = function (apr) {
    this.introApr = toFloat(apr);
};

/**
 * Get the intro interest rate.
 * @returns {number}
 */
BalanceTransferCalculator.prototype.getIntroApr = function () {
    return this.introApr;
};

/**
 * Set the intro term in months.
 * @param term
 */
BalanceTransferCalculator.prototype.setIntroTerm = function (term) {
    this.introTerm = toInt(term);
};

/**
 * Get the intro term in months.
 * @returns {number}
 */
BalanceTransferCalculator.prototype.getIntroTerm = function () {
    return this.introTerm;
};

/**
 * Set the regular apr.
 * @param apr
 */
BalanceTransferCalculator.prototype.setRegularApr = function (apr) {
    this.regularApr = toFloat(apr);
};

/**
 * Get the regular apr.
 * @returns {number}
 */
BalanceTransferCalculator.prototype.getRegularApr = function () {
    return this.regularApr;
};

/**
 * Set the annual fee.
 * @param fee
 */
BalanceTransferCalculator.prototype.setAnnualFee = function (fee) {
    this.annualFee = toFloat(fee);
};

/**
 * Get the annual fee.
 * @returns {number}
 */
BalanceTransferCalculator.prototype.getAnnualFee = function () {
    return this.annualFee;
};

/**
 * Get the fee based on a percentage of the balance..
 * @param percent
 */
BalanceTransferCalculator.prototype.setPercentOfBalanceFee = function (percent) {
    percent = toFloat(percent);

    this.percentOfBalanceFee = toDecimal(percent);
};

/**
 * Get the fee based on a percentage of the balance.
 * @returns {number}
 */
BalanceTransferCalculator.prototype.getPercentOfBalanceFee = function () {
    return this.percentOfBalanceFee;
};

/**
 * Set the current fees total
 * @param fees
 */
BalanceTransferCalculator.prototype.setTotalCurrentFees = function (fees) {
    this.totalCurrentFees = toFloat(fees);
};

/**
 * Get the current fees total
 * @returns {number}
 */
BalanceTransferCalculator.prototype.getTotalCurrentFees = function () {
    return this.totalCurrentFees;
};

/**
 * Set the transfer fees total.
 * @param fees
 */
BalanceTransferCalculator.prototype.setTotalTransferFees = function (fees) {
    this.totalTransferFees = toFloat(fees);
};

/**
 * Get the transfer fees total.
 * @returns {number}
 */
BalanceTransferCalculator.prototype.getTotalTransferFees = function () {
    return this.totalTransferFees;
};

/**
 * Set the fee based on a maximum amount.
 * @param fee
 */
BalanceTransferCalculator.prototype.setMaximumBalanceFee = function (fee) {
    this.maximumBalanceFee = toFloat(fee);
};

/**
 * Get the fee based on a maximum amount.
 * @returns {number}
 */
BalanceTransferCalculator.prototype.getMaximumBalanceFee = function () {
    return this.maximumBalanceFee;
};

/**
 * Set a 2d array of cards...balance and apr
 * @param cards
 */
BalanceTransferCalculator.prototype.setCards = function (cards) {

    //Convert all the string values to numbers.
    for (var i = 0; i < cards.length; i++) {
        for (var j = 0; j < cards[i].length; j++) {
            cards[i][j] = toFloat(cards[i][j]);
        }
    }

    this.cards = cards;
};

/**
 * Get a 2d array of cards...balance and apr
 * @returns {Array}
 */
BalanceTransferCalculator.prototype.getCards = function () {
    return this.cards;
};

/**
 * Set the total intro interest total.
 * @param interest
 */
BalanceTransferCalculator.prototype.setTotalIntroInterest = function (interest) {
    this.totalIntroInterest = interest;
};

/**
 * Get the total intro interest total.
 * @returns {*}
 */
BalanceTransferCalculator.prototype.getTotalIntroInterest = function () {
    return this.totalIntroInterest;
};

/**
 * Set the regular interest total.
 * @param interest
 */
BalanceTransferCalculator.prototype.setTotalRegularInterest = function (interest) {
    this.totalRegularInterest = interest;
};

/**
 * Get the regular interest total.
 * @returns {*}
 */

BalanceTransferCalculator.prototype.getTotalRegularInterest = function () {
    return this.totalRegularInterest;
};

/**
 * Set the total savings during intro period.
 * @param amount
 */
BalanceTransferCalculator.prototype.setTotalIntroSavings = function (amount) {
    this.totalIntroSavings = toFloat(amount);
};

/**
 * Get the total savings during intro period.
 * @returns {Number|*}
 */
BalanceTransferCalculator.prototype.getTotalIntroSavings = function () {
    return this.totalIntroSavings;
};

/**
 * Set the total savings during regular period.
 * @param amount
 */
BalanceTransferCalculator.prototype.setTotalRegularSavings = function (amount) {
    this.totalRegularSavings = toFloat(amount);
};

/**
 * Get total savings during regular period.
 * @returns {Number|*}
 */
BalanceTransferCalculator.prototype.getTotalRegularSavings = function () {
    return this.totalRegularSavings;
};

/**
 * Set "DO IT" to true or false...meaning the promotion is worth it or not.
 * @param answer
 */
BalanceTransferCalculator.prototype.setDoIt = function (answer) {
    this.doIt = answer;
};

/**
 * Get the answer as to whether the promotion is worth it or not.
 * @returns {*}
 */
BalanceTransferCalculator.prototype.getDoIt = function () {
    return this.doIt;
};

/**
 * Calculate the data needed for tables and charts.
 */
BalanceTransferCalculator.prototype.calculateDataPoints = function () {


    var cards = this.getCards();
    var totalPrincipalForTransfer = 0;

    for (var i = 0; i < cards.length; i++) {
        totalPrincipalForTransfer += cards[i][0];
    }
    var transferFeePercent = this.getPercentOfBalanceFee();
    var balanceTransferCharge = totalPrincipalForTransfer * transferFeePercent;
    var maximumBalanceTransferFee = this.getMaximumBalanceFee();

    //if transfer fees are greater than maximum fee, use max fee
    if ((balanceTransferCharge > maximumBalanceTransferFee) && (maximumBalanceTransferFee != 0)) {
        balanceTransferCharge = maximumBalanceTransferFee;
    }

    var totalTransferFees = 0;
    //add in transfer charge
    totalTransferFees += balanceTransferCharge;

    var term = this.getIntroTerm();
    var annualFee = this.getAnnualFee();

    //add in promo annual fees
    for (var j = 0; j <= term; j += 12) {
        if ((j == 0) || ((j + 1) <= term)) {
            totalTransferFees += annualFee;
        }
    }

    this.setTotalTransferFees(roundMoney(totalTransferFees));

    //=============== Calc interest charges from CURRENT CARDS ==============================
    var introTerm = this.getIntroTerm();
    var totalRegularInterest = 0;

    //Iterate over all cards.
    for (var i = 0; i < cards.length; i++) {
        var principal = cards[i][0]; //Current Card Principal
        var apr = cards[i][1]; //Current Card APR
        var rate = toMpr(apr); //Current Card MPR
        var payment = cards[i][2]; //Current Monthly Payment

        //Iterate over card for the intro term months.
        for (var j = 0; j < introTerm; j++) {
            principal -= payment; //Subtract payment from principal
            if (principal <= 0) {
                break;
            }
            else {
                totalRegularInterest += principal * rate; //Calculate interest.
            }
        }
    }

    this.setTotalRegularInterest(totalRegularInterest);

    //=============== Calc interest charges from NEW TRANSFER CARD ==============================
    var introApr = this.getIntroApr();
    var introMpr = toMpr(introApr);
    var totalIntroInterest = 0;

    //Iterate over new card for the intro term months.
    for (var i = 0; i < introTerm; i++) {
        totalPrincipalForTransfer -= payment;
        totalIntroInterest += totalPrincipalForTransfer * introMpr;
    }

    this.setTotalIntroInterest(totalIntroInterest);

    //=============== Show intro period results================================================
    var totalSavedDuringIntro = roundMoney(totalRegularInterest - (totalIntroInterest + totalTransferFees));

    //If number is negative...make it positive and flag it as "Don't Do It".
    if (totalSavedDuringIntro < 0) {
        this.setDoIt(false);
        totalSavedDuringIntro = -1 * totalSavedDuringIntro;
    }

    this.setTotalIntroSavings(totalSavedDuringIntro);

    //================ REGULAR BILLING CYCLE - 1ST MONTH AFTER PROMO ENDS ===============================================
    var regularApr = this.getRegularApr();
    var regularMpr = toMpr(regularApr);

    var totalSavedDuringRegularCycle = roundMoney(totalPrincipalForTransfer * regularMpr);

    this.setTotalRegularSavings(totalSavedDuringRegularCycle);
};





