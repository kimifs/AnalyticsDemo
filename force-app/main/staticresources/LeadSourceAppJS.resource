//LEAD SOURCE APP
// Dependencies - in order
// json2.js
// URL
// Base64.js
// CookieHandler.js
// Util.js
// Server.js
// VisitorProfile.js
// Page.js

// BEGIN json2.js
/*
    json2.js
    2013-05-26

    Public Domain.

    NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.

    See http://www.JSON.org/js.html


    This code should be minified before deployment.
    See http://javascript.crockford.com/jsmin.html

    USE YOUR OWN COPY. IT IS EXTREMELY UNWISE TO LOAD CODE FROM SERVERS YOU DO
    NOT CONTROL.


    This file creates a global JSON object containing two methods: stringify
    and parse.

        JSON.stringify(value, replacer, space)
            value       any JavaScript value, usually an object or array.

            replacer    an optional parameter that determines how object
                        values are stringified for objects. It can be a
                        function or an array of strings.

            space       an optional parameter that specifies the indentation
                        of nested structures. If it is omitted, the text will
                        be packed without extra whitespace. If it is a number,
                        it will specify the number of spaces to indent at each
                        level. If it is a string (such as '\t' or '&nbsp;'),
                        it contains the characters used to indent at each level.

            This method produces a JSON text from a JavaScript value.

            When an object value is found, if the object contains a toJSON
            method, its toJSON method will be called and the result will be
            stringified. A toJSON method does not serialize: it returns the
            value represented by the name/value pair that should be serialized,
            or undefined if nothing should be serialized. The toJSON method
            will be passed the key associated with the value, and this will be
            bound to the value

            For example, this would serialize Dates as ISO strings.

                Date.prototype.toJSON = function (key) {
                    function f(n) {
                        // Format integers to have at least two digits.
                        return n < 10 ? '0' + n : n;
                    }

                    return this.getUTCFullYear()   + '-' +
                         f(this.getUTCMonth() + 1) + '-' +
                         f(this.getUTCDate())      + 'T' +
                         f(this.getUTCHours())     + ':' +
                         f(this.getUTCMinutes())   + ':' +
                         f(this.getUTCSeconds())   + 'Z';
                };

            You can provide an optional replacer method. It will be passed the
            key and value of each member, with this bound to the containing
            object. The value that is returned from your method will be
            serialized. If your method returns undefined, then the member will
            be excluded from the serialization.

            If the replacer parameter is an array of strings, then it will be
            used to select the members to be serialized. It filters the results
            such that only members with keys listed in the replacer array are
            stringified.

            Values that do not have JSON representations, such as undefined or
            functions, will not be serialized. Such values in objects will be
            dropped; in arrays they will be replaced with null. You can use
            a replacer function to replace those with JSON values.
            JSON.stringify(undefined) returns undefined.

            The optional space parameter produces a stringification of the
            value that is filled with line breaks and indentation to make it
            easier to read.

            If the space parameter is a non-empty string, then that string will
            be used for indentation. If the space parameter is a number, then
            the indentation will be that many spaces.

            Example:

            text = JSON.stringify(['e', {pluribus: 'unum'}]);
            // text is '["e",{"pluribus":"unum"}]'


            text = JSON.stringify(['e', {pluribus: 'unum'}], null, '\t');
            // text is '[\n\t"e",\n\t{\n\t\t"pluribus": "unum"\n\t}\n]'

            text = JSON.stringify([new Date()], function (key, value) {
                return this[key] instanceof Date ?
                    'Date(' + this[key] + ')' : value;
            });
            // text is '["Date(---current time---)"]'


        JSON.parse(text, reviver)
            This method parses a JSON text to produce an object or array.
            It can throw a SyntaxError exception.

            The optional reviver parameter is a function that can filter and
            transform the results. It receives each of the keys and values,
            and its return value is used instead of the original value.
            If it returns what it received, then the structure is not modified.
            If it returns undefined then the member is deleted.

            Example:

            // Parse the text. Values that look like ISO date strings will
            // be converted to Date objects.

            myData = JSON.parse(text, function (key, value) {
                var a;
                if (typeof value === 'string') {
                    a =
/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)Z$/.exec(value);
                    if (a) {
                        return new Date(Date.UTC(+a[1], +a[2] - 1, +a[3], +a[4],
                            +a[5], +a[6]));
                    }
                }
                return value;
            });

            myData = JSON.parse('["Date(09/09/2001)"]', function (key, value) {
                var d;
                if (typeof value === 'string' &&
                        value.slice(0, 5) === 'Date(' &&
                        value.slice(-1) === ')') {
                    d = new Date(value.slice(5, -1));
                    if (d) {
                        return d;
                    }
                }
                return value;
            });


    This is a reference implementation. You are free to copy, modify, or
    redistribute.
*/

/*jslint evil: true, regexp: true */

/*members "", "\b", "\t", "\n", "\f", "\r", "\"", JSON, "\\", apply,
    call, charCodeAt, getUTCDate, getUTCFullYear, getUTCHours,
    getUTCMinutes, getUTCMonth, getUTCSeconds, hasOwnProperty, join,
    lastIndex, length, parse, prototype, push, replace, slice, stringify,
    test, toJSON, toString, valueOf
*/


// Create a JSON object only if one does not already exist. We create the
// methods in a closure to avoid creating global variables.

if (typeof JSON !== 'object') {
    JSON = {};
}

(function () {
    'use strict';

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function () {

            return isFinite(this.valueOf())
                ? this.getUTCFullYear()     + '-' +
                    f(this.getUTCMonth() + 1) + '-' +
                    f(this.getUTCDate())      + 'T' +
                    f(this.getUTCHours())     + ':' +
                    f(this.getUTCMinutes())   + ':' +
                    f(this.getUTCSeconds())   + 'Z'
                : null;
        };

        String.prototype.toJSON      =
            Number.prototype.toJSON  =
            Boolean.prototype.toJSON = function () {
                return this.valueOf();
            };
    }

    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        gap,
        indent,
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {

// If the string contains no control characters, no quote characters, and no
// backslash characters, then we can safely slap some quotes around it.
// Otherwise we must also replace the offending characters with safe escape
// sequences.

        escapable.lastIndex = 0;
        return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
            var c = meta[a];
            return typeof c === 'string'
                ? c
                : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + string + '"';
    }


    function str(key, holder) {

// Produce a string from holder[key].

        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

// If the value has a toJSON method, call it to obtain a replacement value.

        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

// If we were called with a replacer function, then call the replacer to
// obtain a replacement value.

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

// What happens next depends on the value's type.

        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':

// JSON numbers must be finite. Encode non-finite numbers as null.

            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':

// If the value is a boolean or null, convert it to a string. Note:
// typeof null does not produce 'null'. The case is included here in
// the remote chance that this gets fixed someday.

            return String(value);

// If the type is 'object', we might be dealing with an object or an array or
// null.

        case 'object':

// Due to a specification blunder in ECMAScript, typeof null is 'object',
// so watch out for that case.

            if (!value) {
                return 'null';
            }

// Make an array to hold the partial results of stringifying this object value.

            gap += indent;
            partial = [];

// Is the value an array?

            if (Object.prototype.toString.apply(value) === '[object Array]') {

// The value is an array. Stringify every element. Use null as a placeholder
// for non-JSON values.

                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }

// Join all of the elements together, separated with commas, and wrap them in
// brackets.

                v = partial.length === 0
                    ? '[]'
                    : gap
                    ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
                    : '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }

// If the replacer is an array, use it to select the members to be stringified.

            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    if (typeof rep[i] === 'string') {
                        k = rep[i];
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {

// Otherwise, iterate through all of the keys in the object.

                for (k in value) {
                    if (Object.prototype.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }

// Join all of the member texts together, separated with commas,
// and wrap them in braces.

            v = partial.length === 0
                ? '{}'
                : gap
                ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }

// If the JSON object does not yet have a stringify method, give it one.

    if (typeof JSON.stringify !== 'function') {
        JSON.stringify = function (value, replacer, space) {

// The stringify method takes a value and an optional replacer, and an optional
// space parameter, and returns a JSON text. The replacer can be a function
// that can replace values, or an array of strings that will select the keys.
// A default replacer method can be provided. Use of the space parameter can
// produce text that is more easily readable.

            var i;
            gap = '';
            indent = '';

// If the space parameter is a number, make an indent string containing that
// many spaces.

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

// If the space parameter is a string, it will be used as the indent string.

            } else if (typeof space === 'string') {
                indent = space;
            }

// If there is a replacer, it must be a function or an array.
// Otherwise, throw an error.

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                    typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

// Make a fake root object containing our value under the key of ''.
// Return the result of stringifying the value.

            return str('', {'': value});
        };
    }


// If the JSON object does not yet have a parse method, give it one.

    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {

// The parse method takes a text and an optional reviver function, and returns
// a JavaScript value if the text is a valid JSON text.

            var j;

            function walk(holder, key) {

// The walk method is used to recursively walk the resulting structure so
// that modifications can be made.

                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }


// Parsing happens in four stages. In the first stage, we replace certain
// Unicode characters with escape sequences. JavaScript handles many characters
// incorrectly, either silently deleting them, or treating them as line endings.

            text = String(text);
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

// In the second stage, we run the text against regular expressions that look
// for non-JSON patterns. We are especially concerned with '()' and 'new'
// because they can cause invocation, and '=' because it can cause mutation.
// But just to be safe, we want to reject all unexpected forms.

// We split the second stage into 4 regexp operations in order to work around
// crippling inefficiencies in IE's and Safari's regexp engines. First we
// replace the JSON backslash pairs with '@' (a non-JSON character). Second, we
// replace all simple value tokens with ']' characters. Third, we delete all
// open brackets that follow a colon or comma or that begin the text. Finally,
// we look to see that the remaining characters are only whitespace or ']' or
// ',' or ':' or '{' or '}'. If that is so, then the text is safe for eval.

            if (/^[\],:{}\s]*$/
                    .test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@')
                        .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                        .replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

// In the third stage we use the eval function to compile the text into a
// JavaScript structure. The '{' operator is subject to a syntactic ambiguity
// in JavaScript: it can begin a block or an object literal. We wrap the text
// in parens to eliminate the ambiguity.

                j = eval('(' + text + ')');

// In the optional fourth stage, we recursively walk the new structure, passing
// each name/value pair to a reviver function for possible transformation.

                return typeof reviver === 'function'
                    ? walk({'': j}, '')
                    : j;
            }

// If the text is not JSON parseable, then a SyntaxError is thrown.

            throw new SyntaxError('JSON.parse');
        };
    }
}());


