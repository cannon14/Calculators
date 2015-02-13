import mx.controls.gridclasses.DataGridColumn;
import mx.styles.CSSStyleDeclaration;

#include "cccom/cashback_validator.as"
#include "cccom/global_terms_conditions.as"
#include "cccom/global.as"

//set initial focus to balance field
Selection.setFocus("inputscreen.input_scroller.spContentHolder.principal");

var cashback_url = "http://www.creditcards.com/cash-back.php";
var low_interest_url = "http://www.creditcards.com/low-interest.php";

//init graphs
var chart_fees_source:String = "";
var chart_width = 286;
var chart_height = 180;
var totalMonths = 0;

//global obj to hold user inputs. Parameters set in cashback_validator.as file.
var objInputs;


//set text input field styles to bold
var my_fmt:TextFormat = new TextFormat();
my_fmt.bold = true;
inputscreen.input_scroller.spContentHolder.principal.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.cardUseYears.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.purchases.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.monthlyPayments.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.cashbackPromoApr.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.cashbackPromoLength.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.cashbackStandardApr.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.cashbackStandardAnnualFee.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestPromoApr.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestPromoLength.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestStandardApr.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestStandardAnnualFee.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.percentEarnedRegular.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.percentEarnedBrand.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.qualifyingAmount.setNewTextFormat(my_fmt);

var chartContainer1:MovieClip = graphs.chart_fees;
var anyChart_fees:AnyChart = new AnyChart(chartContainer1);
anyChart_fees.onLoad = function ():Void {
    //set chart xml
    this.setXMLSourceAsString(chart_fees_source);
}

function update_chart_fees(cashbackTotalInterest, interestTotalInterest, totalCashRewardEarned) {
    chart_fees_source = "<?xml version='1.0' encoding='utf-8'?><root><type><system><refresh enabled='yes'/></system><chart type='2DColumn' minimum_value='0'><animation enabled='yes' /><column_chart up_space='15' column_space='0' block_space='10'><block_names><font size='10' type='Verdana' bold='yes' /></block_names><background type='gradient'><colors><color>0x095D8B</color> <color>0xF1F6F9</color><color>0x095D8B</color></colors><alphas><alpha>100</alpha><alpha>50</alpha><alpha>100</alpha></alphas><ratios><ratio>0</ratio><ratio>120</ratio><ratio>0xFF</ratio></ratios> </background></column_chart><hints enabled='no'/><names show='no'/><values decimal_places='0' show='yes'/></chart><workspace><background enabled='no'/><chart_area height='180' width='280' y='40' x='0' deep='0' enabled='yes'/><base_area enabled='no'/><grid><values><captions><font size='9' type='Verdana'/></captions></values></grid> <y_axis smart='yes' /></workspace><legend enabled='yes' x='190' y='0'><values enabled='no'/><header enabled='false'/><names width='150'><font size='9' type='Verdana'/></names><scroller enabled='no'/><border enabled='no'/><background enabled='no'/></legend></type><data>";

    //interest and fees columns
    chart_fees_source += "<block name='Interest & Fees'>";
    chart_fees_source += "<set value='" + cashbackTotalInterest + "' name='Cash Back' color='0x104CC7'><background type='gradient'><colors><color>0x3711C6</color><color>0x104CC7</color><color>0x3711C6</color></colors></background></set>";
    chart_fees_source += "<set value='" + interestTotalInterest + "' name='Low Interest' color='0x009900'><background type='gradient'><colors><color>0x009900</color><color>0x009900</color><color>0x009900</color></colors></background></set>";
    chart_fees_source += "</block>";

    //value of free tix columns
    chart_fees_source += "<block name='Cash Award Earned'>";
    chart_fees_source += "<set value='" + totalCashRewardEarned + "' name='Cash Back' color='0x104CC7'><background type='gradient'><colors><color>0x3711C6</color><color>0x104CC7</color><color>0x3711C6</color></colors></background></set>";
    chart_fees_source += "<set value='0' name='Low Interest' color='0x009900'><background type='gradient'><colors><color>0x009900</color><color>0x009900</color><color>0x009900</color></colors></background></set>";
    chart_fees_source += "</block>";

    chart_fees_source += "</data><objects></objects></root>";

    anyChart_fees.setSWF('/calculators/charts/2DColumn.swf');

    //update chart description
    graphs.chartDescription.html = true;
    graphs.chartDescription.htmlText = "This graph compares interest and fees paid with a cash back and low interest card.  It also shows the total amount earned in cash awards at the end of " + objInputs.cardUseYears + " years.";
}

