function $id(id) {
	if (typeof id == "string") {
		if (id.indexOf("#") == 0) {
			return $(id);
		} else {
			return $("#" + id);
		}
	}
	return $(id);
}

function $window() {
	return $(window);
}

// 判断是否运行在手机浏览器中
var __isOnMobile = null;
function isOnMobile() {
	// 还不能用
	return __isOnMobile;
}

// 获取当前页面最大的z-index
function getMaxZIndex() {
	var zIndex = 0;
	$('[style*="z-index"]').each(function(i, el) {
		var tmpZIndex = el.style.zIndex;
		zIndex = Math.max(zIndex, tmpZIndex);
	});
	return zIndex;
}

// Ajax 类
// Ajax.baseUrl = baseUrl;
// Ajax.post("/url").params({}).data({}).done(function(data, jqXHR){}).go();
// Ajax.post("/url").params({}).data({}).done(function(data, jqXHR){}).fail(function(status, error, jqXHR){}).go();
declare("Ajax.core");
Ajax.core.fn = function() {
	var _cache = false;
	var _async = true;
	var _type = "GET";
	var _url = "";
	// 发送的数据类型: contentType
	var _contentType = "application/json";
	// 返回的数据类型: dataType
	var _resultType = "json";
	//
	var _params = "";
	var _data = {};
	//
	var _doneHandler = null;
	var _failHandler = null;
	var _failMessage = null;
	var _statusHandler = {};
	var _statusMessage = {};
	//
	var _alwaysHandler = null;
	//
	// var logger = console && console.log ? console.log : null;
	//
	this.get = function(url) {
		_type = "GET";
		//
		_url = url;
		//
		return this;
	};
	this.post = function(url) {
		_type = "POST";
		//
		_url = url;
		//
		return this;
	};
	this.put = function(url) {
		_type = "PUT";
		//
		_url = url;
		//
		return this;
	};
	this.params = function(params) {
		_params = params;
		//
		return this;
	};
	this.data = function(data) {
		_data = data;
		//
		return this;
	};
	this.sync = function() {
		_async = false;
		//
		return this;
	};
	this.cache = function() {
		_cache = true;
		//
		return this;
	};
	// 发送内容格式
	this.asJson = function() {
		_contentType = "application/json";
		//
		return this;
	};
	this.asForm = function() {
		_contentType = "application/x-www-form-urlencoded";
		//
		return this;
	};
	// 接收内容格式
	this.forJson = function() {
		_resultType = "json";
		//
		return this;
	};
	this.forHtml = function() {
		_resultType = "html";
		//
		return this;
	};
	// 结果处理
	this.done = function(callback) {
		_doneHandler = callback;
		//
		return this;
	};
	this.fail = function(callback) {
		if (isString(callback)) {
			_failMessage = callback;
		} else {
			_failHandler = callback;
		}
		//
		return this;
	};
	this.always = function(callback) {
		_alwaysHandler = callback;
		//
		return this;
	};
	this.onStatus = function(status, callback) {
		if (isString(callback)) {
			_statusMessage[status] = callback;
		} else {
			_statusHandler[status] = callback;
		}
		//
		return this;
	};
	this.on401 = function(callback) {
		return this.onStatus(401, callback);
	};
	this.on404 = function(callback) {
		return this.onStatus(404, callback);
	};
	this.on500 = function(callback) {
		return this.onStatus(500, callback);
	};
	//
	function sendRequest() {
		var url = _url;
		if (Ajax.baseUrl) {
			url = Ajax.baseUrl + url;
		}
		url = makeUrl(url, _params, true);
		var ajax = null;
		if (_type == "GET") {
			ajax = $.ajax({
				cache : _cache,
				async : _async,
				type : _type,
				url : url,
				dataType : _resultType,
				data : _data
			});
		} else {
			var data = _data;
			if (_contentType.endsWith("/json")) {
				data = JSON.encode(data);
			}
			ajax = $.ajax({
				cache : _cache,
				async : _async,
				type : _type,
				url : url,
				dataType : _resultType,
				data : data,
				contentType : _contentType
			});
		}
		//
		ajax.done(function(data, type, jqXHR) {
			if (typeof _doneHandler == "function") {
				_doneHandler(data, jqXHR);
			}
		});
		//
		ajax.fail(function(jqXHR, type, statusText) {
			var errInfo = {};
			errInfo.type = "error";
			errInfo.message = statusText;
			try {
				errInfo = JSON.decode(jqXHR.responseText);
				if (!errInfo.message) {
					errInfo.message = statusText;
				}
			} catch (ex) {
				//
			}
			var status = jqXHR.status;
			var statusHandler = _statusHandler[status];
			var continueNext = true;
			if (statusHandler != null) {
				var statusMessage = _statusMessage[status];
				if (statusMessage) {
					errInfo.message = statusMessage;
				}
				var handleResult = statusHandler(errInfo, jqXHR, status);
				continueNext = handleResult !== false;
			}
			if (continueNext && _failHandler != null) {
				if (_failMessage) {
					errInfo.message = _failMessage;
				}
				_failHandler(errInfo, jqXHR, status);
			}
		});
		//
		if (_alwaysHandler != null) {
			ajax.always(function(result, type, jqXHR) {
				_alwaysHandler(result, jqXHR);
			});
		}
	}

	//
	this.go = function() {
		sendRequest();
	};
	// 默认处理函数
	this.fail(function(errInfo, jqXHR, status) {
		var errMsg = errInfo.message || "处理失败";
		Layer.msgWarn(errMsg);
	});
	this.on401(function(errInfo, jqXHR, status) {
		var errMsg = errInfo.message || "未认证或权限不足";
		Layer.msgWarn(errMsg);
	});
	this.on404(function(errInfo, jqXHR, status) {
		var errMsg = errInfo.message || "未找到请求的资源";
		Layer.msgWarn(errMsg);
	});
	this.on500(function(errInfo, jqXHR, status) {
		var errMsg = errInfo.message || "服务器繁忙";
		Layer.msgWarn(errMsg);
	});
	//
	return this;
};
//
Ajax.get = function(url) {
	return new Ajax.core.fn().get(url);
};
Ajax.post = function(url) {
	return new Ajax.core.fn().post(url);
};
Ajax.put = function(url) {
	return new Ajax.core.fn().put(url);
};

