/**
* JSONfn - javascript plugin to convert javascript object, ( including those with functions ) 
* to string and vise versa.
*  
* Version - 0.3.00.beta 
* Copyright (c) 2012 Vadim Kiryukhin
* vkiryukhin @ gmail.com
* http://www.eslinstructor.net/jsonfn/
* 
* Dual licensed under the MIT and GPL licenses:
*   http://www.opensource.org/licenses/mit-license.php
*   http://www.gnu.org/licenses/gpl.html
*
*   USAGE:
* 
*        JSONfn.stringify(obj);
*        JSONfn.parse(jsonStr);
*
*        @obj     -  javascript object;
*		 @jsonStr -  String in JSON format; 
*
*   Examples:
*		
*        var str = JSONfn.stringify(obj);
*        var obj = JSONfn.parse(str);
*
*/

// Create a JSON object only if it does not already exist. 
var JSONfn;
if (!JSONfn) {
    JSONfn = {};
}

(function () {
	
	JSONfn.stringify = function(obj) {
		return JSON.stringify(obj,function(key, value){
				return (typeof value === 'function' ) ? value.toString() : value;
			});
	}

	JSONfn.parse = function(str) {
		return JSON.parse(str,function(key, value){
			if(typeof value != 'string') return value;
			return ( value.substring(0,8) == 'function') ? eval('('+value+')') : value;
		});
	}
}());
