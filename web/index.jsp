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


            <script type="text/javascript">
                var ge = null;
                var gex = null;
                var myLatlng;
                google.load("earth", "1");
                google.load("maps", "2");
                var propertyPlacemark;
                var geocodeLocation;
                var polyPlacemark = null;
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
                    var geocoder = new google.maps.ClientGeocoder();
                   
                    geocoder.getLatLng(geocodeLocation, function(point) {
                        if (point) {
                            gex.util.lookAt([point.y, point.x], { range: 50 });

                        }
                    });                           
                            
                }
              

                google.setOnLoadCallback(function() {
                    google.earth.createInstance('map3d', initCallback, failureCallback);
                    addSampleUIHtml(
                    '<input id="location" type="text" style="width:210px;" value="835 Milton St, Oakland, CA"/>'
                );

                    addSampleButton('GO', buttonClick);
                   // addSampleButton('Mark',markProperty);
                    document.getElementById('undo-plane').disabled = true;
                    document.getElementById("undoobs-point").disabled = true;
                    document.getElementById("undoplane-point").disabled = true;
                    document.getElementById('undo-obs').disabled = true;
                    document.getElementById('save-plane').disabled = true;
                    document.getElementById('save-obs').disabled = true;
                });

                function validateOrientation(id, value){
                    if((value >= 0) && (value <= 360)) {

                    } else {
                        document.getElementById("orientation" + id).value = "";
                        alert("Invalid orientation value");
                    }
                }

                function validateRun(id, value) {

                    if((value >= 0) && (value <= 99)) {

                    } else {
                        document.getElementById("run" + id).value = "";
                        alert("Invalid run value");
                    }
                }
                function validateRise(id, value) {
                    if((value >= 0) && (value <= 99)) {

                    } else {
                        document.getElementById("rise" + id).value = "";
                        alert("Invalid rise value");
                    }

                }

                function undoLastPoint(areaType){
                    var drawColor = '#0f0';
                    var polyColor = '8000ff00';
                    if(areaType == "plane") {
                        drawColor = '#0f0';
                    }
                    else if (areaType == "obstruction") {
                        drawColor = '#f00';
                        polyColor = '800000ff';
                    }
                    
                    
                    var tempCoords = [];
                    var coords = polyPlacemark.getGeometry().getOuterBoundary().getCoordinates();
                    if (coords) {
                        var n = coords.getLength();
                        for (var i = n-2; i >= 0; i--) {
                            tempCoords.push(coords.get(i));
                        }                       
                    }
                    gex.dom.removeObject(polyPlacemark);
                    gex.edit.endEditLineString(polyPlacemark.getGeometry().getOuterBoundary());

                    var tempPlacemark = gex.dom.addPolygonPlacemark(tempCoords, {
                        style: {
                            poly: polyColor,
                            line: { width: 3, color: drawColor }
                        }
                    });
                    ge.getFeatures().appendChild(tempPlacemark);
                    polyPlacemark = null;

                    polyPlacemark = tempPlacemark;
                    gex.edit.drawLineString(polyPlacemark.getGeometry().getOuterBoundary());


                }

                function markProperty() {

                    var placemark = ge.createPlacemark('');

                    ge.getFeatures().appendChild(placemark);
                    // Create style map for placemark
                    var icon = ge.createIcon('');
                    icon.setHref('http://maps.google.com/mapfiles/kml/paddle/red-circle.png');
                    var style = ge.createStyle('');
                    style.getIconStyle().setIcon(icon);
                    placemark.setStyleSelector(style);
                    geocoder.getLatLng(geocodeLocation, function(point) {
                        if (point) {
                            placemark.setGeometry(point);
                        }
                    });

                            

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

                        <li><a href="<%=domain%>/helpguide.jsp">Help</a></li>

                    </ul>
                </div>
            </div>
        </div>

        <div id="page">
            <table width="100%">
                <tr>
                    <td style="width:20%;" valign="top">
                        <div  class="boxed">
                            <h2 class="title">LOAD PROPERTY</h2>

                            <div id="sample-ui" nowrap="nowrap"></div>
                        </div>
                        <br/>
                        <div  class="boxed">
                            <h2 class="title">ADD PLANE</h2>
                            <div class="content">
                                <input type="button" onclick="drawPoly('plane');" value="Start"/>
                                &nbsp; &nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="save-plane" type="button" onclick="stopEditPoly('plane');" value="Finish"/>
                                <br/>

                                <input id="undoplane-point" type="button" onclick="undoLastPoint('plane');" value="Undo Point"/>
                                <input id="undo-plane" type="button" onclick="undoLastArea();" value="Undo Area"/>

                                


                            </div>
                        </div>

                        <div  class="boxed">
                            <h2 class="title">ADD OBSTRUCTION</h2>
                            <div class="content">
                                <input type="button" onclick="drawPoly('obstruction');" value="Start"/>
                                &nbsp; &nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="save-obs" type="button" onclick="stopEditPoly('obstruction');" value="Finish"/>
<br/>
                           <input id="undoobs-point" type="button" onclick="undoLastPoint('obstruction');" value="Undo Point"/>
     
                                <input id="undo-obs" type="button" onclick="undoLastArea();" value="Undo Area"/>

                                
                            </div>
                        </div>

                        <div id="info" class="boxed" >
                            <h2 class="title">PLANES & OBSTRUCTIONS</h2>


                            <div id="area-ui" class="content" style="height:250px;overflow-y:auto;"></div>
                        </div>
                        <input type="button" onclick="clearAllAreas();" value="Clear All"/>


                    </td>

                    <td style="width:80%;">
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
