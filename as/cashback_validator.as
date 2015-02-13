function validateUserInputs() {
    var principal = inputscreen.input_scroller.spContentHolder.principal.text;
    var cardUseYears = inputscreen.input_scroller.spContentHolder.cardUseYears.text;
    var purchases = inputscreen.input_scroller.spContentHolder.purchases.text;
    var monthlyPayments = inputscreen.input_scroller.spContentHolder.monthlyPayments.text;

    var cashbackPromoApr = inputscreen.input_scroller.spContentHolder.cashbackPromoApr.text;
    var cashbackPromoLength = inputscreen.input_scroller.spContentHolder.cashbackPromoLength.text;
    var cashbackStandardApr = inputscreen.input_scroller.spContentHolder.cashbackStandardApr.text;
    var cashbackStandardAnnualFee = inputscreen.input_scroller.spContentHolder.cashbackStandardAnnualFee.text;

    var interestPromoApr = inputscreen.input_scroller.spContentHolder.interestPromoApr.text;
    var interestPromoLength = inputscreen.input_scroller.spContentHolder.interestPromoLength.text;
    var interestStandardApr = inputscreen.input_scroller.spContentHolder.interestStandardApr.text;
    var interestStandardAnnualFee = inputscreen.input_scroller.spContentHolder.interestStandardAnnualFee.text;

    var percentEarnedRegular = inputscreen.input_scroller.spContentHolder.percentEarnedRegular.text;
    var percentEarnedBrand = inputscreen.input_scroller.spContentHolder.percentEarnedBrand.text;
    var qualifyingAmount = inputscreen.input_scroller.spContentHolder.qualifyingAmount.text;

    //instantiate new object
    objInputs = new Object();

    /**
     *    check for blank fields
     */
    if ((principal == "") || checkNonNumber(principal)) {
        handleError("Please enter a numeric value only for 'Current balance'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.principal = toFloat(principal);

    if ((cardUseYears == "") || checkNonNumber(cardUseYears)) {
        handleError("Please enter a numeric value only for 'Years you will use card'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.cardUseYears = toFloat(cardUseYears);

    if ((purchases == "") || checkNonNumber(purchases)) {
        handleError("Please enter a numeric value only for 'Monthly charges'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.purchases = toFloat(purchases);

    if ((monthlyPayments == "") || checkNonNumber(monthlyPayments)) {
        handleError("Please enter a numeric value only for 'Estimated monthly payments'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.monthlyPayments = toFloat(monthlyPayments);

    if ((cashbackPromoApr == "") || checkNonNumber(cashbackPromoApr)) {
        handleError("Please enter a numeric value only for 'Cash Back Introductory interest rate'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.cashbackPromoApr = toApr(toFloat(cashbackPromoApr));

    if ((cashbackPromoLength == "") || checkNonNumber(cashbackPromoLength)) {
        handleError("Please enter a numeric value only for 'Cash Back Introductory term (months)'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.cashbackPromoLength = toFloat(cashbackPromoLength);

    if ((cashbackStandardApr == "") || checkNonNumber(cashbackStandardApr)) {
        handleError("Please enter a numeric value only for 'Cash Back Regular interest rate'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.cashbackStandardApr = toApr(toFloat(cashbackStandardApr));

    if ((cashbackStandardAnnualFee == "") || checkNonNumber(cashbackStandardAnnualFee)) {
        handleError("Please enter a numeric value only for 'Cash Back Annual fee'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.cashbackStandardAnnualFee = toFloat(cashbackStandardAnnualFee);

    if ((interestPromoApr == "") || checkNonNumber(interestPromoApr)) {
        handleError("Please enter a numeric value only for 'Low Interest Introductory interest rate'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.interestPromoApr = toApr(toFloat(interestPromoApr));

    if ((interestPromoLength == "") || checkNonNumber(interestPromoLength)) {
        handleError("Please enter a numeric value only for 'Low Interest Introductory term (months)'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.interestPromoLength = toFloat(interestPromoLength);

    if ((interestStandardApr == "") || checkNonNumber(interestStandardApr)) {
        handleError("Please enter a numeric value only for 'Low Interest Regular interest rate'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.interestStandardApr = toApr(toFloat(interestStandardApr));

    if ((interestStandardAnnualFee == "") || checkNonNumber(interestStandardAnnualFee)) {
        handleError("Please enter a numeric value only for 'Low Interest Annual fee'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.interestStandardAnnualFee = toFloat(interestStandardAnnualFee);

    if ((percentEarnedRegular == "") || checkNonNumber(percentEarnedRegular)) {
        handleError("Please enter a numeric value only for '% earned on regular purchases'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.percentEarnedRegular = percentEarnedRegular / 100;

    if ((percentEarnedBrand == "") || checkNonNumber(percentEarnedBrand)) {
        handleError("Please enter a numeric value only for '% earned on specific brand/items'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.percentEarnedBrand = percentEarnedBrand / 100;

    if ((qualifyingAmount == "") || checkNonNumber(qualifyingAmount)) {
        handleError("Please enter a numeric value only for 'Portion of monthly charge that qualifies for brand specific reward'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.qualifyingAmount = toFloat(qualifyingAmount);

    return true;
}