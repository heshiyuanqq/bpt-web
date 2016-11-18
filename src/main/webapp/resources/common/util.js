
// ================================================================================
// ================================================================================
/**
 * 哑函数，只是为了把某些条件式语句看起来更像函数执行
 */
function Void() {
	// do nothing
}

function $id(id) {
	if (typeof $ == "function") {
		if (typeof id == "string") {
			if (id.indexOf("#") == 0) {
				return $(id);
			} else {
				return $("#" + id);
			}
		}
		return $(id);
	} else {
		throw ("This function can only be used with jquery !");
	}
}

/**
 * 判断给定对象是否是未定义(undefined)
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isUndef(obj) {
	return typeof obj == "undefined";
}

/**
 * 判断给定对象是否是null（但不是未定义）
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isNull(obj) {
	return typeof obj != "undefined" && obj == null;
}

/**
 * 判断给定对象是否和null等值（但非恒等===）
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function eqNull(obj) {
	return obj == null;
}

/**
 * 转换为字符串值
 *
 * @param {Object}
 *            obj
 * @return {String}
 */
function asStr(obj) {
	return "" + obj;
}

/**
 * 检查给定的对象是否为给定类型的实例
 *
 * @param {Object}
 *            obj
 * @param {Constructor}
 *            chkClass
 * @return {Boolean}
 */
function isInstanceOf(obj, chkClass) {
	return obj != null && obj.constructor == chkClass;
}

/**
 * { "String": "[object String]", "Number": "[object Number]", "Boolean": "[object Boolean]", "Date": "[object Date]", "Array": "[object Array]", "Function":
 * "[object Function]", "RegExp": "[object RegExp]", "Object": "[object Object]" };
 */

/**
 * 检查给定的对象是否为字符串(string)
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isString(obj) {
	return obj != null && (typeof obj == "string" || obj instanceof String);
}

/**
 * 检查给定的对象是否为数值(number)
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isNumber(obj) {
	return obj != null && (typeof obj == "number" || obj instanceof Number);
}

/**
 * 严格 检查给定的对象是否为数值(excluding NaN and Infinity)
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isNum(obj) {
	return isNumber(obj) && !isNaN(obj) && isFinite(obj);
}

/**
 * 检查给定的对象是否为 boolean 值
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isBoolean(obj) {
	return obj != null && (typeof obj == "boolean" || obj instanceof Boolean);
}

/**
 * 检查给定的对象是否为函数(function)
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isFunction(obj) {
	return obj != null && (typeof obj == "function" || obj instanceof Function);
}

/**
 * 检查给定的对象是否为基本类型（string、number、boolean）
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isPrimitive(obj) {
	return obj != null && (isString(obj) || isNumber(obj) || isBoolean(obj));
}

/**
 * 检查给定的对象是否为日期对象(Date)
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isDate(obj) {
	return obj != null && obj instanceof Date;
}

/**
 * 检查给定的对象是否为数组(Array)
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isArray(obj) {
	return obj != null && Object.prototype.toString.apply(obj) == "[object Array]";
}

/**
 * 检查给定的对象是否为正则表达式(RegExp)
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isRegExp(obj) {
	return obj != null && obj instanceof RegExp;
}

/**
 * 检查给定的对象是否为普通的(json)对象
 *
 * @param {Object}
 *            obj 被检查对象
 * @param {Boolean}
 *            [bLooseCheck] 是否宽松检查
 * @return {Boolean}
 */
function isPlainObject(obj, bLooseCheck) {
	if (!obj || Object.prototype.toString.call(obj) !== "[object Object]" || obj.nodeType || obj.setInterval) {
		return false;
	}

	var hasOwnProperty = Object.prototype.hasOwnProperty;
	//
	if (obj.constructor && !hasOwnProperty.call(obj, "constructor") && !hasOwnProperty.call(obj.constructor.prototype, "isPrototypeOf")) {
		return false;
	}

	if (bLooseCheck == true) {
		return true;
	} else {
		var key;
		for (key in obj) {
			// just pass
		}
		return key === undefined || hasOwnProperty.call(obj, key);
	}
}

/**
 * 返回给定的对象是否为空的(json)对象
 *
 * @param {Object}
 *            obj
 * @return {Boolean}
 */
function isEmptyObject(obj) {
	for ( var name in obj) {
		return false;
	}
	return true;
}

// ------------------------------------------
/**
 * @private
 */
var ___STRING_LTRIM_REG = /^(\s)+/i;
/**
 * @private
 */
