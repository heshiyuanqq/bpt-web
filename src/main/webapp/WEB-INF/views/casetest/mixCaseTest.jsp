<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglibs.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script language="javascript" type="text/javascript"
	src="${ctx}/js/jquery-1.8.0.js"></script>
<script language="javascript" type="text/javascript"
	src="${ctx}/js/jquery.form.js"></script>


<link rel="stylesheet"
	href="${ctx}/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="${ctx}/bootstrap/css/bootstrap-theme.min.css">

<script src="${ctx}/js/jquery.min.js"></script>
<script
	src="${ctx}/js/bootstrap/bootstrap.min.js"></script>

<link rel="stylesheet"
	href="${ctx}/resources/css/jquery.ext.css">
<script
	src="${ctx}/resources/common/common.js"></script>
<script
	src="${ctx}/resources/common/jquery.ext.js"></script>
<title>混合测试</title>


<style type="text/css">
.left_title {
	width: 99%;
	height: 30px;
	background: #3FB4D7 none repeat scroll 0% 0%;
	background-image: linear-gradient(to bottom, #5BC0DE 0px, #2AABD2 100%);
	line-height: 30px;
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	font-size: 14px;
	color: #FFF;
	border: 1px solid #28A4C9;
	border-radius: 6px;
	margin: 2px auto;
	text-align: center;
}

#casetitle {
	background-color: #F0F1F3;
	height: 34px;
	color: #FFF;
	font-size: 14px;
	font-weight: bolder;
	font: inherit;
	line-height: 33px;
	border-bottom: 1px solid #000;
}

.col-xs-12 {
	width: 99%;
	border: 1px solid #000;
	/* overflow-y: hidden; */
	padding-left: 0px;
	padding-right: 0px;
	height: 100%
}

.select_item {
	float: left;
	width: 170px;
	border-right: 1px solid #000;
	text-align: center;
	cursor: pointer;
}

.del_button {
	float: right;
	height: 30px;
	width: 40px;
	margin-top: 2px;
	padding: 3px 2px;
}

