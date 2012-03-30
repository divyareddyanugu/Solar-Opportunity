
<%--
Document   : Help information about Plane
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

          
           <title>About Plane</title>
    </head>
    <body>
        <div id="page">
            <div id="content" style="margin-left:10px;">
                <p><b> What is a Plane? </b></p>
                <p>Plane is a section of the roof that can be used for solar panels.</p>
                <p><b> How to add a Plane? </b></p>
                <p><ul>
                        <li>Click on 'Start' button</li>
                        <li>Click on the roof image to select points that together form a polygon. This polygon represents the usable
                        (for solar panels) section of the roof, a plane.
                        <img src="<%=domain%>/img/aboutplane.png" style="width:700px;height:500px;" alt="Draw Plane"/>
                        <br/><br/>
                        </li>
                        <li>Click on 'Undo Point' to delete the last drawn point.

                        <img src="<%=domain%>/img/undopoint_plane.png" style="width:700px;height:500px;" alt="Undo Last Drawn Plane"/>
                        <br/><br/>
                        </li>
                        <li>Click on 'Finish' to complete drawing the plane. The plane is added to the 'Planes & Obstructions' list. <br/>

                        <img src="<%=domain%>/img/saveplane.png" style="width:700px;height:500px;" alt="Save Plane"/> <br/><br/>
                            Or <br/>
                            Click on 'Undo Area' to delete current plane and start over.
                        </li>
                    </ul></p>

            
            </div>
        </div>

        
    </body>
</html>