// 焦点标示
var focusMarker = new (function() {
	this.mark = function(selector, focusClass) {
		var xFocusClass = focusClass || "focus";
		var target = $(selector);
		target.on("mousedown", function() {
			$(this).addClass(xFocusClass);
		});
		target.on("mouseup", function() {
			$(this).removeClass(xFocusClass);
		});
	};
})();

// Toast 提示
declare("Toast.core");
Toast.core.fn = function() {
	var THIS = this;
	var html = '<div class="toast"><span data-role="content" class="content alert"></span></div>';
	var jqDom = null;
	var jqDomEl = null;
	var jqContent = null;
	var theTimer = null;
	var theCallback = null;
	function createDom() {
		if (jqDom == null) {
			jqDom = $(html).appendTo(document.body);
			jqDomEl = jqDom.get(0);
			jqDom.css("display", "none");
			jqContent = jqDom.find('>span[data-role="content"]');
			//
			$(document).on("mousedown", function(event) {
				if (event.target != jqDomEl && !$.contains(jqDomEl, event.target)) {
					if ($(jqDomEl).is(":visible")) {
						THIS.hide();
					}
				}
			});
		}
	}

	function adjustPosition() {
		jqDom.css("z-index", getMaxZIndex());
		var win  = $(window);
		var left = (win.width() - jqDom.width() - 20) / 2;
		var offsetTop = $(document.body).scrollTop();
		//var top  = (win.innerHeight() - jqDom.height() - 20) / 2;
		var top  = offsetTop + 200;
		jqDom.css("left", left + "px");
		jqDom.css("top", top + "px");
	}

	//
	this.show = function(msg, duration, iconClass, callback) {
		createDom();
		//
		clearTimeout(theTimer);
		//
		callback = callback || null;
		if (typeof iconClass == "function") {
			callback = iconClass;
			iconClass = null;
		}
		theCallback = callback;
		//
		iconClass = iconClass || "tip";
		msg = msg || "";
		duration = duration || 2000;
		//
		jqContent.text(msg);
		jqContent.get(0).className = "content";
		jqContent.addClass(iconClass);
		//
		adjustPosition();
		//
		jqDom.show();
		//
		theTimer = setTimeout(function() {
			THIS.hide();
		}, duration);
		//
		return this;
	};
	this.hide = function() {
		clearTimeout(theTimer);
		//
		if (jqDom != null) {
			jqDom.hide();
		}
		if (typeof theCallback == "function") {
			try {
				theCallback();
			} catch (ex) {
				//
			}
		}
		//
		return this;
	};
	//
	return this;
};
var Toast = new Toast.core.fn();

/**
 * 开关按钮
 */