.glysize {
	font-size: 24px;
	color: #5bc8cc;
	cursor: pointer;
}
</style>
<script type="text/javascript">
	
	function Trim(s) {//过滤空格
		return s.replace(/(^\s*)|(\s*$)/g, "");
	}
	
	function makeItToBeInt(obj)
	{
		obj.value=obj.value.replace(/\D/g,'');
	}
	
	function setselect(divindex) {
		var column2 = document.getElementById("column2-col");
		var column3 = document.getElementById("column3-col");
		$('#u1').css("background-color", "#C0C0C4");
		$('#u2').css("background-color", "#C0C0C4");
		$('#u1').attr("value", "false");
		$('#u2').attr("value", "false");
		switch (divindex) {
		case 1://随机混合
			column2.style.display = "";
			/* 	enb.style.display = "none"; */
			column3.style.display = "none";

			$('#u' + divindex).css("background-color", "#61BF74");
			$('#u' + divindex).attr("value", "true");

			break;
		case 2://分组混合业务
			column3.style.display = "";
			/* 	enb.style.display = "none"; */
			column2.style.display = "none";

			$('#u' + divindex).css("background-color", "#61BF74");
			$('#u' + divindex).attr("value", "true");
			break;
		default:
			break;
		}
	}
	
	//用户组数组
	var groupArray;
	
	var actionlength = 0;
	
	function getUeGroupList(){
		$.ajax({
				type : "POST",
				async : false,
				url : "${ctx}/webCaseTest/getGroupList",
		        data:  {
			},
			success : function(data) {
				if(data != null){
					groupArray = $.parseJSON(data);		
				}else{
					groupArray = null;
				}
			},
			fail : function() {
				
				groupArray = null;
			}
		});
	}
	
	var actionArray = null;
	function getActionList(){
		$.ajax({
				type : "POST",
				async : false,
				url : "${ctx}/webAction/getActionListWeb",
				success : function(data){
					if(data != null && data != '' && data != "FAILED"){
						//console.log(data);
						actionArray = $.parseJSON(data);
					}else{
						actionArray = null;
					}
				},
				fail : function() {
					actionArray = null;
				}
		});
	}
	
	function getActionSelectHTML(actionid){
		if(actionArray == null){
			getActionList();
			//console.log(actionArray);
		}
		var selectHTML = "<div style='width: 80%;height:30px; margin: 10px auto'>";
		selectHTML += "<select id='action"+ actionid +"' class='form-control' name='actionselect' style='text-align: center;float:left;width:80%'>";
		for(var i=0;i<actionArray.length;i++){
			selectHTML += "<option value='"+actionArray[i].actionname+"'>"+actionArray[i].businessname+"</option>";
		}
		selectHTML += "</select>";
		selectHTML += "<div class='del_button'><span type='button' class='glyphicon glyphicon-remove glysize' aria-hidden='true' onclick='deleteaction(this)'></span><div>";
		selectHTML += "</div>";
		return selectHTML;
	}
	
	/**
	* 构建用户组选择器
	**/
	function getSelectHTML(groupid){
		
		//if(groupArray == null){
		//	getUeGroupList();
		//}
		
		getUeGroupList();
		var selectHTML = "<div style='width: 80%;height: 30px; margin: 10px auto'>";
		selectHTML += "<select id='groupselect"+groupid+"' class='form-control' style='text-align: center;'>";
		for(var i=0;i<groupArray.length;i++){
			selectHTML += "<option value='"+groupArray[i]+"'>"+groupArray[i]+"</option>";
		}
		selectHTML += "</select>";
		selectHTML += "</div>";
		return selectHTML;
	}
	
	function getRadioHTML(actionid){
		var radioHTML = "<form class='form-inline' style='width: 80%;height: 30px; margin: 10px auto'>";
		radioHTML += "<div class='form-group' style='width: 100%;'>";
		radioHTML += "<label class='sr-only' for='exampleInputAmount'>比例</label>";
		radioHTML += "<div class='input-group' style='width: 100%;'>";
		radioHTML += "<input id='ratio"+actionid+"' type='number' class='form-control' id='exampleInputAmount' placeholder='比例'";
		radioHTML += "style='text-align: center' onkeyup='makeItToBeInt(this)'  min='0' max='100' ><div class='input-group-addon'>%</div></div></div></form>";
		return radioHTML;
	}
	
	function getDelayHTML(actionid)
	{
		var delayHTML = "<form class='form-inline' style='width: 80%;height: 30px; margin: 10px auto'>";
		delayHTML += "<div class='form-group' style='width: 100%;'>";
		delayHTML += "<label class='sr-only' for='exampleInputAmount'>时延(s):</label>";
		delayHTML += "<div class='input-group' style='width: 100%;'>";
		delayHTML += "<input id='delay"+actionid+"' type='number' class='form-control' id='exampleInputAmount' placeholder='0'";
		delayHTML += "style='text-align: center' onkeyup='makeItToBeInt(this)'  min='0' max='10000' ><div class='input-group-addon'>s</div></div></div></form>";
		return delayHTML;
		
	}
	
	
	/**
	* 行为实体类
	**/
	function actionObj(action,step,time,delay,duration){
		this.action = action;
		this.step = step;
		this.time = time;
		this.delay = delay;
		this.duration = duration;
	}
	
	/**
	* 行为实体类
	**/
	function behaviorObj(actionobj,grouptag,ratio){
		this.action = actionobj;
		this.grouptag = grouptag;
		this.ratio = ratio;
	}
	
	function getcasetype(){
		var ratiocase = $("#u1").attr("value");
		var groupcase = $("#u2").attr("value");
		if(ratiocase == "true"){
			return 1;
		}else if(groupcase == "true"){
			return 2;
		}else{
			return null;
		}
	}
	
	function getcaseduration(){
		var caseduration = Trim($("#duration_time_input").val());
		var reg = new RegExp("^[0-9]*[0-9][0-9]*$"); 
		if(reg.test(caseduration)){
			return caseduration;
		}else{
			Toast.show("执行时长格式错误！");
			return null;
		}
	}
	
	function getcasedalay()
	{
		
		var casedelay = Trim($("#delay_time_input").val());
		var reg = new RegExp("^[0-9]*[0-9][0-9]*$"); 
		if(reg.test(casedelay)){
			return casedelay;
		}else{
			Toast.show("执行时长格式错误！");
			return null;
		}
	}
	
	
	function sendcase(){
		var casetype = getcasetype();
		var caseduration = getcaseduration();
		var casedelay = getcasedalay();
		
		if(casedelay == null)
			casedelay =0;
		
		
		if(casetype != null && caseduration != null){
			var behaviorList = new Array();
			switch(casetype){
				case 1:
					for(var index = 1;index <= actionlength;index++){
						var action = $("#action"+index).val();
						var ratio = $("#ratio"+index).val();
						var delay = $("#delay"+index).val();
						if(delay==null || delay=="")
							delay=0;
						var actionobj = new actionObj(action,1,1,parseInt(delay)+parseInt(casedelay),caseduration);
						var behaviorobj = new behaviorObj(actionobj,"",ratio);
						behaviorList[index-1] = behaviorobj;
					}
					//console.log(JSON.stringify(behaviorList));
			 	break;
				case 2:
					for(var index = 1;index <= actionlength;index++){
						var action = $("#action"+index).val();
						var grouptag = $("#groupselect"+index).val();
						var delay = $("#delay"+index).val();
						if(delay==null || delay=="")
							delay=0;
						var actionobj = new actionObj(action,1,1,parseInt(delay)+parseInt(casedelay),caseduration);
						var behaviorobj = new behaviorObj(actionobj,grouptag,0);
						behaviorList[index-1] = behaviorobj;
					}
					console.log(JSON.stringify(behaviorList));					
			  	break;
			}
			if(behaviorList.length>0){
				$.ajax({
					type : "POST",
					async : false,
					url : "${ctx}/webCaseTest/sendCaseWeb",
			        data:  {
			        	behaviorList : JSON.stringify(behaviorList),
			        	casetype : casetype,
					},
					success : function(data) {
						Toast.show(data, 3000);
					},
					fail : function() {
						//alert("查询失败！");
						groupArray = null;
					}
				});
			}
		}
		
	}
	
	function stopcase(){
		$.ajax({
			type : "POST",
			async : false,
			url : "${ctx}/webCaseTest/stopCaseWeb",
	        data:  {
			},
			success : function(data) {
				Toast.show(data,5000);
			},
			fail : function() {
				Toast.show("失败！",5000);
			}
		});	
	}
	
	function addaction(){
		if(actionlength == 50){
			Toast.show("目前只能添加50个！sorry");
			//$(".toast").css("z-index", 1000);
			return;
		}
		var actionlast = actionlength;
		var newaction = actionlast + 1;
		$("#actionselect").append(getActionSelectHTML(newaction));
		$("#groupselect").append(getSelectHTML(newaction));
		$("#radioselect").append(getRadioHTML(newaction));
		$("#delayselect").append(getDelayHTML(newaction));
		actionlength ++;
	}
	
	function deleteaction(action){
		var ac = $(action).parent().prev();
		var actionid = parseInt($(ac).attr("id").substring(6));
		$(ac).parent().remove();
		$("#groupselect"+actionid).parent().remove();
		$("#ratio"+actionid).parent().parent().parent().remove();
		$("#delay"+actionid).parent().parent().parent().remove();
		for(var i= actionid+1;i<= actionlength;i++){
			$("#action"+i).attr("id","action"+(i-1));
			$("#ratio"+i).attr("id","ratio"+(i-1));
			$("#groupselect"+i).attr("id","groupselect"+(i-1));
			$("#delay"+i).attr("id","delay"+(i-1));
		}
		actionlength--;
		
	}
