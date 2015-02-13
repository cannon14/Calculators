import mx.controls.gridclasses.DataGridColumn;
import mx.styles.CSSStyleDeclaration;

#include "cccom/consolidate_validator.as"
#include "cccom/global_terms_conditions.as"
#include "cccom/global.as"

var balance_transfer_url = "http://www.creditcards.com/balance-transfer.php";
var annualFee;
//holds current card balances and aprs after validation. consolidate_validator.as adds card data to this array.
var currentCards:Array;
//holds monthly data
var currentMonthlyData:Array;
var transferMonthlyData:Array;

//set initial focus to balance field
Selection.setFocus("inputscreen.principal1");

//set text input field styles to bold
var my_fmt:TextFormat = new TextFormat();
my_fmt.bold = true;
inputscreen.principal1.setNewTextFormat(my_fmt);
inputscreen.principal2.setNewTextFormat(my_fmt);
inputscreen.principal3.setNewTextFormat(my_fmt);
inputscreen.principal4.setNewTextFormat(my_fmt);
inputscreen.apr1.setNewTextFormat(my_fmt);
inputscreen.apr2.setNewTextFormat(my_fmt);
inputscreen.apr3.setNewTextFormat(my_fmt);
inputscreen.apr4.setNewTextFormat(my_fmt);
inputscreen.regularAPR.setNewTextFormat(my_fmt);
inputscreen.annualFee.setNewTextFormat(my_fmt);
inputscreen.promoAPR.setNewTextFormat(my_fmt);
inputscreen.promoLength.setNewTextFormat(my_fmt);
inputscreen.transferFeePercent.setNewTextFormat(my_fmt);
inputscreen.transferFeeMaximum.setNewTextFormat(my_fmt);


//init graphs
var chart_cost_source:String = "";
var chart_width = 286;
var chart_height = 180;
var argumentMax = 12;


var chartContainer1:MovieClip = graphs.chart_cost;
var anyChart_cost:AnyChart = new AnyChart(chartContainer1);
anyChart_cost.onLoad = function ():Void {
    //set chart xml
    this.setXMLSourceAsString(chart_cost_source);
}

function update_chart_cost(currentPromoTotalInterest, transferPromoTotalFees, transferPromoTotalInterest) {
    var interestColor = "0x104CC7";
    var feesColor = "0x009900";

    chart_cost_source = "<?xml version='1.0'?><root><type><system><refresh enabled='yes'/></system><chart type='Stacked 2DColumn'><animation enabled='yes' /><values decimal_places='0' /><captions show='yes' text='$ {VALUE}'><font size='12' type='Verdana' color='0xFFFFFF' bold='yes' /></captions><hints enabled='no'/><column_chart left_space='20' right_space='20' block_space='20'><border enabled='no'/><block_names><font size='10' type='Verdana' bold='yes' align='center' /></block_names><background type='gradient'><colors><color>0x095D8B</color> <color>0xF1F6F9</color><color>0x095D8B</color></colors><alphas><alpha>100</alpha><alpha>50</alpha><alpha>100</alpha></alphas><ratios><ratio>0</ratio><ratio>120</ratio><ratio>0xFF</ratio></ratios> </background></column_chart></chart><workspace><background enabled='no'/><base_area enabled='no' /><chart_area height='180' width='280' y='40' x='0' deep='0' enabled='yes'/><grid><values><captions><font size='9' type='Verdana' color='Black'/></captions></values></grid> <y_axis smart='yes' /></workspace><legend enabled='no' x='210' y='0'><values enabled='no'/><header enabled='false'/><names width='150'><font size='9' type='Verdana'/></names><scroller enabled='no'/><border enabled='no'/><background enabled='no'/></legend></type><data>";

    chart_cost_source += "<block name='Current\nCard(s)'>";
    chart_cost_source += "<set value='" + currentPromoTotalInterest + "' name='Interest' color='" + interestColor + "'><background type='gradient'><colors><color>0x3711C6</color><color>0x104CC7</color><color>0x3711C6</color></colors></background></set>";
    //chart_cost_source += "<set value='0' name='Fees' show_value='no' show_argument='no' color='" + feesColor + "'></set>";
    chart_cost_source += "</block>";
    chart_cost_source += "<block name='Balance Transfer\nCard'>";
    chart_cost_source += "<set value='" + transferPromoTotalInterest + "' name='Interest' color='" + interestColor + "'><background type='gradient'><colors><color>0x3711C6</color><color>0x104CC7</color><color>0x3711C6</color></colors></background></set>";
    chart_cost_source += "<set value='" + transferPromoTotalFees + "' name='Fees' color='" + feesColor + "'><background type='gradient'><colors><color>0x009900</color><color>0x009900</color><color>0x009900</color></colors></background></set>";
    chart_cost_source += "</block></data><objects /></root>";

    anyChart_cost.setSWF('/calculators/charts/Stacked2DColumn.swf');
}