var ___STRING_RTRIM_REG = /(\s)+$/i;
/**
 * 返回去掉开头的空白字符后的字符串
 *
 * @param {String}
 *            str
 * @return {String} 去掉开头的空白字符后的字符串
 */
function lTrim(str) {
	return str.replace(___STRING_LTRIM_REG, "");
}

/**
 * 返回去掉结尾的空白字符后的字符串
 *
 * @param {String}
 *            str
 * @return {String} 去掉结尾的空白字符后的字符串
 */
function rTrim(str) {
	return str.replace(___STRING_RTRIM_REG, "");
}

/**
 * 返回去掉两头的空白字符后的字符串
 *
 * @param {String}
 *            str
 * @return {String} 去掉两头的空白字符后的字符串
 */
function trim(str) {
	return str.replace(___STRING_LTRIM_REG, "").replace(___STRING_RTRIM_REG, "");
}
//
function strEql(valX, valY) {
	if (valX == null) {
		return valY == null;
	} else if (valY == null) {
		return valX == null;
	} else {
		return asStr(valX) === asStr(valY);
	}
}

function strEqlAny(val /* , chkVal1, chkVal2,... */) {
	var chkCount = arguments.length - 1;
	if (chkCount <= 0) {
		return false;
	}
	if (isArray(arguments[1])) {
		var chkArray = arguments[1];
		chkCount = chkArray.length;
		for ( var i = 0; i < chkCount; i++) {
			if (strEql(val, chkArray[i])) {
				return true;
			}
		}
	} else {
		chkCount++;
		for ( var i = 1; i < chkCount; i++) {
			if (strEql(val, arguments[i])) {
				return true;
			}
		}
	}
	return false;
}
/**
 * extend String method
 */
String.prototype.lTrim = function() {
	return lTrim(this);
};
/**
 * extend String method
 */
String.prototype.rTrim = function() {
	return rTrim(this);
};
/**
 * extend String method
 */
String.prototype.trim = function() {
	return trim(this);
};
/**
 * extend String method
 *
 * @returns {Boolean} whether this string is empty (ie. =="")
 */
String.prototype.isEmpty = function() {
	return this == "";
};
/**
 * extend String method
 *
 * @returns {Boolean} whether this string is blank (ie. like " ")
 */
String.prototype.isBlank = function() {
	return trim(this) == "";
};
/**
 * 判断给定的对象是否为null，或者作为字符串是否为""
 *
 * @param {Object}
 *            chkStr
 * @return {Boolean}
 */
function isNullOrEmpty(chkStr) {
	return chkStr == null || asStr(chkStr).isEmpty();
}

/**
 * 判断给定的对象是否为null，或者作为字符串是否为"" 或 空白字符
 *
 * @param {Object}
 *            chkStr
 * @return {Boolean}
 */
function isNullOrBlank(chkStr) {
	return chkStr == null || asStr(chkStr).isBlank();
}

var isNoE = isNullOrEmpty;
var isNoB = isNullOrBlank;

/**
 * replace all "what" in "srcStr" by "byWhat" ( "srcStr" not affected )
 *
 * @param {String}
 *            srcStr
 * @param {String}
 *            what
 * @param {String}
 *            [byWhat=""]
 * @returns {String} result string
 */
function replaceStr(srcStr, what, byWhat) {
	if (byWhat == null) {
		byWhat = "";
	}
	var tmpStr = srcStr.split(what);
	return tmpStr.join(byWhat);
};

/**
 * replace all "what"(RegExp string) in "srcStr" by "byWhat"(RegExp string) ( "srcStr" not affected )
 *
 * @param {String}
 *            srcStr
 * @param {String}
 *            what
 * @param {String}
 *            byWhat
 * @returns {String} result string
 */
function replaceRegStr(srcStr, whatReg, byWhat) {
	var reg = new RegExp(whatReg, 'g');
	return srcStr.replace(reg, byWhat);
};

/**
 * return left-most (length) chars in str
 *
 * @param {String}
 *            str
 * @param {int}
 *            length
 * @returns {String} left string chars in total "length"
 */
function left(str, length) {
	if (!isString(str)) {
		return null;
	}
	var strLen = str.length;
	if (length >= strLen) {
		return str;
	} else {
		return str.substring(0, length);
	}
}

/**
 * return right-most (length) chars in str
 *
 * @param {String}
 *            str
 * @param {int}
 *            length
 * @returns {String} right string chars in total "length"
 */
function right(str, length) {
	if (!isString(str)) {
		return null;
	}
	var strLen = str.length;
	if (length >= strLen) {
		return str;
	} else {
		return str.substring(strLen - length);
	}
}

