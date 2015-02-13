/* 
 * This Calculator compares the Airlines and Low Interest Credit Cards.
 *
 * @author David Cannon
 * @date Jan 2014
 */
function AirlineLowInterestCalculator() {

    if (!(this instanceof AirlineLowInterestCalculator)) {
        return new AirlineLowInterestCalculator();
    }

    Calculator.call(this);

    this.milesPerDollar = 0;
    this.milesToApply = 0;
    this.maxYearlyMiles = 0;
    this.milesToFreeTicket = 0;
    this.costOfTicket = 0;
    this.totalMilesEarned = 0;
    this.totalTicketsEarned = 0;
    this.totalValueOfTickets = 0;
    this.cardOneTotalInterestAndFees = 0;
    this.cardTwoTotalInterestAndFees = 0;
}

// inherit Calculator
AirlineLowInterestCalculator.prototype = new ComparisonCalculator();

// correct the constructor pointer because it points to Calculator
AirlineLowInterestCalculator.prototype.constructor = AirlineLowInterestCalculator;

AirlineLowInterestCalculator.prototype.setMilesPerDollar = function (miles) {
    this.milesPerDollar = toInt(miles);
};

AirlineLowInterestCalculator.prototype.getMilesPerDollar = function () {
    return this.milesPerDollar;
};

AirlineLowInterestCalculator.prototype.setMilesToApply = function (miles) {
    this.milesToApply = toInt(miles);
};

AirlineLowInterestCalculator.prototype.getMilesToApply = function () {
    return this.milesToApply;
};

AirlineLowInterestCalculator.prototype.setMaxYearlyMiles = function (miles) {
    this.maxYearlyMiles = toInt(miles);
};

AirlineLowInterestCalculator.prototype.getMaxYearlyMiles = function () {
    return this.maxYearlyMiles;
};

AirlineLowInterestCalculator.prototype.setMilesToFreeTicket = function (miles) {
    this.milesToFreeTicket = toInt(miles);
};

AirlineLowInterestCalculator.prototype.getMilesToFreeTicket = function () {
    return this.milesToFreeTicket;
};

AirlineLowInterestCalculator.prototype.setCostOfTicket = function (cost) {
    this.costOfTicket = cost;
};

AirlineLowInterestCalculator.prototype.getCostOfTicket = function () {
    return this.costOfTicket;
};

AirlineLowInterestCalculator.prototype.setTotalMilesEarned = function (miles) {
    this.totalMilesEarned = toInt(miles);
};

AirlineLowInterestCalculator.prototype.getTotalMilesEarned = function () {
    return this.totalMilesEarned;
};

AirlineLowInterestCalculator.prototype.setTotalTicketsEarned = function (tickets) {
    this.totalTicketsEarned = toInt(tickets);
};

AirlineLowInterestCalculator.prototype.getTotalTicketsEarned = function () {
    return this.totalTicketsEarned;
};

AirlineLowInterestCalculator.prototype.setTotalValueOfTickets = function (value) {
    this.totalValueOfTickets = toFloat(value);
};

AirlineLowInterestCalculator.prototype.getTotalValueOfTickets = function () {
    return this.totalValueOfTickets;
};

AirlineLowInterestCalculator.prototype.setCardOneTotalInterestAndFees = function (amount) {
    this.cardOneTotalInterestAndFees = toFloat(amount);
};

AirlineLowInterestCalculator.prototype.getCardOneTotalInterestAndFees = function () {
    return this.cardOneTotalInterestAndFees;
};

AirlineLowInterestCalculator.prototype.setCardTwoTotalInterestAndFees = function (amount) {
    this.cardTwoTotalInterestAndFees = toFloat(amount);
};

AirlineLowInterestCalculator.prototype.getCardTwoTotalInterestAndFees = function () {
    return this.cardTwoTotalInterestAndFees;
};

/**
 * Calculate the data needed for tables and charts.
 */