function SwitchButton() {
	var noop = function() {
	};
	//
	var THIS = this;
	//
	var ctrlsEverCreated = false;
	var checkbox = null;
	var switchProxy = null;
	//
	var curState = false;
	// 自定义处理函数
	this.onChange = noop;
	//
	this._triggerChange = function() {
		if (typeof this.onChange == "function") {
			this.onChange(curState, this);
		}
	};
	//
	function makeDisabled(disabled) {
		switchProxy.prop("disabled", disabled);
		switchProxy.css("opacity", disabled ? 0.6 : 1);
	}
	//
	function refreshState(triggerHandler) {
		triggerHandler = triggerHandler !== false;
		var tmpState = checkbox.prop("checked");
		if (tmpState == true) {
			switchProxy.removeClass("switchOff");
			switchProxy.addClass("switchOn");
		} else {
			switchProxy.removeClass("switchOn");
			switchProxy.addClass("switchOff");
		}
		if (tmpState != curState) {
			curState = tmpState;
			if (triggerHandler) {
				THIS._triggerChange();
			}
		}
	}
	//
	this._createCtrls = function() {
		if (ctrlsEverCreated) {
			return;
		}
		//
		switchProxy.empty();
		switchProxy.addClass("switchBtn");
		//
		var innerHtml = '<input type="checkbox" />';
		checkbox = $(innerHtml).appendTo(switchProxy);
		// 初始化
		refreshState();
		//
		switchProxy.on("click", function(event) {
			if ($(this).is(":disabled") || $(this).prop("disabled")) {
				return;
			}
			//
			checkbox.prop("checked", !checkbox.prop("checked"));
			refreshState();
		});
		//
		ctrlsEverCreated = true;
	};
	this.init = function(holderId) {
		if (isString(holderId) && !holderId.startsWith("#")) {
			holderId = "#" + holderId;
		}
		switchProxy = $(holderId);
		//
		this._createCtrls();
		//
		return this;
	};
	//
	this.isOn = function() {
		return curState === true;
	};
	this.isOff = function() {
		return !this.isOn();
	};
	//
	this.switchOn = function(triggerHandler) {
		checkbox.prop("checked", true);
		refreshState(triggerHandler);
		//
		return this;
	};
	this.switchOff = function(triggerHandler) {
		checkbox.prop("checked", false);
		refreshState(triggerHandler);
		//
		return this;
	};
	//
	this.setDisabled = function(disabled) {
		makeDisabled(disabled);
		//
		return this;
	};
	//
	return this;
}
/**
 * 普通切换按钮组
 */