function _padString(_srcStr, len, isRight, padStr) {
	var srcStr = "" + _srcStr;
	var needLen = len - srcStr.length;
	if (needLen <= 0) {
		return srcStr;
	}
	if (padStr == null) {
		padStr = " ";
	}
	if (padStr.length <= 0) {
		throw "padStr 's length must be great than 0 !";
	}
	var appendStr = "";
	do {
		appendStr += padStr;
		if (appendStr.length >= needLen) {
			appendStr = left(appendStr, needLen);
			break;
		}
	} while (true);
	//
	return isRight == true ? srcStr + appendStr : appendStr + srcStr;
}
/**
 * return a new string by appending len * padStr string
 *
 * @param {String}
 *            _srcStr
 * @param {int}
 *            len
 * @param {String}
 *            [padStr=" "]
 * @returns {String}
 */
function padLeft(_srcStr, len, padStr) {
	return _padString(_srcStr, len, false, padStr);
}

function padRight(_srcStr, len, padStr) {
	return _padString(_srcStr, len, true, padStr);
}

/**
 * extend String method
 *
 * @param {int}
 *            length
 * @returns {String}
 */
String.prototype.left = function(length) {
	return left(this, length);
};
/**
 * extend String method
 *
 * @param {int}
 *            length
 * @returns {String}
 */
String.prototype.right = function(length) {
	return right(this, length);
};
/**
 * return a new string by duplicating refStr "count" times
 *
 * @param {String}
 *            refStr
 * @param {int}
 *            count
 * @returns {String}
 */
function dupStr(refStr, count) {
	if (!isNum(count)) {
		return null;
	}
	count = Math.floor(count);
	var resultStr = "";
	if (count <= 0) {
		return resultStr;
	}
	resultStr = refStr;
	for ( var i = 1; i < count; i++) {
		resultStr += refStr;
	}
	return resultStr;
}

/**
 * check whether "srcStr" starts with the given "chkStr"
 *
 * @param {String}
 *            srcStr
 * @param {String}
 *            chkStr
 * @returns {Boolean}
 */
function strStartsWith(srcStr, chkStr) {
	if (!isString(chkStr)) {
		return false;
	}
	return (srcStr.indexOf(chkStr) === 0);
}

/**
 * check whether "srcStr" ends with the given "chkStr"
 *
 * @param {String}
 *            srcStr
 * @param {String}
 *            chkStr
 * @returns {Boolean}
 */
function strEndsWith(srcStr, chkStr) {
	if (!isString(chkStr)) {
		return false;
	}
	var lastIndex = srcStr.lastIndexOf(chkStr);
	return (lastIndex != -1) && (lastIndex == srcStr.length - chkStr.length);
}

/**
 * check whether <b>srcStr</b> contains <b>searchStr</b> with optional <b>bIgnoreCase</b> param
 *
 * @param {String}
 *            srcStr
 * @param {String}
 *            searchStr
 * @param {Boolean}
 *            [bIgnoreCase=false]
 * @returns {Boolean}
 */
function strContains(srcStr, searchStr, bIgnoreCase) {
	if (!isString(searchStr)) {
		return false;
	}
	//
	bIgnoreCase === true;
	var xIndex = bIgnoreCase ? srcStr.toUpperCase().indexOf(searchStr.toUpperCase()) : srcStr.indexOf(searchStr);
	return (xIndex != -1);
}

/**
 * extend String method
 *
 * @param {String}
 *            chkStr
 * @returns {Boolean}
 */
String.prototype.startsWith = function(chkStr) {
	return strStartsWith(this, chkStr);
};
/**
 * extend String method
 *
 * @param {String}
 *            chkStr
 * @returns {Boolean}
 */
String.prototype.endsWith = function(chkStr) {
	return strEndsWith(this, chkStr);
};
/**
 * extend String method
 *
 * @param {String}
 *            searchStr
 * @param {Boolean}
 *            bIgnoreCase
 * @returns {Boolean}
 */
String.prototype.contains = function(searchStr, bIgnoreCase) {
	return strContains(this, searchStr, bIgnoreCase);
};
/**
 * 格式化字符串，形如： {0},{1}..的索引位置，或形如 {pro1}, {prop2.subprop}, {prop3[0]}的对象式
 */