function calculate() {
    //validate user entry form
    if (!validateUserInputs()) {
        return false;
    }

    //calculate total interest and fees for cashback card
    totalMonths = objInputs.cardUseYears * 12;
    var cashbackRemainingPrincipal = objInputs.principal;
    var cashbackTotalInterest = 0;
    var cashbackTotalFees = 0;
    var interestRemainingPrincipal = objInputs.principal;
    var interestTotalInterest = 0;
    var interestTotalFees = 0;
    //track standard interest period in case promo length is not 12 months
    var totalStandardCashBackMonths = 0;
    var totalStandardInterestMonths = 0;

    //calculate total cash reward earned for totalMonths used
    var totalRegularCashRewardEarned = (objInputs.qualifyingAmount * objInputs.percentEarnedBrand) * totalMonths;
    var totalBrandCashRewardEarned = ((objInputs.purchases - objInputs.qualifyingAmount) * objInputs.percentEarnedRegular) * totalMonths;
    var totalCashRewardEarned = Math.floor(totalRegularCashRewardEarned + totalBrandCashRewardEarned);

    //show results for above calculations
    resultscreen.totalCashEarned.html = true;
    resultscreen.totalCashEarned.htmlText = toCurrency(totalCashRewardEarned);


    //cycle through months to calculate
    for (var i = 1; i <= totalMonths; i++) {
        //	CALCULATE cashback CARD

        //use standard rate
        if (i > objInputs.cashbackPromoLength) {
            var tmpInterest = ( (cashbackRemainingPrincipal > 0) ? (objInputs.cashbackStandardApr * cashbackRemainingPrincipal) : 0 );

            //add in standard annual fee for start of standard period and for subsequent years
            if ((i != totalMonths) && (totalStandardCashBackMonths % 12 == 0)) {
                cashbackRemainingPrincipal += objInputs.cashbackStandardAnnualFee;
                cashbackTotalFees += objInputs.cashbackStandardAnnualFee;
            }

            totalStandardCashBackMonths++;

        } else {
            //use promo rate

            var tmpInterest = ( (cashbackRemainingPrincipal > 0) ? (objInputs.cashbackPromoApr * cashbackRemainingPrincipal) : 0 );
        }

        cashbackTotalInterest += tmpInterest;
        //add in purchases before making payment
        cashbackRemainingPrincipal += (objInputs.purchases + tmpInterest - objInputs.monthlyPayments);


        //	CALCULATE LOW INTEREST CARD

        //use standard rate
        if (i > objInputs.interestPromoLength) {
            var tmpInterest = ( (interestRemainingPrincipal > 0) ? (objInputs.interestStandardApr * interestRemainingPrincipal) : 0 );

            //add in standard annual fee for start of standard period and for subsequent years
            if ((i != totalMonths) && (totalStandardInterestMonths % 12 == 0)) {
                interestRemainingPrincipal += objInputs.interestStandardAnnualFee;
                interestTotalFees += objInputs.interestStandardAnnualFee;
            }

            totalStandardInterestMonths++;

        } else {
            //use promo rate

            var tmpInterest = ( (interestRemainingPrincipal > 0) ? (objInputs.interestPromoApr * interestRemainingPrincipal) : 0);
        }

        interestTotalInterest += tmpInterest;
        //add in purchases before making payment
        interestRemainingPrincipal += (objInputs.purchases + tmpInterest - objInputs.monthlyPayments);
    }

    //make sure values are not less than zero
    interestRemainingPrincipal = (interestRemainingPrincipal < 0 ? 0 : interestRemainingPrincipal);
    cashbackRemainingPrincipal = (cashbackRemainingPrincipal < 0 ? 0 : cashbackRemainingPrincipal);

    //add fees into total interest
    interestTotalInterest = Math.round(interestTotalInterest + interestTotalFees);
    cashbackTotalInterest = Math.round(cashbackTotalInterest + cashbackTotalFees);

    //show results for total interest and fees calculations
    resultscreen.cashbackTotalInterest.html = true;
    resultscreen.cashbackTotalInterest.htmlText = toCurrency(cashbackTotalInterest);
    resultscreen.interestTotalInterest.html = true;
    resultscreen.interestTotalInterest.htmlText = toCurrency(interestTotalInterest);

    var netCost = cashbackTotalInterest - totalCashRewardEarned;
    var netCostStr = ((netCost < 0) ? toCurrency(Math.abs(netCost)) + " savings" : toCurrency(Math.abs(netCost)));

    resultscreen.netCost.html = true;
    resultscreen.netCost.htmlText = netCostStr;
    resultscreen.interestTotalInterest2.html = true;
    resultscreen.interestTotalInterest2.htmlText = toCurrency(interestTotalInterest);

    var strResult = "";
    var differeceTotalInterest = cashbackTotalInterest - interestTotalInterest;

    if (differeceTotalInterest < 0) {
        strResult += "The Low Interest card will cost you <b>" + toCurrency(Math.abs(differeceTotalInterest)) + "</b> more in interest and fees compared to a Cash Back card over a " + objInputs.cardUseYears + " year period.";
        if (totalCashRewardEarned > 0) {
            strResult += " Additionally, you will receive a total cash award of <b>" + toCurrency(totalCashRewardEarned) + "</b> with the Cash Back card during that period.";
        }

    } else if (differeceTotalInterest > 0) {
        strResult += "The Cash Back card will cost you <b>" + toCurrency(differeceTotalInterest) + "</b> more in interest and fees compared to a Low Interest card over a " + objInputs.cardUseYears + " year period.";

        if (totalCashRewardEarned > 0) {
            strResult += " However, you will receive a total cash award of <b>" + toCurrency(totalCashRewardEarned) + "</b> with the Cash Back card during that period.";
        }

    } else {
        strResult += "The Cash Back card as well as the Low Interest card compare equally in interest and fees over a " + objInputs.cardUseYears + " year period.";

        if (totalCashRewardEarned > 0) {
            strResult += " However, you will receive a total cash award of <b>" + toCurrency(totalCashRewardEarned) + "</b> with the Cash Back card during that period.";
        }
    }


    resultscreen.resultText.html = true;
    resultscreen.resultText.htmlText = strResult;

    graphs.chart1_time_period_text.text = "Time Period: " + objInputs.cardUseYears + " years";

    //pass results to column chart
    update_chart_fees(cashbackTotalInterest, interestTotalInterest, totalCashRewardEarned);

    enableNav();
    showScreen("resultscreen");
}

