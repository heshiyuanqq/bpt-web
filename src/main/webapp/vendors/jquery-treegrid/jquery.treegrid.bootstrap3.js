$.extend($.fn.treegrid.defaults, {
	 expanderTemplate: '<i class="md "></i>',
     indentTemplate: '<span class="treegrid-indent"></span>',
     expanderExpandedClass: 'md-expand-more',
     expanderCollapsedClass: 'md-chevron-right',
     getExpander: function() {
         return $(this).find('.md');
     }
});
