$(document)
		.ready(
				function() {
					$("#img_result").css("display", "none");
					var b = "";
					b += '<center><span class="t_00">(Max file size : 1Mb and extension : png,gif,jpg)</span></center>';
					$("#content_info").html(b)
				});
function load_image(m, k, n) {
	var r = k;
	var p = n;
	var l = document.createElement("canvas");
	l.className = "canvas_0";
	l.id = "canvas_0";
	l.width = r;
	l.height = p;
	document.getElementById("content").appendChild(l);
	if (typeof FlashCanvas != "undefined") {
		FlashCanvas.initElement(l)
	}
	var q = $("#canvas_0")[0];
	var h = q.getContext("2d");
	var o = new Image();
	o.onload = function() {
		h.drawImage(o, 0, 0)
	};
	o.src = m;
	setTimeout(function() {
		display_base64()
	}, 2000)
}
function display_base64() {
	var b = document.getElementById("canvas_0").toDataURL();
	$("#output_base64").val(b)
}
function upload_content() {
	if (typeof (window.FileReader) == "undefined") {
		alert("This browser does not support the features of Picbase64.com  \n It's recommended to use a browser like Chrome, Firefox, IE10, Safari, Opera,... ")
	} else {
		var i = document.getElementById("filetoupload");
		if (i.files[0] == undefined) {
			alert("Please upload a picture");
			return false
		}
		if (!i.files[0].type.match(/image.*/)) {
			alert("This is not image.");
			return false
		}
		var m = i.files[0];
		if (!m.type.match(/image\/png/) && !m.type.match(/image\/jpeg/)
				&& !m.type.match(/image\/gif/)) {
			alert("Error : picture must be a PNG or JPG or GIF");
			return false
		}
		var a = i.files[0].size;
		var k = 1152880;
		var j = 1;
		if (a > k) {
			alert("Picture size > " + j + " Mb .");
			return false
		}
		$("#loaded_im").html("");
		var b = new FileReader();
		var l = "";
		b.onload = function(d) {
			l = d.target.result;
			$("#content_picture")
					.html(
							'<center><div style="font-size:0.8em;margin:60px 0 0 0;">Loading............<a href="http://picbase64.com/">or cancel</a></div></center>');
			$("#img_result").attr("src", l);
			var c = window.location.href;
			var e = /http:\/\/picbase64.com/gi;
			if (!c.match(e)) {
				return false
			}
			var f = "id_im";
			setTimeout(
					function() {
						var r = document.getElementById("img_result").naturalWidth;
						var h = document.getElementById("img_result").naturalHeight;
						$("#" + f).width(r);
						$("#" + f).height(h);
						var g = "";
						g += '<div class="div_00" style="margin:20px 0 0 0;padding:10px 10px 5px 10px;">';
						g += '<form><div style="float:left;"><img style="width:200px;height:200px;" src="'
								+ l
								+ '" alt=""  border="0" /></div><div style="float:left;margin:0 0 0 20px;"><textarea style="width:430px;height:200px;">'
								+ l + "</textarea></div></form>";
						g += "<div style='clear:both;'></div></div>";
						var s = "";
						s += '<div class="div_00" style="margin:10px 0 0 0;padding:10px 10px 5px 10px;">';
						s += "<span style='color:#606060;'>" + r
								+ "</span> x <span style='color:#606060;'>" + h
								+ "</span> pixels";
						s += "</div>";
						$("#content_picture").html(g + s)
					}, 2000)
		};
		b.readAsDataURL(i.files[0])
	}
};