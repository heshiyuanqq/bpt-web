jQuery.extend(jQuery.validator.messages, {
          required: "",
		  remote: "",
		  email: "",
		  url: "",
		  date: "",
		  dateISO: "",
		  number: "",
		  digits: "",
		  creditcard: "",
		  equalTo: "",
		  accept: "",
		  maxlength: jQuery.validator.format(""),
		  minlength: jQuery.validator.format(""),
		  rangelength: jQuery.validator.format(""),
		  range: jQuery.validator.format(""),
		  max: jQuery.validator.format(""),
		  min: jQuery.validator.format("")
});
jQuery.validator.addMethod("account", function(value, element, param) {
	  var reg = new RegExp("^([a-zA-Z0-9]+)$");
      return reg.test(value);  
}, $.validator.format(""));
jQuery.validator.addMethod("NoSpicalChar", function(value, element, param) {
	 var reg = new RegExp("^[a-zA-Z0-9\u4e00-\u9fa5]+$");
     return reg.test(value); 
}, $.validator.format(""));

jQuery.validator.addMethod("equalsPwd", function(value, element, param) {
	  return value == $('#regPassword').val();
}, $.validator.format(""));
jQuery.validator.addMethod("account", function(value, element, param) {
	 var reg = new RegExp("^([a-zA-Z0-9]+)$");
     return reg.test(value);
}, $.validator.format(""));
jQuery.validator.addMethod("fileNameInput", function(value, element, param) {
	var reg = new RegExp("^[^\\/:\*\?\'\"<>\|,]+$");
    return reg.test(value);
}, $.validator.format(""));

/**
 * validator
 */
$.validator.setDefaults({
    errorElement: "span",
    errorClass: "md md-close form-control-feedback",
    highlight: function (element, errorClass, validClass) {
            $(element).closest('.checkbox').removeClass('has-success').addClass('has-error');
            $(element).closest('.input-group').removeClass('has-success').removeClass('has-feedback').addClass('has-error').addClass('has-feedback');
    },
    unhighlight: function (element, errorClass, validClass) {
              $(element).closest('.checkbox').removeClass('has-error').addClass('has-success');
			  $(element).closest('.input-group').removeClass('has-error').removeClass('has-feedback').addClass('has-success').addClass('has-feedback');
			  if(element.id!=''){
				  $(element.form).find("span[for=" + element.id + "]").removeClass('md-close').addClass('md-check');
			  }
    },
    errorPlacement: function (error, element) {
    	if(element.is(':checkbox') || element.is(':radio')) {
		}else{
			error.insertAfter(element.parent());
		}
		 
	},
});

/*
 * Notifications
 */
function notify(title,message,type){
    $.growl({
        icon: 'fa fa-comments',
        title: title+':',
        message: message,
        url: ''
    },{
            element: 'body',
            type: type,
            allow_dismiss: true,
            placement: {
                    from: 'bottom',
                    align: 'center'
            },
            offset: {
                x: 20,
                y: 85
            },
            spacing: 10,
            z_index: 1031,
            delay: 2500,
            timer: 1000,
            url_target: '_blank',
            mouse_over: false,
            animate: {
                    enter: 'animated bounceInUp',
                    exit: 'animated bounceOutUp'
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
};

