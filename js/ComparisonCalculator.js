/* 
 * Comparison calculator adds basic functionality to compare two cards.  It will need to be extended in order to add
 * The logic to perform the actual comparison.
 *
 * @author David Cannon
 * @date Jan 2014
 */
function ComparisonCalculator() {

    if (!(this instanceof ComparisonCalculator)) {
        return new ComparisonCalculator();
    }

    Calculator.call(this);

    this.years = 0;
    this.cardOneIntroApr = 0.0;
    this.cardTwoIntroApr = 0.0;
    this.cardTwoApr = 0.0;
    this.cardTwoAnnualFee = 0.00;
    this.cashbackPercentRegular = 0.0;
    this.cashbackPercentSpecific = 0.0;
    this.qualifyingAmount = 0.00;
    this.totalCashRewardEarned = 0.00;
    this.cardOneNetCost = 0.00;
    this.cardTwoNetCost = 0.00;
    this.cardTwoTotalFees = 0.00;
    this.cardOneIntroAnnualFee = 0.00;
    this.cardTwoIntroAnnualFee = 0.00;
    this.cardOneIntroTerm = 0;
    this.cardTwoIntroTerm = 0;
    this.cardOneRemainingBalance = 0.00;
    this.cardTwoRemainingBalance = 0.00;
}

// inherit Calculator
ComparisonCalculator.prototype = new Calculator();

// correct the constructor pointer because it points to Calculator
ComparisonCalculator.prototype.constructor = ComparisonCalculator;

ComparisonCalculator.prototype.setYears = function (years) {
    this.years = toInt(years);
};

ComparisonCalculator.prototype.getYears = function () {
    return this.years;
};

ComparisonCalculator.prototype.setCardOneIntroApr = function (apr) {
    this.cardOneIntroApr = toFloat(apr);
};

ComparisonCalculator.prototype.getCardOneIntroApr = function () {
    return this.cardOneIntroApr;
};

ComparisonCalculator.prototype.setCardTwoIntroApr = function (apr) {
    this.cardTwoIntroApr = toFloat(apr);
};

ComparisonCalculator.prototype.getCardTwoIntroApr = function () {
    return this.cardTwoIntroApr;
};

ComparisonCalculator.prototype.setCardOneIntroTerm = function (term) {
    this.cardOneIntroTerm = toInt(term);
};

ComparisonCalculator.prototype.getCardOneIntroTerm = function () {
    return this.cardOneIntroTerm;
};

ComparisonCalculator.prototype.setCardTwoIntroTerm = function (term) {
    this.cardTwoIntroTerm = toInt(term);
};

ComparisonCalculator.prototype.getCardTwoIntroTerm = function () {
    return this.cardTwoIntroTerm;
};

ComparisonCalculator.prototype.setCardTwoApr = function (apr) {
    this.cardTwoApr = toFloat(apr);
};

ComparisonCalculator.prototype.getCardTwoApr = function () {
    return this.cardTwoApr;
};

ComparisonCalculator.prototype.setCardTwoAnnualFee = function (fee) {
    this.cardTwoAnnualFee = toFloat(fee);
};

ComparisonCalculator.prototype.getCardTwoAnnualFee = function () {
    return this.cardTwoAnnualFee;
};

ComparisonCalculator.prototype.setCardOneIntroAnnualFee = function (fee) {
    this.cardOneIntroAnnualFee = toFloat(fee);
};

ComparisonCalculator.prototype.getCardOneIntroAnnualFee = function () {
    return this.cardOneIntroAnnualFee;
};

ComparisonCalculator.prototype.setCardTwoIntroAnnualFee = function (fee) {
    this.cardTwoIntroAnnualFee = toFloat(fee);
};

ComparisonCalculator.prototype.getCardTwoIntroAnnualFee = function () {
    return this.cardTwoIntroAnnualFee;
};

ComparisonCalculator.prototype.setCardTwoTotalInterest = function (interest) {
    this.cardTwoTotalInterest = toFloat(interest);
};

ComparisonCalculator.prototype.getCardTwoTotalInterest = function () {
    return this.cardTwoTotalInterest
};

ComparisonCalculator.prototype.setCardOneNetCost = function (cost) {
    this.cardOneNetCost = cost;
};

ComparisonCalculator.prototype.getCardOneNetCost = function () {
    return this.cardOneNetCost;
};

ComparisonCalculator.prototype.setCardTwoNetCost = function (cost) {
    this.cardTwoNetCost = cost;
};

ComparisonCalculator.prototype.getCardTwoNetCost = function () {
    return this.cardTwoNetCost;
};

ComparisonCalculator.prototype.setCardTwoTotalFees = function (fees) {
    this.cardTwoTotalFees = fees;
};

ComparisonCalculator.prototype.getCardTwoTotalFees = function () {
    return this.cardTwoTotalFees;
};

ComparisonCalculator.prototype.setCardOneRemainingBalance = function (balance) {
    this.cardOneRemainingBalance = balance;
};

ComparisonCalculator.prototype.getCardOneRemainingBalance = function () {
    return this.cardOneRemainingBalance;
};

ComparisonCalculator.prototype.setCardTwoRemainingBalance = function (balance) {
    this.cardTwoRemainingBalance = balance;
};

ComparisonCalculator.prototype.getCardTwoRemainingBalance = function () {
    return this.cardTwoRemainingBalance;
};