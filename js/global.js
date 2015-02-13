/*
 *	Contains global functions used in all calculators.
 */

/**
 * Converts a percentage to an annual interest rate.
 * @param apr
 * @returns {number}
 */
function toApr(apr) {
    var intRate = apr / 100;

    return intRate;
}

/**
 * Converts a percentage to a monthly percentage rate.
 * @param apr
 * @returns {number}
 */
function toMpr(apr) {
    var intRate = apr / 100 / 12;

    return intRate
}

/**
 * Converts a percentage to a decimal
 * @param apr
 * @returns {number}
 */
function toDecimal(percentage) {
    var decimal = percentage / 100;

    return decimal;
}

/**
 * Round value to the nearest hundredth.
 * @param value
 * @returns {number}
 */
function roundMoney(value) {
    return Math.round(value * 100) / 100;
}

/**
 * Add a percent sign to a value.
 * @param param
 * @returns {string}
 */
function toPercentage(param) {
    return param + "%"
}

/**
 * Show a value as a dollar amount.
 * @param param
 * @returns {string}
 */
function toCurrency(param) {
    return "$" + toFloat(param).toFixed(2);
}

/**
 * Converts a string to a float.
 * @param param
 * @returns {Number}
 */
function toFloat(param) {
    return (parseFloat((String(param).trim())));
}

/**
 * Converts a string to an Integer.
 * @param param
 * @returns {Number}
 */
function toInt(param) {
    return (parseInt((String(param).trim())));
}