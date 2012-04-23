

<%--
Document   : Help information about Orientation
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
                <p><b> What is Orientation of a Roof-Segment? </b></p>
                <p>Roof orientation describes how South-facing your roof is.</p>
                <p> Orientation is measured in degrees (counter-clockwise from South).
                <ul>
                        <li>0 degrees is south </li>
                        <li>90 degrees is east</li>
                        <li>180 degrees is north</li> 
                        <li>270 degrees is west</li></ul></p>
                
                <img src="<%=domain%>/img/orientationDiffAngles.png" style="width:600px;height:500px;" alt=""/>

                
                <p>A roof best suited for solar panel installation is south facing (between south-east and south-west).
                    In southern hemisphere, the roof should be north-facing. </p>
                <p><b> How to specify orientation for a roof? </b></p>
                <p> Each roof-segment of a roof can have a different orientation.
                    You can set the orientation for a roof-segment using either one of the following options: </p>
                <ul>
                    <li> Using the 'Orientation Tool'
                    </li>
                    <li> Enter the value in orientation textbox. </li>
                </ul>
                <b>Using The Orientation Tool</b>
                <p> Draw a roof-segment on your roof. <i>(Click 'Start Drawing' -> Draw the polygon -> Click 'Finish Drawing'</i><br/>
                Click on the roof-segment to open the balloon, as seen in below image. </p>
                <img src="<%=domain%>/img/orientationBalloon.png" style="width:700px;height:500px;" alt=""/>
                <p>Click on link 'Show Orientation Tool' in the balloon.
                    This shows the orientation tool for the selected roof-segment, as seen below.</p>
                <img src="<%=domain%>/img/orientationShowTool.png" style="width:700px;height:500px;" alt=""/>
                <p>Drag the point along the white circle to set the orientation (angle). <br/>
                The roof-segment seen in the image below is west facing, so the angle is adjusted accordingly.</p>
                <img src="<%=domain%>/img/orientationSetTool.png" style="width:700px;height:500px;" alt=""/>
                <p>Orientation set using the above method is assigned to the roof-segment. This value can be seen in the balloon.
                Click on roof-segment to open the balloon. <br/>
                See the value in orientation textbox in the image below</p>
                <img src="<%=domain%>/img/orientationAfterSet.png" style="width:700px;height:500px;" alt=""/>
               <br/>
               <br/>
                <b>Enter The Value In Orientation Textbox </b>
                 <p> Draw a roof-segment on your roof. <i>(Click 'Start Drawing' -> Draw the polygon -> Click 'Finish Drawing'</i><br/>
                Click on the roof-segment to open the balloon, as seen in below image. </p>
                <img src="<%=domain%>/img/orientationBalloon.png" style="width:700px;height:500px;" alt=""/>

                <p>
Enter the orientation value (between 0 and 360) in the orientation
textbox in the balloon and click on button 'Update'
                </p>    </div>
        </div>


    </body>
</html>
