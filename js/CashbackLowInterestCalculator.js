/* 
 * This Calculator compares the Cashback and Low Interest Credit Cards.
 *
 * @author David Cannon
 * @date Jan 2014
 */
function CashbackLowInterestCalculator() {

    if (!(this instanceof CashbackLowInterestCalculator)) {
        return new CashbackLowInterestCalculator();
    }

    ComparisonCalculator.call(this); // call super constructor.

    this.years = 0;
    this.cardTwoApr = 0.0;
    this.cardTwoAnnualFee = 0.00;
    this.cashbackPercentRegular = 0.0;
    this.cashbackPercentSpecific = 0.0;
    this.qualifyingAmount = 0.00;
    this.totalCashRewardEarned = 0.00;
    this.cardOneNetCost = 0.00;
    this.cardTwoNetCost = 0.00;
    this.cardTwoTotalFees = 0.00;
}

// inherit Calculator
CashbackLowInterestCalculator.prototype = new ComparisonCalculator();

// correct the constructor pointer because it points to Calculator
CashbackLowInterestCalculator.prototype.constructor = CashbackLowInterestCalculator;

CashbackLowInterestCalculator.prototype.setCashbackPercentRegular = function (percent) {
    this.cashbackPercentRegular = toFloat(percent);
};

CashbackLowInterestCalculator.prototype.getCashbackPercentRegular = function () {
    return this.cashbackPercentRegular;
};

CashbackLowInterestCalculator.prototype.setCashbackPercentSpecific = function (percent) {
    this.cashbackPercentSpecific = toFloat(percent);
};

CashbackLowInterestCalculator.prototype.getCashbackPercentSpecific = function () {
    return this.cashbackPercentSpecific;
};

CashbackLowInterestCalculator.prototype.setQualifyingAmount = function (amount) {
    this.qualifyingAmount = toFloat(amount);
};

CashbackLowInterestCalculator.prototype.getQualifyingAmount = function () {
    return this.qualifyingAmount;
};

CashbackLowInterestCalculator.prototype.setTotalCashRewardEarned = function (amount) {
    this.totalCashRewardEarned = toFloat(amount);
};

CashbackLowInterestCalculator.prototype.getTotalCashRewardEarned = function () {
    return this.totalCashRewardEarned;
};

/**
 * Calculate the data needed for tables and charts.
 */
