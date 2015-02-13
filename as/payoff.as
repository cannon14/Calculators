import mx.controls.gridclasses.DataGridColumn;
import mx.styles.CSSStyleDeclaration;

import com.anychart.*;

#include "cccom/global_terms_conditions.as"
#include "cccom/global.as"

var low_interest_url = "http://www.creditcards.com/low-interest.php";

//set initial focus to balance field
Selection.setFocus("inputscreen.userPrincipal");

setTextInputStyles();

//init graphs
graphs.chart_scroller.vScrollPolicy = "on";
graphs.chart_scroller.hScrollPolicy = "off";
var chart_payoff_source:String = "";
var chart_interest_source:String = "";
var chart_width = 286;
var chart_height = 180;
var argumentMax = 12;

//var chartContainer1:MovieClip = graphs.chart_scroller.spContentHolder.createEmptyMovieClip('chartContainer1',this.getNextHighestDepth());
var chartContainer1:MovieClip = graphs.chart_scroller.spContentHolder.chart_payoff;
var anyChart_payoff:AnyChart = new AnyChart(chartContainer1);
anyChart_payoff.onLoad = function ():Void {
    //set chart xml
    this.setXMLSourceAsString(chart_payoff_source);
}

//var chartContainer2:MovieClip = graphs.chart_scroller.spContentHolder.createEmptyMovieClip('chartContainer2',this.getNextHighestDepth());
var chartContainer2:MovieClip = graphs.chart_scroller.spContentHolder.chart_interest;
var anyChart_interest:AnyChart = new AnyChart(chartContainer2);
anyChart_interest.onLoad = function ():Void {
    //set chart xml
    this.setXMLSourceAsString(chart_interest_source);
}
//end - init graphs

function update_chart_interest_paid(resultsArray) {
    chart_interest_source = "<?xml version='1.0'?><root><type><system><refresh enabled='yes'/></system><chart type='2DLine' minimum_argument='0'><animation enabled='yes' speed='50' type='all' appearance='size'/><names show='no' position='bottom' placement='chart'/><values show='no' decimal_places='0' y_offset='-30'><font type='Tahoma' size='14'/></values><arguments show='no' decimal_places='0'></arguments><hints enabled='no'/><line_chart><lines size='2' auto_color='no'/><dots radius='2'><background enabled='yes' auto_color='no' color='White' /><border enabled='yes' size='2' color='0xFDCF6C' /></dots></line_chart></chart><workspace><base_area enabled='no'/><chart_area width='" + chart_width + "' height='" + chart_height + "' deep='0' y='0' x='0'><border enabled='no'/></chart_area><grid><values><lines color='0xB9B9B8' /><captions><font size='12'type='Tahoma'/></captions></values><arguments><lines color='0xB9B9B8' /><captions enabled='yes' ><font size='12' type='Tahoma'/></captions></arguments></grid><x_axis smart='yes' /><y_axis smart='yes' /></workspace></type><data><block color='0x9C0000' border_color='0x9C0000' >";

    var n = Math.floor(resultsArray.length / 12);
    if (n <= 0) {
        n = 1;
    }

    var nodeCount = 1;

    for (var i = 0; i < resultsArray.length; i += n) {
        if (nodeCount == (argumentMax)) {
            chart_interest_source += "<set argument='" + resultsArray[resultsArray.length - 1].month + "' value ='" + Math.round(resultsArray[resultsArray.length - 1].totalInterest) + "'/>";
            break;
        }

        chart_interest_source += "<set argument='" + resultsArray[i].month + "' value ='" + Math.round(resultsArray[i].totalInterest) + "'/>";

        nodeCount++;
    }

    chart_interest_source += "</block></data><objects></objects></root>";

    anyChart_interest.setSWF('/calculators/charts/2DLine.swf');
}


