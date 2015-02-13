import mx.controls.gridclasses.DataGridColumn;
import mx.styles.CSSStyleDeclaration;

#include "cccom/airlines_validator.as"
#include "cccom/global_terms_conditions.as"
#include "cccom/global.as"

//set initial focus to balance field
Selection.setFocus("inputscreen.input_scroller.spContentHolder.principal");

var airlines_url = "http://www.creditcards.com/airline-miles.php";
var low_interest_url = "http://www.creditcards.com/low-interest.php";

//init graphs
graphs.chart_scroller.vScrollPolicy = "on";
graphs.chart_scroller.hScrollPolicy = "off";
var chart_fees_source:String = "";
var chart_flight_source:String = "";
var chart_width = 286;
var chart_height = 180;
var totalMonths = 0;

//global obj to hold user inputs. Parameters set in airlines_validator.as file.
var objInputs;


//set text input field styles to bold
var my_fmt:TextFormat = new TextFormat();
my_fmt.bold = true;
inputscreen.input_scroller.spContentHolder.principal.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.cardUseYears.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.purchases.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.monthlyPayments.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.airlinesPromoApr.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.airlinesPromoLength.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.airlinesStandardApr.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.airlinesPromoAnnualFee.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.airlinesStandardAnnualFee.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestPromoApr.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestPromoLength.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestStandardApr.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestPromoAnnualFee.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.interestStandardAnnualFee.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.milesPerDollar.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.milesForApplying.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.maximumMilesYearly.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.milesForFreeTicket.setNewTextFormat(my_fmt);
inputscreen.input_scroller.spContentHolder.standardTicketCost.setNewTextFormat(my_fmt);

var chartContainer1:MovieClip = graphs.chart_scroller.spContentHolder.chart_fees;
var anyChart_fees:AnyChart = new AnyChart(chartContainer1);
anyChart_fees.onLoad = function ():Void {
    //set chart xml
    this.setXMLSourceAsString(chart_fees_source);
}

var chartContainer2:MovieClip = graphs.chart_scroller.spContentHolder.chart_flight;
var anyChart_flight:AnyChart = new AnyChart(chartContainer2);
anyChart_flight.onLoad = function ():Void {
    //set chart xml
    this.setXMLSourceAsString(chart_flight_source);
}
//end - init graphs

function update_chart_flight() {
    chart_flight_source = "<?xml version='1.0'?><root><type><system><refresh enabled='yes'/></system><chart type='2DLine' minimum_argument='0'><animation enabled='yes' speed='50' type='all' appearance='size'/><names show='no' position='bottom' placement='chart'/><values show='no' decimal_places='0' y_offset='-30'><font type='Tahoma' size='14'/></values><arguments show='no' decimal_places='0'></arguments>";
    chart_flight_source += "<hints enabled='yes' auto_size='yes'><border color='0xB9B9B8' size='1'/><background color='0xF4E1C4' /><text><![CDATA[Months: {ARGUMENT}\nCharges: $ {VALUE}]]></text></hints>";
    chart_flight_source += "<line_chart><lines size='2' auto_color='no'/><dots radius='2'><background enabled='no' auto_color='no' color='0xFDCF6C' /><border enabled='yes' size='2' color='0xFDCF6C' /></dots></line_chart></chart><workspace><base_area enabled='no'/><chart_area width='" + chart_width + "' height='" + chart_height + "' deep='0' y='0' x='0'><border enabled='no'/></chart_area><grid><values><lines color='0xB9B9B8' /><captions><font size='12'type='Tahoma'/></captions></values><arguments><lines color='0xB9B9B8' /><captions enabled='yes' ><font size='12' type='Tahoma'/></captions></arguments></grid><x_axis smart='yes' /><y_axis smart='yes' /></workspace></type><data><block color='0x9C0000' border_color='0x9C0000'>";

    var increment = ( (totalMonths > 24) ? Math.floor(totalMonths / 24) : 1 );

    for (var i = 1; i <= totalMonths; i += increment) {
        var spendingNeeded = Math.round(((objInputs.milesForFreeTicket - objInputs.milesForApplying) / objInputs.milesPerDollar) / i);

        chart_flight_source += "<set argument='" + i + "' value ='" + spendingNeeded + "'/>";
    }

    chart_flight_source += "</block></data><objects></objects></root>";

    anyChart_flight.setSWF('/calculators/charts/2DLine.swf');
}

