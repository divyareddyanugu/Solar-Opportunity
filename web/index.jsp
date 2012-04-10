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

            <script type="text/javascript">
                var ge = null;
                var gex = null;
                var myLatlng;
                google.load("earth", "1");
                google.load("maps", "2");
                var propertyPlacemark;
                var geocodeLocation;
                var geocoder;
                var propertyPoint;
                var polyPlacemark = null;
                var placemarkId = 0;
                function initCallback(pluginInstance) {
                    ge = pluginInstance;
                    ge.getWindow().setVisibility(true);

                    gex = new GEarthExtensions(pluginInstance);
                    // add a navigation control
                    ge.getNavigationControl().setVisibility(ge.VISIBILITY_AUTO);

                    // add some layers
                    ge.getLayerRoot().enableLayerById(ge.LAYER_BORDERS, true);
                    ge.getLayerRoot().enableLayerById(ge.LAYER_ROADS, true);
                    ge.getOptions().setScaleLegendVisibility(true);
                    doc = ge.createDocument('');
                    ge.getFeatures().appendChild(doc);
                    
                }

                function failureCallback(errorCode) {
                }

                function buttonClick() {
                    geocodeLocation = document.getElementById('location').value;
                    geocoder = new google.maps.ClientGeocoder();
                    
                    geocoder.getLatLng(geocodeLocation, function(point) {
                        if (point) {
                            gex.util.lookAt([point.y, point.x], { range: 50 });
                            clearAllAreas();                            
                            markProperty(point.y,point.x);
                        }
                    });

                    defaultPlaneMode();
                    defaultObstructionMode();
                            
                }
              

                google.setOnLoadCallback(function() {
                    google.earth.createInstance('map3d', initCallback, failureCallback);
                    addSampleUIHtml(

                    '<input id="location" type="text" style="width:255px;" value="835 Milton St, Oakland, CA"/>'
                );

                    addSampleButton('GO', buttonClick);                    
                    defaultPlaneMode();
                    defaultObstructionMode();
                });

              
                function defaultPlaneMode() {
                    document.getElementById('draw-plane').disabled = false;
                    document.getElementById('undo-plane').disabled = true;
                    document.getElementById("undoplane-point").disabled = true;
                    document.getElementById('save-plane').disabled = true;

                }
                function editPlaneMode() {

                    document.getElementById('draw-plane').disabled = true;
                    document.getElementById("undo-plane").disabled = false;
        document.getElementById("undoplane-point").disabled = false;
        document.getElementById("save-plane").disabled = false;

                }
                function defaultObstructionMode() {

                    document.getElementById('draw-obs').disabled = false;
                    document.getElementById("undoobs-point").disabled = true;
                    document.getElementById('undo-obs').disabled = true;
                    document.getElementById('save-obs').disabled = true;
                    
                }

                function editObstructionMode() {

                    document.getElementById('draw-obs').disabled = true;
                    document.getElementById("undo-obs").disabled = false;
        document.getElementById("undoobs-point").disabled = false;
        document.getElementById("save-obs").disabled = false;
        
                }

                function markProperty(x,y) {

                    var pointPlacemark;
                    var p = ge.createPoint('');
                    p.setLatitude(x+0.00005); 
                    p.setLongitude(y);
                    pointPlacemark = ge.createPlacemark('');

                    // Create style map for placemark                    
                    var icon = ge.createIcon('');
                    icon.setHref('http://maps.google.com/mapfiles/kml/paddle/red-circle.png');
                    var style = ge.createStyle('');
                    style.getIconStyle().setIcon(icon);
                    pointPlacemark.setStyleSelector(style);
                    
                    pointPlacemark.setGeometry(p);
                            
                    ge.getFeatures().appendChild(pointPlacemark);
                    google.earth.addEventListener(pointPlacemark, 'click', function(event) {
                        // prevent the default balloon from popping up
                        event.preventDefault();

                        var balloon = ge.createHtmlStringBalloon('');
                        balloon.setFeature(event.getTarget());
                        balloon.setMaxWidth(300);

                        // Google logo.
                        balloon.setContentString(
                        "<p> <b> Roof of the property: </b> </p> <p>"+ geocodeLocation+" </p>" +
                            "<input value='Remove Pin' style='width:180px;' type='submit'  onclick=\"removePointPlacemark();ge.setBalloon(null);return false;\"/>"
                            );

                        ge.setBalloon(balloon);
                    });

                }


             /*
              * Removes the point placemark that identifies the searched property
              * And removes the balloon corresponding to the point
              */
              function removePointPlacemark() {
                  var kmlObjectList = ge.getFeatures().getChildNodes();
for(var i = 0; i<kmlObjectList.getLength(); i++){
 var item = kmlObjectList.item(i);
        //checks and see if it is a place mark and if the placemark is a point
  if( item.getGeometry().getType() == 'KmlPoint'){
   ge.getFeatures().removeChild(item);
  }
 }
              }

