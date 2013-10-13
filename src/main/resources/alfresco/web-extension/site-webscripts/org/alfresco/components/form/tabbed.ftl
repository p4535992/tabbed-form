<#assign id=args.htmlid>
<#if formUI == "true">
   <@formLib.renderFormsRuntime formId=formId />
</#if>
<div id="${id}-dialog" <#if form.mode == "create">style="width:100%!important;"</#if>>
   <div id="${id}-dialogTitle" class="hd"></div>
   <div id="basic-accordian">
      <div class="bd">
	 <div id="${formId}-container" class="form-container" >
	    <style type="text/css" media="screen">
	       @import "/share/res/css/tabbed.css";
	    </style>
	    <div id="${formId}-caption" class="caption" style="text-align:right!important;width:100%!important;background-color:#FFF!important;">
	       <div class="tab_container">
		  <div style="float:center;">
		     <#list form.structure as item>
			     <#if item.kind == "set">
				     <div id="${item.id}-header" class="accordion_headings" >${item.label}</div>
			     </#if>
		     </#list>
		  </div>       
	       </div>
	    <#if form.mode != "view">   
			<div id="${formId}-caption-label"><span class="mandatory-indicator">*</span>${msg("form.required.fields")}</div>
		    </div>
	    </#if>
	    <form id="${formId}" method="${form.method}" accept-charset="utf-8" enctype="${form.enctype}" action="${form.submissionUrl}">
	       <#if form.destination??>
		  <input id="${formId}-destination" name="alf_destination" type="hidden" value="${form.destination}" />
	       </#if>
	       <div id="${formId}-fields" class="form-fields">
		
		  <#list form.structure as item>
		     <#if item.kind == "set">
			<div id="${item.id}-content"><div class="accordion_child">
			   <@processZone myzoneitem=item/> 
			</div></div>
		     </#if>
		  </#list>
		  <center>
		  		<#if form.mode != "view">
				   <div id="${formId}-buttons" class="form-buttons">
				      <#if form.showSubmitButton?? && form.showSubmitButton>
				         <input id="${formId}-submit" type="submit" value="${msg("form.button.submit.label")}" />&nbsp;
				      </#if>
				      <#if form.showResetButton?? && form.showResetButton>
				         <input id="${formId}-reset" type="reset" value="${msg("form.button.reset.label")}" />&nbsp;
				      </#if>
				      <#if form.showCancelButton?? && form.showCancelButton>
				         <input id="${formId}-cancel" type="button" value="${msg("form.button.cancel.label")}" />
				      </#if>
				   </div>
				  </#if>
		   </center>
	       </div>
	    </form>
	 </div>
      </div>
   </div>
</div>
<script type="text/javascript">
   var nodeRef = "${form.arguments["itemId"]}",
      formMode = '${form.mode}',
      varId = '${id}',
      varFormId = '${formId}';
   
   function loadScript(url, callback) {
       // adding the script tag to the head as suggested before
      var head = document.getElementsByTagName('head')[0],
	 script = document.createElement('script');
      script.type = 'text/javascript';
      script.src = url;
      // then bind the event to the callback function 
      // there are several events for cross browser compatibility
      script.onreadystatechange = callback;
      script.onload = callback;
      // fire the loading
      head.appendChild(script);
   }
   
   function tabbedMain() {
      initAcc();
   }
   
   loadScript("/share/res/js/tabbed.js", tabbedMain);
   
</script>
<#macro processZone myzoneitem>
   <#assign zone_indicator = myzoneitem.id?substring(0,1)/>
   <#if zone_indicator == "Z">
      <div>
	 <table style="width: 100% ! important;border-spacing: 10px!important;border-collapse: separate!important;" border="0" cellspacing="10" cellpadding="0">
	    <tr>
	       <#list myzoneitem.children as item3>
		  <td style="vertical-align: top;">
		     <#if item3.label == "">
		     <#else>
			<b>${item3.label}</b><br/>
			<hr/>
		     </#if>
		     <@processParentGroup myparentgroupitem=item3/>
		  </td>
		</#list>
	    </tr>
	 </table>
      </div>
   <#else>
      <@processSet myitem=myzoneitem/> 
   </#if>
</#macro>
<#macro processParentGroup myparentgroupitem>
   <#assign group_indicator = false/>
   <#list myparentgroupitem.children as groupitem>
      <#assign id_group_indicator = groupitem.id?substring(0,1)/>
      <#if id_group_indicator == "G">
	 <#assign group_indicator = true/>
      </#if>
   </#list>
   <#if group_indicator>
      <#list myparentgroupitem.children as groupitem>
	 <div class="set-bordered-panel">
	    <div class="set-bordered-panel-heading">${groupitem.label}</div>
	    <div class="set-bordered-panel-body">
	       <@processSet myitem=groupitem/>
	    </div>
	 </div>
      </#list>
   <#else>
      <@processSet myitem=myparentgroupitem/> 
   </#if>
</#macro>
<#macro processSet myitem>
   <#assign my_index = 0/>
   <div>
      <table style="width: 100% ! important;" border="0" cellspacing="0" cellpadding="0">
	 <#list myitem.children as item>
	    <#if my_index == 0>
	       <tr style="overflow:visible!important;">
	    </#if>
	    <#assign i_span = 1/>
	    <#if item.kind == "set">
	       <#assign i_span = item.id?substring(0,1)?number/>
	       <#assign r_span = item.id?substring(1,2)?number/>
	       <td 
	       colspan="${i_span}" rowspan="${r_span}" style="vertical-align: top;">
		  <#list item.children as item2>
		     <#if item2.kind == "set">
			<table style="width: 100% ! important;" border="0" cellspacing="0" cellpadding="0"><tr>
			   <#list item2.children as item3>
				   <td>
					   <@formLib.renderField field=form.fields[item3.id] />
				   </td>
			   </#list>
			</tr></table>
		     <#else>
			<@formLib.renderField field=form.fields[item2.id] />
		     </#if>
		  </#list>
	       </td>
	    <#else>
	       <td>
		  <@formLib.renderField field=form.fields[item.id] />
	       </td>
	    </#if>
	    <#assign my_index = my_index + i_span/>
	    <#if !item_has_next || item.id?substring(2,3) == "1">
	       </tr>	
	       <#if item.id?substring(3,4) == "L">
		  <tr>
		     <td colspan="<#if item.id?substring(4,5) == "0">${my_index}<#else>${item.id?substring(4,5)?number}</#if>">
			<hr/>
		     </td>
		  </tr>
	       </#if>
	       <#assign my_index = 0/>
	    </#if>
	 </#list>
      </table>
   </div>
</#macro>