function update_chart_fees(airlinesTotalInterest, interestTotalInterest, airlinesBalanceRemaining, interestBalanceRemaining, totalTicketsEarnedValue) {
    chart_fees_source = "<?xml version='1.0' encoding='utf-8'?><root><type><system><refresh enabled='yes'/></system><chart type='2DColumn' minimum_value='0'><animation enabled='yes' /><column_chart up_space='15' column_space='0' block_space='10'><block_names><font size='10' type='Verdana' bold='yes' align='center' /></block_names><background type='gradient'><colors><color>0x095D8B</color> <color>0xF1F6F9</color><color>0x095D8B</color></colors><alphas><alpha>100</alpha><alpha>50</alpha><alpha>100</alpha></alphas><ratios><ratio>0</ratio><ratio>120</ratio><ratio>0xFF</ratio></ratios> </background></column_chart><hints enabled='no'/><names show='no'/><values decimal_places='0' show='yes'/></chart><workspace><background enabled='no'/><chart_area height='180' width='280' y='40' x='0' deep='0' enabled='yes'/><base_area enabled='no'/><grid><values><captions><font size='9' type='Verdana'/></captions></values></grid> <y_axis smart='yes' /></workspace><legend enabled='yes' x='190' y='0'><values enabled='no'/><header enabled='false'/><names width='150'><font size='9' type='Verdana'/></names><scroller enabled='no'/><border enabled='no'/><background enabled='no'/></legend></type><data>";

    //interest and fees columns
    chart_fees_source += "<block name='Interest &\nFees'>";
    chart_fees_source += "<set value='" + airlinesTotalInterest + "' name='Airlines' color='0x104CC7'><background type='gradient'><colors><color>0x3711C6</color><color>0x104CC7</color><color>0x3711C6</color></colors></background></set>";
    chart_fees_source += "<set value='" + interestTotalInterest + "' name='Low Interest' color='0x009900'><background type='gradient'><colors><color>0x009900</color><color>0x009900</color><color>0x009900</color></colors></background></set>";
    chart_fees_source += "</block>";

    //remaining balance columns
    chart_fees_source += "<block name='Remaining\nBalance'>";
    chart_fees_source += "<set value='" + airlinesBalanceRemaining + "' name='Airlines' color='0x104CC7'><background type='gradient'><colors><color>0x3711C6</color><color>0x104CC7</color><color>0x3711C6</color></colors></background></set>";
    chart_fees_source += "<set value='" + interestBalanceRemaining + "' name='Low Interest' color='0x009900'><background type='gradient'><colors><color>0x009900</color><color>0x009900</color><color>0x009900</color></colors></background></set>";
    chart_fees_source += "</block>";

    //value of free tix columns
    chart_fees_source += "<block name='Value of\nTickets'>";
    chart_fees_source += "<set value='" + totalTicketsEarnedValue + "' name='Airlines' color='0x104CC7'><background type='gradient'><colors><color>0x3711C6</color><color>0x104CC7</color><color>0x3711C6</color></colors></background></set>";
    chart_fees_source += "<set value='0' name='Low Interest' color='0x009900'><background type='gradient'><colors><color>0x009900</color><color>0x009900</color><color>0x009900</color></colors></background></set>";
    chart_fees_source += "</block>";

    chart_fees_source += "</data><objects></objects></root>";

    anyChart_fees.setSWF('/calculators/charts/2DColumn.swf');

    //update chart description
    graphs.chart_scroller.spContentHolder.chartDescription.htmlText = "Compare your interest and fees, remaining balance, and value of free tickets earned at the end of the " + objInputs.cardUseYears + " year period.";
}