function offset(referenceArea, amount, calledFromOffset) {
    var offsetArea = new Area();



}
function generateFile() {
    var areaListAsString = ""; var separator = " , ";
    areaListAsString ="RoofSegment Id, Type, Area, Usable Area, Orientation, Slope <br/>";
    var planes = getPlanes();
    var obs = getObstructions();
    for(var a in planes) {

        areaListAsString += planes[a].id + separator;
        areaListAsString += planes[a].areaType+ separator;
        areaListAsString += planes[a].area+ separator;
        
        areaListAsString += planes[a].effectiveArea+ separator;
        areaListAsString += planes[a].orientation+ separator;
        areaListAsString += planes[a].rise +"/"+ AreaList[a].run;
        
        areaListAsString += "<br/>";
        for(var b in obs){
            if(obs[b].refPlaneId == planes[a].id) {
                areaListAsString += "NA" + separator;
        areaListAsString += obs[a].areaType+ separator;
        areaListAsString += obs[a].area+ separator;

        areaListAsString += "NA"+ separator;
        areaListAsString += "NA"+ separator;
        areaListAsString += "NA";

        areaListAsString += "<br/>";

            }
        }
    }

    // document.forms["saveFile"].target = "_blank";
     document.forms["saveFile"].propSummary.value = areaListAsString;//document.getElementById("area-ui").innerHTML;
                document.forms["saveFile"].submit();

}
            </script>


            <title>Home GESolar</title>
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
            <table width="100%">
                <tr>
                    <td style="width:23%;min-width:310px;" valign="top">
                        <div  class="boxed">
                            <h2 class="small_title">Search Property Using Address</h2>

                            <div id="sample-ui" nowrap="nowrap"></div>
                            
                        </div>
                        <br/>
                        <div  class="boxed">
                            <h2 class="small_title">Select Roof-Segment to Add Solar Panels</h2>
                            <div class="content">
                                <p> <i> Draw/outline a segment of the roof that can be used for solar panels. </i>
                                    <a href="" onclick="aboutPlane();return false;" ><i> Instructions</i> </a></p>
                                <br/>
                                <input id="draw-plane" type="button" onclick="drawPoly('plane');" style="width:120px;" value="Start Drawing"
                                       title="Click here to start drawing on the roof the property. The outlined area can be used for solar panels"/>
                               <input id="save-plane" type="button" onclick="stopEditPoly('plane');" style="width:160px;"
                                             value="Finish Drawing" title="Click here to finish drawing the roof segment"/>
                               
                                <br/>
 <input id="undoplane-point" type="button" onclick="undoLastPoint('plane');" style="width:120px;" value="Remove Last Point"
        title="Click here to delete the last point you have drawn"/>

                                <input id="undo-plane" type="button" onclick="undoLastArea();" style="width:160px;" value="Remove Current Segment"
                                       title="Click here to delete roof segment you are currently drawing"/>



                            </div>
                        </div>

                        <div  class="boxed">
                            <h2 class="small_title">Select Unusable Area of Roof-Segment</h2>
                            <div class="content">
                                <p> <i> Outline an area on the property roof that can NOT be used for solar panels.
                                   (Ex: a chimney, skylight or any other obstruction) </i>
                                      <a href="" onclick="aboutObstruction();return false;" ><i> Instructions </i> </a></p>
                                <br/>

  <input id="draw-obs" type="button" onclick="drawPoly('obstruction');" style="width:130px;" value="Start Drawing"
         title="Click here to start drawing on the roof of property. The outlined area can NOT be used for solar panels"/>
         &nbsp;                      <input id="save-obs" type="button" onclick="stopEditPoly('obstruction');" style="width:145px;"
                                             value="Finish Drawing" title="Click here to finish drawing the unusable area"/>

                                <br/>
 <input id="undoobs-point" type="button" onclick="undoLastPoint('obstruction');" style="width:130px;" value="Remove Last Point"
        title="Click here to delete the last point you have drawn"/>
&nbsp;
                                <input id="undo-obs" type="button" onclick="undoLastArea();" style="width:145px;" value="Remove Current Area"
                                       title="Click here to delete the area you are currently drawing"/>

                              
                            </div>
                        </div>

                        <div style="margin:1px 0 1px 0;height:28px;" >
                            <h2 class="title1"> Remove All Roof Segments </h2>
                                    <input style="float:right;width:80px;height:28px;"
                                        title="Click here to remove all the roof segments you have drawn on the property"   type="button" onclick="clearAllAreas();" value="Clear"/>
<br/>


                     </div>
                        <div id="info" class="boxed" >
                            <h2 class="title">Property Summary</h2>


                            <div id="area-ui" class="summary" style="height:320px;overflow-y:auto;overflow-x:no;"></div>
                            <%@ page language="java" import="java.io.*" %>
<form name="saveFile" method="GET" action="<%=domain%>/PropertySummary">
<input type="submit" value="Download Property Summary"
   onclick="return generateFile();"/>
<input type="hidden" name="propSummary"/>
</form>
                        </div>


                    </td>

                    <td style="width:77%;vertical-align:top;">
                        <div id="map3d_container" style="width: 100%; height: 800px;">
                            <div id="map3d" style="height: 100%"></div>
                        </div>
                    </td>
                </tr>
            </table>


            <!-- end content -->

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