function RadioGroup() {
	var noop = function() {
	};
	//
	var THIS = this;
	//
	var idSuffix = genUniqueStr();
	var container = null;
	var wrapperTbl = null;
	var ctrlsEverCreated = false;
	var initConfig = {};
	var radioLabels = [];
	var radioImages = [];
	var curValue = null;
	// 自定义处理函数
	this.onChange = noop;
	//
	this._triggerChange = function() {
		if (typeof this.onChange == "function") {
			this.onChange(curValue, this);
		}
	};
	//
	function getRadioByValue(value) {
		var label = radioLabels.find(function(label, i) {
			var radio = label.data("target");
			return radio.val() == value;
		});
		return label == null ? null : label.data("target");
	}

	//
	function clearCheckState() {
		curValue = null;
		radioLabels.forEach(function(label, i) {
			var tmpItem = initConfig.items[i];
			var radio = label.data("target");
			radio.prop("checked", false);
			var image = radioImages[i];
			label.removeClass(tmpItem.bgClassChecked);
			if (initConfig.markerClass) {
				label.removeClass(initConfig.markerClass);
			}
			image.attr("src", tmpItem.image);
		});
	}

	//
	function refreshCheckState() {
		radioLabels.forEach(function(label, i) {
			var tmpItem = initConfig.items[i];
			var radio = label.data("target");
			var image = radioImages[i];
			if (radio.is(":checked")) {
				label.addClass(tmpItem.bgClassChecked);
				if (initConfig.markerClass) {
					label.addClass(initConfig.markerClass);
				}
				image.attr("src", tmpItem.imageChecked);
				//
				var value = radio.val();
				if (value != curValue) {
					curValue = value;
					THIS._triggerChange();
				}
			} else {
				label.removeClass(tmpItem.bgClassChecked);
				if (initConfig.markerClass) {
					label.removeClass(initConfig.markerClass);
				}
				image.attr("src", tmpItem.image);
			}
		});
	}

	//
	function makeDisabled(disabled) {
		radioLabels.forEach(function(label, i) {
			label.prop("disabled", disabled);
			var opacity = initConfig.useOpacity ? (disabled ? 0.6 : 1) : 1;
			label.css("opacity", opacity);
		});
	}

	//
	this._createCtrls = function() {
		if (ctrlsEverCreated) {
			return;
		}
		//
		var containerId = initConfig.containerId;
		if (isString(containerId) && !containerId.startsWith("#")) {
			containerId = "#" + containerId;
		}
		container = $(containerId);
		wrapperTbl = $('<table class="radioGroup"></table>').appendTo(container);
		//
		initConfig.markerClass = initConfig.markerClass || "";
		initConfig.useOpacity = initConfig.useOpacity !== false;
		initConfig.useRadius = initConfig.useRadius !== false;
		initConfig.useBorder = initConfig.useBorder !== false;
		//
		var width = initConfig.width || "100%";
		var widthInfo = parseDimen(width);
		wrapperTbl.css("width", widthInfo.value + widthInfo.unit);
		//
		var itemCount = initConfig.items.length;
		var isPercentage = widthInfo.unit == "%";
		if (isPercentage) {
			width = Math.floor(100.0 / itemCount) + "%";
		} else {
			width = Math.floor(widthInfo.value * 1.0 / itemCount) + widthInfo.unit;
		}
		var height = initConfig.height || "100%";
		var heightInfo = parseDimen(height);
		isPercentage = heightInfo.unit == "%";
		if (isPercentage) {
			height = container.height() + "px";
		} else {
			height = heightInfo.value + heightInfo.unit;
		}
		//
		var imageWidth = initConfig.imageWidth || "100%";
		if (isNum(imageWidth)) {
			imageWidth += "px";
		}
		var imageHeight = initConfig.imageHeight || "100%";
		if (isNum(imageHeight)) {
			imageHeight += "px";
		}
		//
		var wrapperTr = $('<tr></tr>').appendTo(wrapperTbl);
		//
		var groupName = initConfig.name || "group-" + idSuffix;
        var label = null;
		for ( var i = 0, c = itemCount; i < c; i++) {
			var tmpItem = initConfig.items[i];
			tmpItem.id = tmpItem.id || "";
			tmpItem.text = tmpItem.text || "";
			tmpItem.image = tmpItem.image || "";
			tmpItem.imageChecked = tmpItem.imageChecked || "";
			tmpItem.bgClass = tmpItem.bgClass || "";
			tmpItem.bgClassChecked = tmpItem.bgClassChecked || "";
			//
			var td = $('<td></td>').appendTo(wrapperTr);
			td.css("width", width);
			td.css("height", height);
			td.css("line-height", height);
			var proxyHtml = tmpItem.image ? '<img align="absmiddle" src="' + tmpItem.image + '" width="' + imageWidth + '" height="' + imageHeight + '"/>'
					: tmpItem.text;
			var radioIdHtml = tmpItem.id ? ' id="' + tmpItem.id + '" ' : ' ';
			var ctrlsHtml = '<input ' + radioIdHtml + ' type="radio" value="' + tmpItem.value + '" name="' + groupName
					+ '" style="display:none;" /><label role="proxy" style="display:inline-block;text-align:center;vertical-align:middle;'
					+ 'width:100%;height:' + height + ';line-height:' + height + '">' + proxyHtml + '</label>';
			$(ctrlsHtml).appendTo(td);
			label = td.find('label[role="proxy"]');
			radioLabels.add(label);
			label.addClass(tmpItem.bgClass);
			if (initConfig.useRadius) {
				if (i == 0) {
                    if (itemCount == 1) {
                        label.addClass("leftRadius rightRadius");
                    } else {
                        label.addClass("leftRadius");
                    }
				} else if (i == itemCount - 1) {
					label.addClass("rightRadius");
				}
			}
			if (initConfig.useBorder) {
				label.addClass("border");
				if (i == itemCount - 1) {
					label.addClass("borderLast");
				}
			}
			var radio = td.find("input:radio");
			label.data("target", radio);
            // 只有多于一个按钮时，增加相应的点击事件
            if (itemCount > 1) {
                label.on("click", function(event) {
                    if ($(this).is(":disabled") || $(this).prop("disabled")) {
                        return;
                    }
                    //
                    $(this).data("target").prop("checked", true);
                    refreshCheckState();
                });
            } else {
                label.addClass(tmpItem.bgClass);
            }
			//
			var image = label.find("img");
			radioImages.add(image);
			image.attr("src", tmpItem.image);
			//
			if (!initConfig.useBorder && i < itemCount - 1) {
				var tdSeperator = $(
						'<td style="width:1px;"><label style="display:inline-block;vertical-align:middle;width:100%;height:' + height + ';line-height:'
								+ height + '">&nbsp;</label></td>').appendTo(wrapperTr);
				tdSeperator.find("label").addClass("seperator");
			}
		}
	};
	//
	this.init = function(config) {
		initConfig = config || {};
		initConfig.items = initConfig.items || [];
		//
		this._createCtrls();
		//
		return this;
	};
	//
	this.setValue = function(value) {
		var radio = getRadioByValue(value);
		if (radio != null) {
			radio.prop("checked", true);
			refreshCheckState();
		}
		//
		return this;
	};
	//
	this.getValue = function() {
		return curValue;
	};
	//
	this.setDisabled = function(disabled) {
		makeDisabled(disabled);
		//
		return this;
	};
	//
	return this;
}
/**
 * Tab页签切换组
 */