function update_chart_payoff_time(yourMonthlyPayment, rSubUser, principal, startingMonth, purchases) {
    //start plotting 3 months before current startingMonth
    startingMonth = (startingMonth > 5 ? startingMonth - 5 : 0);

    chart_payoff_source = "<?xml version='1.0'?><root><type><system><refresh enabled='yes'/></system><chart type='2DLine' minimum_argument='" + startingMonth + "'><animation enabled='yes' speed='50' type='all' appearance='size'/><names show='no' position='bottom' placement='chart'/><values show='no' decimal_places='0' y_offset='-30'><font type='Tahoma' size='14'/></values><arguments show='no' decimal_places='0'></arguments><hints enabled='no'/><line_chart><lines size='2' auto_color='no'/><dots radius='2'><background enabled='yes' auto_color='no' color='White' /><border enabled='yes' size='2' color='0xFDCF6C' /></dots></line_chart></chart><workspace><base_area enabled='no'/><chart_area width='" + chart_width + "' height='" + chart_height + "' deep='0' y='0' x='0'><border enabled='no'/></chart_area><grid><values><lines color='0xB9B9B8' /><captions><font size='12'type='Tahoma'/></captions></values><arguments><lines color='0xB9B9B8' /><captions enabled='yes' ><font size='12' type='Tahoma'/></captions></arguments></grid><x_axis smart='yes' /><y_axis smart='yes' /></workspace></type><data><block color='0x9C0000' border_color='0x9C0000' >";

    var max = argumentMax + 18;
    var increment = 2;
    var yourMonthlyPaymentFlag = false;

    for (var i = 1; i <= max; i += increment) {
        var monthlyPayment = Math.ceil((rSubUser * principal) / (1 - (Math.pow(1 + rSubUser, -(startingMonth + i)))));
        monthlyPayment += purchases;

        if ((monthlyPayment == (yourMonthlyPayment + purchases)) && (!yourMonthlyPaymentFlag)) {
            chart_payoff_source += "<set argument='" + (startingMonth + i) + "' radius='4' color='0x000000' border_color='0x000000' value ='" + monthlyPayment + "'/>";
            yourMonthlyPaymentFlag = true;
        } else {
            chart_payoff_source += "<set argument='" + (startingMonth + i) + "' value ='" + monthlyPayment + "'/>";
        }
    }

    chart_payoff_source += "</block></data><objects>";
    //chart_payoff_source += "<line value='" + (yourMonthlyPayment+purchases) + "' name='' color='0x009900' size='3'/>";
    chart_payoff_source += "</objects></root>";

    anyChart_payoff.setSWF('/calculators/charts/2DLine.swf');
}

function setTextInputStyles() {
    var my_fmt:TextFormat = new TextFormat();
    my_fmt.bold = true;

    inputscreen.userPrincipal.setNewTextFormat(my_fmt);
    inputscreen.userAPR.setNewTextFormat(my_fmt);
    inputscreen.monthlyPurchases.setNewTextFormat(my_fmt);
    inputscreen.payoffMonths.setNewTextFormat(my_fmt);
    inputscreen.userPayment.setNewTextFormat(my_fmt);
}

function buildChart(resultsArray) {
    var grid = tables.interestGrid;
    grid.sortableColumns = false;

    grid.removeAllColumns();
    var myDP:Array = new Array();
    grid.dataProvider = myDP;

    var col_month:DataGridColumn = grid.addColumn(new DataGridColumn("col_month"));
    col_month.headerText = "Month";
    var col_payment:DataGridColumn = grid.addColumn(new DataGridColumn("col_payment"));
    col_payment.headerText = "Monthly\nPayment";
    var col_principal:DataGridColumn = grid.addColumn(new DataGridColumn("col_principal"));
    col_principal.headerText = "Principal\nPaid*";
    var col_interest:DataGridColumn = grid.addColumn(new DataGridColumn("col_interest"));
    col_interest.headerText = "Interest\nPaid";
    var col_owed:DataGridColumn = grid.addColumn(new DataGridColumn("col_owed"));
    col_owed.headerText = "Remaining\nBalance";
    var col_cumminterest:DataGridColumn = grid.addColumn(new DataGridColumn("col_cumminterest"));
    col_cumminterest.headerText = "Total\nInterest";

    //grid styles
    grid.headerHeight = 38;
    grid.setStyle("textAlign", "center");

    grid.getColumnAt(0).width = 48;
    grid.getColumnAt(1).width = 60;
    grid.getColumnAt(2).width = 60;
    grid.getColumnAt(3).width = 57;
    grid.getColumnAt(4).width = 49;
    grid.getColumnAt(5).width = 72;

    //set styles for grid
    if (_global.styles.DataGrid == undefined) {
        _global.styles.DataGrid = new CSSStyleDeclaration();
    }
    _global.styles.DataGrid.setStyle("borderStyle", "none");
    _global.styles.DataGrid.setStyle("vGridLines", true);
    _global.styles.DataGrid.setStyle("hGridLines", true);
    _global.styles.DataGrid.setStyle("headerColor", 0xFFFFFF);
    _global.styles.DataGrid.setStyle("vGridLineColor", 0xCCCCCC);
    _global.styles.DataGrid.setStyle("hGridLineColor", 0xCCCCCC);
    _global.styles.DataGrid.setStyle("rollOverColor", 0xE8E8E8);


    for (var i = 0; i < resultsArray.length; i++) {
        var obj:Object = {
            col_month: resultsArray[i].month,
            col_payment: toCurrency(Math.round(resultsArray[i].monthlyPayment)),
            col_principal: toCurrency(Math.round(resultsArray[i].principalPaid)),
            col_interest: toCurrency(Math.round(resultsArray[i].interestPaid)),
            col_owed: toCurrency(Math.round(resultsArray[i].remainingPrincipal)),
            col_cumminterest: toCurrency(Math.round(resultsArray[i].totalInterest))
        };
        grid.addItem(obj);
    }
}