function disableNav() {
    btn_disabled_cover._visible = true;
    btn_disabled_cover.useHandCursor = false;

    btn_results._alpha = "50";
    btn_graphs._alpha = "50";
}

function enableNav() {
    btn_disabled_cover._visible = false;

    btn_results._alpha = "100";
    btn_graphs._alpha = "100";
}

function processTabKey() {
    switch (currentScreen) {
        case "resultscreen":
            showScreen("graphs");
            break;

        case "graphs":
            showScreen("help");
            break;

        case "help":
            showScreen("inputscreen");
            break;

        case "terms":
            showScreen("inputscreen");
            break;
    }
}

/***********************************/
/**** BEGIN - Button Listeners *****/
/***********************************/
resultscreen.btn_find_cashback_card.onPress = function () {
    getURL(cashback_url, "_blank");
}
resultscreen.btn_find_interest_card.onPress = function () {
    getURL(low_interest_url, "_blank");
}

btn_inputs.onPress = function () {
    showScreen("inputscreen");
}
btn_results.onPress = function () {
    showScreen("resultscreen");
}
btn_graphs.onPress = function () {
    showScreen("graphs");
}
btn_tables.onPress = function () {
    showScreen("tables");
}
btn_help.onPress = function () {
    showScreen("help");
}
btn_terms.onPress = function () {
    showScreen("terms");
}

errorscreen.btn_ok.onPress = function () {
    clearError();
}
inputscreen.input_scroller.spContentHolder.btn_calculate.onPress = function () {
    calculate();
}


inputscreen.input_scroller.spContentHolder.principal.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.cardUseYears.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.purchases.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.monthlyPayments.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.cashbackPromoApr.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.cashbackPromoLength.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.cashbackStandardApr.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.cashbackStandardAnnualFee.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.interestPromoApr.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.interestPromoLength.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.interestStandardApr.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.interestStandardAnnualFee.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.percentEarnedRegular.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.percentEarnedBrand.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.qualifyingAmount.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
/*********************************/
/**** END - Button Listeners *****/
/*********************************/