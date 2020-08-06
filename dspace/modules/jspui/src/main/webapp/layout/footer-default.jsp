<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

            <%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null)
    {
%>
	</div>
	<div class="col-md-3">
                    <%= sidebar %>
    </div>
    </div>       
<%
    }
%>
</div>
</main>
            <%-- Page footer --%>
	    <footer>
		  <div class="container">
			<div class="col-lg-4">
				
				<img style="width:200px;" src="<%= request.getContextPath() %>/image/iknow-.jpg" /><br/>
				<img height="80"  src="<%= request.getContextPath() %>/image/logo-ui-fk-imeri.png" alt="Logo" />
			</div>
			<div class="col-lg-4">
				<h3>Quick links</h3>
				<ul style='list-style: none;padding: 3px;'>
					<li><a target="_blank" href="http://ui.ac.id">Universitas Indonesia</a></li>
					<li><a target="_blank" href="http://fk.ui.ac.id">Faculty of Medicine</a></li>
					<li><a target="_blank" href="http://imeri.fk.ui.ac.id">Indonesia Medical Education and Research Institute</a></li>
					<li><a target="_blank" href="http://perpustakaan.fk.ui.ac.id">Perpustakaan FKUI</a></li>
					<li><a target="_blank" href="http://lib.ui.ac.id">UI Library</a></li>
				</ul>
			</div>
			<div class="col-lg-4">
				<h3>Get in touch</h3>
				<div>
					IMERI Management<br/>Education Tower IMERI building, 2nd floor<br/>
					Jalan Salemba Raya no. 6<br/>Jakarta Pusat, DKI Jakarta, Indonesia<br/>+62 21 29189162
					<br> Visitor : 
						<!-- Default Statcounter code for iknow
						http://152.118.76.18:8080/jspui -->
						<script type="text/javascript">
						var sc_project=12370303; 
						var sc_invisible=0; 
						var sc_security="dddfb22d"; 
						var sc_https=1; 
						var scJsHost = "https://";
						document.write("<sc"+"ript type='text/javascript' src='" +
						scJsHost+
						"statcounter.com/counter/counter.js'></"+"script>");
						</script>
						<noscript><div class="statcounter"><a title="Web Analytics"
						href="https://statcounter.com/" target="_blank"><img
						class="statcounter"
						src="https://c.statcounter.com/12370303/0/dddfb22d/0/"
						alt="Web Analytics"></a></div></noscript>
						<!-- End of Statcounter Code -->
						<a href="https://statcounter.com/p12370303/?guest=1">View My
						Stats</a>
				</div>
			</div>
			
		  </div>
             <div class="navbar navbar-inverse navbar-bottom">
             <div id="designedby" class="container text-muted">
            <%-- <fmt:message key="jsp.layout.footer-default.theme-by"/> <a href="http://www.cineca.it"><img
                                    src="<%= request.getContextPath() %>/image/logo-cineca-small.png"
				    alt="Logo CINECA" /></a> --%>
			<div id="footer_feedback" class="pull-right">                                    
                                <p class="text-muted"><fmt:message key="jsp.layout.footer-default.text"/>&nbsp;-
                                <a target="_blank" href="<%= request.getContextPath() %>/feedback"><fmt:message key="jsp.layout.footer-default.feedback"/></a>
                                <a href="<%= request.getContextPath() %>/htmlmap"></a></p>
                                </div>
			</div>
		</div>
    </footer>
    </body>
</html>