function calculate() {
    //init array to hold cards 1-4 interest values - array slots will correspond to card #
    var currentCardsInterestTotals = new Array(0, 0, 0, 0);

    //validate user entry form
    if (!validateUserInputs()) {
        return false;
    }

    //reset values each time form is submitted
    var currentPromoTotalInterest = 0;
    var transferPromoTotalFees = 0;
    var transferPromoTotalInterest = 0;
    var totalPrincipalForTransfer = 0;
    var currentRegularInterest = 0;
    var transferRegularInterest = 0;

    var principal1 = parseFloat(String(inputscreen.principal1.text));
    var principal2 = parseFloat(String(inputscreen.principal2.text));
    var principal3 = parseFloat(String(inputscreen.principal3.text));
    var principal4 = parseFloat(String(inputscreen.principal4.text));
    var apr1 = parseFloat(String(inputscreen.apr1.text));
    var apr2 = parseFloat(String(inputscreen.apr2.text));
    var apr3 = parseFloat(String(inputscreen.apr3.text));
    var apr4 = parseFloat(String(inputscreen.apr4.text));
    var regularAPR = parseFloat(String(inputscreen.regularAPR.text));
    annualFee = parseFloat(String(inputscreen.annualFee.text));
    var promoAPR = parseFloat(String(inputscreen.promoAPR.text));
    var promoLength = parseFloat(String(inputscreen.promoLength.text));
    var transferFeeMaximum = inputscreen.transferFeeMaximum.text;
    transferFeeMaximum = (transferFeeMaximum != "" ? parseFloat(String(inputscreen.transferFeeMaximum.text)) : 0);
    var transferFeePercent = parseFloat(String(inputscreen.transferFeePercent.text));
    transferFeePercent = transferFeePercent / 100;

    //================== ADD IN INITIAL FEES AND TRANSFER CHARGE FOR TRANSFER CARD =====================

    for (var card in currentCards) {
        totalPrincipalForTransfer += currentCards[card][1];
    }

    var balanceTransferCharge = totalPrincipalForTransfer * transferFeePercent;

    //if transfer fees are greater than maximum fee, use max fee
    if (!isNaN(transferFeeMaximum)) {
        if ((balanceTransferCharge > transferFeeMaximum) && (transferFeeMaximum != 0))
            balanceTransferCharge = transferFeeMaximum;
    }

    //add in transfer charge
    transferPromoTotalFees += balanceTransferCharge;

    //add in promo annual fees
    for (var j = 0; j <= promoLength; j += 12) {
        if ((j == 0) || ((j + 1) <= promoLength)) {
            transferPromoTotalFees += annualFee;
        }
    }


    //=============== Calc interest charges from CURRENT CARDS ==============================
    for (var card in currentCards) {
        //cardnum is actually based on card 1-4, not card 0-3
        var cardNum = currentCards[card][0] - 1;
        var p = currentCards[card][1];
        var r = currentCards[card][2];

        var tmpInterest = p * toApr(r);

        currentRegularInterest += tmpInterest;
        currentCardsInterestTotals[cardNum] = tmpInterest * promoLength;
    }

    //add up interest for all cards
    for (var card in currentCardsInterestTotals) {
        currentPromoTotalInterest += currentCardsInterestTotals[card];
    }


    //=============== Calc interest charges from NEW TRANSFER CARD ==============================

    transferPromoTotalInterest += (totalPrincipalForTransfer * toApr(promoAPR)) * promoLength;
    transferRegularInterest = totalPrincipalForTransfer * toApr(regularAPR);

    //=============== Show promo period results================================================

    var totalSavedDuringPromo = Math.round(currentPromoTotalInterest - (transferPromoTotalInterest + transferPromoTotalFees));

    if (totalSavedDuringPromo >= 0) {
        var spendingText = "<b>you will save ";
    } else {
        var spendingText = "<b>you will pay an additional<br>";
        totalSavedDuringPromo *= -1;
    }

    var resultText = "By transferring balances, " + spendingText + toCurrency(totalSavedDuringPromo) + "</b> in interest over the duration of the balance transfer promotion, net of fees of <b>" + toCurrency(transferPromoTotalFees) + "</b>.";


    //================ REGULAR BILLING CYCLE - 1ST MONTH AFTER PROMO ENDS ===============================================

    totalSavedDuringRegularCycle = Math.round(currentRegularInterest - transferRegularInterest);

    if (totalSavedDuringRegularCycle >= 0) {
        var savingsText = "<b>continue to save</b>";
    } else {
        var savingsText = "<b>begin to pay</b>";
        totalSavedDuringRegularCycle *= -1;
    }

    resultText += "<br /><br />After expiration of the promotional period, you will " + savingsText + " approximately <b>" + toCurrency(totalSavedDuringRegularCycle) + "</b> each month, compared to your current situation.";

    //build charts
    update_chart_cost(currentPromoTotalInterest, transferPromoTotalFees, transferPromoTotalInterest);

    //update promotion period text just above graph and below red header
    graphs.chart_promo_period_text.html = true;
    graphs.chart_promo_period_text.htmlText = "Promotional Period: " + promoLength + " months";
    //graphs.chart_promo_period_text.setStyle("fontWeight", "bold");

    //show results
    resultscreen.resultBox.html = true;
    resultscreen.resultBox.htmlText = resultText;
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

resultscreen.btn_find_card.onPress = function () {
    getURL(balance_transfer_url, "_blank");
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
btn_help.onPress = function () {
    showScreen("help");
}
btn_terms.onPress = function () {
    showScreen("terms");
}
errorscreen.btn_ok.onPress = function () {
    clearError();
}
inputscreen.btn_calculate.onPress = function () {
    calculate();
}


inputscreen.principal1.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.principal2.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.principal3.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.principal4.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.apr1.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.apr2.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.apr3.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.apr4.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.regularAPR.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.annualFee.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.promoAPR.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.promoLength.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.transferFeePercent.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.transferFeeMaximum.onChanged = function (textfield_txt:TextField) {
    disableNav();
};

/*********************************/
/**** END - Button Listeners *****/
/*********************************/