
<%--
Document   : Help
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
        <meta http-equiv="content-type" content="text/html; charset=utf-8"><title>SFSU / City Of Oakland Solar Energy Project</title>
            <link href="<%=domain%>/css/default.css" rel="stylesheet" type="text/css" />
            <!--
             <script type="text/javascript" src="https://www.google.com/jsapi?key=ABQIAAAALwb25IR2fJddvXhxh-B0VhT2yXp_ZAY8_ufC3CFXhHIE1NvwkxSg64kZN_mb_Ed79poahKsISZ1mkw"> </script>
            -->

            <script type="text/javascript" src="https://www.google.com/jsapi?key=ABQIAAAALwb25IR2fJddvXhxh-B0VhS4tN3Xp5_DBMdF7xUAP7eDAIPoARTuHEexs2X2QeneMvd0li8GSaGViA">
            </script>
            <script src="extensions.js" type="text/javascript"></script>
            <script src="arealist.js" type="text/javascript"></script>
          
           <title>Help Guide</title>
    </head>
    <body>
        <div id="header">
            <div id="logo">
                <h2><a href="">Solar Opportunity</a></h2>
                   
            
                <div id="menu">
                    <ul>
                        <li><a href="<%=domain%>/index.jsp">Home</a></li>
                        
                        <li class="active"><a href="<%=domain%>/helpguide.jsp">Help</a></li>
                        
                    </ul>
                </div>
            </div>
        </div>
        <div id="page">
            <div id="content" style="margin-left:50px;">
            <p> Roof pitch is a numerical measure of the steepness of a roof. <br/>
                Roof Pitch = (rise / run)
            </p>

            <img src="<%=domain%>/img/help.png"/>
            </div>
        </div>

        <div id="footer">
            <table width="100%">
                <tbody><tr>
                        <td align="left">
                            <p>©2008 San Francisco State University.</p>
                        </td>
                        <td align="center">
                            <p><a href="<%=domain%>/secure/about.jsp">About</a> | <a href="<%=domain%>/secure/credits.jsp">Credits</a> </p>
                        </td>
                        <td align="right">
                            <p><i>(Based on a design by <a href="http://www.freecsstemplates.org/">Free CSS Templates</a>)</i></p>
                        </td>
                    </tr>
                </tbody></table>
        </div>
    </body>
</html>