function formatStr(template) {
	if (!isString(template)) {
		return template;
	}
	var params = Array.prototype.slice.call(arguments, 1);
	var paramCount = params.length;
	if (paramCount == 0) {
		return template;
	}
	var nullAs = template.nullAs || "null";
	var resultStr = "";
	var asObject = isPlainObject(params[0]);
	if (asObject) {
		params = params[0];
		var xReg = /\{[a-zA-Z_]+(\.[a-zA-Z_]+|\[\d+\])*\}?/mg;
		resultStr = template.replace(xReg, function(m) {
			var holder = m.substring(1, m.length - 1).trim();
			var param = eval("params." + holder);
			// alert(holder +" : "+param);
			return "" + (param == null ? nullAs : param);
		});
	} else {
		var xReg = /\{\d+}?/mg;
		resultStr = template.replace(xReg, function(m) {
			var holder = m.substring(1, m.length - 1).trim();
			var index = parseInt(holder);
			if (index >= 0 && index < paramCount) {
				var param = params[index];
				// alert(holder +" : "+param);
				return "" + (param == null ? nullAs : param);
			} else {
				return m;
			}
		});
	}
	return resultStr;
}

String.prototype.format = function() {
	var args = [ this ].concat(Array.prototype.slice.call(arguments, 0));
	return formatStr.apply(window, args);
};

String.prototype.isIn = function() {
	var args = [ this ].concat(Array.prototype.slice.call(arguments, 0));
	return strEqlAny.apply(window, args);
};
/**
 * @private
 */
var __escapeStrReg = {
	backslash : /\\/ig,
	quote : /'/ig,
	dblquote : /"/ig,
	newline : /\n/ig,
	carriage : /\r/ig,
	carriage2 : /\r\n/ig,
	formfeed : /\f/ig,
	hrtab : /\t/ig,
	foreslash : /\//ig
// not used for json escape
};

/**
 * Escape string by filter special chars(\, ', ", \n, \r, \t etc.)
 *
 * @param {String}
 *            src original string
 * @param {Boolean}
 *            [useSingleQutoe=false] whether to use Single Qutoe
 * @returns {String} escaped string
 * @example escapeJsonStr("aaaaaa'bbb/ccc\t'ddd",true) => aaaaaa\'bbb/ccc\t\'ddd
 */
function escapeJsonStr(src, useSingleQutoe) {
	if (src == null || src == "") {
		return src;
	} else {
		useSingleQutoe = useSingleQutoe === true;
		// backslash
		__escapeStrReg.backslash.lastIndex = -1;
		src = src.replace(__escapeStrReg.backslash, "\\\\");
		if (useSingleQutoe) {
			// quote
			__escapeStrReg.quote.lastIndex = -1;
			src = src.replace(__escapeStrReg.quote, "\\'");
		} else {
			// dblquote
			__escapeStrReg.dblquote.lastIndex = -1;
			src = src.replace(__escapeStrReg.dblquote, '\\"');
		}
		// newline
		__escapeStrReg.newline.lastIndex = -1;
		src = src.replace(__escapeStrReg.newline, '\\n');
		// carriage
		__escapeStrReg.carriage.lastIndex = -1;
		src = src.replace(__escapeStrReg.carriage, '\\r');
		// carriage2
		__escapeStrReg.carriage2.lastIndex = -1;
		src = src.replace(__escapeStrReg.carriage2, '\\r\\n');
		// formfeed
		__escapeStrReg.formfeed.lastIndex = -1;
		src = src.replace(__escapeStrReg.formfeed, '\\f');
		// hrtab
		__escapeStrReg.hrtab.lastIndex = -1;
		src = src.replace(__escapeStrReg.hrtab, '\\t');
		return src;
	}
}

/**
 * extend String method
 *
 * @param {Boolean}
 *            useSingleQutoe
 * @returns {String} {@link #escapeJsonStr }
 */
String.prototype.escapeJson = function(useSingleQutoe) {
	return escapeJsonStr(this, useSingleQutoe);
};

// 公开方法
String.builder = function() {
	var obj = new String.builder.fn();
	obj.append.apply(obj, arguments);
	return obj;
};

String.builder.fn = function() {
	this.value = "";
	//
	this.append = function() {
		for ( var i = 0, c = arguments.length; i < c; i++) {
			this.value = this.value + arguments[i];
		}
	};
	this.appendln = function() {
		this.append.apply(this, arguments);
		this.append("\n");
	};
	this.prepend = function() {
		for ( var i = 0, c = arguments.length; i < c; i++) {
			this.value = arguments[i] + this.value;
		}
	};
	this.clear = function() {
		this.value = "";
	};
	this.toString = function() {
		return this.value;
	};
};