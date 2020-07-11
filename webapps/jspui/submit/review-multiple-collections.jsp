
<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Sample Review JSP
  -
  - This is a sample JSP that works in conjuction with
  - the org.dspace.submit.step.SampleStep class
  -
  - This JSP is meant to be a template for similar review JSPs.
  -
  - Parameters to pass in to this page (from review.jsp)
  -    submission.jump - the step and page number (e.g. stepNum.pageNum) to create a "jump-to" link
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.service.CommunityService" %>
<%@ page import="org.dspace.content.factory.ContentServiceFactory" %>
<%@ page import="org.dspace.app.util.CollectionDropDown" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="javax.servlet.jsp.PageContext" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);    

	//get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

	//get the step number (for jump-to link)
	String stepJump = (String) request.getParameter("submission.jump");


    // ======================
    // Get item's collections
    List<Collection> collections = subInfo.getSubmissionItem().getItem().getCollections();

    CommunityService communityService = ContentServiceFactory.getInstance().getCommunityService();
%>   

<%-- ====================================================== --%>
<%--           MULTIPLE COLLECTIONS REVIEW PAGE             --%>
<%-- ====================================================== --%>
			    <div class='col-md-10'>    
				    <h5> Collections in which this item is being part of: </h5>
				    <ul>
					    <li><strong><%= CollectionDropDown.collectionPath(context, subInfo.getSubmissionItem().getCollection()) %></strong></li>
				    <% for(Collection col : collections) { %>
				    <li>
					<%= CollectionDropDown.collectionPath(context, col) %>
				    </li>
				    <% } %> 
				    </ul>
		    	    </div>
			    <div class='col-md-2'>
				    <input class="btn btn-default" type="submit" name="submit_jump_<%= stepJump %>" value="<fmt:message key="jsp.submit.review.button.correct"/>" />
			    </div>
