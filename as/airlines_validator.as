function validateUserInputs() {
    var principal = inputscreen.input_scroller.spContentHolder.principal.text;
    var cardUseYears = inputscreen.input_scroller.spContentHolder.cardUseYears.text;
    var purchases = inputscreen.input_scroller.spContentHolder.purchases.text;
    var monthlyPayments = inputscreen.input_scroller.spContentHolder.monthlyPayments.text;

    var airlinesPromoApr = inputscreen.input_scroller.spContentHolder.airlinesPromoApr.text;
    var airlinesPromoLength = inputscreen.input_scroller.spContentHolder.airlinesPromoLength.text;
    var airlinesStandardApr = inputscreen.input_scroller.spContentHolder.airlinesStandardApr.text;
    var airlinesPromoAnnualFee = inputscreen.input_scroller.spContentHolder.airlinesPromoAnnualFee.text;
    var airlinesStandardAnnualFee = inputscreen.input_scroller.spContentHolder.airlinesStandardAnnualFee.text;

    var interestPromoApr = inputscreen.input_scroller.spContentHolder.interestPromoApr.text;
    var interestPromoLength = inputscreen.input_scroller.spContentHolder.interestPromoLength.text;
    var interestStandardApr = inputscreen.input_scroller.spContentHolder.interestStandardApr.text;
    var interestPromoAnnualFee = inputscreen.input_scroller.spContentHolder.interestPromoAnnualFee.text;
    var interestStandardAnnualFee = inputscreen.input_scroller.spContentHolder.interestStandardAnnualFee.text;

    var milesPerDollar = inputscreen.input_scroller.spContentHolder.milesPerDollar.text;
    var milesForApplying = inputscreen.input_scroller.spContentHolder.milesForApplying.text;
    var maximumMilesYearly = inputscreen.input_scroller.spContentHolder.maximumMilesYearly.text;
    var milesForFreeTicket = inputscreen.input_scroller.spContentHolder.milesForFreeTicket.text;
    var standardTicketCost = inputscreen.input_scroller.spContentHolder.standardTicketCost.text;

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

    if ((airlinesPromoApr == "") || checkNonNumber(airlinesPromoApr)) {
        handleError("Please enter a numeric value only for 'Airlines Introductory interest rate'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.airlinesPromoApr = toApr(toFloat(airlinesPromoApr));

    if ((airlinesPromoLength == "") || checkNonNumber(airlinesPromoLength)) {
        handleError("Please enter a numeric value only for 'Airlines Introductory term (months)'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.airlinesPromoLength = toFloat(airlinesPromoLength);

    if ((airlinesStandardApr == "") || checkNonNumber(airlinesStandardApr)) {
        handleError("Please enter a numeric value only for 'Airlines Regular interest rate'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.airlinesStandardApr = toApr(toFloat(airlinesStandardApr));

    if ((airlinesPromoAnnualFee == "") || checkNonNumber(airlinesPromoAnnualFee)) {
        handleError("Please enter a numeric value only for 'Airlines Introductory annual fee'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.airlinesPromoAnnualFee = toFloat(airlinesPromoAnnualFee);

    if ((airlinesStandardAnnualFee == "") || checkNonNumber(airlinesStandardAnnualFee)) {
        handleError("Please enter a numeric value only for 'Airlines Regular annual fee'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.airlinesStandardAnnualFee = toFloat(airlinesStandardAnnualFee);

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

    if ((interestPromoAnnualFee == "") || checkNonNumber(interestPromoAnnualFee)) {
        handleError("Please enter a numeric value only for 'Low Interest Introductory annual fee'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.interestPromoAnnualFee = toFloat(interestPromoAnnualFee);

    if ((interestStandardAnnualFee == "") || checkNonNumber(interestStandardAnnualFee)) {
        handleError("Please enter a numeric value only for 'Low Interest Regular annual fee'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.interestStandardAnnualFee = toFloat(interestStandardAnnualFee);

    if ((milesPerDollar == "") || checkNonNumber(milesPerDollar)) {
        handleError("Please enter a numeric value only for 'Miles earned per dollar spent'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.milesPerDollar = toFloat(milesPerDollar);

    if ((milesForApplying == "") || checkNonNumber(milesForApplying)) {
        handleError("Please enter a numeric value only for 'Miles earned for applying'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.milesForApplying = toFloat(milesForApplying);

    if ((maximumMilesYearly == "") || checkNonNumber(maximumMilesYearly)) {
        handleError("Please enter a numeric value only for 'Maximum miles earned yearly'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.maximumMilesYearly = toFloat(maximumMilesYearly);

    if ((milesForFreeTicket == "") || checkNonNumber(milesForFreeTicket)) {
        handleError("Please enter a numeric value only for 'Miles required for 1 free ticket'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.milesForFreeTicket = toFloat(milesForFreeTicket);

    if ((standardTicketCost == "") || checkNonNumber(standardTicketCost)) {
        handleError("Please enter a numeric value only for 'Regular cost of ticket'. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    objInputs.standardTicketCost = toFloat(standardTicketCost);


    return true;
}