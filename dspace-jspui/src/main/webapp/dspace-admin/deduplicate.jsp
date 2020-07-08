<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Form to upload a metadata files
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.List"            %>
<%@ page import="java.util.UUID"            %>
<%@ page import="java.util.ArrayList"            %>
<%@ page import="org.dspace.content.Collection"            %>



<dspace:layout style="submission" titlekey="jsp.dspace-admin.batchimport.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin" 
               nocache="true">

    <h1><fmt:message key="jsp.dspace-admin.batchimport.title"/></h1>

	<h1>Test ini deduplication </h1>
    <script>
	    $( "#import-type" ).change(function() {
	    	var index = $("#import-type").prop("selectedIndex");
	    	if (index <= 1){
	    		if (index == 1) {
	    			$( "#input-file" ).hide();
	    			$( "#input-url" ).show();
	    		}
	    		else {
		    		$( "#input-file" ).show();
		    		$( "#input-url" ).hide();	    			
	    		}
	    		$( "#owning-collection-info" ).show();
	    		$( "#owning-collection-optional" ).show();
	    	}
	    	else {
	    		$( "#input-file" ).show();
	    		$( "#input-url" ).hide();
	    		$( "#owning-collection-info" ).hide();
	    		$( "#owning-collection-optional" ).hide();
	    	}
	    });
		
		$( "#owning-collection-select" ).change(function() {
	    	var index = $("#owning-collection-select").prop("selectedIndex");
	    	if (index == 0){
	    		$( "#other-collections-div" ).hide();
				$( "#other-collections-select > option" ).attr("selected",false);
	    	}
	    	else {
	    		$( "#other-collections-div" ).show();
	    	}
	    });
    </script>
    
    
</dspace:layout>
