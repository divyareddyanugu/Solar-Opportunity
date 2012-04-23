
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
         
        <title>Help Guide</title>
    </head>
    <body>
        <div id="page">
            <div>
             <h2 class="small_title" style="text-align:center;">HELP GUIDE</h2>
            <div id="content">

                <a href="#plane1" name="top" style="color:blue;">What is a Roof-Segment? </a>
                <br/>
                <br/>
                <a href="#plane2" style="color:blue;">How to add a Roof-Segment? </a>
                <br/>
                <br/>
                <a href="#plane3" style="color:blue;">How to add multiple Roof-Segments? </a>
                <br/>
                <br/>
                <a href="#plane4" style="color:blue;">How to delete a Roof-Segment? </a>
                <br/>
                <br/>
                <a href="#plane5" style="color:blue;">How to set orientation & slope for a Roof-Segment?</a>
                <br/>
                <br/>

                <a href="#obs1" style="color:blue;"> What is an Unusable Area? </a>
                <br/>
                <br/>
                <a href="#obs2" style="color:blue;">How to add an Unusable Area?</a>
                <br/>
                <br/>
                <a href="#slope1" name="topSlope" style="color:blue;"> What is roof pitch or slope? </a>
                <br/>
                <br/>
                <a href="#slope2" style="color:blue;">How to set the slope for a Roof-Segment?</a>
                <br/>
                <br/>
<a href="#orientation1" name="topOrientation" style="color:blue;">What is Orientation of a Roof-Segment?</a>
<br/>
                <br/>
<a href="#orientation2" style="color:blue;">How to set Orientation of a Roof-Segment?</a>


                <br/> <br/>
                <br/> <br/>


                <a name="plane1" style="color:black;"><b> WHAT IS A ROOF-SEGMENT? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>    Roof-Segment is a section of the roof that can be used for solar panels. </p>
                <br/>
                <br/>

                <a name="plane2" style="color:black;"><b>HOW TO ADD A ROOF-SEGMENT?</b> 
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>
                    <ul>
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
                    </ul>
                </p>                         <br/>
                <br/>

                <a name="plane3" style="color:black;"><b>HOW TO ADD MULTIPLE ROOF-SEGMENTS? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>
                    <ul>

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
                        </li></ul>
                </p>
                <br/>
                <br/>

                <a name="plane4" style="color:black;"><b>HOW TO DELETE A ROOF-SEGMENT? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>
                    <ul>

                        <li>Click on 'Remove Current Segment', to delete the roof-segment currently being edited
                            (if you have not clicked on 'Finish Drawing' yet, then the segment is being currently edited)</li>
                        <li>To delete a segment that has already been added to the property summary,
                            click on the desired segment on the image to open the balloon.
                            <img src="<%=domain%>/img/orientationBalloon.png" style="width:700px;height:500px;" alt="Roof-Segment"/>
                        </li>
                        <li>Click on button 'Delete'. This removes the screen from the property image and the property summary. Total usable area is adjusted accordingly. </li>
                    </ul>
                </p>
                <br/>
                <br/>

                <a name="plane5" style="color:black;"><b>HOW TO SET ORIENTATION & SLOPE FOR A ROOF-SEGMENT? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>
                    <ul>
                        <li>Click on the property image to select the segment to which you would like to set the orientation and slope.
                            This opens a balloon as seen below.</li>
                        <li>Follow the instructions in 'Help' to set the orientation and slope for the roof-segment
                            <img src="<%=domain%>/img/orientationBalloon.png" style="width:700px;height:500px;" alt="Roof-Segment"/>
                        </li>
                    </ul>
                </p>
                <br/>
                <br/>

                <a name="obs1" style="color:black;"><b>WHAT IS AN UNUSABLE AREA? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>Unusable area is a section of the roof that can't be used for solar panels. If there is a chimney / skylight / 
                    tree shadow on the roof, then that section of the roof can not be used to install solar panels.
                    <br/>
                    The sample image below shows a roof with a skylight (see arrow). That section of the roof can not be used
                    to install a solar panel. It is an unusable area.
                    <img src="<%=domain%>/img/sampleobstruction.JPG" style="width:700px;height:500px;" alt="Example Unusable Area"/>

                </p>


                <br/> <br/>
                <a name="obs2" style="color:black;"><b>HOW TO ADD AN UNUSABLE AREA? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p><ul>
                        <li>Click on 'Start Drawing' button</li>
                        <li>Click on the roof image to select points that together form a polygon. This polygon represents the unusable
                            section of the roof. The entire unusable area should lie within a single roof segment.
                            <img src="<%=domain%>/img/aboutobstruction.png" style="width:700px;height:500px;" alt="Draw Unusable Area"/>
                            <br/><br/>
                        </li>
                        <li>Click on 'Finish Drawing' to complete drawing the unusable area. The area is added to the
                            'Property Summary' list. <br/>

                            <img src="<%=domain%>/img/saveobstruction.png" style="width:700px;height:500px;" alt="Save Unusable Area"/> <br/><br/>
                            Or <br/>
                            Click on 'Remove Current Area' to delete current area and start over.
                        </li>
                    </ul></p>


                <br/> <br/>
                <a name="slope1" style="color:black;"><b>WHAT IS ROOF PITCH OR SLOPE? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>
Roof pitch is a numerical measure of the steepness of a roof. <br/>
                Roof Pitch = (rise / run) Ft
      <br/>

            <img src="<%=domain%>/img/help.png"/>
  </p>

                <br/> <br/>
                <a name="slope2" style="color:black;"><b>HOW TO SET THE SLOPE FOR A ROOF-SEGMENT? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>
                    <ul>
                        <li>Draw a roof-segment on your roof.
                </li>
                        <li>Click on the roof-segment to open the balloon, as seen in below image.
                        <br/>
                         <img src="<%=domain%>/img/orientationBalloon.png" style="width:700px;height:500px;" alt=""/>

                        </li>
                        <li> Enter the rise and run of the roof segment and click on button 'Update'</li>
                    </ul>

            
               </p>

                          <br/> <br/>
                <a name="orientation1" style="color:black;"><b>WHAT IS ORIENTATION OF A ROOF-SEGMENT? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                          <p>
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
                
                          </p>
 <br/> <br/>
                <a name="orientation2" style="color:black;"><b>HOW TO SET ORIENTATION OF A ROOF-SEGMENT? </b>
                    <a style="float:right;" href="#top">Back to Top</a>
                </a>
                <p>
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
                </p>
                </p>
                <br/>
                <br/>
            </div>
            </div>
        </div>


    </body>
</html>
