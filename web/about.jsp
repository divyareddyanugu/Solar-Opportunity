<%--
Document   : login
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
            <script src="help.js" type="text/javascript"></script>
            <script src="orientation.js" type="text/javascript"></script>


</head>
    <body>
        <div id="header">
            <div id="logo">
                <h2><a href="">Solar Opportunity</a></h2>

                <div id="menu">
                    <ul>
                        <li class="active"><a href="<%=domain%>/index.jsp">Home</a></li>

                        <li><a href="" onclick="openHelpGuide(); return false;">Help</a></li>

                    </ul>
                </div>
            </div>
        </div>

        <div id="page">

<div id="content" style="margin-left:10px;margin-right:10px;">
             <h2 style="text-align:left;"><b>ABOUT</b></h2>
             <p>This application is the result of collaboration between City of Oakland and the 
                 <a href="http://cs.sfsu.edu">Computer Science Dept. at San Francisco State University</a>. <br/>
             
             </p>
                 <h2  style="text-align:left;"><b>CREDITS</b></h2>
             <ul>
                     <li>
                         <b> Scott Wentworth </b><br/>
                         Energy Engineer<br/>
                         City of Oakland<br/>
                         <br/>
                     </li>
                     <li>
                         <b>  Dr. Barry Levine</b><br/>
                         Professor<br/>
                         Computer Science Department<br/>
                         San Francisco State University<br/>
                         <br/>
                     </li>
                 <li>
                     <b>Project Developers</b> <br/>
                         Students @ Computer Science Department <br/>
                         San Francisco State University<br/>
                     </li>
                 </ul>

             
            </div>

            <!-- end content -->

        </div>

        <div id="footer">
            <table width="100%">
                <tbody><tr>
                        <td align="left">
                            <p>©2008 San Francisco State University.</p>
                        </td>
                        <td align="center">
                            <p><a href="<%=domain%>/about.jsp">About/Credits</a> </p>
                        </td>
                        <td align="right">
                            <p><i>(Based on a design by <a href="http://www.freecsstemplates.org/">Free CSS Templates</a>)</i></p>
                        </td>
                    </tr>
                </tbody></table>
        </div>
    </body>
</html>

        
