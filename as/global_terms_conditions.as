/**
 * Load terms & conditions from text file to flash.
 * If it fails, use default terms embedded in flash file.
 */
var termsUrl = "calc_terms_conditions.txt";

var lv:LoadVars = new LoadVars();
lv.onLoad = function (success:Boolean) {
    if (success) {
        terms.scroller.contentPath = "termsuse_loaded";
        terms.scroller.spContentHolder.terms.htmlText = this.terms;
    } else {
        terms.scroller.contentPath = "termsuse_default";
    }
};
lv.load(termsUrl);


//set copyright date in footer
currentDate = new Date();
copyright_date.text = "Copyright " + currentDate.getFullYear() + " CreditCards.com";