function TabGroup() {
	var noop = function() {
	};
	//
	var THIS = this;
	//
	var idSuffix = genUniqueStr();
	var container = null;
	var wrapperTbl = null;
	var ctrlsEverCreated = false;
	var initConfig = {};
	var radioLabels = [];
	var tabbedPages = [];
	var curValue = null;
	// 自定义处理函数
	this.onChange = noop;
	//
	this._triggerChange = function() {
		if (typeof this.onChange == "function") {
			this.onChange(curValue, this);
		}
	};
	//
	function getRadioByValue(value) {
		var label = radioLabels.find(function(label, i) {
			var radio = label.data("target");
			return radio.val() == value;
		});
		return label == null ? null : label.data("target");
	}

	//
	function clearCheckState() {
		curValue = null;
		radioLabels.forEach(function(label, i) {
			var tmpItem = initConfig.items[i];
			var radio = label.data("target");
			radio.prop("checked", false);
			label.removeClass(tmpItem.bgClassChecked);
			var page = tabbedPages[i];
			page.hide();
		});
	}

	//
	function refreshCheckState() {
		radioLabels.forEach(function(label, i) {
			var tmpItem = initConfig.items[i];
			var radio = label.data("target");
			var page = tabbedPages[i];
			if (radio.is(":checked")) {
				label.addClass(tmpItem.bgClassChecked);
				page.show();
				//
				var value = radio.val();
				if (value != curValue) {
					curValue = value;
					THIS._triggerChange();
				}
			} else {
				label.removeClass(tmpItem.bgClassChecked);
				page.hide();
			}
		});
	}

	//
	function makeDisabled(disabled) {
		radioLabels.forEach(function(label, i) {
			label.prop("disabled", disabled);
			var opacity = initConfig.useOpacity ? (disabled ? 0.6 : 1) : 1;
			label.css("opacity", opacity);
		});
	}

	//
	this._createCtrls = function() {
		if (ctrlsEverCreated) {
			return;
		}
		//
		var containerId = initConfig.containerId;
		if (isString(containerId) && !containerId.startsWith("#")) {
			containerId = "#" + containerId;
		}
		container = $(containerId);
		wrapperTbl = $('<table class="tabGroup"></table>').appendTo(container);
		//
		initConfig.useOpacity = initConfig.useOpacity !== false;

		//
		var width = initConfig.width || "100%";
		var widthInfo = parseDimen(width);
		wrapperTbl.css("width", widthInfo.value + widthInfo.unit);
		//
		var itemCount = initConfig.items.length;
		var isPercentage = widthInfo.unit == "%";
		if (isPercentage) {
			width = Math.floor(100.0 / itemCount) + "%";
		} else {
			width = Math.floor(widthInfo.value * 1.0 / itemCount) + widthInfo.unit;
		}
		var height = initConfig.height || "100%";
		var heightInfo = parseDimen(height);
		isPercentage = heightInfo.unit == "%";
		if (isPercentage) {
			height = container.height() + "px";
		} else {
			height = heightInfo.value + heightInfo.unit;
		}
		//
		var wrapperTr = $('<tr></tr>').appendTo(wrapperTbl);
		//
		var groupName = initConfig.name || "group-" + idSuffix;
		for ( var i = 0, c = itemCount; i < c; i++) {
			var tmpItem = initConfig.items[i];
			tmpItem.id = tmpItem.id || "";
			tmpItem.text = tmpItem.text || "";
			tmpItem.bgClass = tmpItem.bgClass || "";
			tmpItem.bgClassChecked = tmpItem.bgClassChecked || "";
			//
			var td = $('<td></td>').appendTo(wrapperTr);
			td.css("width", width);
			td.css("height", height);
			td.css("line-height", height);
			var proxyHtml = tmpItem.text;
			var radioIdHtml = tmpItem.id ? ' id="' + tmpItem.id + '" ' : ' ';
			var ctrlsHtml = '<input ' + radioIdHtml + ' type="radio" value="' + tmpItem.value + '" name="' + groupName
					+ '" style="display:none;" /><label role="proxy" style="display:inline-block;text-align:center;vertical-align:middle;'
					+ 'width:100%;height:' + height + ';line-height:' + height + '">' + proxyHtml + '</label>';
			$(ctrlsHtml).appendTo(td);
			var label = td.find('label[role="proxy"]');
			radioLabels.add(label);
			label.addClass(tmpItem.bgClass);
			if (i < itemCount - 1) {
				var tdSeperator = $('<td></td>').appendTo(wrapperTr);
				tdSeperator.addClass(tmpItem.bgClass);
				tdSeperator.addClass("seperator");
			}
			var page = $id(tmpItem.page);
			tabbedPages.add(page);
			page.hide();
			//
			var radio = td.find("input:radio");
			label.data("target", radio);
			label.on("click", function(event) {
				if ($(this).is(":disabled") || $(this).prop("disabled")) {
					return;
				}
				//
				$(this).data("target").prop("checked", true);
				refreshCheckState();
			});
		}
	};
	//
	this.init = function(config) {
		initConfig = config || {};
		initConfig.items = initConfig.items || [];
		//
		this._createCtrls();
		//
		return this;
	};
	//
	this.setValue = function(value) {
		var radio = getRadioByValue(value);
		if (radio != null) {
			radio.prop("checked", true);
			refreshCheckState();
		}
		//
		return this;
	};
	//
	this.getValue = function() {
		return curValue;
	};
	//
	this.setDisabled = function(disabled) {
		makeDisabled(disabled);
		//
		return this;
	};
	//
	return this;
}
/**
 * 弹出层绑定代理
 */
