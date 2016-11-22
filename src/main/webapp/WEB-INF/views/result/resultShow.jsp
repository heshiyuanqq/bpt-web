<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/css/public.css"
	rel="stylesheet" type="text/css">

<link href="${ctx}/css/buttonstyle.css"
	rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript"
	src="${ctx}/js/jquery-1.8.0.js"></script>
<script language="javascript" type="text/javascript"
	src="${ctx}/js/jquery.form.js"></script>


<script type="text/javascript" language="javascript"
	src="${ctx}/js/commenhead.js"></script>
<script type="text/javascript" language="javascript"
	src="${ctx}/js/taskmain/fxw_taskmain.js"></script>

<link rel="stylesheet"
	href="${ctx}/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="${ctx}/bootstrap/css/bootstrap-theme.min.css">
<link rel="stylesheet"
	href="${ctx}/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css"
	rel="stylesheet">
<script src="${ctx}/js/jquery.min.js"></script>
<%-- <script src="${ctx}/js/map.js"></script> --%>
<script
	src="${ctx}/js/bootstrap/bootstrap.min.js"></script>
<script
	src="${ctx}/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<title>eNB大容量性能测试集装箱系统</title>
<style type="text/css">
.glyphicon {
	cursor: pointer;
}

.glyphicon {
	cursor: pointer;
}
</style>
<script type="text/javascript">
	function extend(row) {
		var strs = new Array(); //定义一数组
		var j = 0;
		var k = 0;
		var i = 2;
		strs = row.split("w"); //字符分割 
		if ($("#" + row).attr("class") == "glyphicon glyphicon-arrow-down") {
			if (strs[1] < 5) {
				j = 5;
				k = 2;
			} else if (strs[1] == 5) {
				j = 2;
				k = 2;
			} else if (strs[1] == 6) {
				j = 7;
				k = 7;
			} else if (strs[1] == 7) {
				j = 3;
				k = 6;
			} else if (strs[1] == 8) {
				j = 2;
				k = 3;
			} else if (strs[1] == 9) {
				j = 3;
				k = 8;
			}
			for (; i <= j; i++) {
				for ( var n = 1; n <= k; n++) {
					document.getElementById(row + i + n).style.display = "";
				}
			}
			$("#" + row).attr("class", "glyphicon glyphicon-arrow-up");
		} else {
			if (strs[1] < 5) {
				j = 5;
				k = 2;
			} else if (strs[1] == 5) {
				j = 2;
				k = 2;
			} else if (strs[1] == 6) {
				j = 7;
				k = 7;
				i = 6;
			} else if (strs[1] == 7) {
				j = 3;
				k = 6;
			} else if (strs[1] == 8) {
				j = 2;
				k = 3;
			} else if (strs[1] == 9) {
				j = 3;
				k = 8;
			}

			for (; i <= j; i++) {
				for ( var n = 1; n <= k; n++) {
					document.getElementById(row + i + n).style.display = "none";
				}
			}
			$("#" + row).attr("class", "glyphicon glyphicon-arrow-down");
		}
	}
	
	function returnpre(){
		$("#return").attr("href","${ctx}/nav/result/resultMain");
		document.getElementById("return").click();
	}

	function extendrow(row, j) {
		var strs = new Array(); //定义一数组
		var i = 3;
		strs = row.split("w"); //字符分割 
		if ($("#" + row).attr("class") == "glyphicon glyphicon-arrow-down") {
			for (; i <= j; i++) {
				document.getElementById(row + i).style.display = "";
			}
			$("#" + row).attr("class", "glyphicon glyphicon-arrow-up");
		} else {

			for (; i <= j; i++) {
				document.getElementById(row + i).style.display = "none";
			}
			$("#" + row).attr("class", "glyphicon glyphicon-arrow-down");
		}
	}

	function getjigui(jg) {
		document.getElementById("jigui").value = jg;
	}

	function getpingbi(pb) {
		document.getElementById("pingbi").value = pb;
	}

	function getue(ue) {
		document.getElementById("ue").value = ue;
	}

	function getxiangti(xt) {
		document.getElementById("xiangti").value = xt;
	}
</script>

