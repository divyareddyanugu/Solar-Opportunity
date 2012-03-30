
<%--
Document   : Help information about Obstruction
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

          
           <title>About Obstruction</title>
    </head>
    <body>
        <div id="page">
            <div id="content" style="margin-left:10px;">
                <p><b> What is an Obstruction? </b></p>
                <p>Obstruction is a section of the roof that can't be used for solar panels. Ex: Chimney / Skylight
                    <br/>
                The sample image below shows a roof with a skylight (see arrow). That section of the roof can not be used
                to install a solar panel. It is called an obstruction.
                <img src="<%=domain%>/img/sampleobstruction.JPG" style="width:700px;height:500px;" alt="Example Obstruction"/>

                </p>
                <p><b> How to add an Obstruction? </b></p>
                <p><ul>
                        <li>Click on 'Start' button</li>
                        <li>Click on the roof image to select points that together form a polygon. This polygon represents the unusable
                         section of the roof, an obstruction. The entire obstruction should lie within a plane.
                        <img src="<%=domain%>/img/aboutobstruction.png" style="width:700px;height:500px;" alt="Draw Obstruction"/>
                        <br/><br/>
                        </li>
                        <li>Click on 'Finish' to complete drawing the obstruction. The obstruction is added to the 'Planes & Obstructions' list. <br/>

                        <img src="<%=domain%>/img/saveobstruction.png" style="width:700px;height:500px;" alt="Save Obstruction"/> <br/><br/>
                            Or <br/>
                            Click on 'Undo Area' to delete current obstruction and start over.
                        </li>
                    </ul></p>            
            </div>
        </div>

        
    </body>
</html>
