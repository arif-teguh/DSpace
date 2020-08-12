<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - User profile editing form.
  -
  - This isn't a full page, just the fields for entering a user's profile.
  -
  - Attributes to pass in:
  -   eperson       - the EPerson to edit the profile for.  Can be null,
  -                   in which case blank fields are displayed.
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.Locale"%>

<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.eperson.service.EPersonService" %>
<%@ page import="org.dspace.eperson.factory.EPersonServiceFactory" %>
<%@ page import="org.dspace.core.Utils" %>

<%
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    EPerson epersonForm = (EPerson) request.getAttribute("eperson");

    String lastName = "";
    String firstName = "";
    String phone = "";
    String language = "";
	String cluster = "";
	String department = "";

    if (epersonForm != null)
    {
        EPersonService epersonService = EPersonServiceFactory.getInstance().getEPersonService();

        // Get non-null values
        lastName = epersonForm.getLastName();
        if (lastName == null) lastName = "";

        firstName = epersonForm.getFirstName();
        if (firstName == null) firstName = "";

        phone = epersonService.getMetadata(epersonForm, "phone");
        if (phone == null) phone = "";

        language = epersonService.getMetadata(epersonForm, "language");
        if (language == null) language = "";
		
		department = epersonForm.getDepartment();
        if (department == null) department = "";
		
		cluster = epersonForm.getCluster();
        if (cluster == null) cluster = "";
    }
%>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tfirst_name"><fmt:message key="jsp.register.profile-form.fname.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="first_name" id="tfirst_name" size="40" value="<%= Utils.addEntities(firstName) %>"/></div>
	</div>
	<div class="form-group">
        <%-- <td align="right" class="standard"><label for="tlast_name"><strong>Last name*:</strong></label></td> --%>
		<label class="col-md-offset-3 col-md-2 control-label" for="tlast_name"><fmt:message key="jsp.register.profile-form.lname.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="last_name" id="tlast_name" size="40" value="<%= Utils.addEntities(lastName) %>" /></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tphone"><fmt:message key="jsp.register.profile-form.phone.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="phone" id="tphone" size="40" maxlength="32" value="<%= Utils.addEntities(phone) %>"/></div>
    </div>
    <div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tlanguage"><strong><fmt:message key="jsp.register.profile-form.language.field"/></strong></label>
 		<div class="col-md-3">
        <select class="form-control" name="language" id="tlanguage">
<%
        for (int i = supportedLocales.length-1; i >= 0; i--)
        {
        	String lang = supportedLocales[i].toString();
        	String selected = "";
        	
        	if (language.equals(""))
        	{ if(lang.equals(I18nUtil.getSupportedLocale(request.getLocale()).getLanguage()))
        		{
        			selected = "selected=\"selected\"";
        		}
        	}
        	else if (lang.equals(language))
        	{ selected = "selected=\"selected\"";}
%>
           <option <%= selected %>
                value="<%= lang %>"><%= supportedLocales[i].getDisplayName(UIUtil.getSessionLocale(request)) %></option>
<%
        }
