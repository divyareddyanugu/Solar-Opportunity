
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

          
           <title>About Roof-Segment</title>
    </head>
    <body>
        <div id="page">
            <div id="content" style="margin-left:10px;">
                <p><b> What is a Roof-Segment ? </b></p>
                <p>Roof-Segment is a section of the roof that can be used for solar panels.</p>
                <p><b> How to add a Roof-Segment? </b></p>
                <p><ul>
                        <li>Click on 'Start Drawing' button</li>
                        <li>Click on the roof image to select points that together form a polygon. This polygon represents the usable
                        (for solar panels) section of the roof.
                        <img src="<%=domain%>/img/aboutplane.png" style="width:700px;height:500px;" alt="Draw Roof-Segment"/>
                        <br/><br/>
                        </li>
                        <li>Click on 'Remove Last Point' to delete the last drawn point.

                        <img src="<%=domain%>/img/undopoint_plane.png" style="width:700px;height:500px;" alt="Remove Last Drawn Plane"/>
                        <br/><br/>
                        </li>
                        <li>Click on 'Finish Drawing' to complete drawing the roof segment. The segment is added to the 'Property Summary' list. <br/>

                        <img src="<%=domain%>/img/saveplane.png" style="width:700px;height:500px;" alt="Save Plane"/> <br/><br/>
                          </li>
                    </ul></p>

             <p><b> How to multiple Roof-Segments? </b></p>
                <p><ul>
                        
                        <li>Click on 'Start Drawing' button</li>
                        <li>Draw the roof-segment on the property image</li>
                        <li>Click on 'Finish Drawing' button. This adds the segment to property summary</li>
                        <li>To add another plane. Click on 'Start Drawing' button</li>
                        <li>Draw the second roof-segment on the property image</li>
                        <li>Click on 'Finish Drawing' button. This adds the segment to property summary.
                        </li>

                        <li>
                        Property summary now shows both roof-segments
                            <img src="<%=domain%>/img/addMultiplePlanes.png" style="width:700px;height:500px;" alt="Draw Roof-Segment"/>
                        </li></ul></p>

                          <p><b> How to delete a Roof-Segment? </b></p>
                <p><ul>

                        <li>Click on 'Remove Current Segment', to delete the roof-segment currently being edited
                            (if you have not clicked on 'Finish Drawing' yet, then the segment is being currently edited)</li>
                        <li>To delete a segment that has already been added to the property summary,
                        click on the desired segment on the image to open the balloon.
                            <img src="<%=domain%>/img/orientationBalloon.png" style="width:700px;height:500px;" alt="Roof-Segment"/>
                        </li>
                        <li>Click on button 'Delete'. This removes the screen from the property image and the property summary. Total usable area is adjusted accordingly. </li>
                    </ul>
                </p>
                        <p><b>How to set orientation & slope for a Roof-Segment?</b>
                        </p>
                        <p><ul>
                                <li>Click on the property image to select the segment to which you would like to set the orientation and slope.
                                This opens a balloon as seen below.</li>
                                <li>Follow the instructions in 'Help' to set the orientation and slope for the roof-segment
                                  <img src="<%=domain%>/img/orientationBalloon.png" style="width:700px;height:500px;" alt="Roof-Segment"/>
                        </li>
                            </ul></p>
            </div>
        </div>

        
    </body>
</html>