</head>
<body style="font-size: 11px">
	<div style="float: left; width: 100%">
		<div class="alert alert-info" role="alert">
			<h4>
				<p class="text-center">
					<strong><span class="glyphicon glyphicon-arrow-left "
						aria-hidden="true" onclick="returnpre();"></span>&nbsp;&nbsp;
						${logAnylizeInfoVO.caselogname}</strong>
				</p>
			</h4>
		</div>
		<a id="return" style="display: none;"></a>

		<div class="panel panel-danger" id="network_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-signal" aria-hidden="true"></span>&nbsp;
				总流量速率实时变化图
			</div>
			<div class="panel-footer">
 				<!-- <div id="network" style="width: 100%; height: 300px"></div> -->
			    <div id="network_flow" style="width: 100%; height: 300px"></div>
 			    <div id="call_flow" style="width: 100%; height: 300px"></div>
			   <!--  <div id="video_flow" style="width: 100%; height: 300px"></div> -->
				
			</div>
		</div>

		<!-- <div class="panel panel-danger" id="sms_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-folder-open" aria-hidden="true"></span>&nbsp;
				短信业务：接收时间分布，共接收短信***条
			</div>
			<div class="panel-footer">
				<div id="sms" style="width: 100%; height: 300px"></div>

			</div>
		</div> -->


		<!-- <div class="panel panel-danger" id="tab_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home"  aria-hidden="true"></span>&nbsp;
				切换/重选事件图与时延分析
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: 320px">
				<div id="tab" style="float: left; width: 48%; height: 300px"></div>
				<div id="delay" style="float: left; width: 48%; height: 300px">

				</div>

			</div>
		</div> -->

		<div class="panel panel-danger" id="ftp_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;
				FTP业务：总速率
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: ">
				<div id="ftpdown_speed" style="width: 98%; height: 300px"></div>
				<div id="ftpup_speed" style="width: 98%; height: 300px"></div>
				<div id="ftp_fail" style="width: 98%; height: 300px"></div>

			</div>
		</div>

		<div class="panel panel-danger" id="call_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;
				语音业务：通话接通率，通话用户数
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: 640px">
				<div id="call_success"
					style="float: left; width: 100%; height: 300px"></div>
				<div id="call_number" style="float: left; width: 100%; height: 300px">

				</div>

			</div>
		</div>




		<!-- <div class="panel panel-danger" id="ping_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;
				Ping业务：成功率，网页打开时延
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: 640px">
				<div id="ping_fail" style="float: left; width: 48%; height: 300px">

				</div>
				<div id="ping_success"
					style="float: left; width: 98%; height: 300px"></div>
				<div id="ping_delay"
					style="float: left; width: 100%; height: 300px; margin-top: 20px">

				</div>

			</div>
		</div> -->


		<div class="panel panel-danger" id="web_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;
				Web业务：成功率，网页打开时延
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: 950spx">
				<div id="web_fail" style="float: left; width: 98%; height: 300px"></div>
				<div id="web_success" style="float: left; width: 98%; height: 300px"></div>
				<div id="web_delay" style="float: left; width: 98%; height: 300px; margin-top: 20px"></div>
			</div>
		</div>


		<!--<div class="panel panel-danger" id="weixintext_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;
				微信文本业务：成功率，文本消息时延
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: 640px">
				<div id="weixintext_fail"
					style="float: left; width: 48%; height: 300px"></div>
				<div id="weixintext_success"
					style="float: left; width: 98%; height: 300px"></div>
				<div id="weixintext_delay"
					style="float: left; width: 100%; height: 300px; margin-top: 20px">

				</div>

			</div>
		</div>


		<div class="panel panel-danger" id="weixinimage_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;
				微信图片业务：失败事件，成功率，网页打开时延
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: 640px">
				<div id="weixinimage_fail"
					style="float: left; width: 48%; height: 300px"></div>
				<div id="weixinimage_success"
					style="float: left; width: 48%; height: 300px"></div>
				<div id="weixinimage_delay"
					style="float: left; width: 100%; height: 300px; margin-top: 20px">

				</div>

			</div>
		</div>

		<div class="panel panel-danger" id="weixinvideo_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;
				微信视频业务：失败事件，成功率，网页打开时延
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: 640px">
				<div id="weixinvideo_fail"
					style="float: left; width: 48%; height: 300px"></div>
				<div id="weixinvideo_success"
					style="float: left; width: 48%; height: 300px"></div>
				<div id="weixinvideo_delay"
					style="float: left; width: 100%; height: 300px; margin-top: 20px">

				</div>

			</div>
		</div>

		<div class="panel panel-danger" id="weixinvoice_picture"
			style="float: left; width: 98%; margin-left: 1.7%">
			<div class="panel-heading">
				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;
				微信语音业务：失败事件，成功率，网页打开时延
			</div>
			<div class="panel-footer"
				style="float: left; width: 100%; height: 640px">
				<div id="weixinvoice_fail"
					style="float: left; width: 48%; height: 300px"></div>
				<div id="weixinvoice_success"
					style="float: left; width: 48%; height: 300px"></div>
				<div id="weixinvoice_delay"
					style="float: left; width: 100%; height: 300px; margin-top: 20px">

				</div>

			</div> -->
	</div>


	<script
		src="${ctx}/echarts/build/dist/echarts.js"></script>
	<script type="text/javascript">
			
			require.config({
						paths : {
							echarts : '${ctx}/echarts/build/dist'
						}
					});
			require(
					[ 'echarts', 'echarts/chart/line', // 按需加载所需图表，如需动态类型切换功能，别忘了同时加载相应图表
					'echarts/chart/bar', 'echarts/chart/scatter',
							'echarts/chart/pie' ],
					function(ec) {
						<%--NETWORK画图--%>
					
					
					/* var myChart = ec.init(document
					.getElementById('network')); */
					function getnetworkpic(a) {
						myChartnew1.showLoading({
							  text: 'loading',
							  color: 'red',
							  textColor: 'blue',
							  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
							 maskColor: 'rgba(255, 255, 255, 0.8)',
							  zlevel:0
							});
						myChart5.showLoading({
							  text: 'loading',
							  color: 'red',
							  textColor: 'blue',
							  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
							 maskColor: 'rgba(255, 255, 255, 0.8)',
							  zlevel:0
							});
						$.ajax({
								type : "POST",
								async : true,
								url : "${ctx}/logtopic/getnetworklog",
								data : {
									case_name : "${logAnylizeInfoVO.caselogname}"
								},
								success : function(data) {
									//alert(data);
									//var a11 = 1;
									var cell_type = [];
									var allcell = [];
									//a11 = a11 + 15;
									if (null != data && data != 'null' && data != '') {
										$("#network_picture").show();
										var networkdata = new Array();
										//alert(data);
										networkdata = data.split("$$");
										var getnetworkdata = $
												.parseJSON(networkdata[2]);
										var networktype = $
												.parseJSON(networkdata[0]);
										
										for ( var i = 0; i < networkdata[1]; i++) {
											cell_type
													.push(networktype[i].cellname);
											var net;
											switch (i) {
											case 0:
												net = getnetworkdata.CELL1;
												break;
											case 1:
												net = getnetworkdata.CELL2;
												break;
											case 2:
												net = getnetworkdata.CELL3;
												break;
											case 3:
												net = getnetworkdata.CELL4;
												break;
											case 4:
												net = getnetworkdata.CELL5;
												break;
											case 5:
												net = getnetworkdata.CELL6;
												break;
											case 6:
												net = getnetworkdata.CELL7;
												break;
											case 7:
												net = getnetworkdata.CELL8;
												break;
											case 8:
												net = getnetworkdata.CELL9;
												break;
											case 9:
												net = getnetworkdata.CELL10;
												break;
											case 10:
												net = getnetworkdata.CELL11;
												break;
											case 11:
												net = getnetworkdata.CELL12;
												break;
											case 12:
												net = getnetworkdata.CELL13;
												break;
											default:
												alert("小区ID出错");
											}
											var cell = [];
											console.log(net);
											for ( var j = 0; j < net.length; j++) {

												cell
														.push([
																net[j].x_data
																		,
																net[j].y_data ]);

												var title0 = net[j].start_time;
											}

											allcell.push(cell);

										}
										var option = {
											title : {
												/* text : '网络强度(' + title0
														+ ')　', */
												text: 'LTE　RSRP',
												x:'center',
												y:'25'
											},
											tooltip : {
												trigger : 'axis',
												showDelay : 1,
												formatter : function(
														params) {
													if (params.value.length > 1) {
														return "小区ID:"
																+ params.seriesName
																+ ' :<br/>time:'
																+ params.value[0]
																+ 's <br/>RSRP:'
																+ params.value[1]
																+ '(dbm) ';
													} else {
														return params.seriesName
																+ ' :<br/>'
																+ params.name
																+ ' : '
																+ params.value;
													}
												},
												axisPointer : {
													show : true,
													type : 'cross',
													lineStyle : {
														type : 'dashed',
														width : 1
													}
												}
											},
											legend : {
												data : cell_type,
												x : 'right',
												y: '25'
											},

											toolbox : {
												show : false,
												feature : {
													dataZoom : {
														show : true
													},
													restore : {
														show : true
													},
													saveAsImage : {
														show : true
													}
												}
											},
											dataZoom : {

												fillerColor : '#00EEEE',
												show : true,
												realtime : true,
												
											},
											xAxis : [ {
												type : 'value',
												scale : true,
												name : 'time(s)',
												axisLabel : {
													formatter : '{value} '
												}
											} ],
											yAxis : [ {
												type : 'value',
												scale : true,
												name : 'RSRP (dbm)',
												axisLabel : {
													formatter : '{value}'
												}
											} ],
											series : (function() {
												var all = [];
												for ( var i = 0; i < networkdata[1]; i++) {
													// alert(networktype[i].cellid);
													var one = {
														name : networktype[i].cellname,
														type : 'scatter',
														data : allcell[i],
														markPoint : {
															effect : {
																show : false,
																type : 'scale',
																loop : true,
																period : 15,
																scaleSize : 1,
																bounceDistance : 10,
																color : null,
																shadowColor : null,
																shadowBlur : 0
															},
															data : [
																	{
																		type : 'max',
																		name : '最大值'
																	},
																	{
																		type : 'min',
																		name : '最小值'
																	} ]
														},
														markLine : {
															data : [ {
																type : 'average',
																name : '平均值'
															} ]
														}
													}
													all.push(one);
												}
												return all;

											})(),
										};
												//myChart.hideLoading();
 												//myChart.setOption(option);

									} else {
										//clearInterval(getnetworkpic_time);
										//$("#network_picture").remove();
										$("#network").hide();
									}

								},
								fail : function() {
									alert("Web业务统计查询失败！");
								}
							});
				}

				//getnetworkpic();
				/* var getnetworkpic_time = setInterval(getnetworkpic,
						15000); */
				
				/*电话流量速率  */
				var myChartnew1 = ec.init(document.getElementById('call_flow'));
				function getcallflow() {
					       	  
		              $.ajax({
		        			type : "POST",
		        			async : false,
		        			url : "${ctx}/logtopic/getnetworkflowlog",
		        			data : { 
		        				case_name : "${logAnylizeInfoVO.caselogname}",
		        				name : 'calllog'
		        			},
		                  
		        			success : function(data) {
		        				//alert("VoLTE");
		  					var xAxisDate = new Array();
		  					var seriesDateUp = new Array();
		  					var seriesDateDown = new Array();
		                               
		        			   if(null != data && data != 'null' && data != ''){
		  	   					var networkFlowList = $.parseJSON(data);
		  	   					for (var i = 0; i < networkFlowList.length; i++) {
		  	   						var networkFlowObj = networkFlowList[i];
		  	   						xAxisDate.push(networkFlowObj.x_data );
		  	   						seriesDateUp.push(networkFlowObj.y_updata);
		  	   						seriesDateDown.push(networkFlowObj.y_downdata);
		  	   					}
		  	   							          	   		                 
		                 var option1 = {
		                		 title : {
		                			 text: 'VoLTE',
										x:'center',
										y:'25'
									},
		         				tooltip : {
		         					trigger : 'axis'
		         				},
		         				//上侧折线图对应Key
		         				legend : {
		         					data : [ 'DL', 'UL' ],
		         					x : 'right',
		         					y:'25'
		         				},
		         				//上侧多态图标栏显示,不需要直接关闭
		         				toolbox : {
		         					show : true,
		         					feature : {
		         						mark : {
		         							show : true
		         						},
		         						dataView : {
		         							show : true,
		         							readOnly : false
		         						},
		         						magicType : {
		         							show : true,
		         							type : [ 'line', 'bar' ]
		         						},
		         						restore : {
		         							show : true
		         						},
		         						saveAsImage : {
		         							show : true
		         						}
		         					}
		         				},
		         				dataZoom : {
		   		  		    	fillerColor:'#00EEEE',
		   		  		        show : true,
		   		  		        realtime: true,
		   		  		        start:0,
		   		  		        end:10
		   		  		        
		   		  		    },
		         				calculable : true,
		         				xAxis : [ {
		         					type : 'category',
		         					boundaryGap : false,
		         					name:'time(s)',
		         					data : xAxisDate
		         				} ],
		         				yAxis : [ {
		         					type : 'value',
		         					name:'Data Rate(Mbps)',
		  	    		        interval:'auto',
		  	    		        scale:true,
		         					axisLabel : {
		         						formatter : '{value}'
		         					}
		         				} ],
		         				series : [ {
		         					name : 'DL',
		         					type : 'line',
		         					data : seriesDateDown
		         				}, {
		         					name : 'UL',
		         					type : 'line',
		         					data : seriesDateUp
		         				} ]
		         			};		    				  				          
				  				         myChartnew1.setOption(option1); 
				  				         myChartnew1.hideLoading();
		     
		        				}else{
		        					//alert("Network业务统计查询失败！");
		        					$("#call_flow").hide();
		        				}

		        			},
		        			fail : function() {
		        				alert("总流量速率业务统计查询失败！");
		        			}
				
						});
					}
					getcallflow();
					//var getcallflow_time = setInterval(getcallflow, 15000);
			
				
					/*视频流量速率  */
					//var myChartnew2 = ec.init(document.getElementById('video_flow'));
					function getvideoflow() {
					       	  
		              $.ajax({
		        			type : "POST",
		        			async : false,
		        			url : "${ctx}/logtopic/getnetworkflowlog",
		        			data : { 
		        				case_name : "${logAnylizeInfoVO.caselogname}",
		        				name : 'videolog'
		        			},
		                  
		        			success : function(data) {   
		        				alert("Video");
		  					var xAxisDate = new Array();
		  					var seriesDateUp = new Array();
		  					var seriesDateDown = new Array();
		                               
		        			   if(null != data && data != 'null' && data != ''){
		  	   					var networkFlowList = $.parseJSON(data);
		  	   					for (var i = 0; i < networkFlowList.length; i++) {
		  	   						var networkFlowObj = networkFlowList[i];
		  	   						xAxisDate.push(networkFlowObj.x_data );
		  	   						seriesDateUp.push(networkFlowObj.y_updata);
		  	   						seriesDateDown.push(networkFlowObj.y_downdata);
		  	   					}
		  	   							          	   		                 
		                 var option2 = {
		                		 title : {
		                			 text: 'Video',
		     		   		        x:'center',
		     		   		        y:'25'
									},
		         				tooltip : {
		         					trigger : 'axis'
		         				},
		         				//上侧折线图对应Key
		         				legend : {
		         					data : [ 'DL', 'UL' ],
		         					x : 'right',
		         					y:'25'
		         					
		         				},
		         				//上侧多态图标栏显示,不需要直接关闭
		         				toolbox : {
		         					show : false,
		         					feature : {
		         						mark : {
		         							show : true
		         						},
		         						dataView : {
		         							show : true,
		         							readOnly : false
		         						},
		         						magicType : {
		         							show : true,
		         							type : [ 'line', 'bar' ]
		         						},
		         						restore : {
		         							show : true
		         						},
		         						saveAsImage : {
		         							show : true
		         						}
		         					}
		         				},
		         				dataZoom : {
		   		  		    	fillerColor:'#00EEEE',
		   		  		        show : true,
		   		  		        realtime: true,
		   		  		        
		   		  		    },
		         				calculable : true,
		         				xAxis : [ {
		         					type : 'category',
		         					boundaryGap : false,
		         					name:'time(s)',
		         					data : xAxisDate
		         				} ],
		         				yAxis : [ {
		         					type : 'value',
		         					name:'Data Rate(Mbps)',
		  	    		        interval:'auto',
		  	    		        scale:true,
		         					axisLabel : {
		         						formatter : '{value}'
		         					}
		         				} ],
		         				series : [ {
		         					name : 'DL',
		         					type : 'line',
		         					data : seriesDateDown
		         				}, {
		         					name : 'UL',
		         					type : 'line',
		         					data : seriesDateUp
		         				} ]
		         			};		   
			  				       //myChartnew2.hideLoading();
		  				           //myChartnew2.setOption(option2); 
		     
		        				}else{
		        					//alert("Network业务统计查询失败！");
		        					$("#video_flow").hide();
		        				}

		        			},
		        			fail : function() {
		        				alert("总流量速率业务统计查询失败！");
		        			}
				
				});
			}
				//getvideoflow();
				//var getvideoflow_time = setInterval(getvideoflow, 15000);
			
				/*总流量速率  */
				var myChart5 = ec.init(document.getElementById('network_flow'));
				function getnetworkflow() {
					       	  
		              $.ajax({
		        			type : "POST",
		        			async : false,
		        			url : "${ctx}/logtopic/getnetworkflowlog",
		        			data : { 
		        				case_name : "${logAnylizeInfoVO.caselogname}"
		        			},		                  
		        			success : function(data) {  
		        			//alert("Total Throughput");
		  					var xAxisDate = new Array();
		  					var seriesDateUp = new Array();
		  					var seriesDateDown = new Array();
		                               
		        			   if(null != data && data != 'null' && data != ''){
		  	   					var networkFlowList = $.parseJSON(data);
		  	   					for (var i = 0; i < networkFlowList.length; i++) {
		  	   						var networkFlowObj = networkFlowList[i];
		  	   						xAxisDate.push(networkFlowObj.x_data );
		  	   						seriesDateUp.push(networkFlowObj.y_updata);
		  	   						seriesDateDown.push(networkFlowObj.y_downdata);
		  	   					}
		  	   					
		          	   
		                 
		                 var option3 = {
		                		 title : {
		                			 text: 'Total Throughput',
		     		   		         x:'center',
		     		   		         y:'25'
									},
		         				tooltip : {
		         					trigger : 'axis'
		         				},
		         				//上侧折线图对应Key
		         				legend : {
		         					data : [ 'DL', 'UL' ],
		         					x : 'right',
		         					y : '25'
		         				},
		         				//上侧多态图标栏显示,不需要直接关闭
		         				toolbox : {
		         					show : true,
		         					feature : {
		         						mark : {
		         							show : true
		         						},
		         						dataView : {
		         							show : true,
		         							readOnly : false
		         						},
		         						magicType : {
		         							show : true,
		         							type : [ 'line', 'bar' ]
		         						},
		         						restore : {
		         							show : true
		         						},
		         						saveAsImage : {
		         							show : true
		         						}
		         					}
		         				},
		         				dataZoom : {
		   		  		    	fillerColor:'#00EEEE',
		   		  		        show : true,
		   		  		        realtime: true,
		   		  		        start:0,
		   		  		        end:10
		   		  		        
		   		  		    },
		         				calculable : true,
		         				xAxis : [ {
		         					type : 'category',
		         					boundaryGap : false,
		         					name:'time(s)',
		         					data : xAxisDate
		         				} ],
		         				yAxis : [ {
		         					type : 'value',
		         					name:'Data Rate(Mbps)',
		  	    		        interval:'auto',
		  	    		        scale:true,
		         					axisLabel : {
		         						formatter : '{value}'
		         					}
		         				} ],
		         				series : [ {
		         					name : 'DL',
		         					type : 'line',
		         					data : seriesDateDown
		         				}, {
		         					name : 'UL',
		         					type : 'line',
		         					data : seriesDateUp
		         				} ]
		         			};		   			  				           	
				  				        myChart5.setOption(option3); 
				  				      	myChart5.hideLoading();
		     
		        				}else{
		        					//alert("Network业务统计查询失败！");
		        					$("#network_flow").hide();
		        				}

		        			},
		        			fail : function() {
		        				alert("总流量速率业务统计查询失败！");
		        			}
				
						});
					}
					getnetworkflow();
					//var getnetworkflow_time = setInterval(getnetworkflow, 15000);
					
					
					<%--CALL接通率画图--%>
					var callexist = 1;
					var myChart6 = ec.init(document
							.getElementById('call_success'));
					var myChart7 = ec.init(document
							.getElementById('call_number'));
					
					myChart7.showLoading({
						  text: 'loading',
						  color: 'red',
						  textColor: 'blue',
						  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
						 maskColor: 'rgba(255, 255, 255, 0.8)',
						  zlevel:0
						});
					function getcallsucessratepic() {
						myChart6.showLoading(
								{
								  text: 'loading',
								  color: 'red',
								  textColor: 'blue',
								  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
								 maskColor: 'rgba(255, 255, 255, 0.8)',
								  zlevel:0
								}
							);
						$.ajax({
				type : "POST",
				async : true,
				url : "${ctx}/logtopic/getcallsuccessrate",
				data : {
					case_name : "${logAnylizeInfoVO.caselogname}"
				},
				success : function(data) {
					//console.log(data);
					myChart6.hideLoading();						
					var x_data = [];
					var y_data = [];
					var dl = [];
					var ul = [];
					var title6;
					var time1=0;
					
					if (null != data && data != 'null' && data != '') {							
						$("#call_picture").show();					
						var callsuccessrate = $.parseJSON(data);
       	          	     for(var i=0;i<callsuccessrate.length;i++){
       	            		x_data.push(callsuccessrate[i].x_time);
       	            		y_data.push(callsuccessrate[i].y_rate);
       	            		title6=callsuccessrate[i].start_time;       	            		
       	                    }
       	          	  		
					var option6 = {
						title : {
							text : '通话接通率('+ title6 + ')',
							x: 'center',
							y:'5'
						},
						 tooltip : {
							trigger : 'axis',
							formatter : function(
									params) {
								return '时间 :'
										+ params[0].name
										+ 's<br/>'
										+ '接通率:'
										+ params[0].value
										+ '%<br/>';
							}
						}, 
						legend : {
							x : 'right',
         					y:'25',
							data : [ '接通率' ],
							textStyle:{
								color:'#4169E1'
							}
						},
						toolbox : {
							show : true,
							feature : {
								dataZoom : {
									show : true
									
								},
								magicType : {
									show : true,
									type : [
											'line',
											'bar' ]
								},
								restore : {
									show : true
								},
								saveAsImage : {
									show : true
								}
							}
						},
						 dataZoom : {
							fillerColor : '#00EEEE',
							show : true,
							realtime : true,
							//handleSize:50,
							start:0,
							end:4
							
							
						}, 
						calculable : true,
						xAxis : [ {
							type : 'category',//'category',
							name : '时间(s)',								
							boundaryGap:false,
							axisTick:{
								alignWithLabel:true,
								interval :'auto',									
								onGap:false,									 
							},
							splitLine: {show:true},
							axisLabel:{
								interval:'auto',										
							}, 
							data:x_data
							
						} ], 										
						yAxis : [ {
							type : 'value',
							name : '接通率',											
							scale : true,											
							axisLabel : {
								formatter : '{value} %'
							}
						} ],
						series : [ {
							name : '接通率',
							type : 'line',
							data : y_data,											
							markPoint : {
								data : [ {
									type : 'max',
									name : '最大值(%)'
								}, {
									type : 'min',
									name : '最小值(%)'
								} ]
							},
							markLine : {
								data : [ {
									type : 'average',
									name : '平均值(%)'
								} ]
							}
						}
						]
					};
				myChart6.setOption(option6);
				} else {
					callexist = 0;
					//clearInterval(getcallsucessratepic_time);
					$("#call_picture").hide();
				}
			},
			fail : function() {
				alert("通话接通率查询失败！");
			}
		});
			
		}
		
		<%--CALL在线用户数画图--%>
		 function getcallusernumber(){
			$.ajax({
				type : "POST",
				async : true,
				url : "${ctx}/logtopic/getcallusernumber",
				data : {
					case_name : "${logAnylizeInfoVO.caselogname}"
				},
				success : function(data) {
					myChart7.hideLoading();
					//console.log(data);
					var x_data = [];
					var y_data = [];
					var title7;
					if (null != data && data != 'null' && data != '') {

						$("#call_picture").show();
						//console.log(data);
						
						var callOnlineNum = $.parseJSON(data);
	  	          	     for(var i=0;i<callOnlineNum.length;i++){
	  	            		x_data.push(callOnlineNum[i].x_data);
	  	            		y_data.push(callOnlineNum[i].y_data);
	  	            		title7=callOnlineNum[i].start_time;       	            		
	  	                     	}
	  	          										
						var option7 = {
							title : {
								text : '通话用户数('
										+ title7
										+ ')',
										x: 'center',
										y:'5'
							},
							tooltip : {
								trigger : 'axis',
								formatter : function(
										params) {
									return '时间 :'
											+ params[0].name
											+ 's<br/>'
											+ '用户数:'
											+ params[0].value
											+ '<br/>';
								}
							},
							legend : {
								x : 'right',
	         					y:'25',
								data : [ '用户数' ]
							},
							toolbox : {
								show : true,
								feature : {
									dataZoom : {
										show : true
									},
									magicType : {
										show : true,
										type : [
												'line',
												'bar' ]
									},
									restore : {
										show : true
									},
									saveAsImage : {
										show : true
									}
								}
							},
							dataZoom : {
								fillerColor : '#00EEEE',
								show : true,
								realtime : true,
								start:0,
								end:4
								
							},
							calculable : true,
							xAxis : [ {
								type : 'category',
								name : '时间(s)',
								//boundaryGap : [ 0,
										//0.3 ],
						
								boundaryGap:false,
								axisTick:{
									//alignWithLabel:true,
									interval :'auto',
									//length:5,
									onGap:false,
									 
								},
								splitLine: {show:false},
								axisLabel:{
									interval:'auto',
									//rotate:-90
								},
								data : x_data,
							} ],
							yAxis : [ {
								type : 'value',
								name : '用户数',
								interval : 'auto',
								scale : true,
								axisLabel : {
									formatter : '{value} '
								}
							} ],
							series : [ {
								name : '用户数',
								type : 'line',
								data : y_data,
								markPoint : {
									data : [
											{
												type : 'max',
												name : '最大值'
											},
											{
												type : 'min',
												name : '最小值'
											} ]
								},
								markLine : {
									data : [ {
										type : 'average',
										name : '平均值'
									} ]
								}
							}

							]
						};

							myChart7.setOption(option7);

					} else {
						// clearInterval(getcallsucessratepic_time);
						$("#call_picture").hide();
					}

				},
				fail : function() {
					alert("通话用户数失败！");
				}
			});
		} 
		  getcallsucessratepic();
		 getcallusernumber();				 
		/* var getcallsucessratepic_time = setInterval(
				getcallsucessratepic, 8000); 
		var getcallsucessratepic_time = setInterval(
				getcallusernumber, 10000); */
				
		<%--FTP画图--%>	
		var myChart4 = ec.init(document
				.getElementById('ftpdown_speed'));
		var myChart41 = ec.init(document
				.getElementById('ftpup_speed'));
		var myChart5 = ec.init(document
				.getElementById('ftp_fail'));
       // alert("${logAnylizeInfoVO.caselogname}");
		function getftppic() {
					myChart4.showLoading(
							{
							  text: 'loading',
							  color: 'red',
							  textColor: 'blue',
							  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
							 maskColor: 'rgba(255, 255, 255, 0.8)',
							  zlevel:0
							}
						);
					myChart41.showLoading(
							{
							  text: 'loading',
							  color: 'red',
							  textColor: 'blue',
							  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
							 maskColor: 'rgba(255, 255, 255, 0.8)',
							  zlevel:0
							}
						);
					myChart5.showLoading(
							{
							  text: 'loading',
							  color: 'red',
							  textColor: 'blue',
							  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
							 maskColor: 'rgba(255, 255, 255, 0.8)',
							  zlevel:0
							}
						);
						$.ajax({
									type : "POST",
									async : true,
									url : "${ctx}/logtopic/getftplog",
									data : {
										case_name : "${logAnylizeInfoVO.caselogname}"
									},
									success : function(data) {
										//alert(data);
										var up = [];
										var down = [];
										//alert(data);
										var title4;
										if (null != data && data != 'null' && data != '') {
											//alert(data);
											$("#ftp_picture").show();
											var ftpdata = new Array();
											ftpdata = data.split("$$");
											if(ftpdata[0]!='null')
												{
											var ftpdownlog = $.parseJSON(ftpdata[0]);
											for ( var j = 0; j < ftpdownlog.length-10; j++) {
												down.push([
															ftpdownlog[j].x_data,
															parseFloat(ftpdownlog[j].y_Stringdata) ]);
										
												title4 = ftpdownlog[j].start_time;
											}
												}
											if(ftpdata[1]!='null')
												{
											var ftpuplog = $
													.parseJSON(ftpdata[1]);
											for ( var k = 0; k < ftpuplog.length-10; k++) {
												up
														.push([
																ftpuplog[k].x_data,
																parseFloat(parseFloat(ftpuplog[k].y_Stringdata)) ]);
												title41 = ftpuplog[k].start_time;
											}
												}

											var fail = $
													.parseJSON(ftpdata[3]);
											var fail_data = [];
											var x1_data = [];

											
											//console.log(ftpuplog);
										//	console.log(ftpdownlog);

											
											for ( var m = 0; m < fail.length; m++) {
												fail_data
														.push(fail[m].y_data);
												x1_data
														.push(fail[m].x_data);
											}
											if (down.length != 0) {

											var option4 = {
												title : {
													/* text : '下载吞吐量(' + title4
															+ ')', */
													text: 'FTP DL',
									   		        x:'center',
									   		        y:'25'
												},
												tooltip : {
													trigger : 'axis',
													formatter : function(
															params) {
														return params.seriesName
																+ ' : [ '
																+ params.value[0]
																+ ', '
																+ params.value[1]
																+ ' ]';
													}

												},
												legend : {
													data : [ 'DL'],
													x : 'right',
						         					y:'25'
												},
												toolbox : {

													show : true,
													feature : {
														dataZoom : {
															show : true
														},
														magicType : {
															show : true,
															type : [
																	'line',
																	'bar' ]
														},
														restore : {
															show : true
														},
														saveAsImage : {
															show : true
														}
													}
												},
												dataZoom : {
													fillerColor : '#00EEEE',
													show : true,
													realtime : true,
													start:0,
													end:8
												},
												calculable : true,
												xAxis : [ {
													type : 'value',
													name : 'time(s)',
													
												//  data : x_data,
												} ],
												yAxis : [ {
													type : 'value',
													name : 'Data Rate(Mbps)',

												} ],
												series : (function() {
													var all = [];
													if (down.length != 0) {
														var onedown = {
															name : 'DL',
															type : 'line',
															data : down,
															markPoint : {
																data : [
																		{
																			type : 'max',
																			name : '最大值'
																		},
																		{
																			type : 'min',
																			name : '最小值'
																		}

																]
															},
															markLine : {
																data : [ {
																	type : 'average',
																	name : '平均值'
																} ]
															}
														}
														all.push(onedown);
													}
													/* if (up.length != 0) {
														var oneup = {
															name : 'FTP上传',
															type : 'line',
															data : up,
															markPoint : {
																data : [
																		{
																			type : 'max',
																			name : '最大值'
																		},
																		{
																			type : 'min',
																			name : '最小值'
																		}

																]
															},
															markLine : {
																data : [ {
																	type : 'average',
																	name : '平均值'
																} ]
															}
														}
														all.push(oneup);
													} */
													return all;

												})(),

											};
										}
											
											if(up.length!=0){
											var option41 = {
													title : {
														/* text : '上传吞吐量(' + title41
																+ ')', */
														text: 'FTP UL',
										   		        x:'center',
										   		        y:'25'
													},
													color:['#87cefa'],
													tooltip : {
														trigger : 'axis',
														formatter : function(
																params) {
															return params.seriesName
																	+ ' : [ '
																	+ params.value[0]
																	+ ', '
																	+ params.value[1]
																	+ ' ]';
														}

													},
													legend : {
														x : 'right',
							         					y:'25',
														data : [ 
																'FTP UL' ],
																x : 'right',
									         					y:'25'
													},
													toolbox : {

														show : true,
														feature : {
															dataZoom : {
																show : true
															},
															magicType : {
																show : true,
																type : [
																		'line',
																		'bar' ]
															},
															restore : {
																show : true
															},
															saveAsImage : {
																show : true
															}
														}
													},
													dataZoom : {
														fillerColor : '#00EEEE',
														show : true,
														realtime : true,
														start:0,
														end:8

													},
													calculable : true,
													xAxis : [ {
														type : 'value',
														name : 'time(s)',
														
													//  data : x_data,
													} ],
													yAxis : [ {
														type : 'value',
														name : 'Data Rate(Mbps)',

													} ],
													series : (function() {
														var all = [];
														/* if (down.length != 0) {
															var onedown = {
																name : 'FTP下载',
																type : 'line',
																data : down,
																markPoint : {
																	data : [
																			{
																				type : 'max',
																				name : '最大值'
																			},
																			{
																				type : 'min',
																				name : '最小值'
																			}

																	]
																},
																markLine : {
																	data : [ {
																		type : 'average',
																		name : '平均值'
																	} ]
																}
															}
															all.push(onedown);
														} */
														if (up.length != 0) {
															var oneup = {
																name : 'FTP UL',
																type : 'line',
																data : up,
														
																markPoint : {
																	data : [
																			{
																				type : 'max',
																				name : '最大值'
																			},
																			{
																				type : 'min',
																				name : '最小值'
																			}

																	]
																},
																markLine : {
																	data : [ {
																		type : 'average',
																		name : '平均值'
																	} ]
																}
															}
															all.push(oneup);
														}
														return all;

													})(),

												};
											}

											var option5 = {
												title : {
													text : 'FTP失败事件次数统计',
													x:'center',
													y:'25'
												},
												tooltip : {
													trigger : 'axis',
													formatter : function(
															params) {
														return '时间 :'
																+ params[0].name
																+ 's<br/>'
																+ '出现次数:'
																+ params[0].value
																+ '次<br/>';
													}
												},
												legend : {
													x : 'right',
						         					y:'25',
													data : [ 'Fail Number' ]
												},
												toolbox : {
													show : true,
													feature : {
														mark : {
															show : true
														},
														dataView : {
															show : true,
															readOnly : false
														},
														dataZoom : {
															show : true
														},
														magicType : {
															show : true,
															type : [
																	'line',
																	'bar' ]
														},
														restore : {
															show : true
														},
														saveAsImage : {
															show : true
														}
													}
												},
												dataZoom : {
													fillerColor : '#00EEEE',
													show : true,
													realtime : true,
													start:0,
													end:8														
												},
												calculable : true,
												xAxis : [ {
													name : '时间',
													data : x1_data,
												} ],
												yAxis : [ {
													type : 'value',
													name : '次数(次)',
													scale : true,
													interval : 'auto',
													axisLabel : {
														formatter : '{value}'
													}
												} ],

												series : [ {
													name : 'Fail Number',
													type : 'line',
													data : fail_data,
													markPoint : {
														data : [ {
															type : 'max',
															name : '最大值'
														}, {
															type : 'min',
															name : '最小值'
														} ]
													},
													markLine : {
														data : [ {
															type : 'average',
															name : '平均值'
														} ]
													}
												}

												]
											};
											if (up.length != 0){
												myChart41.setOption(option41);
												myChart41.hideLoading(); 

											}else{
												$("#ftpup_speed").hide();
											}
											if (down.length != 0){
												myChart4.setOption(option4);
												myChart4.hideLoading(); 
											}else{
												$("#ftpdown_speed").hide();
											}																								
												myChart5.setOption(option5);
												myChart5.hideLoading(); 
										} else {
											//clearInterval(getftppic_time);
											$("#ftp_picture").hide();
										}

									},										
									fail : function() {
										alert("FTP吞吐率查询失败！");
									}
								});
					}
					getftppic();
		//var getftppic_time = setInterval(getftppic, 15000);
			
		<%--WEB画图--%>
		var myChart11 = ec.init(document.getElementById('web_fail'));						
		var myChart12 = ec.init(document.getElementById('web_success'));
		var myChart13 = ec.init(document.getElementById('web_delay'));

		function getwebpic() {
			myChart11.showLoading({
				  text: 'loading',
				  color: 'red',
				  textColor: 'blue',
				  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
				 maskColor: 'rgba(255, 255, 255, 0.8)',
				  zlevel:0
				});
			myChart12.showLoading({
				  text: 'loading',
				  color: 'red',
				  textColor: 'blue',
				  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
				 maskColor: 'rgba(255, 255, 255, 0.8)',
				  zlevel:0
				});
			myChart13.showLoading({
				  text: 'loading',
				  color: 'red',
				  textColor: 'blue',
				  effect:'ring',//'spin' | 'bar' | 'ring' | 'whirling' | 'dynamicLine' | 'bubble'
				 maskColor: 'rgba(255, 255, 255, 0.8)',
				  zlevel:0
				});
			$.ajax({
				type : "POST",
				async : true,
				url : "${ctx}/logtopic/getweblog",
				data : {
					case_name : "${logAnylizeInfoVO.caselogname}"
				},
				success : function(data) {
					//	alert(data);
					var x_data = [];
					var y_data = [];
					var y1_data = [];
					var y2_data = [];
					var y3_data = [];
					var x3_data = [];
					var start_time;
					var a0 = 0, a1 = 0, a2 = 0, a3 = 0;
					if (null != data && data != 'null' && data != '') {
						$("#web_picture").show();
						var webfail = $.parseJSON(data);
						for ( var i = 0; i < webfail.length; i++) {
							x_data
									.push(webfail[i].x_data);
							y1_data
									.push(webfail[i].y1_data);
							y2_data
									.push(webfail[i].y2_data);
							start_time = webfail[i].start_time;
							if (webfail[i].y3_data != -1) {
								x3_data
										.push(webfail[i].x_data);

								y3_data
										.push(parseFloat(webfail[i].y3_Stringdata));
								if (webfail[i].y3_data > 0
										&& webfail[i].y3_data <= 1) {
									a0++;
								} else if (webfail[i].y3_data > 1
										&& webfail[i].y3_data <= 2) {
									a1++;
								} else if (webfail[i].y3_data > 2
										&& webfail[i].y3_data <= 3) {
									a2++;
								} else {
									a3++;

								}

							}
						}
						var option11 = {
							title : {
								text : 'Web失败统计('
										+ start_time
										+ ')',
										x: 'center',
										y:'25'
							},
							tooltip : {
								trigger : 'axis',
								formatter : function(
										params) {
									return '时间 :'
											+ params[0].name
											+ 's<br/>'
											+ '失败次数:'
											+ params[0].value
											+ '<br/>';
								}
							},
							legend : {
								x : 'right',
	         					y:'25',
								data : [ '失败次数' ]
							},
							toolbox : {
								show : true,
								feature : {
									dataZoom : {
										show : true
									},
									magicType : {
										show : true,
										type : [
												'line',
												'bar' ]
									},
									restore : {
										show : true
									},
									saveAsImage : {
										show : true
									}
								}
							},
							dataZoom : {
								fillerColor : '#00EEEE',
								show : true,
								realtime : true,
								start: 0,
								end: 10									
							},
							calculable : true,
							xAxis : [ {
								type : 'category',
								name : '时间(s)',
								data : x_data,
							} ],
							yAxis : [ {
								type : 'value',
								name : '失败次数',
								interval : 'auto',
								scale : true,
								axisLabel : {
									formatter : '{value} '
								}
							} ],
							series : [ {
								name : '失败次数',
								type : 'line',
								data : y1_data,
								markPoint : {
									data : [ {
										type : 'max',
										name : '最大值'
									}, {
										type : 'min',
										name : '最小值'
									} ]
								},
								markLine : {
									data : [ {
										type : 'average',
										name : '平均值'
									} ]
								}
							}

							]
						};

						option12 = {
							title : {
								/* text : 'Web成功率('
										+ start_time
										+ ')', */
								text: 'Web Browser',
				   		        x:'center',
				   		     y:'25'
							},
							tooltip : {
								trigger : 'axis',
								formatter : function(
										params) {
									return 'time :'
											+ params[0].name
											+ 's<br/>'
											+ ' rate:'
											+ params[0].value
											+ '%<br/>';
								}
							},
							legend : {
								x : 'right',
	         					y:'25',
								data : [ 'Success Rate' ]
							},
							toolbox : {
								show : true,
								feature : {
									dataZoom : {
										show : true
									},
									magicType : {
										show : true,
										type : [
												'line',
												'bar' ]
									},
									restore : {
										show : true
									},
									saveAsImage : {
										show : true
									}
								}
							},
							dataZoom : {
								fillerColor : '#00EEEE',
								show : true,
								realtime : true,
								start:0,
								end:10
								
							},
							calculable : true,
							xAxis : [ {
								type : 'category',
								name : 'time(s)',
								boundaryGap : false,
								data : x_data,
							} ],
							yAxis : [ {
								type : 'value',
								interval : 'auto',
								name : 'Success Rate',
								scale : false,
								axisLabel : {
									formatter : '{value}% '
								}
							} ],
							series : [ {
								name : 'Success Rate',
								type : 'line',
								smooth : true,
								itemStyle : {
									normal : {
										areaStyle : {
											type : 'default'
										}
									}
								},
								data : y2_data,
							} ]
						};

						var option13 = {
							title : {
								/* text : 'Web时延('
										+ start_time
										+ ')', */
								text: 'Web Latency',
				   		        x:'center',
				   		     y:'25'
							},
							tooltip : {
								trigger : 'axis',
								formatter : function(
										params) {
									return 'time :'
											+ params[0].name
											+ 's<br/>'
											+ 'Latency:'
											+ params[0].value
											+ 's<br/>';
								}
							},
							legend : {
								x : 'right',
	         					y:'25',
								data : [ 'latency' ]
							},
							toolbox : {
								show : true,
								feature : {
									dataZoom : {
										show : true
									},
									magicType : {
										show : true,
										type : [
												'line',
												'bar' ]
									},
									restore : {
										show : true
									},
									saveAsImage : {
										show : true
									}
								}
							},
							dataZoom : {
								fillerColor : '#00EEEE',
								show : true,
								realtime : true,
								start:0,
								end: 10									
							},
							calculable : true,
							xAxis : [ {
								type : 'category',
								name : 'time(s)',
								boundaryGap : [ 0, 0.8 ],
								data : x3_data,
							} ],
							yAxis : [ {
								type : 'value',
								name : 'Latency',
								interval : 'auto',
								scale : true,

								axisLabel : {
									formatter : '{value} s'
								}
							} ],
							series : [
									{
										name : 'latency',
										type : 'line',
										data : y3_data,
										markPoint : {
											data : [
													{
														type : 'max',
														name : '最大值'
													},
													{
														type : 'min',
														name : '最小值'
													} ]
										},
										markLine : {
											data : [ {
												type : 'average',
												name : '平均值'
											} ]
										}
									},
									{
										name : 'Latency',
										type : 'pie',
										tooltip : {
											trigger : 'item',
											formatter : '{a} <br/>{b} : {c} ({d}%)'
										},
										center : [ 800,
												120 ],
										radius : [ 0,
												30 ],
										itemStyle : {
											normal : {
												labelLine : {
													length : 20
												}
											}
										},
										data : [
												{
													value : a0,
													name : '0~1s'
												},
												{
													value : a1,
													name : '1~2s'
												},
												{
													value : a2,
													name : '2~3s'
												},
												{
													value : a3,
													name : '3s以上'
												} ]
									}

							]
						};

						myChart11.setOption(option11);
						myChart11.hideLoading();
						myChart12.setOption(option12);
						myChart12.hideLoading();
						myChart13.setOption(option13);
						myChart13.hideLoading();

					} else {
						//clearInterval(getwebpic_time);
						$("#web_picture").hide();
					}

				},
				fail : function() {
					alert("Web失败次数查询失败！");
				}
			});

		}
		getwebpic();
		//var getwebpic_time = setInterval(getwebpic, 15000);
		
			
		});
		</script>
</body>
</html>