AirlineLowInterestCalculator.prototype.calculateDataPoints = function () {

    var yearlyMilesEarned = 12 * (this.getMonthlyCharges() * this.getMilesPerDollar());
    //see if total yearly miles exceeds max miles allowed
    yearlyMilesEarned = (yearlyMilesEarned > this.getMaxYearlyMiles() ? this.getMaxYearlyMiles() : yearlyMilesEarned);

    //calculate total miles earned over live of card given monthly purchases
    var totalMilesEarned = this.getYears() * yearlyMilesEarned + this.getMilesToApply();
    var totalTicketsEarned = Math.floor(totalMilesEarned / this.getMilesToFreeTicket());
    var totalTicketsEarnedValue = totalTicketsEarned * this.getCostOfTicket();

    this.setTotalMilesEarned(totalMilesEarned);
    this.setTotalTicketsEarned(totalTicketsEarned);
    this.setTotalValueOfTickets(roundMoney(totalTicketsEarnedValue));

    //calculate total interest and fees for airlines card
    var totalMonths = this.getYears() * 12;
    var airlinesRemainingPrincipal = this.getPrincipal();
    var airlinesTotalInterest = 0;
    var airlinesTotalFees = 0;
    var interestRemainingPrincipal = this.getPrincipal();
    var interestTotalInterest = 0;
    var interestTotalFees = 0;
    //track standard interest period in case promo length is not 12 months
    var totalStandardAirlineMonths = 0;
    var totalStandardInterestMonths = 0;

    //cycle through months to calculate
    for (var i = 1; i <= totalMonths; i++) {
        /**
         *    CALCULATE AIRLINES CARD
         */
        //use standard rate
        if (i > this.getCardOneIntroTerm()) {
            var tempInterest = ( (airlinesRemainingPrincipal > 0) ? (toMpr(this.getApr()) * airlinesRemainingPrincipal) : 0 );

            //add in standard annual fee for start of standard period and for subsequent years
            if ((i != totalMonths) && (totalStandardAirlineMonths % 12 == 0)) {
                airlinesRemainingPrincipal += this.getAnnualFee();
                airlinesTotalFees += this.getAnnualFee();
            }
            totalStandardAirlineMonths++;

        } else {
            //use promo rate

            var tempInterest = ( (airlinesRemainingPrincipal > 0) ? (toMpr(this.getCardOneIntroApr()) * airlinesRemainingPrincipal) : 0 );

            //add in promo annual fee for subsequent promo years
            //add 1 to i to get to 13th month. Shouldn't charge fee on 12th month
            //if(((i == 1) || ((i + 1) % 12 == 0)) && (objInputs.airlinesPromoLength >= 12))
            if (((i == 1) && (this.getCardOneIntroTerm() >= 12)) || (((i + 1) % 12 == 0) && (this.getCardOneIntroTerm() > 12))) {
                airlinesRemainingPrincipal += this.getCardOneIntroAnnualFee();
                airlinesTotalFees += this.getCardOneIntroAnnualFee();
            }
        }

        airlinesTotalInterest += tempInterest;
        //add in purchases before making payment
        airlinesRemainingPrincipal += (this.getMonthlyCharges() + tempInterest - this.getMonthlyPayment());


        /**
         *    CALCULATE LOW INTEREST CARD
         */

        //use standard rate
        if (i > this.getCardTwoIntroTerm()) {
            var tempInterest = ( (interestRemainingPrincipal > 0) ? (toMpr(this.getCardTwoApr()) * interestRemainingPrincipal) : 0 );

            //add in standard annual fee for start of standard period and for subsequent years
            if ((i != totalMonths) && (totalStandardInterestMonths % 12 == 0)) {
                interestRemainingPrincipal += this.getCardTwoAnnualFee();
                interestTotalFees += this.getCardTwoAnnualFee();
            }

            totalStandardInterestMonths++;

        } else {
            //use promo rate

            var tempInterest = ( (interestRemainingPrincipal > 0) ? (toMpr(this.getCardTwoIntroApr()) * interestRemainingPrincipal) : 0);

            //add in promo annual fee for subsequent promo years
            //if(((i == 1) || (i % 12 == 0)) && (objInputs.interestPromoLength >= 12))
            if (((i == 1) && (this.getCardTwoIntroTerm() >= 12)) || (((i + 1) % 12 == 0) && (this.getCardTwoIntroTerm() > 12))) {
                interestRemainingPrincipal += this.getCardTwoIntroAnnualFee();
                interestTotalFees += this.getCardTwoIntroAnnualFee();
            }
        }

        interestTotalInterest += tempInterest;
        //add in purchases before making payment
        interestRemainingPrincipal += (this.getMonthlyCharges() + tempInterest - this.getMonthlyPayment());
    }

    //make sure values are not less than zero
    interestRemainingPrincipal = (interestRemainingPrincipal < 0 ? 0 : interestRemainingPrincipal);
    airlinesRemainingPrincipal = (airlinesRemainingPrincipal < 0 ? 0 : airlinesRemainingPrincipal);

    this.setCardOneRemainingBalance(roundMoney(airlinesRemainingPrincipal));
    this.setCardTwoRemainingBalance(roundMoney(interestRemainingPrincipal));

    //add fees into total interest
    interestTotalInterest = roundMoney(interestTotalInterest + interestTotalFees);
    airlinesTotalInterest = roundMoney(airlinesTotalInterest + airlinesTotalFees);

    this.setCardOneTotalInterestAndFees(roundMoney(airlinesTotalInterest));
    this.setCardTwoTotalInterestAndFees(roundMoney(interestTotalInterest));

    var strResult = "";
    var differeceTotalInterest = airlinesTotalInterest - interestTotalInterest;

    if (differeceTotalInterest < 0) {
        strResult += "The Airlines card will save you <strong>" + toCurrency(Math.abs(differeceTotalInterest)) + "</strong> in interest and fees compared to a Low Rate card over a " + this.getYears() + " year period.";

        if (totalTicketsEarned > 0) {
            strResult += " Additionally, you would earn <strong>" + totalTicketsEarned + " free ticket(s)</strong> with the Airlines card, valued at <strong>" + toCurrency(totalTicketsEarnedValue) + "</strong>.";
        }

    } else if (differeceTotalInterest > 0) {
        strResult += "The Low Interest card will save you <strong>" + toCurrency(differeceTotalInterest) + "</strong> in interest and fees compared to an Airlines card over a " + this.getYears() + " year period.";

        if (totalTicketsEarned > 0) {
            strResult += " However, you would earn <strong>" + totalTicketsEarned + " free ticket(s)</strong> with the Airlines card, valued at <strong>" + toCurrency(totalTicketsEarnedValue) + "</strong>.";
        }

    } else {
        strResult += "The Airlines card as well as the Low Interest card compare equally in interest and fees over a " + this.getYears() + " year period.";

        if (totalTicketsEarned > 0) {
            strResult += " However, you would earn <strong>" + totalTicketsEarned + " free ticket(s)</strong> with the Airlines card, valued at <strong>" + toCurrency(totalTicketsEarnedValue) + "</strong>.";
        }
    }

    this.setResult(strResult);
};





