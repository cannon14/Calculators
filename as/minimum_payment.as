import mx.controls.gridclasses.DataGridColumn;
import mx.styles.CSSStyleDeclaration;

#include "cccom/global_terms_conditions.as"
#include "cccom/global.as"

/** BEGIN - INIT **/

var low_interest_url = "http://www.creditcards.com/low-interest.php";

buildMinimumPaymentDropdown();
buildMinimumPercentageDropdown();

var cb = _global.styles.ComboBox = new mx.styles.CSSStyleDeclaration();
cb.color = 0x000000;
cb.fontFamily = "Verdana";
cb.fontWeight = "bold";

inputscreen.calculateMinimum.setStyle("fontWeight", "bold");
inputscreen.minimumPayment.setStyle("fontWeight", "bold");

//set initial focus to balance field
Selection.setFocus(inputscreen.userPrincipal);

/** END - INIT **/

function buildChart(dp) {
    var grid = tables.interestGrid;
    grid.sortableColumns = false;
    grid.removeAllColumns();

    var month:DataGridColumn = grid.addColumn(new DataGridColumn("month"));
    month.headerText = "Month";
    var payment:DataGridColumn = grid.addColumn(new DataGridColumn("payment"));
    payment.headerText = "Minimum\nPayment";
    var principal:DataGridColumn = grid.addColumn(new DataGridColumn("principal"));
    principal.headerText = "Principal\nPaid";
    var interest:DataGridColumn = grid.addColumn(new DataGridColumn("interest"));
    interest.headerText = "Interest\nPaid";
    var owed:DataGridColumn = grid.addColumn(new DataGridColumn("owed"));
    owed.headerText = "Remaining\nBalance";
    var col_cumminterest:DataGridColumn = grid.addColumn(new DataGridColumn("cummInterestFormatted"));
    col_cumminterest.headerText = "Total\nInterest";

    //grid styles
    grid.headerHeight = 38;
    grid.setStyle("textAlign", "center");

    grid.getColumnAt(0).width = 48;
    grid.getColumnAt(1).width = 60;
    grid.getColumnAt(2).width = 60;
    grid.getColumnAt(3).width = 55;
    grid.getColumnAt(4).width = 46;
    grid.getColumnAt(5).width = 74;

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

    //set data provider of grid to new data param
    grid.dataProvider = dp;
}

//init graphs
var chart_interest_source:String = "";
var chart_width = 286;
var chart_height = 180;
var argumentMax = 12;


var chartContainer1:MovieClip = graphs.chart_interest;
var anyChart_interest:AnyChart = new AnyChart(chartContainer1);
anyChart_interest.onLoad = function ():Void {
    //set chart xml
    this.setXMLSourceAsString(chart_interest_source);
}
//end - init graphs

function update_chart_interest_paid(resultsArray) {
    chart_interest_source = "<?xml version='1.0'?><root><type><system><refresh enabled='yes'/></system><chart type='2DLine' minimum_argument='0'><animation enabled='yes' speed='50' type='all' appearance='size'/><names show='no' position='bottom' placement='chart'/><values show='no' decimal_places='0' y_offset='-30'><font type='Tahoma' size='14'/></values><arguments show='no' decimal_places='0'></arguments><hints enabled='no'/><line_chart><lines size='2' auto_color='no'/><dots radius='2'><background enabled='yes' auto_color='no' color='White' /><border enabled='yes' size='2' color='0xFDCF6C' /></dots></line_chart></chart><workspace><base_area enabled='no'/><chart_area width='" + chart_width + "' height='" + chart_height + "' deep='0' y='0' x='0'><border enabled='no'/></chart_area><grid><values><lines color='0xB9B9B8' /><captions><font size='12'type='Tahoma'/></captions></values><arguments><lines color='0xB9B9B8' /><captions enabled='yes' ><font size='12' type='Tahoma'/></captions></arguments></grid><x_axis smart='yes' /><y_axis smart='yes' /></workspace></type><data><block color='0x9C0000' border_color='0x9C0000' >";

    var n = Math.floor(resultsArray.length / 12);
    var nodeCount = 1;

    for (var i = 0; i < resultsArray.length; i += n) {
        if (nodeCount == argumentMax) {
            chart_interest_source += "<set argument='" + resultsArray[resultsArray.length - 1].month + "' value ='" + Math.round(resultsArray[resultsArray.length - 1].cummInterest) + "'/>";
            break;
        }

        chart_interest_source += "<set argument='" + resultsArray[i].month + "' value ='" + Math.round(resultsArray[i].cummInterest) + "'/>";

        nodeCount++;
    }

    chart_interest_source += "</block></data><objects></objects></root>";

    anyChart_interest.setSWF('/calculators/charts/2DLine.swf');
}

function buildMinimumPercentageDropdown() {
    var fld = inputscreen.calculateMinimum;

    for (var i = 2; i <= 5; i += .5) {
        fld.addItem({data: i, label: i + "%"});
    }

    //add interest + 1%
    fld.addItem({data: 99, label: "interest + 1%"});

    //preselect a default value
    fld.selectedIndex = 2;
}