/**
 jQuery plugin methods interface, in order to keep the backward compatibility
*/

(function($) {

    $.toJSON = function(o)
    {
        if (typeof(JSON) == 'object' && JSON.stringify)
            return JSON.stringify(o);

    };


    $.evalJSON = function(src)
    {
        if (typeof(JSON) == 'object' && JSON.parse)
            return JSON.parse(src);
    };

    $.secureEvalJSON = function(src)
    {
        if (typeof(JSON) == 'object' && JSON.parse)
            return JSON.parse(src);

    };
})(jQuery);
// END json2.js

// BEGIN URL
/**
*
*  URL encode / decode
*
**/
var Url = {
    encode : function (string) {
        return encodeURI(string);
    }

    ,decode : function (string) {
        return decodeURI(string);
    }

    ,encodeComponent : function (string) {
        return encodeURIComponent(string);
    }

    ,decodeComponent : function (string) {
        return decodeURIComponent(string);
    }

    /* Appends CDN domain if applicable for the file extension and type.
       Reads from /system/modules/_common/templates/includes/js-settings to get "domainPrefixes" map.
    */
    ,getFullUrl : function(url) {
        try {
            // ignore URLs that have "http://", "https://" or "//" at the beginning
            var ignoreRegEx = /^(https?:)?\/\//
            var noDomain = (url.match(ignoreRegEx) == null);
            var dotIndex = url.lastIndexOf(".");
            var domainPrefixes = com.salesforce.www.App.config.domainPrefixes;

            if (noDomain && dotIndex > 0 && domainPrefixes != null) {
                var ext = url.substring(dotIndex+1);
                var domainPrefix = domainPrefixes[ext];
                if (domainPrefix != null) {
                    // if relative URL, then get the base path name from current page, e.g. image.png --> /path/path/image.png
                    if (url.indexOf("/") != 0) {
                        var path = document.location.pathname;
                        url = path.substring(0, path.lastIndexOf('/')+1) + url;
                    }
                    return domainPrefix + url;
                }
            }
        } catch(e) {
            // do nothing
        }
        return url;
    }

}
// END URL.js

// BEGIN Base64.js
/**
*
*  Base64 encode / decode
*  http://www.webtoolkit.info/
*
**/
var Base64 = {
    // private property
    _keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

    // public method for encoding
    encode : function (input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;

        input = Base64._utf8_encode(input);

        while (i < input.length) {
            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);

            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;

            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }

            output = output +
            this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
            this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
        }

        return output;
    },

    // public method for decoding
    decode : function (input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;

        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

        while (i < input.length) {
            enc1 = this._keyStr.indexOf(input.charAt(i++));
            enc2 = this._keyStr.indexOf(input.charAt(i++));
            enc3 = this._keyStr.indexOf(input.charAt(i++));
            enc4 = this._keyStr.indexOf(input.charAt(i++));

            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            output = output + String.fromCharCode(chr1);

            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }

        output = Base64._utf8_decode(output);

        return output;
    },

    // private method for UTF-8 encoding
    _utf8_encode : function (string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);

            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
        }

        return utftext;
    },

    // private method for UTF-8 decoding
    _utf8_decode : function (utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;

        while ( i < utftext.length ) {
            c = utftext.charCodeAt(i);

            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i+1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i+1);
                c3 = utftext.charCodeAt(i+2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }
        }

        return string;
    }
}
// END Base64.js