function PopupProxy() {
	var noop = function() {
	};
	//
	this.popup = null;
	this.target = null;
	// 自定义处理函数
	this.onPopupShow = noop;
	this.onPopupHide = noop;
	//
	this.triggerPopupShow = function() {
		this.onPopupShow(this);
	};
	this.triggerPopupHide = function() {
		this.onPopupHide(this);
	};
	this.adjustPopupBottom = function(alignWhat) {
		var popup = this.getPopup();
		//
		var alignTarget = $(alignWhat);
		var alignOffset = alignTarget.offset();
		var targetBottom = alignOffset.top + alignTarget.height();
		var popupTop = targetBottom;
		var popupBottom = popupTop + popup.height();
		var scrollBottom = $(window).height();
		if (popupBottom > scrollBottom - 4) {
			popupTop -= (popupBottom - scrollBottom) + 4;
			popup.css("top", popupTop + "px");
		}
	};
	//
	this.bind = function(popup, target, alignTo, hrAlign) {
		this.popup = $(popup);
		this.target = $(target);
		//
		this.popup.hide();
		this.popup.css("position", "absolute");
		if (this.popup.width() > $(window).width()) {
			this.popup.width($(window).width());
		}
		//
		var popupEl = this.popup.get(0);
		var targetEl = this.target.get(0);
		var alignToEl = (alignTo == null) ? null : $(alignTo).get(0);
		hrAlign = hrAlign || "left";
		if (hrAlign === true) {
			hrAlign = "center";
		}
		var popupProxy = this;
		//
		this.popup.on("mousedown", false);
		this.popup.on("click", false);
		this.target.on("mousedown", function(event) {
			event.stopPropagation();
			var alignWhat = alignToEl != null ? alignToEl : targetEl;
			//
			if ($(popupEl).is(":hidden")) {
				$(document).triggerHandler("mousedown");
				//
				var disabled = $(targetEl).is(":disabled") || $(targetEl).prop("disabled") == true;
				if (!disabled) {
					$(popupEl).css("z-index", getMaxZIndex() + 1);
					$(popupEl).show();

					$(popupEl).position({
						my : (hrAlign == "center" ? "center top" : (hrAlign == "right" ? "right top" : "left top")),
						at : (hrAlign == "center" ? "center bottom" : (hrAlign == "right" ? "right bottom" : "left bottom")),
						of : alignWhat
					});
					popupProxy.triggerPopupShow();
				}
				$(document).one("mousedown", function(event) {
					if (event.target != popupEl && !$.contains(popupEl, event.target)) {
						if ($(popupEl).is(":visible")) {
							$(popupEl).hide();
							popupProxy.triggerPopupHide();
						}
					}
				});
			} else {
				$(popupEl).hide();
				popupProxy.triggerPopupHide();
			}
			popupProxy.adjustPopupBottom(alignWhat);
		});
		//
		return this;
	};
	this.getPopup = function() {
		return this.popup;
	};
	this.getTarget = function() {
		return this.target;
	};
	//
	return this;
}

PopupProxy.newOne = function() {
	return new PopupProxy();
};
/**
 * 下拉菜单
 *
 * @returns
 */
function DropdownMenu() {
	var popupProxy = null;
	var theMenu = null;
	var theMenuItems = [];
	var theMenuItemClickHandler = null;
	//
	this._createMenu = function() {
		if (theMenu == null) {
			var menuHtml = '<ul class="menu"></ul>';
			theMenu = $(menuHtml).appendTo(document.body);
			//
			theMenu.on("mousedown", "> li.menu-item", function(event) {
				$(event.target).addClass("menu-item-active");
			});
			theMenu.on("mouseup", "> li.menu-item", function(event) {
				$(event.target).removeClass("menu-item-active");
			});
			//
			theMenu.on("click", ">li.menu-item", function(event) {
				popupProxy.getPopup().hide();
				//
				if (theMenuItemClickHandler != null) {
					var menuItem = $(event.target);
					theMenuItemClickHandler(menuItem.data("data"), menuItem.text());
				}
			});
		}
	};
	this._createMenuItems = function() {
		theMenu.empty();
		//
		var menuItemCount = theMenuItems.length;
		for ( var i = 0; i < menuItemCount; i++) {
			var tmpItem = theMenuItems[i];
			var itemText = tmpItem.text;
			var itemHtml = '<li class="menu-item"></li>';
			var menuItem = $(itemHtml).appendTo(theMenu);
			menuItem.text(itemText);
			menuItem.data("data", tmpItem);
		}
		theMenu.find("> li.menu-item").hover(function() {
			$(this).addClass("menu-item-active");
		}, function() {
			$(this).removeClass("menu-item-active");
		});
	};
	//
	this.init = function(triggerId, hrRight) {
		this._createMenu();
		theMenu.css("display", "none");
		theMenu.addClass("boxShadow");
		if (isString(triggerId) && !triggerId.startsWith("#")) {
			triggerId = "#" + triggerId;
		}
		hrRight = hrRight || false;
		$(triggerId).css("cursor", "default");
		$(triggerId).addClass("drowDownBtn");
		//
		popupProxy = PopupProxy.newOne().bind(theMenu, triggerId, null, hrRight ? "right" : "left");
		//
		return this;
	};
	this.setMenuItemClickHandler = function(clickHandler) {
		theMenuItemClickHandler = clickHandler;
		//
		return this;
	};
	this.setMenuItems = function(menuItems) {
		theMenuItems = menuItems || [];
		this._createMenuItems();
		//
		return this;
	};
	//
	return this;
}
/**
 * 日期选择组件
 */
