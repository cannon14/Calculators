function validateUserInputs() {
    var principal1 = inputscreen.principal1.text;
    var principal2 = inputscreen.principal2.text;
    var principal3 = inputscreen.principal3.text;
    var principal4 = inputscreen.principal4.text;
    var apr1 = inputscreen.apr1.text;
    var apr2 = inputscreen.apr2.text;
    var apr3 = inputscreen.apr3.text;
    var apr4 = inputscreen.apr4.text;
    var regularAPR = inputscreen.regularAPR.text;
    var annualFee = inputscreen.annualFee.text;
    var promoAPR = inputscreen.promoAPR.text;
    var promoLength = inputscreen.promoLength.text;
    var transferFeePercent = inputscreen.transferFeePercent.text;
    var transferFeeMaximum = inputscreen.transferFeeMaximum.text;

    //validate current credit cards - check for any value entered
    if (((trim(principal2) != "") && (trim(apr2) == "")) || ((trim(principal2) == "") && (trim(apr2) != ""))) {
        handleError("Please enter a value for both Balance and Interest Rate (APR) for Credit Card #2.");
        return false;
    } else if (((trim(principal3) != "") && (trim(apr3) == "")) || ((trim(principal3) == "") && (trim(apr3) != ""))) {
        handleError("Please enter a value for both Balance and Interest Rate (APR) for Credit Card #3.");
        return false;
    } else if (((trim(principal4) != "") && (trim(apr4) == "")) || ((trim(principal4) == "") && (trim(apr4) != ""))) {
        handleError("Please enter a value for both Balance and Interest Rate (APR) for Credit Card #4.");
        return false;
    }

    if ((principal1 == "") || (checkNonNumber(principal1))) {
        handleError("Please enter a numeric value only for Balance for Credit Card #1. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if ((apr1 == "") || (checkNonNumber(apr1))) {
        handleError("Please enter a numeric value only for Interest Rate (APR) for Credit Card #1. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if ((principal2 != "") && (checkNonNumber(principal2))) {
        handleError("Please enter a numeric value only for Balance for Credit Card #2. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if ((apr2 != "") && (checkNonNumber(apr2))) {
        handleError("Please enter a numeric value only for Interest Rate (APR) for Credit Card #2. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if ((principal3 != "") && (checkNonNumber(principal3))) {
        handleError("Please enter a numeric value only for Balance for Credit Card #3. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if ((apr3 != "") && (checkNonNumber(apr3))) {
        handleError("Please enter a numeric value only for Interest Rate (APR) for Credit Card #3. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if ((principal4 != "") && (checkNonNumber(principal4))) {
        handleError("Please enter a numeric value only for Balance for Credit Card #4. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if ((apr4 != "") && (checkNonNumber(apr4))) {
        handleError("Please enter a numeric value only for Interest Rate (APR) for Credit Card #4. Please do not use special characters like comma, $, #, etc.");
        return false;
    }

    //validate transfer card
    if (checkNonNumber(regularAPR)) {
        handleError("Please enter a numeric value only for Regular Interest Rate (APR). Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if (checkNonNumber(annualFee)) {
        handleError("Please enter a numeric value only for Annual Fee. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if (checkNonNumber(promoAPR)) {
        handleError("Please enter a numeric value only for Introductory Interest Rate (APR). Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if (checkNonNumber(promoLength)) {
        handleError("Please enter a numeric value only for Introductory Term (months). Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if (checkNonNumber(transferFeePercent)) {
        handleError("Please enter a numeric value only for Balance Transfer Fee - % of Balance. Please do not use special characters like comma, $, #, etc.");
        return false;
    }

    if ((trim(transferFeeMaximum) != "") && (isNaN(trim(transferFeeMaximum)))) {
        handleError("Please enter a numeric value only for Balance Transfer Fee - Maximum Fee. Please do not use special characters like comma, $, #, etc.");
        return false;
    }

    if (toFloat(trim(transferFeeMaximum)) == 0) {
        handleError("Please enter a numeric value for Balance Transfer Fee - Maximum Fee that is greater than zero. It may also be left blank.");
        return false;
    }

    /**
     *    Store current credit card in global array so we don't have to check it again during calculate
     */
    currentCards = new Array();

    //convert values to numbers
    principal1 = toFloat(principal1);
    principal2 = toFloat(principal2);
    principal3 = toFloat(principal3);
    principal4 = toFloat(principal4);
    apr1 = toFloat(apr1);
    apr2 = toFloat(apr2);
    apr3 = toFloat(apr3);
    apr4 = toFloat(apr4);


    /**
     *    Check for current card data and add to global array to avoid double-checking later.
     */

    //1st credit card is required and has already been validated
    var tmpArr = new Array(1, principal1, apr1);
    currentCards.push(tmpArr);

    if (_cardDataPresent(principal2, apr2)) {
        var tmpArr = new Array(2, principal2, apr2);
        currentCards.push(tmpArr);
    }

    if (_cardDataPresent(principal3, apr3)) {
        var tmpArr = new Array(3, principal3, apr3);
        currentCards.push(tmpArr);
    }

    if (_cardDataPresent(principal4, apr4)) {
        var tmpArr = new Array(4, principal4, apr4);
        currentCards.push(tmpArr);
    }


    return true;
}


function _cardDataPresent(balance, apr) {
    if (isNaN(balance) || isNaN(apr)) {
        return false;
    }

    return true;
}