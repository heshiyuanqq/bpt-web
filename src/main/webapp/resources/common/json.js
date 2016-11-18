// ------------
var __isJSONDefined = typeof (JSON) !== "undefined" && (isFunction(JSON.parse) || isFunction(JSON.stringify));
// alert("JSON already defined ? "+__isJSONDefined);

function isJSONDefined() {
	__isJSONDefined = false;
	// force to use simple JSON object.(IGNORE browser built-in JSON)
	return __isJSONDefined;
}

//
if (!isJSONDefined()) {
	JSON = {};
}

function objFromJsonStr(jsonStr) {
	try {
		return eval('(' + jsonStr + ')');
	} catch (exp) {
		throw new TypeError("JSON parse error !");
	}
}

if (!isJSONDefined()) {//
	JSON.parse = objFromJsonStr;
};
if (isFunction(JSON.parse)) {
	JSON.decode = JSON.parse;
	//
	JSON.decodeStr = function(str) {
		return str == null ? null : decodeURIComponent(str);
	};
};

function objToJsonStr(obj) {
	var dblQuote = '"';
	var Callee = arguments.callee;
	if (obj == null || isNumber(obj) || isBoolean(obj)) {
		return obj;
	} else if (isString(obj)) {
		return dblQuote + escapeJsonStr(obj) + dblQuote;
	} else if (isDate(obj)) {
		return dblQuote + obj.format('yyyy-MM-dd HH:mm:ss') + dblQuote;
	} else if (isArray(obj)) {
		var count = obj.length;
		var elemStrs = new Array();
		for ( var i = 0; i < count; i++) {
			elemStrs[i] = Callee(obj[i]);
		}
		return "[" + elemStrs.join(",") + "]";
	} else if (typeof (obj.toJSON) == "function") {
		return obj.toJSON();
	} else// if(isPlainObject(obj)) //Strict Check ...
	{
		var attrStrs = new Array();
		var index = 0;
		var hasOwnProperty = Object.hasOwnProperty;
		for ( var attr in obj) {
			if (hasOwnProperty.call(obj, attr)) {
				var value = obj[attr];
				attrStrs[index++] = Callee(attr) + ":" + Callee(value);
			}
		}
		return "{" + attrStrs.join(",") + "}";
	}
}

if (!isJSONDefined()) {//
	JSON.stringify = objToJsonStr;
};
if (isFunction(JSON.stringify)) {
	JSON.encode = JSON.stringify;
	//
	JSON.encodeStr = function(str) {
		return str == null ? null : encodeURIComponent(str);
	};
};