function buildMinimumPaymentDropdown() {
    var fld = inputscreen.minimumPayment;

    for (var i = 10; i <= 30; i += 5) {
        fld.addItem({data: i, label: toCurrency(i)});
    }

    //preselect a default value
    fld.selectedIndex = 3;
}

function calculate() {
    var principal = inputscreen.userPrincipal.text;
    var apr = inputscreen.userAPR.text;
    var calculateMinimum = inputscreen.calculateMinimum.selectedItem.data;
    var minimumPayment = inputscreen.minimumPayment.selectedItem.data;

    // --- form validation ---
    if (checkNonNumber(principal)) {
        handleError("Please enter a numeric value only for Current Balance. Please do not use special characters like comma, $, #, etc.");
        return false;
    }

    if (checkNonNumber(apr) || (toFloat(apr) >= 100)) {
        handleError("Please enter a numeric value only for Interest Rate (APR). Please do not use special characters like comma, $, #, etc.");
        return false;
    }

    principal = toFloat(principal);
    apr = toFloat(apr);

    calculatePayoffMonths(principal, apr, calculateMinimum, minimumPayment);
}

function calculatePayoffMonths(principal, apr, calculateMinimum, minimumPayment) {
    //build data provider array for data table
    var dp = new Array();

    //start off with total principal
    var principalOwed = principal;
    var interest = 0;
    var principalPaid = 0;
    var cummInterest = 0;
    //user APR
    var rSubUser = toApr(apr);
    var calculatedPayment = 0;
    var payment = 0;
    var payoffMonths = 0;

    while (principalOwed > 0) {
        payoffMonths++;

        interest = principalOwed * rSubUser;
        cummInterest += interest;

        if (calculateMinimum == 99) {
            calculatedPayment = (principalOwed * .01) + interest;
        } else {
            calculatedPayment = principalOwed * (calculateMinimum / 100);
        }

        payment = Math.max(calculatedPayment, minimumPayment);

        //if payment is too high for amount owed plus interest
        if ((interest + principalOwed) > payment) {
            principalPaid = payment - interest;
            principalOwed -= principalPaid;

        } else {
            principalPaid = principalOwed;
            payment = principalOwed + interest;
            principalOwed = 0;
        }

        dp.addItem({
            month: payoffMonths,
            payment: toCurrency(Math.round(payment)),
            cummInterestFormatted: toCurrency(Math.round(cummInterest)),
            cummInterest: Math.round(cummInterest),
            interest: toCurrency(Math.round(interest)),
            principal: toCurrency(Math.round(principalPaid)),
            owed: toCurrency(Math.round(principalOwed))
        });
    }

    buildChart(dp);
    update_chart_interest_paid(dp);

    var resultStr = "It will take you <b>" + payoffMonths + "</b> months to pay off your debt, if you make minimum monthly payments on a balance of <b>" + toCurrency(principal) + "</b> with a <b>" + apr + "% APR</b>.";
    resultStr += " In that time, you will pay <b>" + toCurrency(Math.round(cummInterest)) + "</b> in interest charges.";
    resultStr += "<br><br>We recommend that you pay more than the minimum payment whenever possible. If you make only the minimum payment each month, it will take you longer and cost you more to clear your balance.";

    resultscreen.resultText.html = true;
    resultscreen.resultText.htmlText = resultStr;

    showScreen("resultscreen");
    enableNav();
}

function disableNav() {
    btn_disabled_cover._visible = true;
    btn_disabled_cover.useHandCursor = false;

    btn_results._alpha = "50";
    btn_tables._alpha = "50";
    btn_graphs._alpha = "50";
}

function enableNav() {
    btn_disabled_cover._visible = false;

    btn_results._alpha = "100";
    btn_tables._alpha = "100";
    btn_graphs._alpha = "100";
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

resultscreen.btn_find_interest_card.onPress = function () {
    getURL(low_interest_url, "_blank");
}

btn_inputs.onPress = function () {
    showScreen("inputscreen");
}
btn_results.onPress = function () {
    showScreen("resultscreen");
}
btn_tables.onPress = function () {
    showScreen("tables");
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

//listener for #1 current balance entry
inputscreen.userPrincipal.onChanged = function (textfield_txt:TextField) {
    disableNav();
};

//listener for #2 current balance entry
inputscreen.userAPR.onChanged = function (textfield_txt:TextField) {
    disableNav();
};

//listener for 3-a dropdown
var listener3a:Object = new Object();
listener3a.change = function (event_obj:Object) {
    disableNav();
};
inputscreen.calculateMinimum.addEventListener("change", listener3a);


//listener for 3-b dropdown
var listener3b:Object = new Object();
listener3b.change = function (event_obj:Object) {
    disableNav();
};
inputscreen.minimumPayment.addEventListener("change", listener3b);

/*********************************/
/**** END - Button Listeners *****/
/*********************************/