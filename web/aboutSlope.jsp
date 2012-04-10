
<%--
Document   : Help information about Slope
Author     : Divya Reddy Anugu
--%>
<%@ page contentType="text/html" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%
            String domain = (String) session.getAttribute("domain");

            if (domain == null) {
                domain = request.getRequestURL().toString();
                int end = domain.indexOf(request.getServletPath());
                domain = domain.substring(0, end == -1 ? domain.length() - 1 : end);
                session.setAttribute("domain", domain);
            }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>

          
           <title>About Slope</title>
    </head>
    <body>
       <div id="page">
            <div id="content" style="margin-left:50px;">
                <p><b>What is roof pitch or slope? </b></p>
                <p> Roof pitch is a numerical measure of the steepness of a roof. <br/>
                Roof Pitch = (rise / run) Ft
            </p>

            <img src="<%=domain%>/img/help.png"/>
            <p><b>How to set the slope for a roof segment. </b>
            <br/>
                   <p> Draw a roof-segment on your roof. <br/>
                Click on the roof-segment to open the balloon, as seen in below image. </p>

            </p>
                <img src="<%=domain%>/img/orientationBalloon.png" style="width:700px;height:500px;" alt=""/>
                <p>Enter the rise and run of the roof segment and click on button 'Update'</p>
            </div>
        </div>

        
    </body>
</html>
