/**
 *    Contains global functions used in all calculators.
 *
 *
 */

Stage.showMenu = false;

var currentScreen = "inputscreen";

//disable results, graphs, tables buttons until user calculates for first time
disableNav();


function processEnterKey() {
    switch (currentScreen) {
        case "inputscreen":
            calculate();
            break;

        case "errorscreen":
            clearError();
            break;
    }
}

var keyListener:Object = new Object();
keyListener.onKeyDown = function () {
    switch (Key.getCode()) {
        case Key.ENTER :
            processEnterKey();
            break;

        case Key.TAB :
            processTabKey();
            break;
    }
};
Key.addListener(keyListener);

function toApr(apr) {
    var rSubUser = apr / 100 / 12;

    if (rSubUser <= 0) {
        // feign lim as n->0
        rSubUser = .000000001;
    }

    return rSubUser;
}

function cropCents(amount) {
    return amount.split(".", 1);
}

function toCurrency(param) {
    return "$ " + param;
}

function handleError(msg) {
    errorscreen.errorMessage.htmlText = msg;
    showScreen("errorscreen");
}

function clearError() {
    inputscreen.errorMessage.htmlText = "";
    showScreen("inputscreen");
}

function toFloat(param) {
    return (parseFloat(trim(String(param))));
}

/**
 *    check for a numeric value. Returns true if it is not a number.
 */
function checkNonNumber(param) {
    if ((isNaN(parseFloat(trim(String(param))))) || isNaN(trim(param)) || (param == "")) {
        return true;
    }

    return false;
}

function trim(param) {
    while (param.charAt(0) == " ") {
        param = param.substring(1, param.length);
    }
    while (param.charAt(param.length - 1) == " ") {
        param = param.substring(0, param.length - 1);
    }

    return param;
}

function showScreen(screenname:String) {
    inputscreen.visible = screenname == "inputscreen";
    resultscreen.visible = screenname == "resultscreen";
    graphs.visible = screenname == "graphs";
    tables.visible = screenname == "tables";
    help.visible = screenname == "help";
    errorscreen.visible = screenname == "errorscreen";
    terms.visible = screenname == "terms";

    currentScreen = screenname;
}