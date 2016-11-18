<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
 <script type="text/javascript">
      function lockScreen(){
    	  window.location.href="${ctx}/lockScreen";
      }
      function viewMyOrders(){
    	  window.location.href="${ctx}/equiptOrder/viewMyOrdersIndex";
      }
        jQuery(function($) {
        	$('#proForm').bootstrapValidator({
        		message: 'This value is not valid',
        		excluded: [':disabled'],
        		feedbackIcons:  {
        			valid: 'md md-check',
        			invalid: 'md md-close',
        			validating: 'md md-refresh'
        	    },
        	    group: '.input-group',
        		fields: {
        			proRegUserDetailName: {
        				container: 'tooltip',
        				validators: {
        					notEmpty: {
        						message: '用户名不能为空!'
        					},
        					regexp: {
        						regexp: /^[a-zA-Z0-9\u4e00-\u9fa5]+$/i,
        						message: '用户名不能存在特殊字符!'
        					}
        				}
        			},proRegPhone: {
        				container: 'tooltip',
        				validators: {
        					notEmpty: {
        						message: '手机号不能为空!'
        					},
        					numeric: {
        						message: '清输入正确的手机号!'
        					}
        				}
        			},
        			proRegEmail: {
        				container: 'tooltip',
        				validators: {
        					notEmpty: {
        						message: '邮箱地址不能为空!'
        					},
        					emailAddress: {
        						message: '请输入有效的邮箱地址!'
        					}
        				}
        			}
        		}
        	});
        	
        	
        	$('#pwdForm').bootstrapValidator({
        		message: 'This value is not valid',
        		excluded: [':disabled'],
        		feedbackIcons:  {
        			valid: 'md md-check',
        			invalid: 'md md-close',
        			validating: 'md md-refresh'
        	    },
        	    group: '.input-group',
        		fields: {
        			oldpassword:{
        				container: 'tooltip',
        				validators: {
        					notEmpty: {
        						message: '原密码不能为空!'
        					}
        				}
        			},
        			regPassword: {
        				container: 'tooltip',
        				validators: {
        					notEmpty: {
        						message: '新密码不能为空!'
        					}
        				}
        			},
        			password: {
        				container: 'tooltip',
        				validators: {
        					notEmpty: {
        						message: '确认新密码不能为空!'
        					},
        					identical: {
        						field: 'regPassword',
                                message: '确认新密码和新密码不一致!'
        					}
        				}
        			}
        		}
        	});
        	
        });
    	
         function openProfileModel(){
        	 $('#proForm').data('bootstrapValidator').resetForm(true);
        	 $("#proRegUserDetailName").val('${user.userName}');
        	 $("#proRegPhone").val('${user.phone}');
        	 $("#proRegEmail").val('${user.email}');
        	 $('#profileModel').modal('show');
         }
         function logoutFnc(){
        	 swal({   title: "你确定要退出?",  
    			 text: "退出系统后需要登录才能进入该系统",  
    			 type: "warning",  
    			 showCancelButton: true,  
    			 cancelButtonText: "取消",
    			 confirmButtonColor: "#428BCA",  
    			 confirmButtonText: "确定",   
    			 closeOnConfirm: false }, 
    			 function(){
    				 window.location.href= "${ctx }/logout";
    				 }
    			 );
         }
         function openChangePwdModel(){
        	 $('#pwdForm').data('bootstrapValidator').resetForm(true);
        	 $("#oldpassword").val('');
        	 $("#regPassword").val('');
        	 $("#password").val('');
        	 $('#changePwdModel').modal('show');
         }
         function submitPwdChange(){
        	 $('#pwdForm').data('bootstrapValidator').validate();
         	if(!$('#pwdForm').data('bootstrapValidator').isValid()){
          		return false;
          	}else{
          		 $('#pwdSaveBtn').attr("disabled",true);
          		 $('#pwdCancelBtn').attr("disabled",true);
          		 $.ajax({
     	             type: "POST",
     	             url: "${ctx}/webContruser/changeUserNewPassword",
     	             data: {
     	            	oldPassword:$("#oldpassword").val(),
     	            	newPassword:$("#regPassword").val()
     	            	 },
     	             success: function(data){
     	            	 if(data=='1'){
     	            		 $('#changePwdModel').modal('hide');
     	            		 swal({   
     	                         title: "修改成功",   
     	                         text: "密码修改成功!",   
     	                         type: "success",
     	                         timer: 2000,   
     	                         showConfirmButton: false 
     	                     });
     	            	 }else{
     	            		 notify('修改失败','请重试!','danger');
     						}
     	            	 $('#pwdSaveBtn').attr("disabled",false);
     	         		 $('#pwdCancelBtn').attr("disabled",false);
     	             }
     	         });
          	}
         }
         function submitProChange(){
        	 $('#proForm').data('bootstrapValidator').validate();
          	if(!$('#proForm').data('bootstrapValidator').isValid()){
         		return false;
         	}else{
         		 $('#saveBtn').attr("disabled",true);
         		 $('#cancelBtn').attr("disabled",true);
         		 $.ajax({
    	             type: "POST",
    	             url: "${ctx}/webContruser/changeUserNewProfile",
    	             data: {
    	            	 userName:$("#proRegUserDetailName").val(),
    	            	 phone:$("#proRegPhone").val(),
    	            	 email:$("#proRegEmail").val()
    	            	 },
    	             success: function(data){
    	            	 if(data=='1'){
    	            		// $('#profileModel').modal('hide');
    	            		 swal({   
    	                         title: "修改成功",   
    	                         text: "个人信息修改成功!",   
    	                         type: "success",
    	                         timer: 2000,   
    	                         showConfirmButton: false 
    	                     });
    	            		//刷新缓存页面和缓存session，清除后退的相关记录
 							location.replace('${ctx}/');  
    	            	 }else if(data=='-1'){
    	            		 notify('修改失败','用户名已经存在！','danger');
    	            		 $('#proRegUserDetailName').focus();
    	            	 }else{
    	            		 notify('修改失败','请重试!','danger');
    						}
    	            	 $('#saveBtn').attr("disabled",false);
    	         		 $('#cancelBtn').attr("disabled",false);
    	             }
    	         });
         	}
         }
        </script>
	 <script>
	 var menuid=${menuid}+'';
	 var menupid=${menupid}+'';
	 

     function MyNotify(from, align, icon, type, msg){
               $.growl({
                   icon: icon,
                   title: ' 警告 ',
                   message: msg,
                   url: ''
               },{
                       element: 'body',
                       type: type,
                       allow_dismiss: true,
                       placement: {
                               from: from,
                               align: align
                       },
                       offset: {
                           x: 20,
                           y: 85
                       },
                       spacing: 10,
                       z_index: 1031,
                       delay: 2500,
                       url_target: '_blank',
                       mouse_over: false,
                       animate: {
                               enter: 'animated fadeIn',
                               exit: 'animated fadeOut'
                       },
                       icon_type: 'class',
                       template: '<div data-growl="container" class="alert" role="alert">' +
                                       '<button type="button" class="close" data-growl="dismiss">' +
                                           '<span aria-hidden="true">&times;</span>' +
                                           '<span class="sr-only">Close</span>' +
                                       '</button>' +
                                       '<span data-growl="icon"></span>' +
                                       '<span data-growl="title"></span>' +
                                       '<span data-growl="message"></span>' +
                                       '<a href="#" data-growl="url"></a>' +
                                   '</div>'
               });
           }
    jQuery(function($) {
    	 $.ajax({
             type: "GET",
             url: "${ctx }/webContromenuAction/jsTreePermissionAjax",
             data: {
            	 },
             success: function(data){
            	 data=eval("("+data+")");
            	 var str='<ul class="main-menu" >';
            	 for(var i=0;i<data.length;i++){
            		 if(data[i].children.length>0){
            			 if(menupid!=''&&menupid==data[i].id){
            				str+=' <li class="sub-menu active toggled">';
            			 }else{
            				 str+='<li class="sub-menu">';
            			 }
            		 }else{
            			 str+='<li>';
            		 }
            		 if(data[i].resurl==''){
            			 str+='<a href="javascript:void(0)"><i class="'+data[i].icon+'"></i> '+data[i].text+'</a>'
            		 }else{
            			 str+='<a href="${ctx}'+data[i].resurl+'"><i class="'+data[i].icon+'"></i> '+data[i].text+'</a>'
            		 }
            		 var children=data[i].children;
            		 if(children.length>0){
            			 str+='  <ul class="main-menu" style="margin-top: 0px;">';
            			 for(var j=0;j<children.length;j++){
            				 if(children[j].children.length>0){
                    			 str+=' <li class="sub-menu">';
                    		 }else{
                    			 str+='<li>';
                    		 }
            				 if(j>0){
            					 
            					 if(children[j].resurl==''){
                        			 str+='<a href="javascript:void(0)" style="margin-top: 16px;"><i class="'+children[j].icon+'"></i> '+children[j].text+'</a>'
                        		 }else{
                        			 if(menuid!=''&&menuid==children[j].id){
                            			 str+='<a href="${ctx}'+children[j].resurl+'?menuid='+children[j].id+'&menupid='+data[i].id+'"   class="active"  style="margin-top: 16px;"><i class="'+children[j].icon+'"></i> '+children[j].text+'</a>'
                         			 }else{
                            			 str+='<a href="${ctx}'+children[j].resurl+'?menuid='+children[j].id+'&menupid='+data[i].id+'" style="margin-top: 16px;"><i class="'+children[j].icon+'"></i> '+children[j].text+'</a>'
                         			 }
                        		 }
            				 }else{
            					 if(children[j].resurl==''){
                        			 str+='<a href="javascript:void(0)" style="margin-top: 0px;"><i class="'+children[j].icon+'"></i> '+children[j].text+'</a>'
                        		 }else{
                        			 if(menuid!=''&&menuid==children[j].id){
                            			 str+='<a href="${ctx}'+children[j].resurl+'?menuid='+children[j].id+'&menupid='+data[i].id+'"   class="active"  style="margin-top: 0px;"><i class="'+children[j].icon+'"></i> '+children[j].text+'</a>'
                         			 }else{
                            			 str+='<a href="${ctx}'+children[j].resurl+'?menuid='+children[j].id+'&menupid='+data[i].id+'" style="margin-top: 0px;"><i class="'+children[j].icon+'"></i> '+children[j].text+'</a>'
                         			 }
                        		 }
            				 }
            				
            				 str+='</li>'
            			 }
            			 str+='</ul>';
            		 }
            		 str+='</li>'
            	 }
            	 str+='</ul>';
            	 $(".si-inner").append(str);
             }
         });
    	
    });
    function openAvatarSetting(){
		window.location.href="${ctx}/webContravatarSettings";
    }
    
    function openMyOrderTask(){
    	//去掉任务提示
    	$("#myWaitTasks>span").remove();
    	window.location.href="${ctx}/inStorageControl/myTasksIndex";
    }
   
    </script>
    
 <!--   <script type="text/javascript">
    back top
	$(document).ready(function() { 
		$(window).scroll(function () {
	        if($(window).scrollTop()>=100) {
	            $("#backtop").fadeIn();
	        }else {
	        	$("#backtop").fadeOut();
	        }
	    });
		
	
		$("#backtop").click(function(event){	
			$('html,body').animate({scrollTop:0}, 500);
			return false;
		});
	})