function calculate() {
    //validate user entry form
    if (!validateUserInputs()) {
        return false;
    }

    var yearlyMilesEarned = 12 * (objInputs.purchases * objInputs.milesPerDollar);
    //see if total yearly miles exceeds max miles allowed
    yearlyMilesEarned = (yearlyMilesEarned > objInputs.maximumMilesYearly ? objInputs.maximumMilesYearly : yearlyMilesEarned);

    //calculate total miles earned over live of card given monthly purchases
    var totalMilesEarned = objInputs.cardUseYears * yearlyMilesEarned + objInputs.milesForApplying;
    var totalTicketsEarned = Math.floor(totalMilesEarned / objInputs.milesForFreeTicket);
    var totalTicketsEarnedValue = totalTicketsEarned * objInputs.standardTicketCost;

    //show results for above calculations
    resultscreen.totalMilesEarned.html = true;
    resultscreen.totalMilesEarned.htmlText = totalMilesEarned;
    resultscreen.totalTicketsEarned.html = true;
    resultscreen.totalTicketsEarned.htmlText = totalTicketsEarned;
    resultscreen.totalTicketsEarnedValue.html = true;
    resultscreen.totalTicketsEarnedValue.htmlText = toCurrency(totalTicketsEarnedValue);

    //calculate total interest and fees for airlines card
    totalMonths = objInputs.cardUseYears * 12;
    var airlinesRemainingPrincipal = objInputs.principal;
    var airlinesTotalInterest = 0;
    var airlinesTotalFees = 0;
    var interestRemainingPrincipal = objInputs.principal;
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
        if (i > objInputs.airlinesPromoLength) {
            var tmpInterest = ( (airlinesRemainingPrincipal > 0) ? (objInputs.airlinesStandardApr * airlinesRemainingPrincipal) : 0 );

            //add in standard annual fee for start of standard period and for subsequent years
            if ((i != totalMonths) && (totalStandardAirlineMonths % 12 == 0)) {
                airlinesRemainingPrincipal += objInputs.airlinesStandardAnnualFee;
                airlinesTotalFees += objInputs.airlinesStandardAnnualFee;
            }

            totalStandardAirlineMonths++;

        } else {
            //use promo rate

            var tmpInterest = ( (airlinesRemainingPrincipal > 0) ? (objInputs.airlinesPromoApr * airlinesRemainingPrincipal) : 0 );

            //add in promo annual fee for subsequent promo years
            //add 1 to i to get to 13th month. Shouldn't charge fee on 12th month
            //if(((i == 1) || ((i + 1) % 12 == 0)) && (objInputs.airlinesPromoLength >= 12))
            if (((i == 1) && (objInputs.airlinesPromoLength >= 12)) || (((i + 1) % 12 == 0) && (objInputs.airlinesPromoLength > 12))) {
                airlinesRemainingPrincipal += objInputs.airlinesPromoAnnualFee;
                airlinesTotalFees += objInputs.airlinesPromoAnnualFee;
            }
        }

        airlinesTotalInterest += tmpInterest;
        //add in purchases before making payment
        airlinesRemainingPrincipal += (objInputs.purchases + tmpInterest - objInputs.monthlyPayments);


        /**
         *    CALCULATE LOW INTEREST CARD
         */

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

            //add in promo annual fee for subsequent promo years
            //if(((i == 1) || (i % 12 == 0)) && (objInputs.interestPromoLength >= 12))
            if (((i == 1) && (objInputs.interestPromoLength >= 12)) || (((i + 1) % 12 == 0) && (objInputs.interestPromoLength > 12))) {
                interestRemainingPrincipal += objInputs.interestPromoAnnualFee;
                interestTotalFees += objInputs.interestPromoAnnualFee;
            }
        }

        interestTotalInterest += tmpInterest;
        //add in purchases before making payment
        interestRemainingPrincipal += (objInputs.purchases + tmpInterest - objInputs.monthlyPayments);
    }

    //make sure values are not less than zero
    interestRemainingPrincipal = (interestRemainingPrincipal < 0 ? 0 : interestRemainingPrincipal);
    airlinesRemainingPrincipal = (airlinesRemainingPrincipal < 0 ? 0 : airlinesRemainingPrincipal);

    //add fees into total interest
    interestTotalInterest = Math.ceil(interestTotalInterest + interestTotalFees);
    airlinesTotalInterest = Math.ceil(airlinesTotalInterest + airlinesTotalFees);

    //show results for total interest and fees calculations
    resultscreen.airlinesTotalInterest.html = true;
    resultscreen.airlinesTotalInterest.htmlText = toCurrency(airlinesTotalInterest);
    resultscreen.interestTotalInterest.html = true;
    resultscreen.interestTotalInterest.htmlText = toCurrency(interestTotalInterest);

    var strResult = "";
    var differeceTotalInterest = airlinesTotalInterest - interestTotalInterest;

    if (differeceTotalInterest < 0) {
        strResult += "The Airlines card will save you <b>" + toCurrency(Math.abs(differeceTotalInterest)) + "</b> in interest and fees compared to a Low Rate card over a " + objInputs.cardUseYears + " year period.";

        if (totalTicketsEarned > 0) {
            strResult += " Additionally, you would earn <b>" + totalTicketsEarned + " free ticket(s)</b> with the Airlines card, valued at <b>" + toCurrency(totalTicketsEarnedValue) + "</b>.";
        }

    } else if (differeceTotalInterest > 0) {
        strResult += "The Low Interest card will save you <b>" + toCurrency(differeceTotalInterest) + "</b> in interest and fees compared to an Airlines card over a " + objInputs.cardUseYears + " year period.";

        if (totalTicketsEarned > 0) {
            strResult += " However, you would earn <b>" + totalTicketsEarned + " free ticket(s)</b> with the Airlines card, valued at <b>" + toCurrency(totalTicketsEarnedValue) + "</b>.";
        }

    } else {
        strResult += "The Airlines card as well as the Low Interest card compare equally in interest and fees over a " + objInputs.cardUseYears + " year period.";

        if (totalTicketsEarned > 0) {
            strResult += " However, you would earn <b>" + totalTicketsEarned + " free ticket(s)</b> with the Airlines card, valued at <b>" + toCurrency(totalTicketsEarnedValue) + "</b>.";
        }
    }


    resultscreen.resultText.html = true;
    resultscreen.resultText.htmlText = strResult;

    graphs.chart_scroller.spContentHolder.chart1_time_period_text.text = "Time Period: " + objInputs.cardUseYears + " years";

    //pass results to column chart
    update_chart_fees(airlinesTotalInterest, interestTotalInterest, airlinesRemainingPrincipal, interestRemainingPrincipal, totalTicketsEarnedValue);
    update_chart_flight();

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
resultscreen.btn_find_airlines_card.onPress = function () {
    getURL(airlines_url, "_blank");
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
inputscreen.input_scroller.spContentHolder.airlinesPromoApr.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.airlinesPromoLength.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.airlinesStandardApr.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.airlinesPromoAnnualFee.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.airlinesStandardAnnualFee.onChanged = function (textfield_txt:TextField) {
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
inputscreen.input_scroller.spContentHolder.interestPromoAnnualFee.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.interestStandardAnnualFee.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.milesPerDollar.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.milesForApplying.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.maximumMilesYearly.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.milesForFreeTicket.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
inputscreen.input_scroller.spContentHolder.standardTicketCost.onChanged = function (textfield_txt:TextField) {
    disableNav();
};
/*********************************/
/**** END - Button Listeners *****/
/*********************************/