function calculate() {
    var monthlyPurchases = inputscreen.monthlyPurchases.text;
    var pmt = inputscreen.userPayment.text;
    var months = inputscreen.payoffMonths.text;
    var principal = inputscreen.userPrincipal.text;
    var apr = inputscreen.userAPR.text;
    var purchases = (monthlyPurchases != "" ? toFloat(monthlyPurchases) : 0);
    var rSubUser = toApr(toFloat(apr));

    //form validation
    if (checkNonNumber(principal)) {
        handleError("Please enter a numeric value only for Current Balance. Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if (checkNonNumber(apr) || (toFloat(apr) >= 100)) {
        handleError("Please enter a numeric value only for Interest Rate (APR). Please do not use special characters like comma, $, #, etc.");
        return false;
    }
    if (checkNonNumber(monthlyPurchases)) {
        handleError("Please enter a numeric value only for Monthly Purchases. Please do not use special characters like comma, $, #, etc.");
        return;
    }
    if ((pmt != "----") && checkNonNumber(pmt)) {
        handleError("Please enter a numeric value only for Desired Monthly Payment. Please do not use special characters like comma, $, #, etc.");
        return;
    }
    if ((months != "---") && checkNonNumber(months)) {
        handleError("Please enter a numeric value only for Desired Months to Pay Off. Please do not use special characters like comma, $, #, etc.");
        return;
    }

    principal = toFloat(principal);
    apr = toFloat(apr);
    purchases = toFloat(purchases);

    var pmtValue = toFloat(pmt);

    if (months != "---") {
        var monthsValue = Math.floor(toFloat(months));

        //make sure the months field is a whole number
        inputscreen.payoffMonths.text = monthsValue;
    }

    if ((pmt != "----") && (pmt != "") && (pmtValue != 0)) {
        if (purchases >= pmtValue) {
            handleError("Your Desired Monthly Payment amount is less than your Monthly Purchase amount and Interest charges. With these values, you will never be able to pay off your balance.<br><br>Please increase the Desired Monthly Payment and try again.");
        } else {
            calculatePayoffMonths(principal, pmtValue, rSubUser, purchases);

            //hide nav button cover so user can now access '/calculators/charts/
            enableNav();
        }

    } else if ((months != "---") && (months != "") && (monthsValue != 0)) {
        calculateMonthlyPayment(principal, monthsValue, rSubUser, purchases);

        //hide nav button cover so user can now access '/calculators/charts/
        enableNav();

    } else {
        //catch-all error
        handleError("Please enter a numeric value only for either Desired Months to Pay Off or Desired Monthly Payment. Please do not use special characters like comma, $, #, etc.");
    }
}

function calculateMonthlyPayment(principal, payoffMonths, rSubUser, purchases) {
    //to hold month objects and be passed to chart and graphs
    var resultsArray = new Array();

    var monthlyPayment = (rSubUser * principal) / (1 - (Math.pow(1 + rSubUser, -payoffMonths)));
    //calc total interest paid before adding in monthly purchases
    var totalInterest = Math.ceil((payoffMonths * monthlyPayment) - principal);
    monthlyPayment = Math.ceil(monthlyPayment) + purchases;


    if (isNaN(monthlyPayment)) {
        handleError("Please enter a numeric value only for all fields. Please do not use special characters like comma, $, #, etc.");

    } else {

        var rst = "At your current rate of spending, it will take payments<br>of <b>" + toCurrency(monthlyPayment) + "</b> per month to pay off your credit card balance<br>in <b>" + payoffMonths + "</b> months.";
        rst += "<br><br>If you were to pay off your debt immediately, you could<br>avoid <b>" + toCurrency(totalInterest) + "</b> in interest costs.";

        //calc monthly payment if payoffMonths was 2 months less
        var lessPayoffMonths = payoffMonths - 2;
        var lessMonthlyPayment = (rSubUser * principal) / (1 - (Math.pow(1 + rSubUser, -lessPayoffMonths)));
        var lessTotalInterest = Math.round((lessPayoffMonths * lessMonthlyPayment) - principal);
        lessTotalInterest = totalInterest - lessTotalInterest;
        lessMonthlyPayment = Math.round(lessMonthlyPayment + purchases);

        if (lessPayoffMonths > 0) {
            var rstSaveMoney = "Paying off your balance 2 months earlier will increase your monthly payment to <b>" + toCurrency(lessMonthlyPayment) + "</b>,";
            rstSaveMoney += " but it will save you <b>" + toCurrency(lessTotalInterest) + "</b> in interest charges in the long run.";
        }

        resultscreen.resultText.htmlText = rst;
        resultscreen.saveMoneyText.htmlText = rstSaveMoney;

        //set monthly payment above chart
        setChartMonthlyPaymentText(monthlyPayment);

        showScreen("resultscreen");

        //take purchases out of monthly payment before passing to graph
        monthlyPayment -= purchases;

        resultsArray = buildMonthlyData(monthlyPayment, rSubUser, principal, payoffMonths, purchases);

        tables.tableTitle.text = "Monthly Statement : Fixed Term";
        buildChart(resultsArray);

        update_chart_payoff_time(monthlyPayment, rSubUser, principal, payoffMonths, purchases);
        update_chart_interest_paid(resultsArray);
    }
}

function setChartMonthlyPaymentText(monthlyPayment) {
    graphs.chart_scroller.spContentHolder.monthlyPaymentBox1.htmlText = "<b>Monthly Payment: " + toCurrency(monthlyPayment) + "</b>";
}

function buildMonthlyData(monthlyPayment, rSubUser, principal, payoffMonths, purchases) {
    var tmpArray = new Array();
    var remainingPrincipal = principal;
    var interestPaid = 0;
    var principalPaid = 0;
    var cummInterest = 0;

    //============= build object array with each month in payoff for chart and graph ==============
    for (var i = 1; i <= payoffMonths; i++) {
        interestPaid = remainingPrincipal * rSubUser;
        cummInterest += interestPaid;

        //add purchases into monthly payment
        if ((remainingPrincipal + interestPaid) < monthlyPayment) {
            totalPayment = remainingPrincipal + interestPaid + purchases;
            principalPaid = remainingPrincipal;
            remainingPrincipal = 0;
        } else {
            principalPaid = monthlyPayment - interestPaid;
            remainingPrincipal -= principalPaid;
            totalPayment = monthlyPayment + purchases;
        }

        var mon = new Object();
        mon.month = i;
        mon.monthlyPayment = totalPayment;
        mon.principalPaid = principalPaid + purchases;
        mon.interestPaid = interestPaid;
        mon.remainingPrincipal = remainingPrincipal;
        mon.totalInterest = cummInterest;

        tmpArray.push(mon);
    }

    return tmpArray;
}

function calculatePayoffMonths(principal, monthlyPayment, rSubUser, purchases) {
    var payoffMonths = (-1 * Math.log(1 - rSubUser * principal / (monthlyPayment - purchases))) / (Math.log(1 + rSubUser));

    if (isNaN(payoffMonths)) {
        handleError("Your Desired Monthly Payment is less than the interest you owe. With these values, you will never be able to pay off your balance.<br><br>Please increase the Desired Monthly Payment and try again.");

    } else {
        //to hold month objects and be passed to chart and graphs
        var resultsArray = new Array();

        var totalInterest = Math.ceil((payoffMonths * (monthlyPayment - purchases)) - principal);

        payoffMonths = Math.ceil(payoffMonths);

        var rst = "At your current rate of spending, it will take <b>" + payoffMonths + "</b> monthly payments of <b>" + toCurrency(monthlyPayment) + "</b> to pay off your credit card balance.";
        rst += "<br><br>If you were to pay off your debt immediately, you could<br>avoid <b>" + toCurrency(totalInterest) + "</b> in interest costs.";

        //calc payoffMonths if payment was $25 more a month
        var lessPayoffMonths = (-1 * Math.log(1 - rSubUser * principal / (monthlyPayment - purchases + 25))) / (Math.log(1 + rSubUser));
        var lessTotalInterest = Math.ceil((lessPayoffMonths * (monthlyPayment - purchases + 25)) - principal);
        lessTotalInterest = totalInterest - lessTotalInterest;
        lessPayoffMonths = Math.ceil(lessPayoffMonths);

        if (lessPayoffMonths > 0) {
            var rstSaveMoney = "You might consider paying more each month.  Reducing your monthly charges or increasing your payment by <b>$ 25</b> per month,";
            rstSaveMoney += " will reduce the months to repay to <b>" + lessPayoffMonths + " months</b> and will save you <b>" + toCurrency(lessTotalInterest) + "</b> in interest charges.";
        }

        resultscreen.resultText.htmlText = rst;
        resultscreen.saveMoneyText.htmlText = rstSaveMoney;

        //set monthly payment above chart
        setChartMonthlyPaymentText(monthlyPayment);

        showScreen("resultscreen");

        //remove purchases from payment
        monthlyPayment -= purchases;

        resultsArray = buildMonthlyData(monthlyPayment, rSubUser, principal, payoffMonths, purchases);

        tables.tableTitle.text = "Monthly Statement : Fixed Payment";
        buildChart(resultsArray);

        update_chart_payoff_time(monthlyPayment, rSubUser, principal, payoffMonths, purchases);
        update_chart_interest_paid(resultsArray);
    }
}

function disableNav() {
    btn_disabled_cover._visible = true;
    btn_disabled_cover.useHandCursor = false;

    btn_results._alpha = "50";
    btn_graphs._alpha = "50";
    btn_tables._alpha = "50";
}

function enableNav() {
    btn_disabled_cover._visible = false;

    btn_results._alpha = "100";
    btn_graphs._alpha = "100";
    btn_tables._alpha = "100";
}

function processTabKey() {
    switch (currentScreen) {
        case "resultscreen":
            showScreen("graphs");
            break;

        case "graphs":
            showScreen("tables");
            break;

        case "tables":
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
inputscreen.btn_calculate.onPress = function () {
    calculate();
}

resultscreen.btn_find_card.onPress = function () {
    getURL(low_interest_url, "_blank");
}

inputscreen.payoffMonths.onChanged = function (textfield_txt:TextField) {
    inputscreen.userPayment.text = "----";
    disableNav();
};

inputscreen.userPayment.onChanged = function (textfield_txt:TextField) {
    inputscreen.payoffMonths.text = "---";
    disableNav();
};

inputscreen.userPrincipal.onChanged = function (textfield_txt:TextField) {
    disableNav();
};

inputscreen.userAPR.onChanged = function (textfield_txt:TextField) {
    disableNav();
};

inputscreen.monthlyPurchases.onChanged = function (textfield_txt:TextField) {
    disableNav();
};

var focusListener:Object = new Object();
focusListener.onSetFocus = function (oldFocus, newFocus) {

    if ((newFocus.text == "---") || (newFocus.text == "----")) {
        newFocus.text = "";
    }
}
Selection.addListener(focusListener);

inputscreen.userPayment.onKillFocus = function (newFocus) {
    if (inputscreen.userPayment.text == "") {
        inputscreen.userPayment.text = "----";
    }
};

inputscreen.payoffMonths.onKillFocus = function (newFocus) {
    if (inputscreen.payoffMonths.text == "") {
        inputscreen.payoffMonths.text = "---";
    }
};

inputscreen.monthlyPurchases.onKillFocus = function (newFocus) {
    if (inputscreen.monthlyPurchases.text == "") {
        inputscreen.monthlyPurchases.text = "0";
    }
};
/*********************************/
/**** END - Button Listeners *****/
/*********************************/


//init function added no 10-26-2010 to support the calculator banner
function init() {
    if (_root.userPrincipal) {
        inputscreen.userPrincipal.text = _root.userPrincipal;
    }
    if (_root.userApr) {
        inputscreen.userAPR.text = _root.userApr;
    }

    if (_root.userPayment) {
        inputscreen.userPayment.text = _root.userPayment;
        inputscreen.payoffMonths.text = "---";
    }
}

init();