</script>-->
 <script type="text/javascript">
 	var client;
 	var infoCount=0;
 	var chatCount=0;
 	var mytaskCount=0;
 	var channels=[];
 	var roleIds='${user.roleIds}';
 	
 	function examMessage(stu_id,tea_id,page_id,que_id,message){
      	this.stu_id=stu_id;
      	this.tea_id=tea_id;
      	this.page_id=page_id;
      	this.que_id=que_id;
      	this.message=message;
      }
 	function chatMessage(stu_id,tea_id,page_id,stu_name,stu_img,message){
      	this.stu_id=stu_id;
      	this.tea_id=tea_id;
      	this.page_id=page_id;
      	this.stu_name=stu_name;
      	this.stu_img=stu_img;
      	this.message=message;
      }
 	function chatUSMessage(stu_id,tea_id,page_id,name,img,time,message,type){
      	this.stu_id=stu_id;
      	this.tea_id=tea_id;
      	this.page_id=page_id;
      	this.name=name;
      	this.img=img;
      	this.message=message;
      	this.time=time;
      	this.type=type;
      }
 	function taskMessage(name,img,message,inStorageGroupId){
 		this.name=name;
 		this.img=img;
 		this.message=message;
 		this.inStorageGroupId=inStorageGroupId;
 	}
 	function testPlanMessage(name,img,createTime,testPlanName){
 		this.name=name;
 		this.img=img;
 		this.createTime=createTime;
 		this.testPlanName=testPlanName;
 	}
	$(document).ready(function() { 
        ion.sound({
            sounds: [
                {name: "beer_can_opening"},
                {name: "bell_ring", volume: 0.6},
                {name: "branch_break", volume: 0.3},
                {name: "button_click"},
                {name: "button_click_on"},
                {name: "button_push"},
                {name: "button_tiny", volume: 0.6},
                {name: "camera_flashing"},
                {name: "camera_flashing_2", volume: 0.6},
                {name: "cd_tray", volume: 0.6},
                {name: "computer_error"},
                {name: "door_bell"},
                {name: "door_bump", volume: 0.3},
                {name: "glass"},
                {name: "keyboard_desk"},
                {name: "light_bulb_breaking", volume: 0.6},
                {name: "metal_plate"},
                {name: "metal_plate_2"},
                {name: "pop_cork"},
                {name: "snap"},
                {name: "staple_gun"},
                {name: "tap", volume: 0.6},
                {name: "water_droplet"},
                {name: "water_droplet_2"},
                {name: "water_droplet_3", volume: 0.6}
            ],
            path:'${ctx}/vendors/ionsound/sounds/',
            preload: true
        });
		
		 if(window.WebSocket) {
 			 client = Stomp.client("ws://123.56.182.100:61614");
 			 console.log(client);
		  }else{
			  alert("你得浏览器不支持websocket,请使用高级浏览器比如谷歌！");
		  }
		 console.log(4);
		
		 client.connect("", "", function(frame) {
	            console.log("connected to Stomp"+"/topic/chat"+'${user.id}');
	            //接受消息
	            client.subscribe("/topic/chat"+'${user.id}', function(message) {
	            		var msj=eval("("+decodeURI(message.body)+")");
		            	 console.log(msj.message);
		            	var noticeId="notice_"+msj.stu_id+"_"+msj.tea_id+"_"+msj.page_id+"_"+msj.que_id;
		            	 console.log($("#"+noticeId).hasClass("lv-item"));
		            	if($("#questionNotice+div").hasClass("dropdown-menu")){
		            		if(!$("#"+noticeId).hasClass("lv-item")){
            						$("#noticeBody").append('<div class="lv-item" id="'+noticeId+'"><div class="media"><div class="pull-right"><button class="btn btn-success waves-effect" onclick="completeFault(\''+noticeId+'\');">故障设置完成</button></div><div class="media-body"><div class="lv-title">答题结束</div><small class="lv-small" style="white-space: pre-wrap">'+msj.message+'</small></div></div></div>');
            						infoCount++;
		            		}
		            		ion.sound.play("door_bell");
		            		
		            	}else{
		            		infoCount++;
		            		ion.sound.play("door_bell");
		            		$("#questionNotice").after('<div class="dropdown-menu dropdown-menu-lg pull-right" id="noticeDropdown"><div class="listview" id="notifications"><div class="lv-header">消息</div><div class="lv-body c-overflow" id="noticeBody"><div class="lv-item" id="'+noticeId+'"><div class="media"><div class="pull-right"><button class="btn btn-success waves-effect" onclick="completeFault(\''+noticeId+'\');" >故障设置完成</button></div><div class="media-body"><div class="lv-title">答题结束</div><small class="lv-small" style="white-space: pre-wrap">'+msj.message+'</small></div></div></div></div></div>');
		            	}
		            	if(infoCount>0){
		            		if($("#questionNotice>span").hasClass("avtiveCount")){
		            			$("#questionNotice>span").html(infoCount);
		            		}else{
			            		$("#questionNotice").append("<span class='avtiveCount'>"+infoCount+"</span>");
		            		}
	            		}
	            });
	            
	            //接受消息
	            console.log(1);
	            if(roleIds=='1'){
	            	   client.subscribe("/topic/letmeTestPlanNotice1", function(message) {
		            		var msj=eval("("+decodeURI(message.body)+")");
			            	if($("#questionNotice+div").hasClass("dropdown-menu")){
        						$("#noticeBody").append('<div class="lv-item" ><div class="media"><div class="pull-right"><button class="btn btn-success waves-effect" onclick="IKnowItFunc(this);">我知道了</button></div><div class="pull-left"><img class="lv-img-sm" src="${ctx}'+msj.img+'" alt=""></div><div class="media-body"><div class="lv-title">'+msj.name+'</div><small class="lv-small" style="white-space: pre-wrap">在'+msj.createTime+'创建'+msj.testPlanName+'!!</small></div></div></div>');
	            				infoCount++;
			            		ion.sound.play("door_bell");
			            	}else{
			            		infoCount++;
			            		ion.sound.play("door_bell");
			            		$("#questionNotice").after('<div class="dropdown-menu dropdown-menu-lg pull-right" id="noticeDropdown"><div class="listview" id="notifications"><div class="lv-header">消息</div><div class="lv-body c-overflow" id="chatBody"><div class="lv-item" ><div class="media"><div class="pull-right"><button class="btn btn-success waves-effect" onclick="IKnowItFunc(this);" >我知道了</button></div> <div class="pull-left"><img class="lv-img-sm" src="${ctx}'+msj.img+'" alt=""></div><div class="media-body"><div class="lv-title">'+msj.name+'</div><small class="lv-small" style="white-space: pre-wrap">在'+msj.createTime+'创建'+msj.testPlanName+'!!</small></div></div></div></div></div>');

			            	}
			            	if(infoCount>0){
			            		if($("#questionNotice>span").hasClass("avtiveCount")){
			            			$("#questionNotice>span").html(infoCount);
			            		}else{
				            		$("#questionNotice").append("<span class='avtiveCount'>"+infoCount+"</span>");
			            		}
		            		}
		            });
	            }
	            
	            console.log(2);
	            //接受聊天
	            client.subscribe("/topic/letmeChat"+'${user.id}', function(message) {
	            	var msjData=message.body;
            		var msj=eval("("+decodeURI(msjData)+")");
	            	 console.log(msj.message);
	            	var letmeId="letmeChat_"+msj.stu_id+"_"+msj.tea_id+"_"+msj.page_id;
	            	 console.log($("#"+letmeId).hasClass("lv-item"));
	            	if($("#chatNotice+div").hasClass("dropdown-menu")){
	            		if(!$("#"+letmeId).hasClass("lv-item")){
        						$("#chatBody").append('<div class="lv-item" id="'+letmeId+'"><div class="media"><div class="pull-right"><button class="btn btn-success waves-effect" onclick="gotoChat(\''+letmeId+'\',\''+msjData+'\');">接受</button></div><div class="pull-left"><img class="lv-img-sm" src="${ctx}'+msj.stu_img+'" alt=""></div><div class="media-body"><div class="lv-title">'+msj.stu_name+'</div><small class="lv-small" style="white-space: pre-wrap">'+msj.message+'</small></div></div></div>');
        						chatCount++;
	            		}
	            		ion.sound.play("bell_ring");
	            		
	            	}else{
	            		chatCount++;
	            		ion.sound.play("bell_ring");
	            		$("#chatNotice").after('<div class="dropdown-menu dropdown-menu-lg pull-right" id="noticeChatDropdown"><div class="listview" id="notificationChats"><div class="lv-header">聊天</div><div class="lv-body c-overflow" id="chatBody"><div class="lv-item" id="'+letmeId+'"><div class="media"><div class="pull-right"><button class="btn btn-success waves-effect" onclick="gotoChat(\''+letmeId+'\',\''+msjData+'\');" >接受</button></div> <div class="pull-left"><img class="lv-img-sm" src="${ctx}'+msj.stu_img+'" alt=""></div><div class="media-body"><div class="lv-title">'+msj.stu_name+'</div><small class="lv-small" style="white-space: pre-wrap">'+msj.message+'</small></div></div></div></div></div>');
	            	}
	            	if(chatCount>0){
	            		if($("#chatNotice>span").hasClass("avtiveCount")){
	            			$("#chatNotice>span").html(chatCount);
	            		}else{
		            		$("#chatNotice").append("<span class='avtiveCount'>"+chatCount+"</span>");
	            		}
            		}
            });
	            
	         //接受任务
	            client.subscribe("/topic/taskChat"+'${user.roleIds}', function(message) {
            		var msj=eval("("+decodeURI(message.body)+")");
	            	 console.log(msj.message);
	            	var inStorageGroupId="task_"+msj.inStorageGroupId;
	            	if($("#questionNotice+div").hasClass("dropdown-menu")){
	            		if(!$("#"+inStorageGroupId).hasClass("lv-item")){
    							$("#noticeBody").append('<div class="lv-item" id="'+inStorageGroupId+'"><div class="media"><div class="pull-right"><button class="btn btn-success waves-effect" onclick="acceptTaskFunc(\''+msj.inStorageGroupId+'\')" id="taskChatBtn'+inStorageGroupId+'">接受任务</button></div><div class="pull-left"><img class="lv-img-sm" src="${ctx}'+msj.img+'" alt=""></div><div class="media-body"><div class="lv-title">'+msj.name+'</div><small class="lv-small" style="white-space: pre-wrap">'+msj.name+"想对\'"+msj.message+"\'等物品进行入库!"+'</small></div></div></div>');
        						infoCount++;
	            		}
	            		ion.sound.play("door_bell");
	            		
	            	}else{
	            		infoCount++;
	            		ion.sound.play("door_bell");
	            		$("#questionNotice").after('<div class="dropdown-menu dropdown-menu-lg pull-right" id="noticeDropdown"><div class="listview" id="notificationChats"><div class="lv-header">聊天&任务</div><div class="lv-body c-overflow" id="chatBody"><div class="lv-item" id="'+inStorageGroupId+'"><div class="media"><div class="pull-right"><button class="btn btn-success waves-effect" onclick="acceptTaskFunc(\''+msj.inStorageGroupId+'\')" >接受任务</button></div> <div class="pull-left"><img class="lv-img-sm" src="${ctx}'+msj.img+'" alt=""></div><div class="media-body"><div class="lv-title">'+msj.name+'</div><small class="lv-small" style="white-space: pre-wrap">'+msj.name+"想对\'"+msj.message+"\'等物品进行入库!"+'</small></div></div></div></div></div>');
	            	}
	            	var h= window.document.location.href;
	            	if(h.indexOf('/myTasksIndex')>0){
	            		//处于代办任务页面
	            		$("#data-table-selection").bootgrid('reload');
	        		}
	            	if(infoCount>0){
	            		if($("#questionNotice>span").hasClass("avtiveCount")){
	            			$("#questionNotice>span").html(infoCount);
	            		}else{
		            		$("#questionNotice").append("<span class='avtiveCount'>"+infoCount+"</span>");
	            		}
            		}
            });
            
	            
	          }
		 );
		 
		$(window).scroll(function() {
			($(this).scrollTop() > ($('header').height() + 200)) ? $('#BackId').addClass('cd-is-visible') : $('#BackId').removeClass('cd-is-visible cd-fade-out');
		}).trigger('scroll');
		$('#BackId').on('click', function(event) {
			event.preventDefault();
			$('html,body').animate({
				scrollTop: 0
			}, 700);
		});
	});
	function gotoChat(id,msjData){
		//接受聊天
		console.log("接受聊天"+id);
		client.send("/topic/letusChat"+id, {}, encodeURI("ok"));
		var msj=eval("("+decodeURI(msjData)+")");
		console.log("当前位置"+ window.document.location.href +"--"+msj);
		var h= window.document.location.href;
		if(h.indexOf('/helpChat')<0){
			window.document.location.href='${ctx}/helpChat?s='+msj.stu_id+'&p='+msj.page_id;
		}else{
			//已处于聊天界面
			//如果已存在
			if(!$("#listImgview"+msj.stu_id).hasClass("lv-item")){
				//添加头像和相应消息内容
				var nowusId="nowusChat_"+msj.stu_id+"_"+'${user.id}'+"_"+msj.page_id;
				$('#msMenu').append('<div class="lv-item media" id="listImgview'+msj.stu_id+'" onclick="changeChannelFunc(\''+msj.stu_id+'\',\''+msj.tea_id+'\',\''+msj.page_id+'\',\''+msj.stu_img+'\',\''+msj.stu_name+'\');"><div class="lv-avatar pull-left"><img src="${ctx}'+msj.stu_img+'" alt="" id="listviewImg'+msj.stu_id+'"><i class="activeOnline" ></i></div><div class="media-body"><div class="lv-title">'+msj.stu_name+'</div></div></div>');
	     		$('#msBody').append('<div class="listview lv-message" id="msgBody'+msj.stu_id+'" style="display:none;"><div class="lv-header-alt bgm-white"><div id="ms-menu-trigger"><div class="line-wrap"><div class="line top"></div><div class="line center"></div><div class="line bottom"></div></div></div><div class="lvh-label hidden-xs"> <div class="lv-avatar pull-left"><img src="${ctx}'+msj.stu_img+'" alt=""></div><span class="c-black">'+msj.stu_name+'</span></div><ul class="lv-actions actions"><li><a href="javascript:void(0);" title="清空记录" onclick="clearChatBody();"><i class="md md-delete"></i></a></li></ul></div><div class="lv-body" style="height: 300px;overflow-y:auto;" id="chatbody'+msj.stu_id+'"></div> <div style="box-shadow: 0 -20px 20px -5px #fff;border-top: 1px solid #F0F0F0;background-color: #40E0D0"><div style="margin-left: 25px;"><a href="javascript:void(0);" title="发送图片" onclick="selectPicturesFunc();"><i class="md md-insert-photo" style="font-size: 25px"></i></a><a style="margin-left: 10px;" href="javascript:void(0);" title="发送截图" onclick="StartCapture();"><i class="md md-content-cut" style="font-size: 25px"></i></a></div></div><div class="lv-footer ms-reply"><textarea placeholder="我想说..." id="replyms'+msj.stu_id+'"></textarea><button title="按Enter发送消息,按Ctrl+Enter换行" onclick="sendReplyMessage();"><i class="md md-send"></i></button></div></div>');

	     		  channels.push("/topic/letmeChat"+nowusId);
	     		 var nowusId="nowusChat_"+msj.stu_id+"_"+'${user.id}'+"_"+msj.page_id;
      	    	//chatUSMessage(stu_id,tea_id,page_id,name,img,time,message)
      	    	var time=new Date().toLocaleString();
      	    	var cusm=new chatUSMessage(sid,tid,pid,name,img,time,'你好,我是 \''+name+'\',有什么问题吗?',0);
      	    	client.send("/topic/letusChatting"+nowusId, {}, encodeURI(JSON.stringify(cusm)));
     		   	$('#chatbody'+msj.stu_id).append('<div class="lv-item media"><div class="lv-avatar pull-left"><img src="${ctx}${user.portraitAddress}" alt=""></div><div class="media-body"> <div class="ms-item">你好,我是${user.userName},有什么问题吗?</div><small class="ms-date"><i class="md md-access-time"></i>'+time+'</small></div></div>');

      	    	
      	    	client.subscribe("/topic/letmeChat"+nowusId, function(message) {
	 	    		var msj=eval("("+decodeURI(message.body)+")");
			    		ion.sound.play("bell_ring");
			    		//+msj.stu_id+
			    		if(!$("#listImgview"+msj.stu_id).hasClass("active")){
     		    			if(!$('#listviewImg'+msj.stu_id).next().is("i")){
     	 		    			$('#listviewImg'+msj.stu_id).after('<i class="activeOnline" ></i>');
     	 		    		}
     		    		}
			    		if(msj.type==0){
			    			 $('#chatbody'+msj.stu_id).append('<div class="lv-item media right"><div class="lv-avatar pull-right"><img src="${ctx}'+msj.img+'" alt=""></div><div class="media-body"><div class="ms-item">'+msj.message+'</div><small class="ms-date"><i class="md md-access-time"></i>'+msj.time+'</small></div></div>');
			    		}else{
	     	     		   	$('#chatbody'+msj.stu_id).append('<div class="lv-item media right"><div class="lv-avatar pull-right"><img src="${ctx}'+msj.img+'" alt=""></div><div class="media-body"><div class="ms-item"><img src="${ctx}'+msj.message+'" ></div><small class="ms-date"><i class="md md-access-time"></i>'+msj.time+'</small></div></div>');
	 		    		}
	     	     		  $('#chatbody'+msj.stu_id).scrollTop( $('#chatbody'+msj.stu_id)[0].scrollHeight );
			    		
	 		    });
			}
			
		}
		$("#"+id).remove();
		chatCount--;
		if(chatCount<=0){
			chatCount=0;
			$("#noticeChatDropdown").remove();
			$("#chatNotice>span").remove();
		}else{
			$("#chatNotice>span").html(chatCount);
		}
	}
	
	function IKnowItFunc(obj){
		$(obj).remove();
		infoCount--;
		if(infoCount<=0){
			infoCount=0;
			$("#noticeDropdown").remove();
			$("#questionNotice>span").remove();
		}else{
			$("#questionNotice>span").html(infoCount);
		}
	}
	function completeFault(id){
		//启动特别聊天工具
		//发送消息
	     console.log("故障设置完成");
	     client.send("/topic/chat"+id, {}, encodeURI("ok"));
		$("#"+id).remove();
		infoCount--;
		if(infoCount<=0){
			infoCount=0;
			$("#noticeDropdown").remove();
			$("#questionNotice>span").remove();
		}else{
			$("#questionNotice>span").html(infoCount);
		}
	}
	
	function acceptTaskFunc(groupId){
		$("#taskChatBtn"+groupId).attr("disabled", true);
		$.ajax({
            type: "POST",
            url: "${ctx}/inStorageControl/acceptTask",
            data: {
            	groupId:groupId
           	 },
            success: function(data){
           	 if(data=='1'){
           		 	 swal({   
	                         title: "领取成功",   
	                         text: "领取任务成功！",   
	                         type: "success",
	                         timer: 2000,   
	                         showConfirmButton: false 
	                     });
           		 	var h= window.document.location.href;
	            	if(h.indexOf('/myTasksIndex')>0){
	            		//处于代办任务页面
	            		$("#data-table-selection").bootgrid('reload');
	        		}
           	 }else if(data=='2'){
           		 swal({   
                        title: "领取失败",   
                        text: "任务已被领取",   
                        type: "error",
                        timer: 2000,   
                        showConfirmButton: false 
                    });
           	 }else if(data=='3'){
           		 swal({   
                        title: "领取失败",   
                        text: "系统异常,请刷新或者联系管理员!",   
                        type: "error",
                        timer: 2000,   
                        showConfirmButton: false 
                    });
				}
           	 	console.log('group:'+groupId);
           		$("#noticeDropdown>#task_"+groupId).remove();
	           	infoCount--;
	    		if(infoCount<=0){
	    			infoCount=0;
	    			$("#noticeDropdown").remove();
	    			$("#questionNotice>span").remove();
	    		}else{
	    			$("#questionNotice>span").html(infoCount);
	    		}
	    		mytaskCount++;
	    		if($("#myWaitTasks>span").hasClass('menuavtiveCount')){
	    			$("#myWaitTasks>span").html(mytaskCount);
	    		}else{
	    			$("#myWaitTasks").append("<span class='menuavtiveCount'>"+mytaskCount+"</span>");
	    		}
	    		
	    		
	    		
	    		$("#taskChatBtn"+groupId).attr("disabled", false);
            },
            error:function(){
           	 swal({   
                        title: "领取失败",   
                        text: "系统异常,请刷新或者联系管理员!",   
                        type: "error",
                        timer: 2000,   
                        showConfirmButton: false 
                    });
           		 $("#taskChatBtn"+groupId).attr("disabled", false);
            }
		});
	}
</script>
	