%>
        </select>
        </div>
     </div>

     <div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tdepartment">Department :</label>
        <div class="col-md-3">
		<select class="form-control" name="department" id="tdepartment">
		<option value="<%= Utils.addEntities(department) %>"> <%= Utils.addEntities(department) %> </option>
		<option value = "Department of Anatomy">Department of Anatomy</option>
		<option value = "Department of Biochemistry & Molecular Biology">Department of Biochemistry & Molecular Biology</option>
		<option value = "Department of Medical Biology">Department of Medical Biology</option>
		<option value = "Department of Physiology">Department of Physiology</option>
		<option value = "Department of Pharmacy">Department of Pharmacy</option>
		<option value = "Department of Pharmacology & Therapeutic">Department of Pharmacology & Therapeutic</option>
		<option value = "Department of Medical Education">Department of Medical Education</option>
		<option value = "Department of Medical Physics">Department of Medical Physics</option>
		<option value = "Department of Community Medicine">Department of Community Medicine</option>
		<option value = "Department of Histology">Department of Histology</option>
		<option value = "Department of Medical Chemistry">Department of Medical Chemistry</option>
		<option value = "Department of Microbiology Clinic">Department of Microbiology Clinic</option>
		<option value = "Department of Parastiology">Department Parastiology </option>
		<option value = "Department of Anesthesiology">Department of Anesthesiology</option>
		<option value = "Department of Surgery">Department of Surgery</option>
		<option value = "Department of Neurology">Department of Neurology</option>
		<option value = "Department of Neurosurgery">Department of Neurosurgery</option>
		<option value = "Department of Psychiatry">Department of Psychiatry</option>
		<option value = "Department of Dentistry">Department of Dentistry</option>
		<option value = "Department of Pediatric">Department of Pediatric</option>
		<option value = "Department of Forensic and Medicolegal">Department of Forensic and Medicolegal</option>
		<option value = "Department of Dermatology and Venereology">Department of Dermatology and Venereology</option>
		<option value = "Department Ear, Nose and Throat">Department Ear, Nose and Throat</option>
		<option value = "Department of Radiology">Department of Radiology</option>
		<option value = "Department of Pulmonology and Respiratory Medicine">Department of Pulmonology and Respiratory Medicine</option>
		<option value = "Department of Clinical Pathology">Department of Clinical Pathology</option>
		<option value = "Department of Obstetrics and Gynecology">Department of Obstetrics and Gynecology</option>
		<option value = "Department of Cardiology and Vascular Medicine">Department of Cardiology and Vascular Medicine</option>
		<option value = "Department of Ophthalmology">Department of Ophthalmology</option>
		<option value = "Department of Internal Medicine">Department of Internal Medicine</option>
		</select>
		</div>
    </div>

    <div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tcluster">cluster :</label>
        <div class="col-md-3">
		<select class="form-control" type="text" name="cluster" id="tcluster">
		<option value="<%= Utils.addEntities(cluster)%>"><%= Utils.addEntities(cluster)%></option>
		<option value="Center of e-Learning">Center of e-Learning</option>
		<option value="Indonesia Museum of Health and Medicine">Indonesia Museum of Health and Medicine</option>
		<option value="Knowledge Management Center">Knowledge Management Center</option>
		<option value="Medical Education Center">Medical Education Center</option>
		<option value="Simulation Based Medical Education & Research Center">Simulation Based Medical Education & Research Center</option>
		<option value="Drug Development">Drug Development</option>
		<option value="Human Cancer">Human Cancer</option>
		<option value="Human Genetics">Human Genetics</option>
		<option value="Human Nutrition">Human Nutrition</option>
		<option value="Human Reproduction, Fertility and Family Planning">Human Reproduction, Fertility and Family Planning</option>
		<option value="Infectious Disease and Immunology">Infectious Disease and Immunology</option>
		<option value="Metabolic Disorder, Carduivascular and Aging">Metabolic Disorder, Carduivascular and Aging</option>
		<option value="Neuroscience and Brain Development">Neuroscience and Brain Development</option>
		<option value="Occupational and Environmental Health">Occupational and Environmental Health</option>
		<option value="Sport and Exercise Studies">Sport and Exercise Studies</option>
		<option value="Stem Cells and Tissue Engineering">Stem Cells and Tissue Engineering</option>
		<option value="Molecular Biology and Proteomics Core Facilities">Molecular Biology and Proteomics Core Facilities</option>
		<option value="Animal Research Facilities">Animal Research Facilities</option>
		<option value="Clinical Research Supporting Unit">Clinical Research Supporting Unit</option>
		<option value="Bio-Informatica">Bio-Informatica</option>
		<option value="Medical Technology">Medical Technology</option>
		<option value="Writing Center">Writing Center</option>
		</select>

		</div>
	</div>