</script>

</head>

<body>
	<div style="width: 100%; height: auto; position: absolute;">

		<div id="column1-col"
			style="width: 69%; height: 100%; position: relative; float: left; margin: 5px 2px;">
			<div class="left_title">测试参数详情</div>
			<div id="context1"
				style="width: 99%; height: auto; border: 1px solid #DDD; border-radius: 6px; margin: 4px auto; padding: 10px">
				<div class="container-fluid">

					<div class="col-xs-12">
						<div id="casetitle">
							<div id="u1" onclick="return setselect(1);" value="false"
								class="select_item" style="background-color: #C0C0C4;">
								<span>随机混合业务</span>
							</div>
							<div id="u2" onclick="return setselect(2);" value="true"
								class="select_item" style="background-color: #61BF74;">
								<span>分组混合业务</span>
							</div>
							<div id="add" style="float: right; width: 40px" title="增加">
								<span
									style="cursor: pointer; color: #2AABD2; text-align: center; line-height: 32px;"
									class="glyphicon glyphicon-plus" aria-hidden="true"
									onclick="addaction()"></span>
							</div>
						</div>


						<div id="column1-col"
							style="width: 40%; height: 100%; position: relative; float: left; margin: 5px 2px;">
							<div class="left_title">业务类型</div>
							<div id="actionselect"
								style="width: 99%; height: 550px; border: 1px solid #DDD; border-radius: 6px; margin: 4px auto;">
								
							</div>

						</div>
						<div id="column2-col"
							style="width: 30%; height: 100%; position: relative; float: left; margin: 5px 2px; display: none">
							<div class="left_title">随机比例</div>
							<div id="radioselect"
								style="width: 99%; height: 550px; border: 1px solid #DDD; border-radius: 6px; margin: 4px auto;">
								<!-- <form class="form-inline" style="width: 80%; margin: 10px auto">
									<div class="form-group" style="width: 100%;">
										<label class="sr-only" for="exampleInputAmount">比例</label>
										<div class="input-group" style="width: 100%;">
											<input id="ratio1" type="text" class="form-control"
												id="exampleInputAmount" placeholder="比例"
												style="text-align: center">
											<div class="input-group-addon">%</div>
										</div>
									</div>
								</form> -->
							</div>
						</div>


						<div id="column3-col"
							style="width: 30%; height: 100%; position: relative; float: left; margin: 5px 2px; display:">
							<div class="left_title">指定分组</div>
							<div id="groupselect"
								style="width: 99%; height: 550px; border: 1px solid #DDD; border-radius: 6px; margin: 4px auto;">
								
							</div>
						</div>
						
						<div id="column4-col"
							style="width: 25%; height: 100%; position: relative; float: left; margin: 5px 2px; display:">
							<div class="left_title">分组延时</div>
							<div id="delayselect"
								style="width: 99%; height: 550px; border: 1px solid #DDD; border-radius: 6px; margin: 4px auto;">
								
							</div>
						</div>


					</div>
				</div>
			</div>
		</div>
		<div id="column2-col"
			style="width: 30%; height: 100%; position: relative; float: left; margin: 5px 2px;">
			<div class="left_title">执行/终止测试</div>

			<div id="context2"
				style="width: 99%; height: auto; border: 1px solid #DDD; border-radius: 6px; margin: 4px auto;">
				<div id="start_time"
					style="margin: 10px auto; width: 80%; font-size: 16px;">
					<span style="float: left; padding-top: 3px"><span
						class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>
						延时执行(秒)：</span><input id="delay_time_input"
						style="width: 66%; height: 25px; text-align: center" value="0"
						type="text">


				</div>
				<div id="duration_time"
					style="margin: 10px auto; width: 80%; font-size: 16px;">
					<span style="float: left; padding-top: 3px"><span
						class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>
						执行时长(秒) ：</span> <input id="duration_time_input"
						style="width: 66%; height: 25px; text-align: center" value="600"
						type="text">
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-primary"
						onclick="return sendcase();" data-dismiss="modal">下发</button>
					<button type="button" class="btn btn-danger"
						onclick="return stopcase();" data-dismiss="modal">停止</button>
				</div>

			</div>
		</div>
	</div>



</body>
</html>