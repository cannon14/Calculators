/*
 Highstock JS v1.3.1 (2013-04-09)
 Prototype adapter

 @author Michael Nelson, Torstein Hønsi.

 Feel free to use and modify this script.
 Highcharts license: www.highcharts.com/license.
 */
var HighchartsAdapter = function () {
    var f = typeof Effect !== "undefined";
    return {
        init: function (a) {
            if (f)Effect.HighchartsTransition = Class.create(Effect.Base, {
                initialize: function (c, b, d, g) {
                    var e;
                    this.element = c;
                    this.key = b;
                    e = c.attr ? c.attr(b) : $(c).getStyle(b);
                    if (b === "d")this.paths = a.init(c, c.d, d), this.toD = d, e = 0, d = 1;
                    this.start(Object.extend(g || {}, {from: e, to: d, attribute: b}))
                }, setup: function () {
                    HighchartsAdapter._extend(this.element);
                    if (!this.element._highchart_animation)this.element._highchart_animation = {};
                    this.element._highchart_animation[this.key] =
                        this
                }, update: function (c) {
                    var b = this.paths, d = this.element;
                    b && (c = a.step(b[0], b[1], c, this.toD));
                    d.attr ? d.element && d.attr(this.options.attribute, c) : (b = {}, b[this.options.attribute] = c, $(d).setStyle(b))
                }, finish: function () {
                    this.element && this.element._highchart_animation && delete this.element._highchart_animation[this.key]
                }
            })
        }, adapterRun: function (a, c) {
            return parseInt($(a).getStyle(c), 10)
        }, getScript: function (a, c) {
            var b = $$("head")[0];
            b && b.appendChild((new Element("script", {type: "text/javascript", src: a})).observe("load",
                c))
        }, addNS: function (a) {
            var c = /^(?:click|mouse(?:down|up|over|move|out))$/;
            return /^(?:load|unload|abort|error|select|change|submit|reset|focus|blur|resize|scroll)$/.test(a) || c.test(a) ? a : "h:" + a
        }, addEvent: function (a, c, b) {
            a.addEventListener || a.attachEvent ? Event.observe($(a), HighchartsAdapter.addNS(c), b) : (HighchartsAdapter._extend(a), a._highcharts_observe(c, b))
        }, animate: function (a, c, b) {
            var d, b = b || {};
            b.delay = 0;
            b.duration = (b.duration || 500) / 1E3;
            b.afterFinish = b.complete;
            if (f)for (d in c)new Effect.HighchartsTransition($(a),
                d, c[d], b); else {
                if (a.attr)for (d in c)a.attr(d, c[d]);
                b.complete && b.complete()
            }
            a.attr || $(a).setStyle(c)
        }, stop: function (a) {
            var c;
            if (a._highcharts_extended && a._highchart_animation)for (c in a._highchart_animation)a._highchart_animation[c].cancel()
        }, each: function (a, c) {
            $A(a).each(c)
        }, inArray: function (a, c) {
            return c.indexOf(a)
        }, offset: function (a) {
            return $(a).cumulativeOffset()
        }, fireEvent: function (a, c, b, d) {
            a.fire ? a.fire(HighchartsAdapter.addNS(c), b) : a._highcharts_extended && (b = b || {}, a._highcharts_fire(c, b));
            b && b.defaultPrevented && (d = null);
            d && d(b)
        }, removeEvent: function (a, c, b) {
            $(a).stopObserving && (c && (c = HighchartsAdapter.addNS(c)), $(a).stopObserving(c, b));
            window === a ? Event.stopObserving(a, c, b) : (HighchartsAdapter._extend(a), a._highcharts_stop_observing(c, b))
        }, washMouseEvent: function (a) {
            return a
        }, grep: function (a, c) {
            return a.findAll(c)
        }, map: function (a, c) {
            return a.map(c)
        }, _extend: function (a) {
            a._highcharts_extended || Object.extend(a, {
                _highchart_events: {},
                _highchart_animation: null,
                _highcharts_extended: !0,
                _highcharts_observe: function (c,
                                               a) {
                    this._highchart_events[c] = [this._highchart_events[c], a].compact().flatten()
                },
                _highcharts_stop_observing: function (a, b) {
                    a ? b ? this._highchart_events[a] = [this._highchart_events[a]].compact().flatten().without(b) : delete this._highchart_events[a] : this._highchart_events = {}
                },
                _highcharts_fire: function (a, b) {
                    var d = this;
                    (this._highchart_events[a] || []).each(function (a) {
                        if (!b.stopped)b.preventDefault = function () {
                            b.defaultPrevented = !0
                        }, b.target = d, a.bind(this)(b) === !1 && b.preventDefault()
                    }.bind(this))
                }
            })
        }
    }
}();