CashbackLowInterestCalculator.prototype.calculateDataPoints = function () {

    //calculate total interest and fees for cashback card
    var totalMonths = this.getYears() * 12;
    var cashbackRemainingPrincipal = this.getPrincipal();
    var cashbackTotalInterest = 0;
    var cashbackTotalFees = 0;
    var interestRemainingPrincipal = this.getPrincipal();
    var interestTotalInterest = 0;
    var interestTotalFees = 0;
    //track standard interest period in case promo length is not 12 months
    var totalStandardCashBackMonths = 0;
    var totalStandardInterestMonths = 0;

    //calculate total cash reward earned for totalMonths used
    var totalRegularCashRewardEarned = (this.getQualifyingAmount() * toDecimal(this.getCashbackPercentSpecific())) * totalMonths;
    var totalBrandCashRewardEarned = ((this.getMonthlyCharges() - this.getQualifyingAmount()) * toDecimal(this.getCashbackPercentRegular())) * totalMonths;
    var totalCashRewardEarned = roundMoney(totalRegularCashRewardEarned + totalBrandCashRewardEarned);
    this.setTotalCashRewardEarned(totalCashRewardEarned);

    //cycle through months to calculate
    for (var i = 1; i <= totalMonths; i++) {
        //	CALCULATE cashback CARD

        //use standard rate\
        var term = this.getCardOneIntroTerm();
        if (i > term) {
            var tempInterest = ((cashbackRemainingPrincipal > 0) ? (toMpr(this.getApr()) * cashbackRemainingPrincipal) : 0 );

            //add in standard annual fee for start of standard period and for subsequent years
            if ((i != totalMonths) && (totalStandardCashBackMonths % 12 == 0)) {
                cashbackRemainingPrincipal += this.getAnnualFee();
                cashbackTotalFees += this.getAnnualFee();
            }
            totalStandardCashBackMonths++;
        }
        else {
            //use promo rate
            var tempInterest = (cashbackRemainingPrincipal > 0 ? toMpr(this.getCardOneIntroApr()) * cashbackRemainingPrincipal : 0 );
        }

        cashbackTotalInterest += tempInterest;
        //add in purchases before making payment
        cashbackRemainingPrincipal += (this.getMonthlyCharges() + tempInterest - this.getMonthlyPayment());

        //CALCULATE LOW INTEREST CARD

        //use standard rate
        if (i > this.getCardTwoIntroTerm()) {
            var tempInterest = (interestRemainingPrincipal > 0 ? toMpr(this.getCardTwoApr()) * interestRemainingPrincipal : 0 );

            //add in standard annual fee for start of standard period and for subsequent years
            if ((i != totalMonths) && (totalStandardInterestMonths % 12 == 0)) {
                interestRemainingPrincipal += this.getCardTwoAnnualFee();
                interestTotalFees += this.getCardTwoAnnualFee();
            }
            totalStandardInterestMonths++;
        }
        else {
            //use promo rate

            var tempInterest = (interestRemainingPrincipal > 0) ? toMpr(this.getCardTwoIntroApr()) * interestRemainingPrincipal : 0;
        }

        interestTotalInterest += tempInterest;
        //add in purchases before making payment
        interestRemainingPrincipal += (this.getMonthlyCharges() + tempInterest - this.getMonthlyPayment());
    }

    //make sure values are not less than zero
    interestRemainingPrincipal = (interestRemainingPrincipal < 0 ? 0 : interestRemainingPrincipal);
    cashbackRemainingPrincipal = (cashbackRemainingPrincipal < 0 ? 0 : cashbackRemainingPrincipal);

    this.setTotalInterest(roundMoney(cashbackTotalInterest));
    this.setTotalFees(roundMoney(cashbackTotalFees));
    this.setCardTwoTotalInterest(roundMoney(interestTotalInterest));
    this.setCardTwoTotalFees(roundMoney(interestTotalFees));

    var cashbackNetCost = (cashbackTotalInterest + cashbackTotalFees) - totalCashRewardEarned;
    this.setCardOneNetCost(cashbackNetCost);

    var lowInterestNetCost = interestTotalInterest + interestTotalFees;
    this.setCardTwoNetCost(lowInterestNetCost);

    var strResult = "";
    var differeceTotalInterest = cashbackTotalInterest - interestTotalInterest;

    if (differeceTotalInterest < 0) {
        strResult += "<p>The Low Interest card will cost you <strong>" + toCurrency(Math.abs(differeceTotalInterest) + this.getCardTwoTotalFees()) + "</strong> more in interest and fees compared to a Cash Back card over a " + this.getYears() + " year period.</p>";
        if (totalCashRewardEarned > 0) {
            strResult += "<p>Additionally, you will receive a total cash award of <strong>" + toCurrency(totalCashRewardEarned) + "</strong> with the Cash Back card during that period.</p>";
        }

    } else if (differeceTotalInterest > 0) {
        strResult += "<p>The Cash Back card will cost you <strong>" + toCurrency(differeceTotalInterest + this.getTotalFees()) + "</strong> more in interest and fees compared to a Low Interest card over a " + this.getYears() + " year period.</p>";

        if (totalCashRewardEarned > 0) {
            strResult += "<p>However, you will receive a total cash award of <strong>" + toCurrency(totalCashRewardEarned) + "</strong> with the Cash Back card during that period.</p>";
        }

    } else {
        strResult += "<p>The Cash Back card as well as the Low Interest card compare equally in interest and fees over a " + this.getYears() + " year period.<p>";

        if (totalCashRewardEarned > 0) {
            strResult += "<p>However, you will receive a total cash award of <strong>" + toCurrency(totalCashRewardEarned) + "</strong> with the Cash Back card during that period.</p>";
        }
    }

    this.setResult(strResult);
};