// BEGIN CookieHandler.js
/**
*
*  Javascript cookies
*  http://www.webtoolkit.info/
*
**/
function CookieHandler() {
    this.setCookie = function (name, value, seconds, domain) {
        domain = domain ? domain : Server.getCookieDomain();
        var expires = "";
        var expiresNow = "";
        var date = new Date();
        date.setTime(date.getTime() + (-1*1000));
        expiresNow = "; expires=" + date.toGMTString();

        if (typeof(seconds) != 'undefined') {
            date.setTime(date.getTime() + (seconds*1000));
            expires = "; expires=" + date.toGMTString();
        }

        // fix production scoping issues
        // keep writing the old cookie, but make it expire
        document.cookie = name + "=" + value + expiresNow + "; path=/";
        // now just set the right one
        document.cookie = name + "=" + value + expires + "; path=/; domain=" + domain;
    }

    this.getCookie = function (name) {
        name = name + "=";
        var carray = document.cookie.split(';');

        for(var i=0;i < carray.length;i++) {
            var c = carray[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
        }

        return null;
    }

    this.deleteCookie = function (name) {
        this.setCookie(name, "", -1);
        this.setCookie(name, "", -1, document.location.hostname);
    }
}
// END CookieHandler.js

// BEGIN Util.js
var Util = Util || {} ;

(function($){

    $.extend(Util, {

        ua : navigator.userAgent
        ,isTouch : "createTouch" in document

        ,isOkAMO: function (str) {
             return typeof str === 'string'  && str.length <= 100 && /^[a-zA-Z0-9\-@:_]+$/.test(str);
        }

        // client-side redirect w/ cookies
        ,redirect : function (destination) {
            var cookiejar = new CookieHandler();
            var referrer = document.referrer ? document.referrer : '';
            cookiejar.setCookie('referrer',escape(referrer),60); // 60 seconds
            top.location.href = destination;
        }

        ,isValidJson : function (jsonString) {
            if (!jsonString) {
                return false;
            }
            return !(/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(jsonString.replace(/"(\\.|[^"\\])*"/g, ''))) && eval('(' + jsonString + ')');
        }

        ,parseJSON : function(str) {
            if (!str) {
                return {};
            }
            return $.secureEvalJSON(str);
        }

        ,toJSON : function(obj) {
            if (!obj) {
                return '';
            }
            return $.toJSON(obj);
        }

        ,getCookie : function(cookieName) {
            var cookieVal = (new CookieHandler()).getCookie(cookieName);
            cookieVal = cookieVal == null ? '' : Url.decodeComponent(cookieVal);
            if (this.isValidJson(cookieVal)) {
                return this.parseJSON(cookieVal);
            }
            return cookieVal;
        }

        ,setCookie : function(val, cookieName, expiration, domain) {
            var cookieVal = '';
            if (typeof(val) == 'object') {
                cookieVal = this.toJSON(val);
            } else if (typeof(val) == 'string' || typeof(val) == 'number') {
                cookieVal = val;
            } else {
                return false;
            }
            (new CookieHandler()).setCookie(
                cookieName
                ,Url.encodeComponent(cookieVal)
                ,expiration
                ,domain || ''
            );
        }

        ,deleteCookie : function(cookieName) {
            (new CookieHandler()).deleteCookie(cookieName);
        }

        ,getJSONCookie : function(cookieName) {
            var cookieVal = (new CookieHandler()).getCookie(cookieName);
            cookieVal = cookieVal == null ? '' : Url.decodeComponent(cookieVal);
            if (!this.isValidJson(cookieVal)) {
                return {};
            }
            return this.parseJSON(cookieVal);
        }

        ,setJSONCookie : function(vals, cookieName, expiration, domain) {
            var cookieVal = this.toJSON(vals);
            (new CookieHandler()).setCookie(
                cookieName
                ,Url.encodeComponent(cookieVal)
                ,expiration
                ,domain
            );
        }

        // convert case-sensitve to insensitive ids
        ,convert15To18 : function (id) {
            if (id == null || id.length == 18) {
                return id;
            } else if (id.length != 15) {
                return null;
            } else {
                var suffix = "";
                for (var i = 0; i < 3; i++) {
                    var flags = 0;
                    for (var j = 0; j < 5; j++) {
                        var c = id.charAt(i * 5 + j);
                        if (c >= 'A' && c <= 'Z') {
                            flags += 1 << j;
                        }
                    }
                    if (flags <= 25) {
                        suffix += "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(flags);
                    } else {
                        suffix += "012345".charAt(flags-26);
                    }
                }
                return id + suffix;
            }
        }

        ,getParam : function (name, targetURL) {
            if (!targetURL) {
                targetURL = window.location.href;
            } else if (targetURL.indexOf('?') == -1) {
                targetURL = '?' + targetURL;
            }
            targetURL = Url.decodeComponent(targetURL);
            var regexS = "[\\?&]+"+name+"=([^&#]*)";
            var regex = new RegExp( regexS, "i" );
            var results = regex.exec( targetURL );
            if( results == null )
                return "";
            else
                return results[1].replace(/^[ \t]+|[ \t]+$/, "");
        }

        ,cleanUrlData : function(val) {
            if (!val) {
                return '';
            }
            val = val.replace(/\+/g, " ");
            val = val.replace(/[',"]/g,"");
            val = val.replace(/\t/g, "");
            val = val.replace(/\n/g, "");
            val = val.toLowerCase();
            return val;
        }

        ,countChars : function(str, chr) {
            var count = 0;
            for (var i=0; i<str.length; i++) {
                if(str.charAt(i) == chr) {
                    count++;
                }
            }
            return count;
        }

        ,deDupe : function(list) {
            // accepts only array
            if (!list || typeof(list) == 'string') {
                return '';
            }

            // checks if object is in seen dict, and filters accordingly
            // if already in dict, filter out, if not in dict, add it in
            var seen = {};
            return $(list).filter(function(item) {
                return seen.hasOwnProperty(item) ? false : (seen[item] = true);
            });
        }

        ,getMeta : function (name) {
            var content = '';
            $('meta').each(function(){
                var attr = '';
                if ($(this).attr('name') === name) {
                    attr = 'name';
                } else if ($(this).attr('property') === name) {
                    attr = 'property';
                }
                if (attr) {
                    content = $(this).attr('content');
                    return false;
                }
            });
            return content;
        }

        ,isIOS : function() {
            return this.isIPhone() || this.isIPad();
        }

        ,isIPhone : function() {
            return (this.ua.match(/iPhone/i) != null) || (this.ua.match(/iPod/i) != null);
        }

        ,isIPad : function() {
            return (this.ua.match(/iPad/i) != null);
        }

        ,getScreenSize : function() {
            var $w = $(window);
            return [$w.width(), $w.height()];
        }

        ,isRobot : function() {
            return (this.ua.match(/google web preview/i) != null) ||
                (this.ua.match(/gomezagent/i) != null) ||
                (this.ua.match(/dejaclick/i) != null) ||
                (this.ua.match(/KTXN/i) != null);
        }

        ,getHref : function (linkObj) {
            try {
                if (linkObj.href && !(linkObj.href == document.location.href || linkObj.href == '#' || linkObj.href.indexOf(document.location.href + '#') > -1)) {
                    return linkObj.href;
                } else if (!(linkObj.getAttribute('sfdc:href') == '' || linkObj.getAttribute('sfdc:href') == null)) {
                    return linkObj.getAttribute('sfdc:href');
                } else {
                    return '';
                }
            } catch (ex) {
                return '';
            }
        }

        ,getDriver : function (clickedUrl) {
            if (!clickedUrl) {
                return '';
            } else if (Util.getParam('d', clickedUrl) && !(Util.getParam('d', clickedUrl).length === 15 || Util.getParam('d', clickedUrl).length === 18)) {
                clickedUrl = clickedUrl.replace('?d=' + Util.getParam('d', clickedUrl), '?');
                clickedUrl = clickedUrl.replace('&d=' + Util.getParam('d', clickedUrl), '&');
            }
            if (!document.location.search) {
                return clickedUrl;
            }

            var qParams = document.location.search.substring(1).split('&');
            if (clickedUrl.indexOf('?') + 1 === clickedUrl.length) {
                clickedUrl = clickedUrl.substring(0, clickedUrl.length - 1);
            }
            for (var i=0; i<qParams.length; i++) {
                var param = qParams[i].substring(0, qParams[i].indexOf('='));
                if (Util.getParam(param)) {
                    // if clickedUrl has this param, replace
                    // else append
                    var from = param + '=' + this.getParam(param, clickedUrl), to = param + '=' + this.getParam(param);
                    if (this.getParam(param, clickedUrl)) {
                        clickedUrl = clickedUrl.replace('?' + from, '?' + to);
                        clickedUrl = clickedUrl.replace('&' + from, '&' + to);
                    } else {
                        clickedUrl += (clickedUrl.indexOf('?') > -1 ? '&' : '?') + to;
                    }
                }
            }
            if (Util.getParam('d', clickedUrl).length === 18) {
                clickedUrl = clickedUrl.replace(Util.getParam('d', clickedUrl), Util.getParam('d', clickedUrl).substring(0, 15));
            }
            if (Util.getParam('d', clickedUrl) && Util.getParam('d', clickedUrl).length !== 15) {
                clickedUrl = clickedUrl.replace('?d=' + Util.getParam('d', clickedUrl), '?');
                clickedUrl = clickedUrl.replace('&d=' + Util.getParam('d', clickedUrl), '&');
            }
            return clickedUrl;
        }

        ,ellipsis : function (str, max) {
            if (str.length < max){
                return str;
            }else{
                str = str.substring(0,max-3);
                if (str.indexOf(" ")!=-1){
                    if (" "!=str.charAt(str.length)){
                        str = str.substring(0,str.lastIndexOf(" "))
                    }
                }
                return str + "...";
            }
        }

        ,endsWith : function(val1, val2) {
            if (!(val1 || val2) || val1.indexOf(val2) === -1) {
                return false;
            } else {
                if (val1.indexOf(val2) + val2.length === val1.length) {
                    return true;
                }
            }
            return false;
        }

        ,equalHeights : function(elSet) {
            var tallestEl = 0;
            if (typeof elSet !== 'undefined'){
                elSet.each(function() {
                    var thisHeight = $(this).height();
                    if(thisHeight > tallestEl) {
                        tallestEl = thisHeight;
                    }
                });
                elSet.height(tallestEl);
            }
        }

        // for the "more" links.  Hides the current link and shows the next sibling span.
        // Usage: <a href="#" onclick="return Util.moreLinkShowNext(this)">...more</a><span style="display:none;">...</span>
        ,moreLinkShowNext : function(el) {
            $(el).hide().next().show();
            return false;
        }
    });

    })(jQuery);   // jQuery, but not necessary $, is defined at this point, especially when including on app pages
// END Util.js

// BEGIN Server.js
/*
 * shared tracking configuration library that defines site-level parameters
 * see /common/assets/js/analytics for a corresponding site-specific configuration file
 */
var Server = {
    isStaging: false

    ,getExternalDomains: function() {
        return this.externalDomains || [];
    }

    ,getInternalDomains: function() {
        return this.internalDomains || [];
    }
};
Server.internalDomains = [".salesforce.com", ".force.com"];
Server.externalDomains = [];

Server.getCookieDomain = function() {
    var a = document.location.hostname;
    return a.indexOf(".salesforce.com") > -1 ? ".salesforce.com" : "." + a
};

Server.isStaging = window.location.hostname === "";
// END Server.js

// BEGIN VisitorProfile.js
/*
 * shared utilities for visitor profiling
 * must follow:
 * - a definition of VisitorProfile.prototype.getType
 * - instantiation of a VisitorProfile object named 'vp'
 * optional VisitorProfile.prototype.customSetup() will be called during constructor execution
 * any other custom functions used by your site
 */

/**
* Visitor Profile
* @since w156.3
* ***********************************************/
function VisitorProfile() {
    this.version = 'w172.1';

    // prepare timestamp
    var now = new Date();
    this.timestamp = now.getTime();

    // get all the profile and activity data from cookies
    this.profileData = Util.getCookie('appxud') || {};
    if (typeof(this.profileData) != 'object') {
        this.profileData = {};
        Util.deleteCookie('appxud');
    }
    this.activityData = Util.getCookie('webact') || {};
    if (typeof(this.activityData) != 'object') {
        this.activityData = {};
        Util.deleteCookie('webact');
    }

    // update session details
    if (this.isNewSession()) {
        this.activityData['l_vdays'] = this.isNewVisitor() ? -1 : Math.round((this.timestamp - this.lastVisit()) / (1000*60*60*24));
        this.activityData['l_visit'] = this.getSession();
        this.activityData['session'] = this.timestamp;
        this.activityData['l_search'] = '';
        this.activityData['l_dtype'] = ("" != this.activityData['l_dtype'] && typeof(this.activityData['l_dtype']) != "undefined") ? this.activityData['l_dtype'] : '';
        this.activityData['l_page'] = '';
        if (this.lastVisit() >= this.firstVisit()) {
            this.activityData['counter']++;
            this.activityData['pv'] = 0;
        }
    }
    this.idle = this.sessionTimer();
    this.activityData['session'] = this.timestamp;

    // set new visitor details
    if (this.isNewVisitor()) {
        this.activityData['counter'] = 0;
        if (this.firstVisit() == 0) {
            this.activityData['f_visit'] = this.timestamp;
            this.activityData['version'] = this.version;
        }
    }

    if (typeof(this.customSetup) == 'function') {
        this.customSetup();
    }

    /*
    * If "forceProfile=customer|prospect" param is specified for testing and is different than the current profile,
    * change the profile and skip saving activity data back to the cookie
    */
    this.skipSave = false;
    var forceProfile = Util.getParam('forceProfile');
    if ((forceProfile == 'customer' && !this.isCustomer()) || (forceProfile == 'prospect' && this.isCustomer())) {
        this.activityData['customer'] = (forceProfile == 'customer' ? this.timestamp : '');
        this.skipSave = true;
    }

    // record unique form complete ID if available
    if (this.getProperty('hash') && (this.getProperty('fcid') || Util.getParam('FormCampaignId'))) {
        this.setFormCompleteId();
    }

    this.saveActivityData();
}

/**
* Cookie / JSON Utils
**************************************************/
VisitorProfile.prototype.getBase64Cookie = function(cookieName) {
    var cd = Util.getCookie(cookieName);
    return (cd == null || !cd) ? '' : Base64.decode(Url.decodeComponent(cd));
}

VisitorProfile.prototype.getWWWCookie = function(cookieName) {
    // look for the server-side-scripted cookie value
    try {
        var cv = wwwCookies[cookieName];
        return Util.isValidJson(cv) ? Util.parseJSON(cv) : '';
    } catch(ex) {
        return '';
    }
}

/**
* Methods for handling activities / profiles
**************************************************/
VisitorProfile.prototype.saveProfileData = function() {
    Util.setJSONCookie(this.profileData, 'appxud', 60*60*24*180); // exp 6 months
    return true;
}

VisitorProfile.prototype.saveActivityData = function() {
    // save is skipped if forceProfile is different from the cookie profile
    if (this.skipSave != true) {
        Util.setJSONCookie(this.activityData, 'webact', 60*60*24*365); // exp 1 year
    }
    return true;
}

VisitorProfile.prototype.getActivity = function(propertyName) {
    // always return an empty string instead of a null
    // so we can safely print back to form values easily
    if (this.activityData != null) {
        return (this.activityData[propertyName] != null ? this.activityData[propertyName] : '');
    } else {
        return '';
    }
}

VisitorProfile.prototype.isCustomer = function() {
    return (this.getActivity('customer') > 0);
}

VisitorProfile.prototype.isDeveloper = function() {
    return (this.getActivity('developer') > 0);
}

VisitorProfile.prototype.isTrialUser = function() {
    return (this.getActivity('trial') > 0);
}

VisitorProfile.prototype.hasCurrentTrial = function() {
    // if trial login within 30 days
    // or if trial form within 30 days
    var converter = 1000 * 60 * 60 * 24;
    if (((this.timestamp - this.getActivity('trial')) / converter) <= 30) {
        return true;
    } else if (((this.timestamp - this.getActivity('signup')) / converter) <= 30) {
        return true;
    } else {
        return false;
    }
}

VisitorProfile.prototype.getVisitNumber = function() {
    return (this.getActivity('counter') > 0 ? this.getActivity('counter') : 0) + 1; // starts from 1
}

VisitorProfile.prototype.isNewVisitor = function() {
    return (this.lastVisit()==0);
}

VisitorProfile.prototype.lastVisit = function() {
    return (this.getActivity('l_visit') > 0 ? this.getActivity('l_visit') : 0);
}

VisitorProfile.prototype.getDaysSinceLastVisit = function() {
    if (this.getActivity('l_vdays') == -1) {
        return 'First Visit';
    } else if (this.getActivity('l_vdays') > -1 && this.getActivity('l_vdays') <= 1) {
        return 'Less than 1 day';
    } else if (this.getActivity('l_vdays') > 1 && this.getActivity('l_vdays') <= 7) {
        return 'Less than 7 days';
    } else if (this.getActivity('l_vdays') > 7 && this.getActivity('l_vdays') <= 30) {
        return 'More than 7 days';
    } else if (this.getActivity('l_vdays') > 30) {
        return 'More than 30 days';
    } else {
        return 'Cookies Not Supported';
    }
}

VisitorProfile.prototype.firstVisit = function() {
    return (this.getActivity('f_visit') > 0 ? this.getActivity('f_visit') : 0);
}

VisitorProfile.prototype.getSession = function() {
    return (this.getActivity('session') > 0 ? this.getActivity('session') : 0);
}


VisitorProfile.prototype.isNewSession = function() {
    var sessionLength = 30*60;  // 30 mins
    if (this.sessionTimer() > sessionLength || this.newSession) {
        this.newSession = true;
    } else {
        this.newSession = false;
    }
    return this.newSession;
}

// returns number of seconds since this session started
VisitorProfile.prototype.sessionTimer = function() {
    return (this.timestamp - this.getSession()) / 1000;
}

VisitorProfile.prototype.getVersion = function() {
    return this.getActivity('version');
}

VisitorProfile.prototype.getFormCompleteId = function() {
    return this.fcid;
}

VisitorProfile.prototype.setFormCompleteId = function() {
    var fcid = Util.getParam('FormCampaignId') || this.getProperty('fcid');
    if (fcid) {
        this.fcid = Util.convert15To18(fcid) + '|' + this.getProperty('hash');
        this.saveProfileData();
    }
}

// precedence is important here!
VisitorProfile.prototype.getType = function() {
    return 'anonymous';
}

VisitorProfile.prototype.getTypeDetailed = function() {
    return this.getType() + ':' + (this.isTrialUser() ? 'has-trial' : 'no-trial');
}

VisitorProfile.prototype.getIdleTime = function() {
    var i = vp.idle;
    if (0 == i) {
        return 'No Previous SFDC Page';
    } else if (0 < i && i <= 2) {
        return '< 2 Seconds';
    } else if (2 < i && i <= 5) {
        return '2-5 Seconds';
    } else if (5 < i && i <= 10) {
        return '6-10 Seconds';
    } else if (10 < i && i <= 15) {
        return '11-15 Seconds';
    } else if (15 < i && i <= 20) {
        return '16-20 Seconds';
    } else if (20 < i && i <= 30) {
        return '21-30 Seconds';
    } else if (30 < i && i <= 60) {
        return '31-60 Seconds';
    } else if (60 < i && i <= 120) {
        return '1-2 Minutes';
    } else if (120 < i && i <= 180) {
        return '2-3 Minutes';
    } else if (180 < i && i <= 300) {
        return '3-5 Minutes';
    } else {
        return '> 5 Minutes';
    }
}

VisitorProfile.prototype.getFirstFormCompleteTime = function() {
    if(this.getActivity('f_form')) {
        return  '';
    }
    // save timestamp
    this.activityData['f_form'] = this.timestamp;
    this.saveActivityData();

    var i = (this.getActivity('f_form') - this.getActivity('f_visit')) / 1000;
    var h = 60, m = 60, d = 24;
    if (i <= 0) {
        return 'No Time Available';
    } else if (i < (5 * m)) {
        return '< 5 minutes';
    } else if (i < (10 * m)) {
        return '5-10 minutes';
    } else if (i < (30 * m)) {
        return '10-30 minutes';
    } else if (i < (2 * m * h)) {
        return '30 minutes to 2 hours';
    } else if (i < (5 * m * h)) {
        return '2-5 hours';
    } else if (i < (1 * m * h * d)) {
        return '5 hours to 1 day';
    } else if (i < (2 * m * h * d)) {
        return '1-2 days';
    } else if (i < (7 * m * h * d)) {
        return '2-7 days';
    } else if (i < (14 * m * h * d)) {
        return '1-2 weeks';
    } else {
        return '> 2 weeks';
    }
}
/**
* Methods for handling profile details
**************************************************/
VisitorProfile.prototype.getProperty = function(propertyName) {
    // always return an empty string instead of a null
    // so we can safely print back to form values easily
    if (this.profileData != null) {
        return (this.profileData[propertyName] != null ? this.profileData[propertyName] : '');
    } else {
        return '';
    }
}
// this is typically an array
VisitorProfile.prototype.getProductInterests = function() {
    return this.getProperty('pi');
}

// and this is a string
VisitorProfile.prototype.getPrimaryProductInterest = function() {
    return this.getProperty('ppi');
}

VisitorProfile.prototype.getProductInterest = function() {
    return this.getProperty('pi');
}

VisitorProfile.prototype.getCompanyEmployees = function() {
    return this.getProperty('emp');
}

VisitorProfile.prototype.getJobTitle = function() {
    return this.getProperty('t');
}

VisitorProfile.prototype.getCompanyName = function() {
    return this.getProperty('c');
}

VisitorProfile.prototype.getCompanyState = function() {
    return this.getProperty('st');
}

VisitorProfile.prototype.getCompanyCountry = function() {
    return this.getProperty('cn');
}

VisitorProfile.prototype.getUserEmail = function() {
    return this.getProperty('e');
}
// now instantiate it
var vp = new VisitorProfile();
// END VisitorProfile.js

// BEGIN Page.js
/*
 * shared page-level tracking configuration library
 */
var Page;
(function($){
Page = {
    name:               null
    ,server:            null
    ,type:              null
    ,driver:            null
    ,previous:          null
    ,locale:            'us'
    ,excludeParams:         ['un', 'pw']

    ,getName: function() {
        if (this.name == null) {
            this.setName();
        }
        return this.name;
    }

    ,setPrevious: function() {
        this.previous = vp.getActivity('l_page');
        vp.activityData['l_page'] = this.name;
        if (vp.activityData['pv'] == null) {
            vp.activityData['pv'] = 0;
        }
        vp.activityData['pv']++;
        vp.saveActivityData();
        return this.previous;
    }

    ,getPrevious: function() {
        if (this.previous == null) {
            this.setPrevious();
        }
        return this.previous == null ? '' : this.previous;
    }

    ,getNameNoLocale: function() {
        // replace only first occurrence
        return this.getName().replace(':' + this.getLocale() + ':', ':');
    }

    ,getPathNode: function(nodeNumber, pageName) {
        var nodes = '';
        if (typeof pageName === 'string') {
            nodes = pageName.split(':');
        } else {
            nodes = !this.name ? (document.location.pathname.substring(1).split('/')) : this.getName().split(':');
        }
        var part = (nodeNumber <= nodes.length ? nodes[nodeNumber] : '');
        if (null != part && "" != part) {
            return part.toString();
        } else {
            return "";
        }
    }

    ,getSegment: function() {
        if (vp.getType()=='employee' || vp.getType()=='customer') {
            return vp.getType()  + ':' + this.getLocale();
        } else {
            return 'non-customer' + ':' + this.getLocale();
        }
    }

    ,saveDriver: function() {
        vp.activityData['l_dtype'] = this.driver.type;
        vp.activityData['d'] = Util.getParam('d') ? Util.getParam('d') : this.driverLookup.getDefault(this.driver.type, this.driver.id);
        vp.saveActivityData();
    }

    ,getDriver: function() {
        if (this.driver) {
            return this.driver;
        } else if (this.hasInternalReferrer()) {
            if (Util.getParam('d')) {
                return { id:(Util.getParam('d').length == 15 ? Util.convert15To18(Util.getParam('d')) : Util.getParam('d')), type:'internal' };
            } else {
                return false;
            }
        } else if (this.getReferrer() || Util.getParam('d')) {
            var driverID = Util.getParam('d') ? Util.convert15To18(Util.getParam('d')) : '', driver;
            for (var i=0; i<this.driverLookup.types.length; i++) {
                var dt = this.driverLookup.types[i];
                if (dt.qp) {
                    var params = dt.qp.split(',');
                    isType = true;
                    for (var j=0; j<params.length; j++) {
                        if (params[j].indexOf('|') > -1) {
                            var split = params[j].split('|'), orCheck = false;
                            for (var k=0; k<split.length; k++) {
                                if (Util.getParam(split[k])) {
                                    orCheck = true;
                                    break;
                                }
                            }
                            if (!orCheck) {
                                isType = false;
                            }
                        } else if (!Util.getParam(params[j])) {
                            isType = false;
                            break;
                        }
                    }
                    if (isType && Util.getParam('internal') != 'true') {
                        driver = { id:driverID + '|' + dt.name, type:dt.name };
                        if (dt.cb) {
                            driver = this.driverLookup[dt.cb](driver);
                            if (driver) {
                                this.driver = driver;
                                this.saveDriver(driverID);
                                return this.driver;
                            }
                        } else {
                            this.driver = driver;
                            this.saveDriver(driverID);
                            return this.driver;
                        }
                    }
                } else {
                    if (dt.pm) {
                        for (var j=0; j<dt.pm.length; j++) {
                            var pml = dt.pm[j].ms.split(',');
                            isType = false;
                            for (var z=0; z<pml.length; z++) {
                                if (this.getReferrer().indexOf(pml[z]) > -1) {
                                    isType = true;
                                    driver = { id:(driverID ? driverID + '|' : '') + dt.name + '|' + dt.pm[j].name, type:dt.name };
                                    if (driver) {
                                        this.driver = driver;
                                        this.saveDriver(driverID);
                                        return this.driver;
                                    }
                                }
                            }
                        }
                    }
                    if (dt.cb) {
                        // make callback
                        driver = { id:(driverID ? driverID + '|' + dt.name : ''), type:dt.name };
                        driver = this.driverLookup[dt.cb](driver);
                        if (driver) {
                            this.driver = driver;
                            this.saveDriver(driverID);
                            return this.driver;
                        }
                    }
                }
            }
        }
        this.driver = { id:this.driverLookup.types[this.driverLookup.types.length-1].name, type:this.driverLookup.types[this.driverLookup.types.length-1].name };
        this.saveDriver();
        return this.driver;
    }

    ,hasInternalReferrer: function() {
        if (this.hasExternalReferrer()) {
            return false;
        }
        var r = this.getReferrer() ? this.getReferrer() : '', internals = Server.getInternalDomains();
        r = r.indexOf('?') == -1 ? r : r.substring(0, r.indexOf('?'));
        for (var i=0; i<internals.length; i++) {
            if (r.indexOf(internals[i]) > -1) {
                return true;
            }
        }

        // catching strays
        if (Util.getParam('internal') == 'true' || (this.getPrevious() && !(Util.getParam('r') || r))) {
            return true;
        }

        return false;
    }

    ,hasExternalReferrer: function() {
        var r = this.getReferrer() ? this.getReferrer() : '', externals = Server.getExternalDomains();
        if (!r) {
            return true;
        }
        r = r.indexOf('?') == -1 ? r : r.substring(0, r.indexOf('?'));
        for (var i=0; i<externals.length; i++) {
            if (r.indexOf(externals[i]) > -1) {
                    return true;
            }
        }
        return false;
    }

    ,getReferrer: function() {
        var r = Util.getParam('r');
        if (r) {
            return r.length > 1 ? r : '';   // r=<one-char> is a special case
        }

        r = document.referrer;
        return (this.hasExcludedParam(r) ? r.split('?')[0] : r);
    }

    ,hasExcludedParam: function(url) {
        for (var i=0, len=this.excludeParams.length; i<len; i++) {
            if (Util.getParam(this.excludeParams[i], url)) {
                return true;
            }
        }
        return false;
    }

  ,hasSFDCNetworkReferrer: function() {
      var d = ".salesforce.com", b = document.createElement("a"), c, e;
      b.href = document.referrer;
      c = b.hostname !== location.hostname;
      e = b.hostname.indexOf(".salesforce.com") > -1 && location.hostname.indexOf(".salesforce.com") > -1;
      return c && e && !this.getDriver()
  }

  ,getSFDCNetworkReferrer: function() {
      if (!this.hasSFDCNetworkReferrer()) {
          return null
      }
      return this.lookupDriver(location.href, this.getReferrer())
  }

    /*
    * qp: query param, searched for in current URL
    * pm: pattern match
    * ms: matchstring, searched for in referrer
    */
    ,driverLookup: {
        types: [
            { name:'SEM', qp:'d,dcmp', cb:'getSearchData' }
            ,{ name:'Email', qp:'d', cb:'getEmail', d:'70130000000sUfv' }
            ,{ name:'BAN', qp:'d,ban', cb:'getDisplay' }
            ,{ name:'SEO', cb:'getSearchData', d:'70130000000sUVb' }
            ,{ name:'Paid Social Media', qp:'d', cb:'getSocial' }
            ,{ name:'Social Media', d:'70130000000sUVl', pm:[
                { name:'youtube', ms:'youtube.com' }
                ,{ name:'twitter', ms:'twitter.com,.t.co,/t.co/', d:'70130000000szyK' }
                ,{ name:'linkedin', ms:'linkedin.com,lnkd.in', d:'70130000000szyP' }
                ,{ name:'facebook', ms:'facebook.com', d:'70130000000szyF' }
                ,{ name:'instagram', ms:'instagram.com', d:'701300000025Rrr' }
                ,{ name:'flickr', ms:'flickr.com,flickr.net' }
                ,{ name:'slideshare', ms:'slideshare.com,slideshare.net' }
                ,{ name:'googleplus', ms:'plus.google.com,plus.url.google.com', d:'70130000000szyU' }
                ,{ name:'vimeo' , ms:'vimeo.com' }
                ,{ name:'pinterest', ms:'pinterest.com,pintrest.com', d:'70130000000szyZ' }
                ,{ name:'foursquare' , ms:'foursquare.com' }
                ,{ name:'stumbleupon' , ms:'stumbleupon.com' }
                ,{ name:'yelp' , ms:'yelp.com' }
                ,{ name:'myspace', ms:'myspace.com' }
                ,{ name:'xing' , ms:'xing.com' }
                ,{ name:'mixi' , ms:'mixi.jp' }
                ,{ name:'viadeo' , ms:'viadeo.com' }
                ,{ name:'friendster' , ms:'friendster.com' }
                ,{ name:'badoo' , ms:'badoo.com' }
                ,{ name:'bebo' , ms:'bebo.com' }
                ,{ name:'hi5' , ms:'hi5.com' }
                ,{ name:'myyearbook' , ms:'myyearbook.com' }
                ,{ name:'nig' , ms:'nig.com' }
                ,{ name:'tumblr' , ms:'tumblr.com' }
                ,{ name:'xanga' , ms:'xanga.com' }
                ,{ name:'yammer' , ms:'yammer.com' }
            ]}
            ,{ name:'SFDC Network', d:'70130000000sUW0', pm: [
                { name:'[AppExchange]', ms:'appexchange.salesforce.com,appexchangejp.salesforce.com,sites.secure.force.com/appexchange' }
                ,{ name:'[Community Site]', ms:'success.salesforce.com,sites.secure.force.com' }
                ,{ name:'[DeveloperForce]', ms:'developer.salesforce.com' }
                ,{ name:'[Help&Training]', ms:'help.salesforce.com' }
                ,{ name:'[Foundation]', ms:'foundation.force.com,salesforcefoundation.org' }
                ,{ name:'[VMForce]', ms:'vmforce.com' }
                ,{ name:'[YourServiceCloud.com]', ms:'yourservicecloud.com,yourservicecloud.force.com' }
                ,{ name:'[JoinTheConversations.com]', ms:'jointheconversations.com' }
                ,{ name:'[Chatter.com]', ms:'chatter.com' }
                ,{ name:'[Site.com]', ms:'site.com' }
                ,{ name:'[Work.com]', ms:'work.com' }
                ,{ name:'[Database.com]', ms:'database.force.com,database.com' }
                ,{ name:'[Data.com]', ms:'data.com' }
                ,{ name:'[Jigsaw.com]', ms:'jigsaw.com' }
                ,{ name:'[Force.com]', ms:'www.force.com' }
                ,{ name:'[Force.com Sites]', ms:'.force.com' }
                ,{ name:'[SalesforceMarketingCloud.com]', ms:'salesforcemarketingcloud.com' }
                ,{ name:'[www.salesforce.com]', ms:'www.salesforce.com' }
                ,{ name:'[trust.salesforce.com]', ms:'trust.salesforce.com' }
                ,{ name:'[Salesforce Blogs]', ms:'blogs.salesforce.com, cloudblog.salesforce.com' }
                ,{ name:'[Salesforce.com App]', ms:'.salesforce.com' }
                ,{ name:'[ExactTarget.com]', ms:'.exacttarget.com'}
                ,{ name:'[Desk.com]', ms:'.desk.com'}
                ,{ name:'[Relateiq.com]', ms:'.salesforceiq.com'}
                ,{ name:"[Steelbrick.com]", ms: ".steelbrick.com, steelbrick.de"}
                ,{ name:"[Marketingcloud]", ms: ".marketingcloud.com"}
                ,{ name:"[Demandware]", ms: ".demandware.com"}
                ,{ name:"[Beyondcore]", ms: ".beyondcore.com"}
                ,{ name:"[Heywire]", ms: ".heywire.com"}
                ,{ name:"[Quip]", ms: ".quip.com"}
                ,{ name:"[Krux]", ms: ".krux.com"}
                ,{ name:"[Gravity Tank]", ms: ".gravitytank.com"}
                ,{ name:'[MuleSoft]', ms:'mulesoft.com'}
                ,{ name:'[CloudCraze]', ms:'cloudcraze.com'}
            ]}
            ,{ name:'External Websites', cb:'getReferredDriver', d:'70130000000sUVv' }
            ,{ name:'Other', qp:'d', cb:'fixInternal' }
            ,{ name:'Typed/Bookmarked', d:'70130000000sUVq' }
        ]
        ,searchEngines: [
            { se:'All The Web', ms:'alltheweb.com', kw:'q,query', dc:'US' }
            ,{ se:'Facebook Graph Search', ms:'facebook.com', kw:'q', dc:'US' }
            ,{ se:'AllSearchEngines', ms:'allsearchengines.co.uk', kw:'query', dc:'United Kingdom' }
            ,{ se:'AltaVista', ms:'altavista.com', kw:'q,r', dc:'US', cl:[
                { cn:'Canada', pre:'ca.' }, { cn:'Denmark', pre:'dk.' }, { cn:'France', pre:'fr.' }, { cn:'Germany', pre:'de.' }, { cn:'Italy', pre:'it.' }
                ,{ cn:'Netherlands', pre:'nl.' }, { cn:'Norway', pre:'no.' }, { cn:'Spain', pre:'es.' }, { cn:'Sweden', pre:'se.' }, { cn:'Switzerland', pre:'ch.' }, { cn:'United Kingdom', pre:'uk.' }
            ]}
            ,{ se:'AOL', ms:'.aol.', kw:'q,query', dc:'US', cl:[
                { cn:'Canada', post:'ca' }, { cn:'France', post:'fr' }, { cn:'Germany', post:'de' }, { cn:'United Kingdom', post:'co.uk' }
            ]}
            ,{ se:'Ask', ms:'ask.com', kw:'q', dc:'US', cl:[
                { cn:'Japan', pre:'jp' }, { cn:'United Kingdom', pre:'uk' }
            ]}
            ,{ se:'Baidu', ms:'baidu.com', kw:'wd,s', dc:'China' }
            ,{ se:'BeGuide.com', ms:'beguide.com', kw:'q,search', dc:'US' }
            ,{ se:'Biglobe', ms:'biglobe.ne.jp', kw:'q', dc:'Japan' }
            ,{ se:'Microsoft Bing', ms:'bing.com', kw:'q', dc:'US' }
            ,{ se:'Blue Window', ms:'search.bluewin.ch', kw:'q,qry', dc:'Switzerland' }
            ,{ se:'Business.com', ms:'business.com', kw:'query', dc:'US' }
            ,{ se:'BuyersIndex', ms:'buyersindex.com', kw:'query', dc:'US' }
            ,{ se:'Chubba', ms:'whatuseek.com', kw:'arg', dc:'US' }
            ,{ se:'CNET', ms:'cnet.com', kw:'query,q', dc:'US' }
            ,{ se:'Debriefing.com', ms:'debriefing.com', kw:'tsearch', dc:'US' }
            ,{ se:'Dmoz', ms:'dmoz.org', kw:'search', dc:'US' }
            ,{ se:'Excite', ms:'excite.com', kw:'q,search', dc:'US', cl:[
                { cn:'Netherlands', post:'.nl' }, { cn:'France', post:'.fr' }, { cn:'Germany', post:'.de' }, { cn:'Japan', post:'.co.jp' }, { cn:'Switzerland', post:'.ch' }
            ]}
            ,{ se:'Fireball', ms:'fireball.de', kw:'q,query', dc:'Germany' }
            ,{ se:'FreshEye', ms:'fresheye.com', kw:'kw,ord', dc:'Japan' }
            ,{ se:'Godado', ms:'godado.it', kw:'key', dc:'Italy' }
            ,{ se:'Goo (Jp.)', ms:'goo.ne.jp', kw:'MT', dc:'Japan' }
            ,{ se:'Google', ms:'.google.,googlesyndication.com', kw:'q', types:[{ tn:'Images', pre:'images' }, { tn:'Video', pre:'video' }], dc:'US', cl:[
                { cn:'Afghanistan', post:'com.af' }, { cn:'American Samoa', post:'as' }, { cn:'Anguilla', post:'com.ai' }, { cn:'Antigua and Barbuda', post:'com.ag' }, { cn:'Argentina', post:'com.ar' }
                ,{ cn:'Armenia', post:'am' }, { cn:'Australia', post:'com.au' }, { cn:'Austria', post:'at' }, { cn:'Azerbaijan', post:'az' }, { cn:'Bahrain', post:'com.bh' }
                ,{ cn:'Bangladesh', post:'com.bd' }, { cn:'Belarus', post:'com.by' }, { cn:'Belgium', post:'be' }, { cn:'Belize', post:'com.bz' }, { cn:'Bolivia', post:'com.bo' }
                ,{ cn:'Bosnia-Hercegovina', post:'ba' }, { cn:'Botswana', post:'co.bw' }, { cn:'Brasil', post:'com.br' }, { cn:'British Virgin Islands', post:'vg' }, { cn:'Brunei', post:'com.bn' }
                ,{ cn:'Bulgaria', post:'bg' }, { cn:'Burundi', post:'bi' }, { cn:'Cambodia', post:'com.kh' }, { cn:'Canada', post:'ca' }, { cn:'Chile', post:'cl' }
                ,{ cn:'China', post:'cn' }, { cn:'Colombia', post:'com.co' }, { cn:'Cook Islands', post:'co.ck' }, { cn:'Costa Rica', post:'co.cr' }, { cn:'Cote D\'Ivoire', post:'ci' }
                ,{ cn:'Croatia', post:'hr' }, { cn:'Cuba', post:'com.cu' }, { cn:'Czech Republic', post:'cz' }, { cn:'Denmark', post:'dk' }, { cn:'Djibouti', post:'dj' }
                ,{ cn:'Dominica', post:'dm' }, { cn:'Dominican Republic', post:'com.do' }, { cn:'Ecuador', post:'com.ec' }, { cn:'Egypt', post:'com.eg' }, { cn:'El Salvador', post:'com.sv' }
                ,{ cn:'Estonia', post:'ee' }, { cn:'Ethiopia', post:'com.et' }, { cn:'Fiji', post:'com.fj' }, { cn:'Finland', post:'fi' }, { cn:'France', post:'fr' }
                ,{ cn:'Germany', post:'de' }, { cn:'Greece', post:'gr' }, { cn:'Greenland', post:'gl' }, { cn:'Guadeloupe', post:'gp' }, { cn:'Guatemala', post:'com.gt' }
                ,{ cn:'Guernsey', post:'gg' }, { cn:'Guyana', post:'gy' }, { cn:'Haiti', post:'ht' }, { cn:'Honduras', post:'hn' }, { cn:'Hong Kong', post:'com.hk' }
                ,{ cn:'Hungary', post:'hu' }, { cn:'India', post:'co.in' }, { cn:'Indonesia', post:'co.id' }, { cn:'Ireland', post:'ie' }, { cn:'Island', post:'is' }
                ,{ cn:'Isle of Gibraltar', post:'com.gi' }, { cn:'Isle of Man', post:'im' }, { cn:'Israel', post:'co.il' }, { cn:'Italy', post:'it' }, { cn:'Jamaica', post:'com.jm' }
                ,{ cn:'Japan', post:'co.jp' }, { cn:'Jersey', post:'je' }, { cn:'Jordan', post:'jo' }, { cn:'Kazakhstan', post:'kz' }, { cn:'Kenya', post:'co.ke' }
                ,{ cn:'Kiribati', post:'ki' }, { cn:'Korea', post:'co.kr' }, { cn:'Kyrgyzstan', post:'kg' }, { cn:'Laos', post:'la' }, { cn:'Latvia', post:'lv' }
                ,{ cn:'Lesotho', post:'co.ls' }, { cn:'Libya', post:'com.ly' }, { cn:'Liechtenstein', post:'li' }, { cn:'Lithuania', post:'lt' }, { cn:'Luxembourg', post:'lu' }
                ,{ cn:'Madagascar', post:'mgz' }, { cn:'Malawi', post:'mw' }, { cn:'Malaysia', post:'com.my' }, { cn:'Maldives', post:'mv' }, { cn:'Malta', post:'com.mt' }, { cn:'Mauritius', post:'mu' }
                ,{ cn:'Mexico', post:'com.mx' }, { cn:'Micronesia', post:'fm' }, { cn:'Moldova', post:'md' }, { cn:'Mongolia', post:'mn' }, { cn:'Montserrat', post:'ms' }
                ,{ cn:'Morocco', post:'co.ma' }, { cn:'Namibia', post:'com.na' }, { cn:'Nauru', post:'nr' }, { cn:'Nepal', post:'com.np' }, { cn:'Netherlands', post:'nl' }
                ,{ cn:'New Zealand', post:'co.nz' }, { cn:'Nicaragua', post:'com.ni' }, { cn:'Nigeria', post:'com.ng' }, { cn:'Niue', post:'nu' }, { cn:'Norfolk Island', post:'com.nf' }
                ,{ cn:'Norway', post:'no' }, { cn:'Oman', post:'com.om' }, { cn:'Pakistan', post:'com.pk' }, { cn:'Panama', post:'com.pa' }, { cn:'Paraguay', post:'com.py' }
                ,{ cn:'Peru', post:'com.pe' }, { cn:'Philippines', post:'com.ph' }, { cn:'Pitcairn Islands', post:'pn' }, { cn:'Poland', post:'pl' }, { cn:'Portugal', post:'pt' }
                ,{ cn:'Puerto Rico', post:'com.pr' }, { cn:'Qatar', post:'com.qa' }, { cn:'Rep. Dem. du Congo', post:'cd' }, { cn:'Rep. du Congo', post:'cg' }, { cn:'Repulic of Georgia', post:'ge' }
                ,{ cn:'Romania', post:'ro' }, { cn:'Russia', post:'ru' }, { cn:'Rwanda', post:'rw' }, { cn:'Saint Helena', post:'sh' }, { cn:'Saint Vincent and the Grenadine', post:'com.vc' }
                ,{ cn:'Samoa', post:'ws' }, { cn:'San Marino', post:'sm' }, { cn:'Sao Tome and Principe', post:'st' }, { cn:'Saudi Arabia', post:'com.sa' }, { cn:'Senegal', post:'sn' }
                ,{ cn:'Seychelles', post:'sc' }, { cn:'Singapore', post:'com.sg' }, { cn:'Slovakia', post:'sk' }, { cn:'Slovenia', post:'si' }, { cn:'Solomon Islands', post:'com.sb' }
                ,{ cn:'South Africa', post:'co.za' }, { cn:'Spain', post:'es' }, { cn:'Sri Lanka', post:'lk' }, { cn:'Sweden', post:'se' }, { cn:'Switzerland', post:'ch' }
                ,{ cn:'Taiwan', post:'com.tw' }, { cn:'Tajikistan', post:'com.tj' }, { cn:'Thailand', post:'co.th' }, { cn:'The Bahamas', post:'bs' }, { cn:'The Gambia', post:'gm' }
                ,{ cn:'Timor-Leste', post:'tp' }, { cn:'Tokelau', post:'tk' }, { cn:'Tonga', post:'to' }, { cn:'Trinidad and Tobago', post:'tt' }, { cn:'Turkey', post:'com.tr' }
                ,{ cn:'Turkmenistan', post:'tm' }, { cn:'Uganda', post:'co.ug' }, { cn:'Ukraine', post:'com.ua' }, { cn:'United Arab Emirates', post:'ae' }, { cn:'United Kingdom', post:'co.uk' }
                ,{ cn:'Uruguay', post:'com.uy' }, { cn:'Uzbekiston', post:'co.uz' }, { cn:'Vanuatu', post:'vu' }, { cn:'Venezuela', post:'co.ve' }, { cn:'Viet Nam', post:'com.vn' }
                ,{ cn:'Virgin Islands', post:'co.vi' }, { cn:'Yugoslavia', post:'co.yu' }, { cn:'Zambia', post:'co.zm' }, { cn:'Zimbabwe', post:'co.zw' }
            ]}
            ,{ se:'Hotbot', ms:'hotbot.com', kw:'query', dc:'US' }
            ,{ se:'ilse.nl', ms:'ilse.nl', kw:'search_for', dc:'Netherlands' }
            ,{ se:'Indeed', ms:'www.indeed.', kw:'q', dc:'US', cl:[
                { cn:'Canada', post:'ca' }, { cn:'India', post:'co.in' }
            ]}
            ,{ se:'InfoSpace', ms:'infospace.com', kw:'', dc:'US' }
            ,{ se:'InfoTiger', ms:'infotiger.com', kw:'qs', dc:'US' }
            ,{ se:'Livedoor', ms:'livedoor.com', kw:'q', dc:'Japan' }
            ,{ se:'Lycos', ms:'.lycos', kw:'query', dc:'US', cl: [
                { cn:'France', post:'.fr' }, { cn:'Germany', post:'.de' }, { cn:'Italy', post:'.it' }, { cn:'Netherlands', post:'.nl' }, { cn:'Spain', post:'.es' }, { cn:'United Kingdom', post:'.co.uk' }
            ]}
            ,{ se:'Metacrawler', ms:'metacrawler.com', kw:'', dc:'US' }
            ,{ se:'Monster Crawler', ms:'monstercrawler.com', kw:'', dc:'US' }
            ,{ se:'myGO', ms:'mygo.com', kw:'', dc:'Taiwan' }
            ,{ se:'Nate.com', ms:'nate.com', kw:'q', dc:'Korea' }
            ,{ se:'Naver', ms:'naver.com', kw:'query', dc:'Korea' }
            ,{ se:'NetSearch', ms:'netscape.com', kw:'qry_str', dc:'US' }
            ,{ se:'Nifty', ms:'nifty.com,search.nifty.com', kw:'q', dc:'Japan' }
            ,{ se:'Oh! New? Mobile', ms:'ohnew.co.jp', kw:'k', dc:'Japan' }
            ,{ se:'OptusZoo', ms:'optuszoo.com.au', kw:'q', dc:'Australia' }
            ,{ se:'Reference.com', ms:'reference.com', kw:'q', dc:'US' }
            ,{ se:'Search.ch', ms:'search.ch', kw:'q', dc:'Switzerland' }
            ,{ se:'Searchalot', ms:'searchalot.com', kw:'q,query', dc:'US' }
            ,{ se:'Tiscali', ms:'tiscali.it', kw:'key', dc:'Italy' }
            ,{ se:'track.nl', ms:'track.nl', kw:'qr', dc:'Netherlands' }
            ,{ se:'Virgilio', ms:'ricerca.virgilio.it,virgilio.it', kw:'qs', dc:'Italy' }
            ,{ se:'Web Wombat', ms:'webwombat.com.au', kw:'ix,I', dc:'Australia' }
            ,{ se:'Web.de', ms:'web.de', kw:'su', dc:'Germany' }
            ,{ se:'Webalta', ms:'webalta.ru', kw:'q', dc:'Russia' }
            ,{ se:'WebCrawler', ms:'webcrawler.com', kw:'', dc:'US' }
            ,{ se:'Yahoo!', ms:'search.yahoo.', kw:'p', dc:'US', cl:[
                { cn:'Argentina', pre:'ar.' }, { cn:'Asia', pre:'asia.' }, { cn:'Australia', pre:'au.' }, { cn:'Austria', pre:'at.' }, { cn:'Brazil', pre:'br.' }
                ,{ cn:'Canada', pre:'ca.' }, { cn:'Canada (French)', pre:'qc.' }, { cn:'Catalan', pre:'ct.' }, { cn:'China', pre:'cn.' }, { cn:'Denmark', pre:'dk.' }
                ,{ cn:'Finland', pre:'fi.' }, { cn:'France', pre:'fr.' }, { cn:'Germany', pre:'de.' }, { cn:'Hong Kong', pre:'hk.' }, { cn:'India', pre:'in.' }
                ,{ cn:'Indonesia', pre:'id.' }, { cn:'Italy', pre:'it.' }, { cn:'Japan', post:'co.jp' }, { cn:'Korea', pre:'kr.' }, { cn:'Malaysia', pre:'malaysia.' }
                ,{ cn:'Mexico', pre:'mx.' }, { cn:'Netherlands', pre:'nl.' }, { cn:'New Zealand', pre:'nz.' }, { cn:'Norway', pre:'no.' }, { cn:'Philippines', pre:'ph.' }
                ,{ cn:'Russia', pre:'ru.' }, { cn:'Singapore', pre:'sg.' }, { cn:'Spain', pre:'es.' }, { cn:'Sweden', pre:'se.' }, { cn:'Switzerland', pre:'ch.' }
                ,{ cn:'Taiwan', pre:'tw.' }, { cn:'Thailand', pre:'th.' }, { cn:'UK and Ireland', pre:'uk.' }, { cn:'Viet Nam', pre:'vn.' }
            ]}
            ,{ se:'Yandex.ru', ms:'yandex.ru', kw:'text', dc:'Russia' }
            ,{ se:'zoeken.nl', ms:'zoeken.nl', kw:'q', dc:'Netherlands' }
        ]

        ,getReferringDomain: function() {
            var ref = Page.getReferrer(), prefix = '://';
            if (!ref || ref.indexOf('http') != 0) {
                return '';
            }
            ref = ref.indexOf(prefix) > -1 ? ref.substring(ref.indexOf(prefix) + prefix.length) : ref;
            ref = ref.indexOf('/') > -1 ? ref.substring(0, ref.indexOf('/')) : ref;
            ref = ref.indexOf('?') > -1 ? ref.substring(0, ref.indexOf('?')) : ref;
            ref = ref.indexOf('#') > -1 ? ref.substring(0, ref.indexOf('#')) : ref;
            return ref;

        }

        ,getReferredDriver: function(args) {
            var ref = this.getReferringDomain();
            if (!(args && ref)) {
                return '';
            }
            args.id = (args.id ? args.id : args.type) + '|' + ref;
            return args;
        }

        ,fixInternal: function(args) {
            if (!args) {
                return '';
            }
            var forceList = this.types[5]; // force.com
            for (var i=0; i<forceList.pm.length; i++) {
                var pml = forceList.pm[i].ms.split(',');
                for (var j=0; j<pml.length; j++) {
                    if (Page.getReferrer().indexOf(pml[j]) > -1) {
                        var driver = { id:forceList.name + '|' + forceList.pm[i].name, type:forceList.type, internal:Util.getParam('d') };
                        return driver;
                    }
                }
            }
            return args;
        }

        ,getDefault: function(type, id) {
            if (!type) {
                return '';
            }

            for (var i=0; i<this.types.length; i++) {
                var dt = this.types[i];
                if (type == dt.name) {
                    if (dt.pm) {
                        var name = id.replace(type + '|', '');
                        for (var j=0; j<dt.pm.length; j++) {
                            if (name == dt.pm[j].name && dt.pm[j].d) {
                                return dt.pm[j].d;
                            }
                        }
                    }
                    if (dt.d) {
                        return dt.d;
                    }
                }
            }

            return '';
        }

        ,getEmail: function(args) {
            var url = document.location.href.toLowerCase();
            if (!(url.indexOf('elq_mid=') > -1 || url.indexOf('eid=') > -1 || url.indexOf('rrid') > -1 || url.indexOf('mkt_tok') > -1)) {
                return '';
            }

            return args;
        }

        ,getDisplay: function(args) {
            if (!(args && args.id && args.type)) {
                return '';
            }

            var ban = Url.decodeComponent(Util.getParam('ban')).replace(/_/g, '|'), pre = 'ban|';
            if (ban.indexOf(pre) == 0 || ban.indexOf(pre.toUpperCase()) == 0) {
                ban = ban.substring(pre.length - 1);
            }
            ban = ban.toLowerCase();
            if (ban.charAt(0) != '|') {
                ban = '|' + ban;
            }
            return { id: args.id + ban, type: args.type };
        }

        ,getSocial: function(args) {
            var soc = Url.decodeComponent(Util.getParam('soc')).toLowerCase();
            if (!(args && soc)) {
                return '';
            }
            args.id += '|' + soc;
            return args;
        }

        ,getSearchData: function(args) {
            // check for referrer match
            // then check for keyword match
            var ref = Page.getReferrer(), engine='', country='', keyword='';
            if (!args) {
                return '';
            } else if (!(args.type == 'SEM' || args.type == 'SEO') || (args.type == 'SEO' && args.id)) {
                return '';
            }
            for (var i=0; i<this.searchEngines.length; i++) {
                var ce = this.searchEngines[i], cms = this.searchEngines[i].ms.split(','); // current engine & matchstrings
                for (var j=0; j<cms.length; j++) {
                    if (cms[j] && (ref.indexOf(cms[j]) > -1)) {
                        // we have a search engine; check for sub-engine (ie Google Images)
                        engine = ce.se;
                        if (ce.types) {
                            for (var t=0; t<ce.types.length; t++) {
                                if (ce.types[t].pre && ref.indexOf(ce.types[t].pre + cms[j]) > -1) {
                                    engine = engine + ' ' + ce.types[t].tn;
                                    break;
                                }
                                if (ce.types[t].post && ref.indexOf(cms[j] + ce.types[t].post) > -1) {
                                    engine = engine + ' ' + ce.types[t].tn;
                                    break;
                                }
                            }
                        }
                        // check for keyword
                        var kwp = ce.kw.split(',');
                        for (var k=0; k<kwp.length; k++) {
                            keyword = Url.decodeComponent(Util.getParam(kwp[k], ref));
                            if (keyword) {
                                break;
                            }
                        }
                        if (!keyword) {
                            var tmpRef = ref.substring(ref.indexOf('//') + 2);
                            if ((ref.indexOf('/url') > -1 && (ref.indexOf('q=&') > -1 || ref.indexOf('?sa=t') > -1)) || (tmpRef.indexOf('/') == -1 || tmpRef.indexOf('/') == tmpRef.length - 1)) {
                                keyword = 'no keyword' + (ref.indexOf('https') > -1 ? ' (secure)' : '');
                            } else {
                                break;
                            }
                        }
                        // check for country
                        if (ce.cl) {
                            for (var l=0; l<ce.cl.length; l++) {
                                if (ce.cl[l].pre && ref.indexOf(ce.cl[l].pre + cms[j]) > -1) {
                                    country = ce.cl[l].cn;
                                }
                                if (ce.cl[l].post && ref.indexOf(cms[j] + ce.cl[l].post) > -1) {
                                    country = ce.cl[l].cn;
                                }
                            }
                        }
                        if (!country) {
                            country = ce.dc || 'US';
                        }
                    }
                }
            }
            if ((args.id && args.type == 'SEM') || (engine && keyword)) {
                keyword = keyword ? Util.cleanUrlData(keyword) : 'no keyword';

                engine = engine ? (country.toUpperCase() != 'US' && country != '' ? engine + ' - ' + country : engine) : 'no search engine';
                if (args.type == 'SEM') {
                    args.id += ((engine ? '|' + engine : '') + (keyword ? '|' + keyword : ''));
                }
                return { 'id':(args.id ? args.id : (args.type + '|' + engine + '|' + keyword)), 'type':args.type, 'keyword':keyword, 'engine':engine };
            } else {
                return '';
            }
        }
    }

    }

})(jQuery)   // jQuery, but not necessarily $, is defined at this point, especially when including on app pages


// get and set online channel
window._getDriver = function () {
  return Page.getDriver();
}