function DatePicker() {
	var noop = function() {
	};
	// 自定义处理函数
	this.onShow = noop;
	this.onHide = noop;
	this.onPicked = noop;
	//
	this._triggerShow = function() {
		this.onShow(this);
	};
	this._triggerHide = function() {
		this.onHide(this);
	};
	this._triggerPicked = function() {
		this.onPicked(this);
	};
	//
	var wrapperDiv = null;
	var popupProxy = null;
	//
	var _placeholder = "选择日期";
	this.setPlaceholder = function(placeholder) {
		_placeholder = placeholder;
	};
	// 当前日期范围（默认第二天开始的30天）
	var curDateRange = {
		startDate : new Date().addDays(1),
		endDate : new Date().addDays(30)
	};
	// 是否是周一作为一周的第一天（否则把周日作为一周的第一天）
	var mondayAsFirstDay = true;
	// 当前日期范围内的所有日期
	var curMonthDays = [];
	//
	function makeMonthWeekDays(monthDays) {
		if (monthDays == null || monthDays.length < 1) {
			return null;
		}
		var retArray = [];
		var weekDates = new Array(7);
		retArray.add(weekDates);
		var dateCount = monthDays.length;
		var weekLastDay = mondayAsFirstDay ? 0 : 6;
		var month = null;
		for ( var i = 0; i < dateCount; i++) {
			var tmpDate = monthDays[i];
			if (month == null) {
				month = tmpDate.getMonth();
				retArray.tagYear = tmpDate.getFullYear();
				retArray.tagMonth = month + 1;
			}
			var wkDay = tmpDate.getPart("dayofweek");
			weekDates[wkDay] = tmpDate;
			if (wkDay % 7 == weekLastDay && i < dateCount - 1) {
				weekDates = new Array(7);
				retArray.add(weekDates);
			}
		}
		return retArray;
	}

	//
	var ctrlsEverRendered = false;
	this._renderCtrls = function() {
		curMonthDays = [];
		//
		var dateList = [];
		var dateCount = curDateRange.endDate.diff(curDateRange.startDate, "day") + 1;
		var month = -1;
		for ( var i = 0, j = -1; i < dateCount; i++) {
			var tmpDate = curDateRange.startDate.addDays(i);
			dateList[i] = tmpDate;
			if (tmpDate.getMonth() != month) {
				month = tmpDate.getMonth();
				curMonthDays[++j] = [];
			}
			curMonthDays[j].add(tmpDate);
		}
		//
		var weekStartDay = mondayAsFirstDay ? 1 : 0;
		var wrapper = $(wrapperDiv);
		wrapper.empty();
		//
		var wkdayNamesHtml = String.builder();
		wkdayNamesHtml.append('<table class="thin-grid-line weekdayNames"><tr>');
		wkdayNamesHtml.append('<td class="blockHeader">周</td>');
		for ( var i = 0, j = weekStartDay; i < 7; i++, j++) {
			wkdayNamesHtml.append('<td>', __weekDayChsNames[j % 7], '</td>');
		}
		wkdayNamesHtml.append('</tr></table>');
		$(wkdayNamesHtml.value).appendTo(wrapper);
		//
		var monthCount = curMonthDays.length;
		for ( var i = 0; i < monthCount; i++) {
			var monthWeekDays = makeMonthWeekDays(curMonthDays[i]);
			var monthTbl = $("<table></table>").appendTo(wrapper);
			monthTbl.addClass("thin-grid-line weekdays");
			var rowCount = monthWeekDays.length;
			for ( var j = 0; j < rowCount; j++) {
				var weekDays = monthWeekDays[j];
				var weekTr = $('<tr></tr>').appendTo(monthTbl);
				if (j == 0) {
					weekTr.addClass("first");
					var monthHead = $('<td class="blockHeader"></td>').appendTo(weekTr);
					var yearHt = $('<span class="year">' + monthWeekDays.tagYear + "</span><br/>").appendTo(monthHead);
					var monthHt = $('<span class="month">' + monthWeekDays.tagMonth + "月</span><br/>").appendTo(monthHead);
					monthHead.attr("rowspan", rowCount);
				}
				for ( var k = 0, m = weekStartDay; k < 7; k++, m++) {
					var weekTd = $('<td></td>').appendTo(weekTr);
					var weekdayNo = m % 7;
					var tmpDate = weekDays[weekdayNo];
					if (tmpDate != null) {
						weekTd.attr("data-dateStr", tmpDate.format("yyyy-MM-dd"));
						weekTd.text(padLeft(tmpDate.getPart("day"), 2, " "));
						if (weekdayNo == 0 || weekdayNo == 6) {
							weekTd.addClass("weekend");
						} else {
							weekTd.addClass("workday");
						}
					} else {
						weekTd.html("&nbsp;");
					}
				}
			}
		}
		//
		ctrlsEverRendered = true;
	};

	this.init = function(ctrlId, alignTo, hrAlign) {
		var wrapper = null;
		if (wrapperDiv == null) {
			wrapperDiv = document.createElement("div");
			wrapperDiv = document.body.appendChild(wrapperDiv);
			wrapper = $(wrapperDiv);
			wrapper.addClass("datePicker");
		} else {
			wrapper = $(wrapperDiv);
		}
		wrapper.css("display", "none");
		wrapper.addClass("boxShadow");
		//
		if (isString(ctrlId) && !ctrlId.startsWith("#")) {
			ctrlId = "#" + ctrlId;
		}
		if (isString(alignTo) && !alignTo.startsWith("#")) {
			alignTo = "#" + alignTo;
		}
		$(ctrlId).prop("readonly", true);
		$(ctrlId).css("cursor", "default");
		popupProxy = PopupProxy.newOne().bind(wrapperDiv, ctrlId, alignTo, hrAlign);
		//
		var datePicker = this;
		popupProxy.onPopupShow = function(popupProxy) {
			var target = popupProxy.getTarget();
			var initDay = target.val();
			if (isNullOrBlank(initDay)) {
				target.get(0).placeholder = target.prop("placeholder") || _placeholder;
			}
			if (Date.isValidDate(initDay)) {
				datePicker.selectDay(initDay);
			}
			//
			datePicker._triggerShow();
		};
		//
		wrapper.on("click", '.weekdays td[data-datestr]', function(event) {
			var selected = wrapper.find('.weekdays td[data-datestr].selected-day');
			selected.removeClass("selected-day");
			var srcEl = event.target;
			$(srcEl).addClass("selected-day");
			// alert($(srcEl).attr("data-datestr"));
			popupProxy.getTarget().val($(srcEl).attr("data-datestr"));
			popupProxy.getPopup().hide();
			popupProxy.triggerPopupHide();
			//
			datePicker._triggerPicked();
		});
		//
		return this;
	};
	//
	this.getDateRange = function() {
		var retRange = {};
		retRange.startDate = curDateRange.startDate;
		retRange.endDate = curDateRange.endDate;
		return retRange;
	};
	//
	this.setDateRange = function(startDate, endDate) {
		if (typeof startDate == "string") {
			startDate = Date.parseAsDate(startDate);
		}
		if (typeof endDate == "string") {
			endDate = Date.parseAsDate(endDate);
		}
		if (endDate <= startDate) {
			endDate = startDate;
		}
		curDateRange.startDate = startDate;
		curDateRange.endDate = endDate;
		//
		this._renderCtrls();
		//
		return this;
	};

	//
	this.show = function() {
		popupProxy.getTarget().get(0).focus();
		popupProxy.getTarget().trigger("mousedown");
		//
		return this;
	};
	//
	this.getSelectedDay = function() {
		if (!ctrlsEverRendered) {
			this._renderCtrls();
		}
		//
		var wrapper = $(wrapperDiv);
		var selected = wrapper.find('.weekdays td[data-datestr].selected-day');
		if (selected.size() == 1) {
			return selected.attr("data-datestr");
		} else {
			return null;
		}
	};
	//
	this.selectDay = function(date) {
		if (!ctrlsEverRendered) {
			this._renderCtrls();
		}
		//
		var dateStr = date;
		if (typeof dateStr == "string") {
			dateStr = Date.parseAsDate(dateStr);
		}
		dateStr = dateStr.format("yyyy-MM-dd");
		var wrapper = $(wrapperDiv);
		var target = wrapper.find('.weekdays td[data-datestr="' + dateStr + '"]');
		if (target.is(":disabled")) {
			target.removeClass("selected-day");
		} else {
			var selected = wrapper.find('.weekdays td[data-datestr].selected-day');
			selected.removeClass("selected-day");
			target.addClass("selected-day");
		}
		//
		return this;
	};
	//
	this.disableDay = function(date, title) {
		if (!ctrlsEverRendered) {
			this._renderCtrls();
		}
		//
		var dateStr = date;
		if (typeof dateStr == "string") {
			dateStr = Date.parseAsDate(dateStr);
		}
		dateStr = dateStr.format("yyyy-MM-dd");
		var wrapper = $(wrapperDiv);
		var target = wrapper.find('.weekdays td[data-datestr="' + dateStr + '"]');
		if (target.size() > 0) {
			popupProxy.getTarget().val("");
			//
			target.prop("disabled", true);
			target.removeClass("selected-day");
			target.addClass("disabled-day");
			if (title != null) {
				target.attr("title", title);
			}
		}
		//
		return this;
	};
	//
	return this;
}